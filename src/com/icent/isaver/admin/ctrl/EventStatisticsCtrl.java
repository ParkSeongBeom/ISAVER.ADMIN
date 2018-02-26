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
        ModelAndView modelAndView = eventStatisticsSvc.findListEventStatistics(parameters);
        modelAndView.setViewName("eventStatistics");
        return modelAndView;
    }

    /**
     * 이벤트 통계 화면을 가져온다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/search")
    public ModelAndView findListEventStatisticsSearch(@RequestParam Map<String, String> parameters) {
        ModelAndView modelAndView = new ModelAndView();

        if(StringUtils.notNullCheck(parameters.get("mode"))){
            switch (parameters.get("mode")){
                case "hour" :
                    modelAndView = eventStatisticsSvc.findListEventStatisticsHour(parameters);
                    break;
                case "day" :
                    modelAndView = eventStatisticsSvc.findListEventStatisticsDay(parameters);
                    break;
                case "dow" :
                    modelAndView = eventStatisticsSvc.findListEventStatisticsDow(parameters);
                    break;
                case "week" :
                    modelAndView = eventStatisticsSvc.findListEventStatisticsWeek(parameters);
                    break;
                case "month" :
                    modelAndView = eventStatisticsSvc.findListEventStatisticsMonth(parameters);
                    break;
                case "year" :
                    modelAndView = eventStatisticsSvc.findListEventStatisticsYear(parameters);
                    break;
            }
        }
        return modelAndView;
    }
}
