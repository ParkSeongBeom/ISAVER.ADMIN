package com.icent.jabber.admin.svcImpl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.svc.MailSvc;
import com.icent.jabber.admin.util.AdminHelper;
import com.icent.jabber.repository.bean.MailBean;
import com.icent.jabber.repository.dao.base.MailDao;
import com.kst.common.springutil.TransactionUtil;
import com.kst.common.util.StringUtils;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionStatus;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.inject.Inject;
import java.util.List;
import java.util.Map;

/**
 * 메일 발송 관리 Service
 * @author : psb
 * @version : 1.0
 * @since : 2015. 02. 17.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2015. 02. 17.     psb           최초 생성
 * </pre>
 */
@Service
public class MailSvcImpl implements MailSvc {

    @Inject
    private MailDao mailDao;

    @Resource(name="mybatisBaseTxManager")
    private DataSourceTransactionManager transactionManager;

    @Override
    public ModelAndView findAllMail(Map<String, String> parameters) {
        List<MailBean> mails = mailDao.findAllMail();

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("mails",mails);
        return modelAndView;
    }

    @Override
    public ModelAndView findByMail(Map<String, String> parameters) {
        MailBean mailBean = null;

        if(StringUtils.notNullCheck(parameters.get("mailType"))) {
            mailBean = mailDao.findByMail(parameters);
        }

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("mail",mailBean);
        return modelAndView;
    }

    @Override
    public ModelAndView saveMail(Map<String, String> parameters) {
        MailBean paramBean = AdminHelper.convertMapToBean(parameters, MailBean.class);

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try {
            mailDao.saveMail(paramBean);
            transactionManager.commit(transactionStatus);
        } catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }
}
