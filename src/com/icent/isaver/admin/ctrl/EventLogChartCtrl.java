package com.icent.isaver.admin.ctrl;

import com.icent.isaver.admin.svc.EventLogChartSvc;
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
@RequestMapping(value="/eventLogChart/*")
public class EventLogChartCtrl {

    @Inject
    private EventLogChartSvc eventLogChartSvc;

    /**
     * [전체][CHART] 로그 분류별 상태 데이터 로그를 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/all")
    public ModelAndView findAllChartEventLogCrane(@RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = eventLogChartSvc.findAllChartEventLog(parameters);
        return modelAndView;
    }

    /**
     * [상세][CHART] 로그 분류별 상태 데이터 로그를 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/detail")
    public ModelAndView findDetailChartEventLogCrane(@RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = eventLogChartSvc.findDetailChartEventLog(parameters);
        return modelAndView;
    }

}
