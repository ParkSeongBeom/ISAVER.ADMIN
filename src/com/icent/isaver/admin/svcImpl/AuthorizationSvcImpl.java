package com.icent.isaver.admin.svcImpl;

import Aladdin.HaspStatus;
import com.icent.isaver.admin.bean.License;
import com.icent.isaver.admin.common.resource.IcentException;
import com.icent.isaver.admin.resource.AdminResource;
import com.icent.isaver.admin.svc.AuthorizationSvc;
import com.icent.isaver.admin.util.AdminHelper;
import com.icent.isaver.admin.util.HaspLicenseUtil;
import com.icent.isaver.repository.bean.LoginHistoryBean;
import com.icent.isaver.repository.bean.UsersBean;
import com.icent.isaver.repository.dao.base.LoginHistoryDao;
import com.icent.isaver.repository.dao.base.UsersDao;
import com.kst.common.spring.TransactionUtil;
import com.kst.common.util.StringUtils;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionStatus;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import java.util.Map;

/**
 * 관리자 인가정보 Service Implements
 *
 * @author : kst
 * @version : 1.0
 * @since : 2014. 6. 2.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 6. 2.     kst           최초 생성
 * </pre>
 */
@Service
public class AuthorizationSvcImpl implements AuthorizationSvc {

    @Inject
    private UsersDao usersDao;

    @Inject
    private LoginHistoryDao loginHistoryDao;

    @Inject
    private HaspLicenseUtil haspLicenseUtil;

    @Resource(name="isaverTxManager")
    private DataSourceTransactionManager transactionManager;

    @Override
    public ModelAndView index() {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("license", haspLicenseUtil.login());
        return modelAndView;
    }

    @Override
    public ModelAndView login(HttpServletRequest request, Map<String, String> parameters) {
        License license = haspLicenseUtil.login();

        if (HaspStatus.HASP_STATUS_OK == license.getStatus()) {
            UsersBean usersBean = usersDao.findByUsersForLogin(parameters);

            if(usersBean != null && StringUtils.notNullCheck(usersBean.getUserId())){
                AdminHelper.setAdminInfo(request, usersBean);
                addLogAuthAdminUser(request, usersBean.getUserId(), AdminResource.ADMIN_LOG_TYPE[0]);
            }else{
                throw new IcentException("");
            }
        }

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("license",license);
        return modelAndView;
    }

    @Override
    public ModelAndView externalLogin(HttpServletRequest request, Map<String, String> parameters) {
        UsersBean usersBean = usersDao.findByUsers(parameters);

        if(usersBean != null && StringUtils.notNullCheck(usersBean.getUserId())){
            AdminHelper.setAdminInfo(request, usersBean);
            addLogAuthAdminUser(request, usersBean.getUserId(), AdminResource.ADMIN_LOG_TYPE[0]);
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView logout(HttpServletRequest request) {
        try{
            addLogAuthAdminUser(request, null, AdminResource.ADMIN_LOG_TYPE[1]);
            AdminHelper.removeAdminInfo(request);
        }catch(Exception e){
        }
        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    /**
     * 관리자 로그인/아웃 이력 등록
     *
     * @author kst
     * @param request
     * @param type
     */
    private void addLogAuthAdminUser(HttpServletRequest request, String adminId, String type){
        LoginHistoryBean loginHistoryBean = new LoginHistoryBean();
        loginHistoryBean.setLogId(StringUtils.getGUID32());
        String id = adminId == null ? AdminHelper.getAdminIdFromSession(request) : adminId;
        loginHistoryBean.setUserId(id);
        loginHistoryBean.setLoginFlag(type);

        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_CLIENT_IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_X_FORWARDED_FOR");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }

        loginHistoryBean.setIpAddress(ip);

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try{
            loginHistoryDao.addLoginHistory(loginHistoryBean);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new IcentException("");
        }
    }
}
