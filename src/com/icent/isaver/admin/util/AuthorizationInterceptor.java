package com.icent.isaver.admin.util;

import com.icent.isaver.admin.resource.AdminResource;
import com.icent.isaver.admin.svc.TemplateSettingSvc;
import com.icent.isaver.repository.bean.UsersBean;
import com.kst.common.util.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.net.InetAddress;
import java.util.Date;

/**
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
public class AuthorizationInterceptor extends HandlerInterceptorAdapter {

    @Value("${cnf.server.version}")
    private String version = null;

    @Value("${ws.server.address}")
    private String wsAddress = null;

    @Value("${ws.server.port}")
    private String wsPort = null;

    @Value("${ws.server.projectName}")
    private String wsProjectName = null;

    @Value("${ws.server.eventUrlConnect}")
    private String wsEventUrlConnect = null;

    @Value("${ws.server.mapUrlConnect}")
    private String wsMapUrlConnect = null;

    @Inject
    private IsaverCriticalUtil isaverCriticalUtil;

    @Inject
    private TemplateSettingSvc templateSettingSvc;

    @Inject
    private IsaverTargetUtil isaverTargetUtil;

    /**
     * 인자절차가 필요없는 path</br>
     * - properties/config.properties 참조
     * @author kst
     * @since 2013. 10. 25.
     */
    private String[] noneAuthorTargets;

    public void setNoneAuthorTargets(String value){
        if(value != null && value.length() > 1){
            this.noneAuthorTargets = value.split(",");
        }
    }

    private String redirectPath = "/";

    public void setRedirectPath(String value){
        if(value != null && value.length()> 1){
            this.redirectPath = value;
        }
    }

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        String path = request.getServletPath();
        path = path.substring(0,path.lastIndexOf("."));
        boolean authorTargetFlag = true;
        if(noneAuthorTargets != null && noneAuthorTargets.length > 1){
            for(String target : noneAuthorTargets){
                if(StringUtils.notNullCheck(path) && path.equals(target)){ // 인가 체크 대상이 아님.
                    authorTargetFlag = false;
                    break;
                }else{ // 인가 유효성 체크 대상.
                    authorTargetFlag = true;
                }
            }
        }

        if(authorTargetFlag){
            UsersBean usersBean;
            String redirectUrl = null;

            usersBean = AdminHelper.getAdminInfo(request);
            redirectUrl = request.getContextPath();
            if(this.redirectPath != null){
                redirectUrl += this.redirectPath;
            }

            if(usersBean == null || usersBean.getUserId() == null) { // 비인가 접근
                response.sendRedirect(redirectUrl);
            }
        }

        return super.preHandle(request, response, handler);
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {

        Date serverDatetime = new Date();
        modelAndView.addObject("serverDatetime", serverDatetime.getTime());
        InetAddress address = InetAddress.getByName(wsAddress);
        modelAndView.addObject("eventWebSocketUrl", "ws://" + address.getHostAddress() + ":" + wsPort + "/" + wsProjectName + wsEventUrlConnect);
        modelAndView.addObject("mapWebSocketUrl", "ws://" + address.getHostAddress() + ":" + wsPort + "/" + wsProjectName + wsMapUrlConnect);
        modelAndView.addObject("rootPath", request.getContextPath());
        modelAndView.addObject("version", AdminResource.DEPLOY_DATETIME);
        modelAndView.addObject("templateSetting",templateSettingSvc.findListTemplateSetting());
        modelAndView.addObject("mainTarget", isaverTargetUtil.getTarget());
        modelAndView.addObject("criticalList", isaverCriticalUtil.getCritical());
        modelAndView.addObject("criticalLevelCss", AdminResource.CRITICAL_LEVEL_CSS);
        modelAndView.addObject("serverVersion", version);
        super.postHandle(request, response, handler, modelAndView);
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
        super.afterCompletion(request, response, handler, ex);
    }

    @Override
    public void afterConcurrentHandlingStarted(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        super.afterConcurrentHandlingStarted(request, response, handler);
    }
}
