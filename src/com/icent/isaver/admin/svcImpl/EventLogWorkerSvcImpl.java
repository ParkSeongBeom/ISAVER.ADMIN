package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.svc.EventLogWorkerSvc;
import com.icent.isaver.repository.bean.EventLogWorkerBean;
import com.icent.isaver.repository.dao.base.EventLogWorkerDao;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
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
    public ModelAndView findListEventLogWorker(Map<String, String> parameters) {
        List<EventLogWorkerBean> eventLogWorkerList = eventLogWorkerDao.findListEventLogWorker(parameters);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("eventLogWorkerList", eventLogWorkerList);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }
}
