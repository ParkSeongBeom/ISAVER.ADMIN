package com.icent.isaver.admin.ctrl;

import com.icent.isaver.admin.common.resource.IsaverException;
import com.icent.isaver.admin.svc.EventLogSvc;
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

@Controller
@RequestMapping(value="/eventLog/*")
public class EventLogCtrl {

    @Value("${cnf.defaultPageSize}")
    private String defaultPageSize;

    @Inject
    private EventLogSvc eventLogSvc;

    /**
     * 이벤트 로그 목록을 가져온다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/list")
    public ModelAndView findListEventLog(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        parameters = AdminHelper.checkReloadList(request, response, "eventLogList", parameters);
        parameters = AdminHelper.checkSearchDate(parameters,0);
        AdminHelper.setPageParam(parameters, defaultPageSize);

        ModelAndView modelAndView = eventLogSvc.findListEventLog(parameters);
        modelAndView.setViewName("eventLogList");
        return modelAndView;
    }

    /**
     * 이벤트 로그 상세를 가져온다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/detail")
    public ModelAndView findByEventLog(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = eventLogSvc.findByEventLog(parameters);
        return modelAndView;
    }

    /**
     * 이벤트 로그 목록을 가져온다. (blinker)
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/blinkerList")
    public ModelAndView findListEventLogBlinkerForArea(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        parameters.put("userId", AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = eventLogSvc.findListEventLogBlinkerForArea(parameters);
        return modelAndView;
    }

    private final static String[] findByEventLogToiletRoomForAreaParam = new String[]{"areaId"};

    /**
     * 이벤트 로그 목록을 가져온다. (toilet room)
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/toiletRoom")
    public ModelAndView findByEventLogToiletRoomForArea(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        if(MapUtils.nullCheckMap(parameters, findByEventLogToiletRoomForAreaParam)){
            throw new IsaverException("");
        }

        ModelAndView modelAndView = eventLogSvc.findByEventLogToiletRoomForArea(parameters);
        return modelAndView;
    }

    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/excel")
    public ModelAndView downloadExcel(HttpServletRequest request,  HttpServletResponse response, @RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = eventLogSvc.findListEventLogForExcel(request, response, parameters);
        modelAndView.setViewName("excelDownloadView");
        return modelAndView;
    }

    /**
     * 이벤트 로그 차트를 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/chart")
    public ModelAndView findListEventLogChart(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = eventLogSvc.findListEventLogChart(parameters);
        return modelAndView;
    }

    /**
     * 자원 모니터링 차트를 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/resourceChart")
    public ModelAndView findListEventLogResourceChart(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = eventLogSvc.findListEventLogResourceChart(parameters);
        return modelAndView;
    }
}
