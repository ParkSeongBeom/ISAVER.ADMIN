package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.svc.EventLogCraneSvc;
import com.icent.isaver.repository.bean.EventLogCraneBean;
import com.icent.isaver.repository.dao.base.EventLogCraneDao;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import java.util.List;
import java.util.Map;

/**
 * 이벤트 로그 크래인 Service implements
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
    public ModelAndView findListEventLogCrane(Map<String, String> parameters) {
        List<EventLogCraneBean> eventLogCraneList = eventLogCraneDao.findListEventLogCrane(parameters);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("eventLogCraneList", eventLogCraneList);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView findChartEventLogCrane(Map<String, String> parameters) {

        List<EventLogCraneBean> eventLogCraneChart = eventLogCraneDao.findChartEventLogCrane(parameters);
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("eventLogCraneChart", eventLogCraneChart);
        return modelAndView;
    }
}
