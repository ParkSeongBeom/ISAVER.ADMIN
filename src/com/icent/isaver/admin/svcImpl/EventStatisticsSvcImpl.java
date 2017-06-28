package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.resource.AdminResource;
import com.icent.isaver.admin.svc.EventStatisticsSvc;
import com.icent.isaver.admin.util.AdminHelper;
import com.icent.isaver.repository.bean.AreaBean;
import com.icent.isaver.repository.bean.EventBean;
import com.icent.isaver.repository.dao.base.EventDao;
import com.icent.isaver.repository.dao.base.EventStatisticsDao;
import com.kst.common.util.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

/**
 * 이벤트 통계 Service Implements
 *
 * @author : psb
 * @version : 1.0
 * @since : 2016. 8. 4.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2016. 8. 4.     psb           최초 생성
 * </pre>
 */
@Service
public class EventStatisticsSvcImpl implements EventStatisticsSvc {
    @Inject
    private EventDao eventDao;

    @Inject
    private EventStatisticsDao eventStatisticsDao;

    @Override
    public ModelAndView findListAreaEventStatistics(Map<String, String> parameters) {
        ModelAndView modelAndView = new ModelAndView();
        List<Map> events = new LinkedList<>();

        Map paramBean = new HashMap();
        if(StringUtils.notNullCheck(parameters.get("startDatetimeStr"))){
            paramBean.put("startDatetimeStr",parameters.get("startDatetimeStr"));
            paramBean.put("startDatetimeHour",parameters.get("startDatetimeHour"));
        }

        if(StringUtils.notNullCheck(parameters.get("endDatetimeStr"))){
            paramBean.put("endDatetimeStr",parameters.get("endDatetimeStr"));
            paramBean.put("endDatetimeHour",parameters.get("endDatetimeHour"));
        }

        switch (parameters.get("eventGubn")){
            case "worker": // 작업자상태
                List<EventBean> workerEvents = eventDao.findListEventForDashBoard(new HashMap<String,Object>(){{put("eventIds", AdminResource.WORKER_EVENT_ID_ALL);}});

                for(EventBean worker : workerEvents){
                    Map workerMap = new HashMap();
                    workerMap.put("event",worker);
                    paramBean.put("eventId",worker.getEventId());
                    workerMap.put("list",eventStatisticsDao.findListAreaEventStatistics(paramBean));
                    events.add(workerMap);
                }
                break;
            case "crane": // 크레인 상태
                List<EventBean> craneEvents = eventDao.findListEventForDashBoard(new HashMap<String,Object>(){{put("eventIds",AdminResource.CRANE_EVENT_ID_ALL);}});

                for(EventBean crane : craneEvents){
                    Map craneMap = new HashMap();
                    craneMap.put("event",crane);
                    paramBean.put("eventId",crane.getEventId());
                    craneMap.put("list",eventStatisticsDao.findListAreaEventStatistics(paramBean));
                    events.add(craneMap);
                }
                break;
            case "gas": // 유해가스
                // 임시 데이터 맵핑
                for(int i=0; i<3; i++){
                    Map addMap = new HashMap();
                    EventBean event = new EventBean();

                    switch (i){
                        case 0 :
                            event.setEventId("oxygen");
                            event.setEventName("산소 결핍 탐지");
                            event.setEventDesc("19.5% 이하");
                            break;
                        case 1 :
                            event.setEventId("carbonMonoxide");
                            event.setEventName("일산화탄소 과다 탐지");
                            event.setEventDesc("100ppm 이상");
                            break;
                        case 2 :
                            event.setEventId("hydrogenSulfide");
                            event.setEventName("황하수소 과다 탐지");
                            event.setEventDesc("15ppm 이상");
                            break;
                    }
                    addMap.put("event",event);
                    paramBean.put("eventId","0");

                    List<AreaBean> areaList = eventStatisticsDao.findListAreaEventStatistics(parameters);
                    int testData = 1000;
                    for(AreaBean area: areaList){
                        area.setEventCnt(testData);
                        testData -= 50;
                    }
                    addMap.put("list",areaList);
                    events.add(addMap);
                }
                break;
            case "inout": // 진출입
                // 진입
                Map inMap = new HashMap();
                EventBean inEvent = new EventBean();
                inEvent.setEventId("workerIn");
                inEvent.setEventName("진입(IN)");
                inMap.put("event",inEvent);
                paramBean.put("eventIds",AdminResource.IN_EVENT_ID);
                inMap.put("list",eventStatisticsDao.findListAreaEventStatisticsMulti(paramBean));
                events.add(inMap);

                // 진출
                Map outMap = new HashMap();
                EventBean outEvent = new EventBean();
                outEvent.setEventId("workerOut");
                outEvent.setEventName("진출(OUT)");
                outMap.put("event",outEvent);
                paramBean.put("eventIds",AdminResource.OUT_EVENT_ID);
                outMap.put("list",eventStatisticsDao.findListAreaEventStatisticsMulti(paramBean));
                events.add(outMap);
                break;
        }

        modelAndView.addObject("resultList",events);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView findListWorkerEventStatistics(Map<String, String> parameters) {
        Map paramBean = new HashMap();
        List<String> dateLists = AdminHelper.findListDateTimeForType(parameters.get("searchDatetime"), parameters.get("dateGubn"));
        paramBean.put("dateLists",dateLists);
        paramBean.put("areaId",parameters.get("areaId"));
        paramBean.put("dateGubn",parameters.get("dateGubn"));
        paramBean.put("eventIds", AdminResource.WORKER_EVENT_ID_ALL);

        List<Map> resultList = eventStatisticsDao.findListWorkerEventStatistics(paramBean);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("dateLists",dateLists);
        modelAndView.addObject("resultList",resultList);
        return modelAndView;
    }

    @Override
    public ModelAndView findListCraneEventStatistics(Map<String, String> parameters) {
        Map paramBean = new HashMap();
        List<String> dateLists = AdminHelper.findListDateTimeForType(parameters.get("searchDatetime"), parameters.get("dateGubn"));
        paramBean.put("dateLists",dateLists);
        paramBean.put("areaId",parameters.get("areaId"));
        paramBean.put("dateGubn",parameters.get("dateGubn"));
        paramBean.put("eventIds", AdminResource.CRANE_EVENT_ID_ALL);

        List<Map> resultList = eventStatisticsDao.findListCraneEventStatistics(paramBean);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("dateLists",dateLists);
        modelAndView.addObject("resultList",resultList);
        return modelAndView;
    }

    @Override
    public ModelAndView findListGasEventStatistics(Map<String, String> parameters) {
        List<String> dateLists = AdminHelper.findListDateTimeForType(parameters.get("searchDatetime"), parameters.get("dateGubn"));

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("dateLists",dateLists);
        return modelAndView;
    }

    @Override
    public ModelAndView findListInoutEventStatistics(Map<String, String> parameters) {
        List<String> dateLists = AdminHelper.findListDateTimeForType(parameters.get("searchDatetime"), parameters.get("dateGubn"));

        Map inParamBean = new HashMap();
        inParamBean.put("dateLists",dateLists);
        inParamBean.put("areaId",parameters.get("areaId"));
        inParamBean.put("dateGubn",parameters.get("dateGubn"));
        inParamBean.put("eventIds", AdminResource.IN_EVENT_ID);
        inParamBean.put("key","inCount");

        Map inResultList = eventStatisticsDao.findListInoutEventStatistics(inParamBean);

        Map outParamBean = new HashMap();
        outParamBean.put("dateLists",dateLists);
        outParamBean.put("areaId",parameters.get("areaId"));
        outParamBean.put("dateGubn",parameters.get("dateGubn"));
        outParamBean.put("eventIds", AdminResource.OUT_EVENT_ID);
        outParamBean.put("key","outCount");

        Map outResultList = eventStatisticsDao.findListInoutEventStatistics(outParamBean);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("dateLists",dateLists);
        modelAndView.addObject("inResultList",inResultList);
        modelAndView.addObject("outResultList",outResultList);
        return modelAndView;
    }
}
