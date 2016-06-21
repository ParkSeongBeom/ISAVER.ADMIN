package com.icent.isaver.admin.ctrl;

import com.icent.isaver.admin.svc.EventLogCraneSvc;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import java.util.Map;

/**
 * Created by icent on 16. 6. 1..
 */
@Controller
@RequestMapping(value="/eventLogCrane/*")
public class EventLogCraneCtrl {

    @Inject
    private EventLogCraneSvc eventLogCraneSvc;

    /**
     * 크래인 상태 데이터를 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/list")
    public ModelAndView findListEventLogCrane(@RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = eventLogCraneSvc.findListEventLogCrane(parameters);
        return modelAndView;
    }

    /**
     * [CHART] 크래인 상태 데이터 로그를 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/chartList")
    public ModelAndView findChartEventLogCrane(@RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = eventLogCraneSvc.findChartEventLogCrane(parameters);
        return modelAndView;
    }

}
