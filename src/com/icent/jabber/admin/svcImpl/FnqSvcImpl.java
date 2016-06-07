package com.icent.jabber.admin.svcImpl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.resource.AdminResource;
import com.icent.jabber.admin.svc.FnqSvc;
import com.icent.jabber.admin.util.AdminHelper;
import com.icent.jabber.repository.bean.CodeBean;
import com.icent.jabber.repository.bean.FindBean;
import com.icent.jabber.repository.bean.FnqBean;
import com.icent.jabber.repository.dao.base.CodeDao;
import com.icent.jabber.repository.dao.base.FnqDao;
import com.kst.common.helper.FileTransfer;
import com.kst.common.springutil.TransactionUtil;
import com.kst.common.util.StringUtils;
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
import java.util.List;
import java.util.Map;

/**
 * 도움말 Service
 * @author : psb
 * @version : 1.0
 * @since : 2014. 10. 13.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 10. 13.     psb           최초 생성
 * </pre>
 */
@Service
public class FnqSvcImpl implements FnqSvc {

    @Inject
    private FnqDao fnqDao;

    @Inject
    private CodeDao codeDao;

    @Resource(name="mybatisBaseTxManager")
    private DataSourceTransactionManager transactionManager;

    @Value("#{configProperties['cnf.fnqFileAttachedUploadPath']}")
    private String fnqUploadPath;

    @Override
    public ModelAndView findAllFnq(Map<String, String> parameters) {
        List<FnqBean> fnqs = fnqDao.findAllFnq(parameters);
        Integer totalCount = fnqDao.findCountFnq(parameters);

        AdminHelper.setPageTotalCount(parameters, totalCount);

        FindBean codeParamBean = new FindBean();
        codeParamBean.setId("F001");
        codeParamBean.setUseYn(AdminResource.YES);
        List<CodeBean> headers = codeDao.findListCode(codeParamBean);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("fnqs",fnqs);
        modelAndView.addObject("paramBean",parameters);
        modelAndView.addObject("headers",headers);
        return modelAndView;
    }

    @Override
    public ModelAndView findByFnq(Map<String, String> parameters) {
        FnqBean paramBean = AdminHelper.convertMapToBean(parameters, FnqBean.class);

        FnqBean fnqBean = null;

        if(StringUtils.notNullCheck(paramBean.getFnqId())) {
            fnqBean = fnqDao.findByFnq(paramBean);
        }

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("fnq",fnqBean);
        return modelAndView;
    }

    @Override
    public ModelAndView addFnq(HttpServletRequest request, Map<String, String> parameters) {

        FnqBean paramBean = AdminHelper.convertMapToBean(parameters, FnqBean.class);
        paramBean.setFnqId(StringUtils.getGUID36());

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        File fnqFile = null;

        try {
            fnqFile = FileTransfer.upload(request, "fnqFile", 1024, fnqUploadPath, null, paramBean.getFnqId());
            if(fnqFile != null){
                paramBean.setPhysicalFileName(fnqFile.getName());

            }
        } catch(IOException e){
            if(fnqFile != null){
                fnqFile.delete();
            }
            throw new JabberException("");
        }

        try {
            paramBean.setDelYn("N");
            fnqDao.addFnq(paramBean);
            transactionManager.commit(transactionStatus);
        } catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }
        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView saveFnq(HttpServletRequest request, Map<String, String> parameters) {
        FnqBean paramBean = AdminHelper.convertMapToBean(parameters, FnqBean.class);
        File fnqFile = null;
        try {
            fnqFile = FileTransfer.upload(request, "fnqFile", 1024, fnqUploadPath, null, paramBean.getFnqId());
            if(fnqFile != null){
                paramBean.setPhysicalFileName(fnqFile.getName());

            }
        } catch(IOException e) {
            if(fnqFile != null){
                fnqFile.delete();
            }
            throw new JabberException("");
        }

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try {

            fnqDao.saveFnq(paramBean);
            transactionManager.commit(transactionStatus);
        } catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);

            throw new JabberException("");
        }
        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView removeFnq(Map<String, String> parameters) {

        FnqBean paramBean = AdminHelper.convertMapToBean(parameters, FnqBean.class);
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try {
            fnqDao.removeFnq(paramBean);
            transactionManager.commit(transactionStatus);
        } catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView downloadFnq(Map<String, String> parameters, HttpServletRequest request, HttpServletResponse response) {
        FnqBean paramBean = AdminHelper.convertMapToBean(parameters, FnqBean.class);
        FnqBean fnq = fnqDao.findByFnq(paramBean);

        if(StringUtils.notNullCheck(fnq.getPhysicalFileName())) {
            try {
                if (new File(fnqUploadPath + fnq.getPhysicalFileName()).exists()) {
                    FileTransfer.download(request, response, fnqUploadPath + fnq.getPhysicalFileName(), "\"" + fnq.getLogicalFileName() + "\"", 1024);
                }
            } catch(IOException | ServletException e) {
                throw new JabberException("");
            }
        }
        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }
}
