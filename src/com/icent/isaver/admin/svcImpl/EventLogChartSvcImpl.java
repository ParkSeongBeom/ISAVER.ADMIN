package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.svc.EventLogChartSvc;
import com.icent.isaver.admin.svc.EventLogCraneSvc;
import com.icent.isaver.repository.bean.EventLogCraneBean;
import com.icent.isaver.repository.bean.EventLogInoutBean;
import com.icent.isaver.repository.bean.EventLogWorkerBean;
import com.icent.isaver.repository.dao.base.EventLogCraneDao;
import com.icent.isaver.repository.dao.base.EventLogInoutDao;
import com.icent.isaver.repository.dao.base.EventLogWorkerDao;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
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
public class EventLogChartSvcImpl implements EventLogChartSvc {

    @Inject
    private EventLogCraneDao eventLogCraneDao;

    @Inject
    private EventLogWorkerDao eventLogWorkerDao;

    @Inject
    private EventLogInoutDao eventLogInoutDao;

    @Override
    public ModelAndView findAllChartEventLog(Map<String, String> parameters) {

        List<EventLogCraneBean> eventLogCraneChart = eventLogCraneDao.findChartEventLogCrane(parameters);
        List<EventLogWorkerBean> eventLogWorkerChart = eventLogWorkerDao.findChartEventLogWorker(parameters);

        ModelAndView modelAndView = new ModelAndView();

        modelAndView.addObject("eventLogCraneChart", eventLogCraneChart);
        modelAndView.addObject("eventLogWorkerChart", eventLogWorkerChart);

        return modelAndView;
    }

    @Override
    public ModelAndView findDetailChartEventLog(Map<String, String> parameters) {

        ModelAndView modelAndView = new ModelAndView();

        if (parameters.get("requestType") != null && parameters.get("areaId") != null) {
            if (parameters.get("requestType").equals("1")) {
                List<EventLogCraneBean> eventLogCraneChart = eventLogCraneDao.findChartEventLogCrane(parameters);
                List<EventLogWorkerBean> eventLogWorkerChart = eventLogWorkerDao.findChartEventLogWorker(parameters);

                modelAndView.addObject("eventLogCraneChart", eventLogCraneChart);
                modelAndView.addObject("eventLogWorkerChart", eventLogWorkerChart);
            }

            if (parameters.get("requestType").equals("0")) {
                List<EventLogInoutBean> eventLogWorkerInout = eventLogInoutDao.findChartEventLogInout(parameters);

                modelAndView.addObject("eventLogInoutChart", eventLogWorkerInout);
            }
        }


        return modelAndView;
    }
}
