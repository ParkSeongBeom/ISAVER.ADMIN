package com.icent.isaver.admin.ctrl;

import com.icent.isaver.admin.common.resource.IsaverException;
import com.icent.isaver.admin.svc.StatisticsSvc;
import com.icent.isaver.admin.util.AdminHelper;
import com.meous.common.util.MapUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
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
public class StatisticsCtrl {

    @Inject
    private StatisticsSvc statisticsSvc;

    /**
     * 이벤트 통계 화면을 가져온다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/list")
    public ModelAndView findListStatistics(@RequestParam Map<String, String> parameters) {
        ModelAndView modelAndView = statisticsSvc.findListStatistics(parameters);
        modelAndView.setViewName("eventStatistics");
        return modelAndView;
    }

    /**
     * 이벤트 통계 화면을 가져온다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/search")
    public ModelAndView findListStatisticsSearch(@RequestParam Map<String, String> parameters) {
        ModelAndView modelAndView = statisticsSvc.findListStatisticsSearch(parameters);
        return modelAndView;
    }

    private final static String[] addStatisticsParam = new String[]{"statisticsName", "chartType", "jsonData"};

    /**
     * 이벤트 통계를 등록 한다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/add")
    public ModelAndView addStatistics(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, addStatisticsParam)){
            throw new IsaverException("");
        }
        parameters.put("insertUserId", AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = statisticsSvc.addStatistics(parameters);
        return modelAndView;
    }

    private final static String[] saveStatisticsParam = new String[]{"statisticsId", "statisticsName", "chartType", "jsonData"};

    /**
     * 이벤트 통계를 수정 한다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/save")
    public ModelAndView saveStatistics(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, saveStatisticsParam)){
            throw new IsaverException("");
        }
        parameters.put("updateUserId",AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = statisticsSvc.saveStatistics(parameters);
        return modelAndView;
    }

    private final static String[] removeStatisticsParam = new String[]{"statisticsId"};

    /**
     * 이벤트 통계를 제거 한다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/remove")
    public ModelAndView removeStatistics(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, removeStatisticsParam)){
            throw new IsaverException("");
        }
        ModelAndView modelAndView = statisticsSvc.removeStatistics(parameters);
        return modelAndView;
    }
}
