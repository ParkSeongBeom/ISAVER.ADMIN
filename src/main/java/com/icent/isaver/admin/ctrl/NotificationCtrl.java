package com.icent.isaver.admin.ctrl;

import com.icent.isaver.admin.common.resource.IsaverException;
import com.icent.isaver.admin.svc.NotificationSvc;
import com.icent.isaver.admin.util.AdminHelper;
import com.meous.common.util.MapUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;

/**
 * 알림센터 Controller
 * @author : psb
 * @version : 1.0
 * @since : 2018. 2. 20.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2018. 2. 20.     psb           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value="/notification/*")
public class NotificationCtrl {

    @Value("${cnf.defaultPageSize}")
    private String defaultPageSize;

    @Inject
    private NotificationSvc notificationSvc;

    /**
     * 알림센터 이력 목록을 가져온다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET}, value="/list")
    public ModelAndView findListNotification(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        parameters = AdminHelper.checkReloadList(request, response, "notificationList", parameters);
        parameters = AdminHelper.checkSearchDate(parameters,1);
        AdminHelper.setPageParam(parameters, defaultPageSize);

        ModelAndView modelAndView = notificationSvc.findListNotification(parameters);
        modelAndView.setViewName("notificationList");
        return modelAndView;
    }

    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/excel")
    public ModelAndView downloadExcel(HttpServletRequest request,  HttpServletResponse response, @RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = notificationSvc.findListNotificationForExcel(request, response, parameters);
        modelAndView.setViewName("excelDownloadView");
        return modelAndView;
    }

    /**
     * 알림센터 목록을 가져온다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET}, value="/dashboard")
    public ModelAndView findListNotificationForDashboard(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = notificationSvc.findListNotificationForDashboard(parameters);
        return modelAndView;
    }

    /**
     * 알림센터 목록을 가져온다. (스쿨존)
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET}, value="/school")
    public ModelAndView findListNotificationForSchool(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = notificationSvc.findListNotificationForSchool(parameters);
        return modelAndView;
    }

    private final static String[] saveNotificationParam = new String[]{"paramData","actionType"};

    /**
     * 알림센터를 저장한다. (해제, 확인)
     *
     * @author psb
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET}, value="/save")
    public ModelAndView saveNotification(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        if(MapUtils.nullCheckMap(parameters, saveNotificationParam)){
            throw new IsaverException("");
        }
        parameters.put("updateUserId", AdminHelper.getAdminIdFromSession(request));
        parameters.put("updateUserName", AdminHelper.getAdminNameFromSession(request));
        ModelAndView modelAndView = notificationSvc.saveNotification(parameters);
        return modelAndView;
    }

    /**
     * 알림센터 전체를 해제한다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET}, value="/allCancel")
    public ModelAndView allCancelNotification(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        parameters.put("updateUserId", AdminHelper.getAdminIdFromSession(request));
        parameters.put("cancelDesc", "all cancel");
        ModelAndView modelAndView = notificationSvc.allCancelNotification(parameters);
        return modelAndView;
    }

    /**
     * 알림센터 전체를 해제한다. crontab용
     *
     * @author psb
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET}, value="/allCancelCron")
    public ModelAndView allCancelNotificationForCron(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        parameters.put("updateUserId", "crontab");
        parameters.put("cancelDesc", "crontab all cancel");
        ModelAndView modelAndView = notificationSvc.allCancelNotification(parameters);
        return modelAndView;
    }

    /**
     * 알림센터 목록을 가져온다. 히트맵용
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET}, value="/heatMap")
    public ModelAndView findListNotificationForHeatMap(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = notificationSvc.findListNotificationForHeatMap(parameters);
        return modelAndView;
    }
}
