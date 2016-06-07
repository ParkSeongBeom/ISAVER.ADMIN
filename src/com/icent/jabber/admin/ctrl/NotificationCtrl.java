package com.icent.jabber.admin.ctrl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.svc.NotificationSvc;
import com.icent.jabber.admin.util.AdminHelper;
import com.kst.common.util.MapUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import java.util.Map;

/**
 * 미리알림 관리 Controller
 * @author : psb
 * @version : 1.0
 * @since : 2015. 02. 11.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2015. 02. 11.     psb           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value="/notification/*")
public class NotificationCtrl {

    @Value("#{configProperties['cnf.defaultPageSize']}")
    private String defaultPageSize;

    @Inject
    private NotificationSvc notificationSvc;

    /**
     * 미리알림 목록을 가져온다.
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="list")
    public ModelAndView findAllNotification(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = notificationSvc.findAllNotification(parameters);
        modelAndView.setViewName("notificationList");
        return modelAndView;
    }

    /**
     * 상세 미리알림을 가져온다.
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="detail")
    public ModelAndView findByNotification(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = notificationSvc.findByNotification(parameters);
        modelAndView.setViewName("notificationDetail");
        return modelAndView;
    }

    private final static String[] saveNotificationParam = new String[]{"notiId", "notiName", "type", "useYn"};

    /**
     * 미리알림을 저장한다.
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="save")
    public ModelAndView saveNotification(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, saveNotificationParam)){
            throw new JabberException("");
        }

        parameters.put("updateUserId",AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = notificationSvc.saveNotification(parameters);
        modelAndView.setViewName("notificationDetail");
        return modelAndView;
    }
}
