package com.icent.jabber.admin.svcImpl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.resource.AdminResource;
import com.icent.jabber.admin.svc.NoticeSvc;
import com.icent.jabber.admin.util.AdminHelper;
import com.icent.jabber.admin.util.JappleMailHelper;
import com.icent.jabber.admin.util.ServerConfigHelper;
import com.icent.jabber.repository.bean.*;
import com.icent.jabber.repository.dao.base.AdminDao;
import com.icent.jabber.repository.dao.base.CodeDao;
import com.icent.jabber.repository.dao.base.FunctionDao;
import com.icent.jabber.repository.dao.base.NoticeDao;
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
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * 공지 사항 관리 Service
 * @author  : dhj
 * @version  : 1.0
 * @since  : 2014. 6. 13.
 * <pre>
 * == 개정이력(Modification Information) ====================
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 6. 13.     kst           최초 생성
 * </pre>
 */
@Service
public class NoticeSvcImpl implements NoticeSvc {

    private Logger logger = LoggerFactory.getLogger("info");

    @Inject
    private NoticeDao noticeDao;

    @Inject
    private CodeDao codeDao;

    @Inject
    private FunctionDao functionDao;

    @Inject
    private AdminDao adminDao;

    @Resource(name="mybatisBaseTxManager")
    private DataSourceTransactionManager transactionManager;

    @Value("#{configProperties['cnf.path.noticeUploadLinkUrl']}")
    private String noticeUploadLinkUrl;

    @Value("#{configProperties['cnf.noticeFileAttachedUploadPath']}")
    private String noticeUploadPath;

    // 공지 구분코드 (대분류, 소분류)
    private final String[] noticeHeaderCode = new String[]{"C007"};

    @Value("#{configProperties['cnf.defaultPageSize']}")
    private String defaultPageSize;

    @Inject
    private ServerConfigHelper serverConfigHelper;

    @Inject
    private JappleMailHelper jappleMailHelper;

    @Override
    public ModelAndView findAllNotice(Map<String, String> parameters) {
        List<NoticeBean> pinNotices = noticeDao.findListPINNotice();

        String _defaultPageSize = String.valueOf(Integer.parseInt(defaultPageSize) - pinNotices.size());
        AdminHelper.setPageParam(parameters, _defaultPageSize);

        FindBean paramBean = AdminHelper.convertMapToBean(parameters, FindBean.class);

        List<NoticeBean> notices = noticeDao.findAllNotice(paramBean);
        Integer totalCount = noticeDao.findCountNotice(paramBean);
        AdminHelper.setPageTotalCount(paramBean, totalCount);

        for (int i=0; i<notices.size(); i++){
            pinNotices.add(notices.get(i));
        }

        FindBean codeParamBean = new FindBean();
        codeParamBean.setId("C007");
        codeParamBean.setUseYn(AdminResource.YES);
        List<CodeBean> headers = codeDao.findListCode(codeParamBean);

        ServerBean file = serverConfigHelper.findByServer("file");

        StringBuilder urlBuilder = new StringBuilder();
        urlBuilder.append(file.getProtocol());
        urlBuilder.append(AdminResource.PROTOCOL_SUBPIX);
        urlBuilder.append(file.getIp());
        urlBuilder.append(CommonResourceBean.COLON_STRING);
        urlBuilder.append(file.getPort());
        urlBuilder.append(noticeUploadLinkUrl);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("fileDownloadUrl",urlBuilder.toString());
        modelAndView.addObject("notices",pinNotices);
        modelAndView.addObject("paramBean",paramBean);
        modelAndView.addObject("headers",headers);
        return modelAndView;
    }

    @Override
    public ModelAndView findByNotice(Map<String, String> parameters) {
        NoticeBean paramBean = AdminHelper.convertMapToBean(parameters, NoticeBean.class);

        NoticeBean noticeBean = new NoticeBean();

        if(StringUtils.notNullCheck(paramBean.getNoticeId())) {
            noticeBean = noticeDao.findByNotice(paramBean);
        }else{
            noticeBean.setStartDatetime(new Date());
            noticeBean.setEndDatetime(new Date());
        }

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("notice",noticeBean);
        return modelAndView;
    }

    @Override
    public ModelAndView addNotice(HttpServletRequest request, Map<String, String> parameters) {

        NoticeBean paramBean = AdminHelper.convertMapToBean(parameters, NoticeBean.class, "yyyy-MM-dd HH:mm:ss");
        paramBean.setNoticeId(StringUtils.getGUID36());

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        File noticeFile = null;

        try {
            noticeFile = FileTransfer.upload(request, "noticeFile", 1024, noticeUploadPath, null, paramBean.getNoticeId());
            if(noticeFile != null){
                paramBean.setPhysicalFileName(noticeFile.getName());

            }
        } catch(IOException e){
            if(noticeFile != null){
                noticeFile.delete();
            }
            throw new JabberException("");
        }

        try {
            paramBean.setDelYn("N");
            noticeDao.addNotice(paramBean);
            transactionManager.commit(transactionStatus);
        } catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        //메일발송
        String[] result = sendResultMail(paramBean);

        if(!StringUtils.checkResult(result)){
            logger.error(result[1]);
        }


        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView saveNotice(HttpServletRequest request, Map<String, String> parameters) {
        NoticeBean paramBean = AdminHelper.convertMapToBean(parameters, NoticeBean.class, "yyyy-MM-dd HH:mm:ss");
        File noticeFile = null;
        try {
            noticeFile = FileTransfer.upload(request, "noticeFile", 1024, noticeUploadPath, null, paramBean.getNoticeId());
            if(noticeFile != null){
                paramBean.setPhysicalFileName(noticeFile.getName());

            }
        } catch(IOException e) {
            if(noticeFile != null){
                noticeFile.delete();
            }
            throw new JabberException("");
        }

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try {
            noticeDao.saveNotice(paramBean);
            transactionManager.commit(transactionStatus);
        } catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);

            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView removeNotice(Map<String, String> parameters) {

        NoticeBean paramBean = AdminHelper.convertMapToBean(parameters, NoticeBean.class, "yyyy-MM-dd HH:mm:ss");
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try {
            noticeDao.removeNotice(paramBean);
            transactionManager.commit(transactionStatus);
        } catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView downloadNotice(Map<String, String> parameters, HttpServletRequest request, HttpServletResponse response) {
        NoticeBean paramBean = AdminHelper.convertMapToBean(parameters, NoticeBean.class);
        NoticeBean notice = noticeDao.findByNotice(paramBean);

        if(StringUtils.notNullCheck(notice.getPhysicalFileName())) {
            try {
                if (new File(noticeUploadPath + notice.getPhysicalFileName()).exists()) {
                    FileTransfer.download(request, response, noticeUploadPath  + notice.getPhysicalFileName(), "\"" + notice.getLogicalFileName() + "\"", 1024);
                }
            } catch(IOException | ServletException e) {
                throw new JabberException("");
            }
        }
        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;

    }

    private String[] sendResultMail(NoticeBean notice){

        FunctionBean functionParam = new FunctionBean();
        functionParam.setFuncId("mail.send");
        FunctionBean mail = functionDao.findByFunction(functionParam);

        if(mail == null || !CommonResourceBean.YES.equalsIgnoreCase(mail.getUseYn())){
            return new String[]{CommonResourceBean.SUCCESS, "mail is disable setting"};
        }

        if(notice == null || StringUtils.nullCheck(notice.getNoticeId())){
            return new String[]{CommonResourceBean.FAILURE, "id is null"};
        }

        NoticeBean target = noticeDao.findByNotice(notice);

        if(target == null || StringUtils.nullCheck(target.getNoticeId())){
            return new String[]{CommonResourceBean.FAILURE, "this notice is null"};
        }

        AdminBean adminParam = new AdminBean();
        adminParam.setAdminId(target.getInsertUserId());
        AdminBean sender = adminDao.findByAdmin(adminParam);

        if(sender == null || StringUtils.nullCheck(sender.getAdminId())){ // || ListUtils.nullCheck(receivers)
            return new String[]{CommonResourceBean.FAILURE,"parameter validate error"};
        }


        String title= "[공지사항]신규공지 안내";

        StringBuilder sbContent = new StringBuilder();

        sbContent.append("<p>새로운 공지가 등록되었습니다. 자세한 내용은 Japple에서 확인하세요!</p>");
        sbContent.append("<table align=\"left\" style=\"width: 90%; border: 1px solid #000; board-radius:3px 0 0 0; margin:0 auto; letter-spacing:0; border-spacing:0; border-collapse: collapse; line-height:1.5em;\"><tbody>");
        sbContent.append("<colgroup>");
        sbContent.append("<col style=\"width:100px\">");
        sbContent.append("<col style=\"width:*\">");
        sbContent.append("</colgroup>");

        CodeBean codeParam = new CodeBean();
        codeParam.setGroupCodeId(noticeHeaderCode[0]);
        codeParam.setCodeId(target.getHeaderCode());
        CodeBean codeBean = codeDao.findByCode(codeParam);

        String headerName = codeBean.getCodeName();

        if(StringUtils.notNullCheck(headerName)){
            sbContent.append("<tr>");
            sbContent.append("<th style=\"border:1px solid #373737; background-color: #fff; line-height:25px; padding:0 10px; color:#373737;\">구&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;분</th>");
            sbContent.append("<td align=\"left\" style=\"border:1px solid #373737; background-color: #fff; line-height:25px; padding:0 10px; color:#373737;\">");
            sbContent.append(headerName);
            sbContent.append("</td>");
            sbContent.append("</tr>");
        }

        sbContent.append("<tr>");
        sbContent.append("<th style=\"border:1px solid #373737; background-color: #fff; line-height:25px; padding:0 10px; color:#373737;\">제&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;목</th>");
        sbContent.append("<td align=\"left\" style=\"border:1px solid #373737; background-color: #fff; line-height:25px; padding:0 10px; color:#373737;\">");
        sbContent.append(target.getTitle());
        sbContent.append("</td>");
        sbContent.append("</tr>");

        sbContent.append("<tr>");
        sbContent.append("<th style=\"border:1px solid #373737; background-color: #fff; line-height:25px; padding:0 10px; color:#373737;\">내&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;용</th>");
        sbContent.append("<td align=\"left\" style=\"border:1px solid #373737; background-color: #fff; line-height:25px; padding:0 10px; color:#373737;\">");

        String comment = target.getComment();
        comment = StringUtils.notNullCheck(comment) ? comment.replaceAll("\\n","</br>") : comment;

        String cutComment = "";

        // p로 끈어서 2줄만 사용
        if(comment!=null){
            int startIndex = 0;
            int endIndex = 0;

            for(int i=0; i<2; i++){
                startIndex = comment.indexOf("<p",endIndex);
                endIndex = comment.indexOf("</p>",endIndex)+4;

                if(startIndex>-1){
                    cutComment += comment.substring(startIndex,endIndex);
                }
            }
            cutComment += "<p>………</p>";
        }

        sbContent.append(cutComment);

        sbContent.append("</td>");
        sbContent.append("</tr>");

        sbContent.append("</tbody></table>");

        return jappleMailHelper.sendNotifyMail(
                JappleMailHelper.Type.NOTICE_REGISTE
                ,sender.getEmail()
                ,target.getInsertUserId()
                ,title
                ,sbContent.toString());
    }
}
