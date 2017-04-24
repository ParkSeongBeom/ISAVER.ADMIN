package com.icent.isaver.admin.ctrl;

import com.icent.isaver.admin.common.resource.IcentException;
import com.icent.isaver.admin.svc.EventSvc;
import com.icent.isaver.admin.util.AdminHelper;
import com.kst.common.util.MapUtils;
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
 * Created by icent on 16. 5. 31..
 */
@Controller
@RequestMapping(value="/event/*")
public class EventCtrl {

    @Value("${cnf.defaultPageSize}")
    private String defaultPageSize;

    @Inject
    private EventSvc eventSvc;
    /**
     * 이벤트 목록을 가져온다.
     *
     * @author dhj
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/list")
    public ModelAndView findListEvent(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        parameters = AdminHelper.checkReloadList(request, response, "eventList", parameters);
        AdminHelper.setPageParam(parameters, defaultPageSize);

        ModelAndView modelAndView = eventSvc.findListEvent(parameters);
        modelAndView.setViewName("eventList");
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }
    /**
     *  이벤트 정보를 가져온다.
     *
     * @author dhj
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/detail")
    public ModelAndView findByEvent(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        ModelAndView modelAndView = eventSvc.findByEvent(parameters);
        modelAndView.setViewName("eventDetail");
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    private final static String[] addEventParam = new String[]{"eventName","eventFlag"};

    /**
     *  이벤트를 등록 한다.
     *
     * @author dhj
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/add")
    public ModelAndView addEvent(HttpServletRequest request, @RequestParam Map<String, String> parameters) {

        if(MapUtils.nullCheckMap(parameters, addEventParam)){
            throw new IcentException("");
        }

        parameters.put("insertUserId",AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = eventSvc.addEvent(request, parameters);
        return modelAndView;
    }

    private final static String[] saveEventParam = new String[]{"eventName","eventFlag"};
    /**
     *  이벤트를 수정 한다.
     *
     * @author dhj
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/save")
    public ModelAndView saveEvent(HttpServletRequest request, @RequestParam Map<String, String> parameters) {

        if(MapUtils.nullCheckMap(parameters, saveEventParam)){
            throw new IcentException("");
        }

        parameters.put("updateUserId",AdminHelper.getAdminIdFromSession(request));
        parameters.put("insertUserId",AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = eventSvc.saveEvent(request, parameters);
        return modelAndView;
    }

    private final static String[] removeEventParam = new String[]{"eventId"};
    /**
     *  이벤트를 제거 한다.
     *
     * @author dhj
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/remove")
    public ModelAndView removeEvent(HttpServletRequest request, @RequestParam Map<String, String> parameters) {

        if(MapUtils.nullCheckMap(parameters, removeEventParam)){
            throw new IcentException("");
        }

        parameters.put("updateUserId",AdminHelper.getAdminIdFromSession(request));

        ModelAndView modelAndView = eventSvc.removeEvent(parameters);
        return modelAndView;
    }
}
