package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.svc.EventLogSvc;
import com.icent.isaver.admin.util.AdminHelper;
import com.icent.isaver.repository.bean.EventBean;
import com.icent.isaver.repository.bean.EventLogBean;
import com.icent.isaver.repository.dao.base.EventLogDao;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import java.util.List;
import java.util.Map;

/**
 * Created by icent on 16. 6. 13..
 */
@Service
public class EventLogSvcImpl implements EventLogSvc {

    @Inject
    private EventLogDao eventLogDao;

    @Override
    public ModelAndView findListEventLog(Map<String, String> parameters) {
        List<EventLogBean> events = eventLogDao.findListEventLog(parameters);
        Integer totalCount = eventLogDao.findCountEventLog(parameters);

        AdminHelper.setPageTotalCount(parameters, totalCount);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("eventLogs", events);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView findByEventLog(Map<String, String> parameters) {
        ModelAndView modelAndView = new ModelAndView();

        EventLogBean eventLog = eventLogDao.findByEventLog(parameters);
        modelAndView.addObject("eventLog", eventLog);
        return modelAndView;
    }

    @Override
    public ModelAndView findListEventLogForAlram(Map<String, String> parameters) {
        List<EventLogBean> events = eventLogDao.findListEventLogForAlram(parameters);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("eventLogs", events);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }
}
