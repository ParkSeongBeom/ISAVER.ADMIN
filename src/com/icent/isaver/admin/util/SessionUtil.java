package com.icent.isaver.admin.util;

import com.icent.isaver.admin.common.resource.IsaverException;
import com.icent.isaver.admin.resource.AdminResource;
import com.icent.isaver.repository.bean.UsersBean;
import com.icent.isaver.repository.dao.base.SessionDao;
import com.icent.isaver.repository.dao.base.UsersDao;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import com.kst.common.spring.TransactionUtil;
import org.springframework.transaction.TransactionStatus;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

public class SessionUtil {

    @Resource(name="isaverTxManager")
    private DataSourceTransactionManager transactionManager;

    @Inject
    private UsersDao usersDao;

    @Inject
    private SessionDao sessionDao;

    public UsersBean getSession(HttpSession session) {
        UsersBean usersBean = (UsersBean)session.getAttribute(AdminResource.AUTHORIZATION_ADMIN);
        if(usersBean==null){
            Map<String, String> parameters = new HashMap<>();
            parameters.put("sessionId", session.getId());
            usersBean = usersDao.findByUsersForSession(parameters);
            if(usersBean!=null){
                session.setAttribute(AdminResource.AUTHORIZATION_ADMIN, usersBean);
            }
        }
        return usersBean;
    }

    public void addSession(HttpServletRequest request, UsersBean usersBean) {
        Map<String, String> parameters = new HashMap<>();
        parameters.put("sessionId", request.getSession().getId());
        parameters.put("userId", usersBean.getUserId());

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try {
            sessionDao.addSession(parameters);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new IsaverException("");
        }
        request.getSession().setAttribute(AdminResource.AUTHORIZATION_ADMIN, usersBean);
    }

    public void removeSession(HttpServletRequest request) {
        Map<String, String> parameters = new HashMap<>();
        parameters.put("sessionId", request.getSession().getId());

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            sessionDao.removeSession(parameters);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new IsaverException("");
        }
        request.getSession().removeAttribute(AdminResource.AUTHORIZATION_ADMIN);
    }
}
