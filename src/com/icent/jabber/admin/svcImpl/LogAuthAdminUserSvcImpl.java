package com.icent.jabber.admin.svcImpl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.resource.AdminResource;
import com.icent.jabber.admin.svc.LogAuthAdminUserSvc;
import com.icent.jabber.admin.util.AdminHelper;
import com.icent.jabber.repository.bean.FindBean;
import com.icent.jabber.repository.bean.LogAuthAdminUserBean;
import com.icent.jabber.repository.dao.base.LogAuthAdminUserDao;
import com.icent.jabber.repository.dao.log.LogAuthAdminUserLogDao;
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
 * 관리자 로그 관리 Service Implements
 *
 * @author : kst
 * @version : 1.0
 * @since : 2014. 6. 10.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 6. 10.     kst           최초 생성
 * </pre>
 */
@Service
public class LogAuthAdminUserSvcImpl implements LogAuthAdminUserSvc {

    @Inject
    private LogAuthAdminUserDao logAuthAdminUserDao;

    @Inject
    private LogAuthAdminUserLogDao logAuthAdminUserLogDao;

    @Resource(name="mybatisLogTxManager")
    private DataSourceTransactionManager logTransactionManager;

    @Override
    public ModelAndView findListLogAuthAdminUser(Map<String, String> parameters) {
        FindBean paramBean = AdminHelper.convertMapToBean(parameters, FindBean.class);

        List<LogAuthAdminUserBean> logAuthAdminUsers = logAuthAdminUserDao.findListLogAuthAdminUser(paramBean);
        Integer totalCount = logAuthAdminUserDao.findCountLogAuthAdminUser(paramBean);

        AdminHelper.setPageTotalCount(paramBean, totalCount);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("logAuthAdminUsers", logAuthAdminUsers);
        modelAndView.addObject("paramBean",paramBean);
        return modelAndView;
    }

    @Override
    public ModelAndView findListLogAuthAdminUserByMain(Map<String, String> parameters) {
        FindBean paramBean = AdminHelper.convertMapToBean(parameters, FindBean.class);
        paramBean.setPageRowNumber(5);
        paramBean.setPageIndex(0);

        List<LogAuthAdminUserBean> logAuthAdminUsers = logAuthAdminUserDao.findListLogAuthAdminUser(paramBean);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("logAuthAdminUsers", logAuthAdminUsers);
        return modelAndView;
    }

    @Override
    public ModelAndView addLogAuthAdminUser(Map<String, String> parameters) {
        LogAuthAdminUserBean paramBean = AdminHelper.convertMapToBean(parameters, LogAuthAdminUserBean.class);
        paramBean.setLogAuthId(StringUtils.getGUID36());

//        String result = logAuthAdminUserDao.addLogAuthAdminUser(paramBean);
//
//        if(!result.equals(AdminResource.RESULT_STATUS_TYPE[0])){
//            throw new JabberException("");
//        }

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(logTransactionManager);

        try{
            logAuthAdminUserLogDao.addLogAuthAdminUser(paramBean);
            logTransactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            logTransactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }
}
