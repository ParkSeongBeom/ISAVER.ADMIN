package com.icent.isaver.admin.ctrl;

import com.icent.isaver.admin.svc.EventLogInoutSvc;
import com.icent.isaver.admin.util.AdminHelper;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import java.util.Map;

/**
 * Created by icent on 16. 6. 1..
 */
@Controller
@RequestMapping(value="/eventLogInout/*")
public class EventLogInoutCtrl {

    @Inject
    private EventLogInoutSvc eventLogInoutSvc;

    /**
     * 작업자 진출입 전체 데이터를 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/list")
    public ModelAndView findListEventLogInout(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        parameters.put("userId", AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = eventLogInoutSvc.findListEventLogInout(parameters);
        return modelAndView;
    }

    /**
     * 작업자 진출입 상세 데이터를 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/detail")
    public ModelAndView findByEventLogInout(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        parameters.put("userId", AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = eventLogInoutSvc.findByEventLogInout(parameters);
        return modelAndView;
    }

    /**
     * [CHART] 작업자 진출입 데이터 로그를 가져온다.
     *
     * @author dhj
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/chartList")
    public ModelAndView findChartEventLogInout(@RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = eventLogInoutSvc.findChartEventLogInout(parameters);
        return modelAndView;
    }
}
