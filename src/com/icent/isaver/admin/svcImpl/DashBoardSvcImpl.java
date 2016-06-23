package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.svc.DashBoardSvc;
import com.icent.isaver.repository.bean.AreaBean;
import com.icent.isaver.repository.bean.EventBean;
import com.icent.isaver.repository.dao.base.AreaDao;
import com.icent.isaver.repository.dao.base.EventDao;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import java.util.*;

/**
 * 대쉬보드 Service Implements
 * @author : psb
 * @version : 1.0
 * @since : 2016. 6. 16.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2016. 6. 16.     psb           최초 생성
 * </pre>
 */
@Service
public class DashBoardSvcImpl implements DashBoardSvc {

    @Inject
    private AreaDao areaDao;

    @Inject
    private EventDao eventDao;

    // 작업자 이벤트 코드
    String[] workerEventIds = {"EVT009", "EVT015","EVT016"};
    // 크래인 이벤트 코드
    String[] craneEventIds = {"EVT100", "EVT101", "EVT102", "EVT210", "EVT211"};

    @Override
    public ModelAndView findAllDashBoard(Map<String, String> parameters) {
        parameters.put("delYn","N");
        List<AreaBean> areas = areaDao.findListArea(parameters);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("areas", areas);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView findByDashBoard(Map<String, String> parameters) {
        List<EventBean> workerEvents = eventDao.findListEventForDashBoard(new HashMap<String,Object>(){{put("eventIds",workerEventIds);}});
        List<EventBean> craneEvents = eventDao.findListEventForDashBoard(new HashMap<String,Object>(){{put("eventIds",craneEventIds);}});
        AreaBean area = areaDao.findByArea(parameters);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("workerEvents", workerEvents);
        modelAndView.addObject("craneEvents", craneEvents);
        modelAndView.addObject("area", area);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }
}
