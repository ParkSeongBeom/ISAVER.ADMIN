package com.icent.isaver.admin.ctrl;

import com.icent.isaver.admin.svc.EventLogSvc;
import com.icent.isaver.admin.util.AdminHelper;
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
 * Created by icent on 16. 6. 1..
 */
@Controller
@RequestMapping(value="/eventLog/*")
public class EventLogCtrl {

    @Value("#{configProperties['cnf.defaultPageSize']}")
    private String defaultPageSize;

    @Inject
    private EventLogSvc eventLogSvc;

    /**
     * 이벤트 로그 목록을 가져온다.
     *
     * @author dhj
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/list")
    public ModelAndView findListEventLog(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        parameters = AdminHelper.checkReloadList(request, response, "eventLogList", parameters);
        AdminHelper.setPageParam(parameters, defaultPageSize);

        ModelAndView modelAndView = eventLogSvc.findListEventLog(parameters);
        modelAndView.setViewName("eventLogList");
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    /**
     *  이벤트 로그 정보를 가져온다.
     *
     * @author dhj
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/detail")
    public ModelAndView findByEventLog(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("eventLogDeatil");
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    /**
     * 알림센터 데이터를 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/alram")
    public ModelAndView findListEventLogForAlram(@RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = eventLogSvc.findListEventLogForAlram(parameters);
        return modelAndView;
    }

    /**
     * 작업자 상태 데이터를 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/worker")
    public ModelAndView findListEventLogForWorker(@RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = new ModelAndView();
//        ModelAndView modelAndView = eventLogSvc.findListEventLogForAlram(parameters);
        return modelAndView;
    }

    /**
     * 크래인 상태 데이터를 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/crane")
    public ModelAndView findListEventLogForCrane(@RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = new ModelAndView();
//        ModelAndView modelAndView = eventLogSvc.findListEventLogForAlram(parameters);
        return modelAndView;
    }

    /**
     * 작업자 진출입 데이터를 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/inout")
    public ModelAndView findListEventLogForInout(@RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = new ModelAndView();
//        ModelAndView modelAndView = eventLogSvc.findListEventLogForAlram(parameters);
        return modelAndView;
    }
}
