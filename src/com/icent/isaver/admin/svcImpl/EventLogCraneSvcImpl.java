package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.resource.AdminResource;
import com.icent.isaver.admin.svc.EventLogCraneSvc;
import com.icent.isaver.repository.bean.EventLogCraneBean;
import com.icent.isaver.repository.dao.base.EventLogCraneDao;
import com.kst.common.util.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 이벤트 로그 크레인 Service implements
 * @author : psb
 * @version : 1.0
 * @since : 2016. 6. 21.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2016. 6. 21.     psb           최초 생성
 * </pre>
 */
@Service
public class EventLogCraneSvcImpl implements EventLogCraneSvc {

    @Inject
    private EventLogCraneDao eventLogCraneDao;

    @Override
    public ModelAndView findAllEventLogCrane(Map<String, String> parameters) {
        Map param = new HashMap();
        param.put("eventIds", AdminResource.CRANE_EVENT_ID_DETAIL);
        List<EventLogCraneBean> eventLogCraneList = eventLogCraneDao.findAllEventLogCrane(param);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("eventLogCraneList", eventLogCraneList);
        modelAndView.addObject("paramBean",parameters);

        return modelAndView;
    }

    @Override
    public ModelAndView findListEventLogCrane(Map<String, String> parameters) {
        Map param = new HashMap();
        param.put("areaId", parameters.get("areaId"));
        if(StringUtils.notNullCheck(parameters.get("datetime"))){
            param.put("datetime", parameters.get("datetime"));
        }
        param.put("eventIds", AdminResource.CRANE_EVENT_ID_ALL);

        List<EventLogCraneBean> eventLogCraneCountList = eventLogCraneDao.findCountListEventLogCrane(param);
        List<EventLogCraneBean> eventLogCraneList = eventLogCraneDao.findListEventLogCrane(param);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("eventLogCraneCountList", eventLogCraneCountList);
        modelAndView.addObject("eventLogCraneList", eventLogCraneList);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView findChartEventLogCrane(Map<String, String> parameters) {
        Map param = new HashMap();
        param.put("minutesCount", parameters.get("minutesCount"));
        if(StringUtils.notNullCheck(parameters.get("pageIndex"))){
            param.put("pageIndex", parameters.get("pageIndex"));
        }
        if(StringUtils.notNullCheck(parameters.get("areaId"))){
            param.put("areaId", parameters.get("areaId"));
        }
        param.put("eventIds", AdminResource.WORKER_EVENT_ID);
        List<EventLogCraneBean> eventLogCraneChart = eventLogCraneDao.findChartEventLogCrane(param);
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("eventLogCraneChart", eventLogCraneChart);
        return modelAndView;
    }
}
