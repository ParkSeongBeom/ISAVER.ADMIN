package com.icent.jabber.admin.svcImpl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.svc.MaintenanceSvc;
import com.icent.jabber.admin.util.AdminHelper;
import com.icent.jabber.admin.util.JappleMailHelper;
import com.icent.jabber.repository.bean.*;
import com.icent.jabber.repository.dao.base.AdminDao;
import com.icent.jabber.repository.dao.base.CodeDao;
import com.icent.jabber.repository.dao.base.FunctionDao;
import com.icent.jabber.repository.dao.base.MaintenanceDao;
import com.kst.common.bean.CommonResourceBean;
import com.kst.common.helper.FileTransfer;
import com.kst.common.springutil.TransactionUtil;
import com.kst.common.util.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionStatus;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.util.*;

/**
 * 의뢰사항 Service Interface
 *
 * @author : dhj
 * @version : 1.0
 * @since : 2014. 5. 20.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 5. 20.     dhj           최초 생성
 * </pre>
 */
@Service("maintenanceSvc")
public class MaintenanceSvcImpl implements MaintenanceSvc {

    private Logger logger = LoggerFactory.getLogger("info");

    @Inject
    private MaintenanceDao maintenanceDao;

    @Inject
    private CodeDao codeDao;

    @Inject
    private FunctionDao functionDao;

    @Inject
    private AdminDao adminDao;

    @Resource(name="mybatisBaseTxManager")
    private DataSourceTransactionManager transactionManager;

    @Value("#{configProperties['cnf.maintenanceAttachedFileUploadPath']}")
    private String maintenanceAttachedFileUploadPath;

    private final Map<String, String> STATUS_CODE = new HashMap<String, String>(){{
        put("complete","5000");
        put("reject","9000");
    }};

    // 의뢰하기 구분코드 (대분류, 소분류)
    private final String[] maintenanceTypeCode = new String[]{"C001","C002"};

    @Inject
    private JappleMailHelper jappleMailHelper;

    @Override
    public ModelAndView findAllMaintenance(Map<String, String> parameters) {

        MaintenanceBean paramBean = AdminHelper.convertMapToBean(parameters, MaintenanceBean.class);
        List<MaintenanceBean> maintenances = maintenanceDao.findAllMaintenance(paramBean);
        Integer totalCount = maintenanceDao.findCountMaintenance(paramBean);
        AdminHelper.setPageTotalCount(paramBean, totalCount);
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("maintenances", maintenances);
        modelAndView.addObject("paramBean", paramBean);
        return modelAndView;

    }

    @Override
    public ModelAndView findByMaintenance(Map<String, String> parameters) {
        FindBean paramBean = AdminHelper.convertMapToBean(parameters, FindBean.class);

        MaintenanceBean maintenance = maintenanceDao.findByMaintenance(paramBean);
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("maintenance", maintenance);
        return modelAndView;
    }

    @Override
    public ModelAndView saveMaintenance(HttpServletRequest request, Map<String, String> parameters) {

        MaintenanceBean paramBean = AdminHelper.convertMapToBean(parameters, MaintenanceBean.class);

        File maintenanceFile = null;

        try {
            maintenanceFile = FileTransfer.upload(request, "maintenanceFile", 1024, maintenanceAttachedFileUploadPath, null, paramBean.getMaintenanceId());

            if(maintenanceFile != null){
                paramBean.setPhysicalFileName(maintenanceFile.getName());
            }
        } catch(IOException e) {
            if(maintenanceFile != null){
                maintenanceFile.delete();
            }
            throw new JabberException("");
        }

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try {
            maintenanceDao.saveMaintenance(paramBean);
            transactionManager.commit(transactionStatus);
        } catch(DataAccessException e) {
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        if(STATUS_CODE.get("complete").equalsIgnoreCase(paramBean.getStatus())
            ||STATUS_CODE.get("reject").equalsIgnoreCase(paramBean.getStatus())){
            String[] result = sendResultMail(paramBean);

            if(!StringUtils.checkResult(result)){
                logger.error(result[1]);
            }
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView removeMaintenance(Map<String, String> parameters) {

        MaintenanceBean paramBean = AdminHelper.convertMapToBean(parameters, MaintenanceBean.class);

        File maintenanceFile = new File(maintenanceAttachedFileUploadPath + paramBean.getPhysicalFileName());

        if (maintenanceFile.exists()) {
            maintenanceFile.delete();
        }

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try {
            maintenanceDao.removeMaintenance(paramBean);
            transactionManager.commit(transactionStatus);
        } catch(DataAccessException e) {
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView fileDownloadMaintenance(HttpServletRequest request, HttpServletResponse response, Map<String, String> parameters) {

        FindBean paramBean = AdminHelper.convertMapToBean(parameters, FindBean.class);

        MaintenanceBean maintenance = maintenanceDao.findByMaintenance(paramBean);

        if(StringUtils.notNullCheck(maintenance.getPhysicalFileName())) {
            try {
                if (new File(maintenanceAttachedFileUploadPath + maintenance.getPhysicalFileName()).exists()) {
                    FileTransfer.download(request, response, maintenanceAttachedFileUploadPath + maintenance.getPhysicalFileName(), "\"" + maintenance.getLogicalFileName() + "\"", 1024);
                }
            } catch(IOException | ServletException e) {
                throw new JabberException("");
            }
        }
        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView findListMaintenanceByMain(Map<String, String> parameters) {
        MaintenanceBean paramBean = AdminHelper.convertMapToBean(parameters, MaintenanceBean.class);
        paramBean.setPageRowNumber(5);
        paramBean.setPageIndex(0);

        List<MaintenanceBean> maintenances = maintenanceDao.findAllMaintenance(paramBean);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("maintenances", maintenances);
        modelAndView.addObject("paramBean", paramBean);
        return modelAndView;

    }

    private String[] sendResultMail(MaintenanceBean maintenanceBean){

        FunctionBean functionParam = new FunctionBean();
        functionParam.setFuncId("mail.send");
        FunctionBean mail = functionDao.findByFunction(functionParam);

        if(mail == null || !CommonResourceBean.YES.equalsIgnoreCase(mail.getUseYn())){
            return new String[]{CommonResourceBean.SUCCESS, "mail is disable setting"};
        }

        if(maintenanceBean == null || StringUtils.nullCheck(maintenanceBean.getMaintenanceId())){
            return new String[]{CommonResourceBean.FAILURE, "id is null"};
        }

        FindBean paramBean = new FindBean();
        paramBean.setId(maintenanceBean.getMaintenanceId());
        MaintenanceBean target = maintenanceDao.findByMaintenanceForDetail(paramBean);

        if(target == null || StringUtils.nullCheck(target.getMaintenanceId())){
            return new String[]{CommonResourceBean.FAILURE, "this maintanence is null"};
        }

        if(StringUtils.nullCheck(target.getRequestUserId()) && StringUtils.nullCheck(target.getRequestUserEmail())){
            return new String[]{CommonResourceBean.FAILURE, "request user id or request userEmail is null"};
        }

        AdminBean adminParam = new AdminBean();
        adminParam.setAdminId(target.getReviewUserId());
        AdminBean sender = adminDao.findByAdmin(adminParam);

        if(sender == null || StringUtils.nullCheck(sender.getAdminId())){ // || ListUtils.nullCheck(receivers)
            return new String[]{CommonResourceBean.FAILURE,"parameter validate error"};
        }


        String title=null;
        if(STATUS_CODE.get("complete").equals(target.getStatus())){ // complete
            title = "[의뢰하기 완료] " + target.getTitle();
        }else if(STATUS_CODE.get("reject").equals(target.getStatus())){ // reject
            title = "[의뢰하기 반려] " + target.getTitle();
        }

        StringBuilder sbContent = new StringBuilder();

        sbContent.append("<table align=\"left\" style=\"border: 1px solid #000; board-radius:3px 0 0 0; margin:0 auto; letter-spacing:0; border-spacing:0; border-collapse: collapse; line-height:1.5em;\"><tbody>");

        sbContent.append("<tr>");
        sbContent.append("<th style=\"border:1px solid #373737; background-color: #fff; line-height:25px; padding:0 10px; color:#373737;\">제&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;목</th>");
        sbContent.append("<td align=\"left\" style=\"border:1px solid #373737; background-color: #fff; line-height:25px; padding:0 10px; color:#373737;\">");
        sbContent.append(target.getTitle());
        sbContent.append("</td>");
        sbContent.append("</tr>");


        CodeBean codeParam = new CodeBean();
        codeParam.setGroupCodeId(maintenanceTypeCode[1]);
        codeParam.setCodeId(target.getTypeCode());
        CodeBean codeBean = codeDao.findByCode(codeParam);

        String typeName = codeBean.getCodeName();

        codeParam.setGroupCodeId(maintenanceTypeCode[0]);
        codeParam.setCodeId(target.getSysCode());
        codeBean = codeDao.findByCode(codeParam);

        String systemName = codeBean.getCodeName();

        if(StringUtils.notNullCheck(typeName)){
            sbContent.append("<tr>");
            sbContent.append("<th style=\"border:1px solid #373737; background-color: #fff; line-height:25px; padding:0 10px; color:#373737;\">유&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;형</th>");
            sbContent.append("<td align=\"left\" style=\"border:1px solid #373737; background-color: #fff; line-height:25px; padding:0 10px; color:#373737;\">");
            sbContent.append(typeName);

            if(StringUtils.notNullCheck(systemName)){
                sbContent.append(" ");
                sbContent.append(CommonResourceBean.HYPHEN_STRING);
                sbContent.append(" ");
                sbContent.append(systemName);
            }

            sbContent.append("</td>");
            sbContent.append("</tr>");
        }


        sbContent.append("<tr>");
        sbContent.append("<th style=\"border:1px solid #373737; background-color: #fff; line-height:25px; padding:0 10px; color:#373737;\">&nbsp;검&nbsp;토&nbsp;자&nbsp;</th>");
        sbContent.append("<td align=\"left\" style=\"border:1px solid #373737; background-color: #fff; line-height:25px; padding:0 10px; color:#373737;\">");
        sbContent.append(sender.getName());
        sbContent.append("</td>");
        sbContent.append("</tr>");

        sbContent.append("<tr>");
        sbContent.append("<th style=\"border:1px solid #373737; background-color: #fff; line-height:25px; padding:0 10px; color:#373737;\">검토내용</th>");
        sbContent.append("<td align=\"left\" style=\"border:1px solid #373737; background-color: #fff; line-height:25px; padding:0 10px; color:#373737;\">");

        String comment = target.getReviewComment();
        comment = StringUtils.notNullCheck(comment) ? comment.replaceAll("\\n","</br>") : comment;
        sbContent.append(comment);

        sbContent.append("</td>");
        sbContent.append("</tr>");

        sbContent.append("</tbody></table>");
        System.out.println(sbContent.toString());

        return jappleMailHelper.sendNotifyMail(
                JappleMailHelper.Type.MAINTANENCE_COMPLETE
                ,sender.getEmail()
                ,StringUtils.notNullCheck(target.getRequestUserEmail()) ? target.getRequestUserEmail() : target.getRequestUserId()
                ,title
                ,sbContent.toString());
    }
}
