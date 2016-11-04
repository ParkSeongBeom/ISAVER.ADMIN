package com.icent.isaver.admin.ctrl;

import com.icent.isaver.admin.svc.EventLogWorkerSvc;
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
@RequestMapping(value="/eventLogWorker/*")
public class EventLogWorkerCtrl {

    @Inject
    private EventLogWorkerSvc eventLogWorkerSvc;

    /**
     * 작업자 상태 전체 데이터를 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/list")
    public ModelAndView findAllEventLogWorker(@RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = eventLogWorkerSvc.findAllEventLogWorker(parameters);
        return modelAndView;
    }

    /**
     * 작업자 상태 상세 데이터를 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/detail")
    public ModelAndView findListEventLogWorker(@RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = eventLogWorkerSvc.findListEventLogWorker(parameters);
        return modelAndView;
    }

    /**
     * [CHART] 작업자 상태 데이터 로그를 가져온다.
     *
     * @author dhj
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/chartList")
    public ModelAndView findChartEventLogWorker(@RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = eventLogWorkerSvc.findChartEventLogWorker(parameters);
        return modelAndView;
    }

}
