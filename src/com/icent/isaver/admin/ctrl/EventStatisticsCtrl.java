package com.icent.isaver.admin.ctrl;

import com.icent.isaver.admin.svc.EventStatisticsSvc;
import com.kst.common.util.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import java.util.Map;

/**
 * 이벤트 통계 Controller
 *
 * @author : psb
 * @version : 1.0
 * @since : 2016. 8. 4.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2016. 8. 4.     psb           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value="/eventStatistics/*")
public class EventStatisticsCtrl {

    @Inject
    private EventStatisticsSvc eventStatisticsSvc;

    /**
     * 이벤트 통계 화면을 가져온다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/list")
    public ModelAndView findListEventStatistics(@RequestParam Map<String, String> parameters) {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("eventStatistics");
        return modelAndView;
    }

    /**
     * 구역별 이벤트 통계 목록을 가져온다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/area")
    public ModelAndView findListAreaEventStatistics(@RequestParam Map<String, String> parameters) {
        ModelAndView modelAndView = new ModelAndView();

        if(StringUtils.notNullCheck(parameters.get("mode"))){
            modelAndView = eventStatisticsSvc.findListAreaEventStatistics(parameters);
        }
        modelAndView.setViewName("areaEventStatistics");
        return modelAndView;
    }

    /**
     * 작업자 이벤트 통계 목록을 가져온다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/worker")
    public ModelAndView findListWorkerEventStatistics(@RequestParam Map<String, String> parameters) {
        ModelAndView modelAndView = new ModelAndView();

        if(StringUtils.notNullCheck(parameters.get("mode"))){
            modelAndView = eventStatisticsSvc.findListWorkerEventStatistics(parameters);
        }
        modelAndView.setViewName("workerEventStatistics");
        return modelAndView;
    }

    /**
     * 크레인 이벤트 통계 목록을 가져온다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/crane")
    public ModelAndView findListCraneEventStatistics(@RequestParam Map<String, String> parameters) {
        ModelAndView modelAndView = new ModelAndView();

        if(StringUtils.notNullCheck(parameters.get("mode"))){
            modelAndView = eventStatisticsSvc.findListCraneEventStatistics(parameters);
        }
        modelAndView.setViewName("craneEventStatistics");
        return modelAndView;
    }

    /**
     * 유해가스 이벤트 통계 목록을 가져온다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/gas")
    public ModelAndView findListGasEventStatistics(@RequestParam Map<String, String> parameters) {
        ModelAndView modelAndView = new ModelAndView();

        if(StringUtils.notNullCheck(parameters.get("mode"))){
            modelAndView = eventStatisticsSvc.findListGasEventStatistics(parameters);
        }
        modelAndView.setViewName("gasEventStatistics");
        return modelAndView;
    }

    /**
     * 진출입자 이벤트 통계 목록을 가져온다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/inout")
    public ModelAndView findListInoutEventStatistics(@RequestParam Map<String, String> parameters) {
        ModelAndView modelAndView = new ModelAndView();

        if(StringUtils.notNullCheck(parameters.get("mode"))){
            modelAndView = eventStatisticsSvc.findListInoutEventStatistics(parameters);
        }
        modelAndView.setViewName("inoutEventStatistics");
        return modelAndView;
    }
}
