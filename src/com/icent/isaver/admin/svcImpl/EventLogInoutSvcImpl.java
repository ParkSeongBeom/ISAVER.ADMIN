package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.resource.AdminResource;
import com.icent.isaver.admin.svc.EventLogInoutSvc;
import com.icent.isaver.repository.bean.EventLogInoutBean;
import com.icent.isaver.repository.bean.InoutConfigurationBean;
import com.icent.isaver.repository.dao.base.EventLogInoutDao;
import com.icent.isaver.repository.dao.base.InoutConfigurationDao;
import com.kst.common.util.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import java.util.HashMap;
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

    @Inject
    private InoutConfigurationDao inoutConfigurationDao;

    @Override
    public ModelAndView findListEventLogInout(Map<String, String> parameters) {
        Map param = new HashMap();
        param.put("userId", parameters.get("userId"));
        param.put("eventIds", AdminResource.INOUT_EVENT_ID);
        List<EventLogInoutBean> eventLogInoutList = eventLogInoutDao.findListEventLogInout(param);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("eventLogInoutList", eventLogInoutList);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView findByEventLogInout(Map<String, String> parameters) {
        InoutConfigurationBean InoutConfiguration = inoutConfigurationDao.findByInoutConfigurationForArea(parameters);

        Map param = new HashMap();
        param.put("areaId", parameters.get("areaId"));
        param.put("nowInoutStarttime",InoutConfiguration.getNowInoutStarttime());
        param.put("nowInoutEndtime",InoutConfiguration.getNowInoutEndtime());
        param.put("beforeInoutStarttime",InoutConfiguration.getBeforeInoutStarttime());
        param.put("beforeInoutEndtime",InoutConfiguration.getBeforeInoutEndtime());
        param.put("eventIds", AdminResource.INOUT_EVENT_ID);
        EventLogInoutBean eventLogInout = eventLogInoutDao.findByEventLogInout(param);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("eventLogInout", eventLogInout);
        modelAndView.addObject("paramBean",param);
        return modelAndView;
    }

    @Override
    public ModelAndView findChartEventLogInout(Map<String, String> parameters) {
        Map param = new HashMap();
        param.put("minutesCount", parameters.get("minutesCount"));
        if(StringUtils.notNullCheck(parameters.get("pageIndex"))){
            param.put("pageIndex", parameters.get("pageIndex"));
        }
        if(StringUtils.notNullCheck(parameters.get("areaId"))){
            param.put("areaId", parameters.get("areaId"));
        }
        param.put("eventIds", AdminResource.INOUT_EVENT_ID);
        List<EventLogInoutBean> eventLogWorkerInout = eventLogInoutDao.findChartEventLogInout(param);
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("eventLogInoutChart", eventLogWorkerInout);
        return modelAndView;
    }
}
