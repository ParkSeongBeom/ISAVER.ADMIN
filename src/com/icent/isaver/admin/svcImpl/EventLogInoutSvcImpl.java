package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.svc.EventLogInoutSvc;
import com.icent.isaver.repository.bean.EventLogInoutBean;
import com.icent.isaver.repository.dao.base.EventLogInoutDao;
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

    @Override
    public ModelAndView findListEventLogInout(Map<String, String> parameters) {
        List<EventLogInoutBean> eventLogInoutList = null;

        if(StringUtils.notNullCheck(parameters.get("areaIds"))){
            Map inoutConfigParam = new HashMap();
            inoutConfigParam.put("userId", parameters.get("userId"));
            inoutConfigParam.put("areaIds", parameters.get("areaIds").split(","));
            eventLogInoutList = eventLogInoutDao.findListEventLogInoutForArea(inoutConfigParam);
        }

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("eventLogInoutList", eventLogInoutList);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }
}
