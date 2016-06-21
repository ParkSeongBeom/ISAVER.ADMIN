package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.svc.EventLogInoutSvc;
import com.icent.isaver.repository.bean.EventLogInoutBean;
import com.icent.isaver.repository.bean.EventLogWorkerBean;
import com.icent.isaver.repository.dao.base.EventLogInoutDao;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import java.util.List;
import java.util.Map;

/**
 * 이벤트 로그 작업자 진출입 Service implements
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
public class EventLogInoutSvcImpl implements EventLogInoutSvc {

    @Inject
    private EventLogInoutDao eventLogInoutDao;

    @Override
    public ModelAndView findListEventLogInout(Map<String, String> parameters) {
        List<EventLogInoutBean> eventLogInoutList = eventLogInoutDao.findListEventLogInout(parameters);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("eventLogInoutList", eventLogInoutList);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView findChartEventLogInout(Map<String, String> parameters) {

        List<EventLogInoutBean> eventLogWorkerInout = eventLogInoutDao.findChartEventLogInout(parameters);
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("eventLogInoutChart", eventLogWorkerInout);
        return modelAndView;
    }
}
