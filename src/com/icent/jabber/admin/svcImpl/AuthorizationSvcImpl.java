package com.icent.jabber.admin.svcImpl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.resource.AdminResource;
import com.icent.jabber.admin.svc.AuthorizationSvc;
import com.icent.jabber.admin.util.AdminHelper;
import com.icent.jabber.repository.bean.AdminBean;
import com.icent.jabber.repository.bean.LogAuthAdminUserBean;
import com.icent.jabber.repository.dao.base.AdminDao;
import com.icent.jabber.repository.dao.log.LogAuthAdminUserLogDao;
import com.kst.common.springutil.TransactionUtil;
import com.kst.common.util.StringUtils;
import com.kst.digest.resource.DigestAlgorithm;
import com.kst.digest.util.DigestUtils;
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
    private AdminDao adminDao;

    @Inject
    private LogAuthAdminUserLogDao logAuthAdminUserLogDao;

    @Resource(name="mybatisLogTxManager")
    private DataSourceTransactionManager logTransactionManager;

    @Override
    public ModelAndView login(HttpServletRequest request, Map<String, String> parameters) {
        AdminBean paramBean = AdminHelper.convertMapToBean(parameters, AdminBean.class);
        paramBean.setPassword(DigestUtils.digest(DigestAlgorithm.MD5, paramBean.getPassword()));

        AdminBean adminBean = adminDao.findByAdminForLogin(paramBean);

        if(adminBean != null && StringUtils.notNullCheck(adminBean.getAdminId())){
            AdminHelper.setAdminInfo(request, adminBean);
//            addLogAuthAdminUser(request, paramBean.getAdminId(), AdminResource.RESULT_STATUS_TYPE[0] , AdminResource.ADMIN_LOG_TYPE[0]);
        }else{
//            addLogAuthAdminUser(request, paramBean.getAdminId(), AdminResource.RESULT_STATUS_TYPE[1] , AdminResource.ADMIN_LOG_TYPE[0]);
            throw new JabberException("");
        }


        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView logout(HttpServletRequest request) {
        try{
            addLogAuthAdminUser(request, null, AdminResource.RESULT_STATUS_TYPE[0] , AdminResource.ADMIN_LOG_TYPE[1]);
            AdminHelper.removeAdminInfo(request);
        }catch(Exception e){
            addLogAuthAdminUser(request, null, AdminResource.RESULT_STATUS_TYPE[1] , AdminResource.ADMIN_LOG_TYPE[1]);
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
    private void addLogAuthAdminUser(HttpServletRequest request, String adminId, String status, String type){
        LogAuthAdminUserBean logAuthAdminUserParamBean = new LogAuthAdminUserBean();
        logAuthAdminUserParamBean.setLogAuthId(StringUtils.getGUID36());
        String id = adminId == null ? AdminHelper.getAdminIdFromSession(request) : adminId;
        logAuthAdminUserParamBean.setAdminUserId(id);
        logAuthAdminUserParamBean.setLogType(type);
        logAuthAdminUserParamBean.setStatus(status);

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

        logAuthAdminUserParamBean.setIpAddress(ip);
//        logAuthAdminUserParamBean.setIpAddress(request.getRemoteAddr());

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(logTransactionManager);

        try{
            logAuthAdminUserLogDao.addLogAuthAdminUser(logAuthAdminUserParamBean);
            logTransactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            logTransactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }
    }

    @Override
    public ModelAndView findByMain(HttpServletRequest request){
        String roleId = "";

        try{
            roleId = AdminHelper.getAdminInfo(request).getRoleId();
        }catch(Exception e){
        }

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("roleId", roleId);
        return modelAndView;
    }
}
