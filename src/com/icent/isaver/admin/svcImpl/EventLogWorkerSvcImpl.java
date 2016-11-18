package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.resource.AdminResource;
import com.icent.isaver.admin.svc.EventLogWorkerSvc;
import com.icent.isaver.repository.bean.EventLogWorkerBean;
import com.icent.isaver.repository.dao.base.EventLogWorkerDao;
import com.kst.common.util.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 이벤트 로그 작업자 Service implements
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
public class EventLogWorkerSvcImpl implements EventLogWorkerSvc {

    @Inject
    private EventLogWorkerDao eventLogWorkerDao;

    @Override
    public ModelAndView findAllEventLogWorker(Map<String, String> parameters) {
        Map param = new HashMap();
        param.put("eventIds", AdminResource.WORKER_EVENT_ID_DETAIL);
        List<EventLogWorkerBean> eventLogWorkerList = eventLogWorkerDao.findAllEventLogWorker(param);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("eventLogWorkerList", eventLogWorkerList);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView findListEventLogWorker(Map<String, String> parameters) {
        Map param = new HashMap();
        param.put("areaId", parameters.get("areaId"));
        if(StringUtils.notNullCheck(parameters.get("datetime"))){
            param.put("datetime", parameters.get("datetime"));
        }
        param.put("eventIds", AdminResource.WORKER_EVENT_ID_DETAIL);

        List<EventLogWorkerBean> eventLogWorkerCountList = eventLogWorkerDao.findCountListEventLogWorker(param);

        param.put("eventIds", AdminResource.WORKER_EVENT_ID_ALL);
        List<EventLogWorkerBean> eventLogWorkerList = eventLogWorkerDao.findListEventLogWorker(param);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("eventLogWorkerCountList", eventLogWorkerCountList);
        modelAndView.addObject("eventLogWorkerList", eventLogWorkerList);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView findChartEventLogWorker(Map<String, String> parameters) {
        Map param = new HashMap();
        param.put("minutesCount", parameters.get("minutesCount"));
        if(StringUtils.notNullCheck(parameters.get("pageIndex"))){
            param.put("pageIndex", parameters.get("pageIndex"));
        }
        if(StringUtils.notNullCheck(parameters.get("areaId"))){
            param.put("areaId", parameters.get("areaId"));
        }
        param.put("eventIds", AdminResource.WORKER_EVENT_ID_DETAIL);
        List<EventLogWorkerBean> eventLogWorkerChart = eventLogWorkerDao.findChartEventLogWorker(param);
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("eventLogWorkerChart", eventLogWorkerChart);
        return modelAndView;
    }
}
