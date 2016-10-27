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
        List<EventLogWorkerBean> eventLogWorkerList = eventLogWorkerDao.findAllEventLogWorker(parameters);

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
        param.put("eventIds", AdminResource.WORKER_EVENT_ID);

        List<EventLogWorkerBean> eventLogWorkerCountList = eventLogWorkerDao.findCountListEventLogWorker(param);
        List<EventLogWorkerBean> eventLogWorkerList = eventLogWorkerDao.findListEventLogWorker(param);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("eventLogWorkerCountList", eventLogWorkerCountList);
        modelAndView.addObject("eventLogWorkerList", eventLogWorkerList);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView findChartEventLogWorker(Map<String, String> parameters) {

        List<EventLogWorkerBean> eventLogWorkerChart = eventLogWorkerDao.findChartEventLogWorker(parameters);
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("eventLogWorkerChart", eventLogWorkerChart);
        return modelAndView;
    }
}
