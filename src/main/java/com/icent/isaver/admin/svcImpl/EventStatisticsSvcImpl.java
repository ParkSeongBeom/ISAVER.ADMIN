package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.bean.EventBean;
import com.icent.isaver.admin.bean.EventStatisticsBean;
import com.icent.isaver.admin.dao.EventDao;
import com.icent.isaver.admin.dao.EventStatisticsDao;
import com.icent.isaver.admin.svc.EventStatisticsSvc;
import com.kst.common.resource.CommonResource;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 이벤트 통계 Service Implements
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
 *  2018. 2. 21.     psb           통계 메뉴 정리
 *  2018. 2. 23.     psb           통계 테이블 변경으로 인한 수정
 * </pre>
 */
@Service
public class EventStatisticsSvcImpl implements EventStatisticsSvc {
    @Inject
    private EventStatisticsDao eventStatisticsDao;

    @Inject
    private EventDao eventDao;

    @Override
    public ModelAndView findListEventStatistics(Map<String, String> parameters) {
        List<EventBean> eventList = eventDao.findListEvent(null);
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("eventList",eventList);
        return modelAndView;
    }

    @Override
    public ModelAndView findListEventStatisticsHour(Map<String, String> parameters) {
        Map paramBean = new HashMap();
        paramBean.put("eventIds", parameters.get("eventIds").split(CommonResource.COMMA_STRING));
        paramBean.put("areaId",parameters.get("areaId"));
        paramBean.put("startDatetime",parameters.get("startDatetime"));
        paramBean.put("endDatetime",parameters.get("endDatetime"));

        List<EventStatisticsBean> eventStatisticsList = eventStatisticsDao.findListEventStatisticsHour(paramBean);
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("eventStatisticsList",eventStatisticsList);
        return modelAndView;
    }

    @Override
    public ModelAndView findListEventStatisticsDay(Map<String, String> parameters) {
        Map paramBean = new HashMap();
        paramBean.put("eventIds", parameters.get("eventIds").split(CommonResource.COMMA_STRING));
        paramBean.put("areaId",parameters.get("areaId"));
        paramBean.put("startDatetime",parameters.get("startDatetime"));
        paramBean.put("endDatetime",parameters.get("endDatetime"));

        List<EventStatisticsBean> eventStatisticsList = eventStatisticsDao.findListEventStatisticsDay(paramBean);
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("eventStatisticsList",eventStatisticsList);
        return modelAndView;
    }

    @Override
    public ModelAndView findListEventStatisticsDow(Map<String, String> parameters) {
        Map paramBean = new HashMap();
        paramBean.put("eventIds", parameters.get("eventIds").split(CommonResource.COMMA_STRING));
        paramBean.put("areaId",parameters.get("areaId"));
        paramBean.put("startDatetime",parameters.get("startDatetime"));
        paramBean.put("endDatetime",parameters.get("endDatetime"));

        List<EventStatisticsBean> eventStatisticsList = eventStatisticsDao.findListEventStatisticsDow(paramBean);
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("eventStatisticsList",eventStatisticsList);
        return modelAndView;
    }

    @Override
    public ModelAndView findListEventStatisticsWeek(Map<String, String> parameters) {
        Map paramBean = new HashMap();
        paramBean.put("eventIds", parameters.get("eventIds").split(CommonResource.COMMA_STRING));
        paramBean.put("areaId",parameters.get("areaId"));
        paramBean.put("startDatetime",parameters.get("startDatetime"));
        paramBean.put("endDatetime",parameters.get("endDatetime"));

        List<EventStatisticsBean> eventStatisticsList = eventStatisticsDao.findListEventStatisticsWeek(paramBean);
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("eventStatisticsList",eventStatisticsList);
        return modelAndView;
    }

    @Override
    public ModelAndView findListEventStatisticsMonth(Map<String, String> parameters) {
        Map paramBean = new HashMap();
        paramBean.put("eventIds", parameters.get("eventIds").split(CommonResource.COMMA_STRING));
        paramBean.put("areaId",parameters.get("areaId"));
        paramBean.put("startDatetime",parameters.get("startDatetime"));
        paramBean.put("endDatetime",parameters.get("endDatetime"));

        List<EventStatisticsBean> eventStatisticsList = eventStatisticsDao.findListEventStatisticsMonth(paramBean);
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("eventStatisticsList",eventStatisticsList);
        return modelAndView;
    }

    @Override
    public ModelAndView findListEventStatisticsYear(Map<String, String> parameters) {
        Map paramBean = new HashMap();
        paramBean.put("eventIds", parameters.get("eventIds").split(CommonResource.COMMA_STRING));
        paramBean.put("areaId",parameters.get("areaId"));
        paramBean.put("startDatetime",parameters.get("startDatetime"));
        paramBean.put("endDatetime",parameters.get("endDatetime"));

        List<EventStatisticsBean> eventStatisticsList = eventStatisticsDao.findListEventStatisticsYear(paramBean);
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("eventStatisticsList",eventStatisticsList);
        return modelAndView;
    }
}
