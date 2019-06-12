package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.bean.EventLogBean;
import com.icent.isaver.admin.dao.EventLogDao;
import com.icent.isaver.admin.resource.AdminResource;
import com.icent.isaver.admin.svc.EventLogSvc;
import com.icent.isaver.admin.util.AdminHelper;
import com.kst.common.util.POIExcelUtil;
import com.kst.common.util.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
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
    public ModelAndView findListEventLogChart(Map<String, String> parameters) {
        List<EventLogBean> eventLogChartList = eventLogDao.findListEventLogChart(parameters);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("eventLogChartList", eventLogChartList);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView findListEventLogResourceChart(Map<String, String> parameters) {
        List<EventLogBean> eventLogChartList = eventLogDao.findListEventLogResourceChart(parameters);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("eventLogChartList", eventLogChartList);
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
    public ModelAndView findListEventLogForDashboard(Map<String, String> parameters) {
        List<EventLogBean> events = eventLogDao.findListEventLogForDashboard(parameters);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("eventLogs", events);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView findListEventLogBlinkerForArea(Map<String, String> parameters) {
        List<EventLogBean> eventLogList = null;

        if(StringUtils.notNullCheck(parameters.get("areaIds"))){
            Map eventLogParam = new HashMap();
            eventLogParam.put("userId", parameters.get("userId"));
            eventLogParam.put("areaIds", parameters.get("areaIds").split(","));
            eventLogList = eventLogDao.findListEventLogBlinkerForArea(eventLogParam);
        }

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("eventLog", eventLogList);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView findByEventLogToiletRoomForArea(Map<String, String> parameters) {
        EventLogBean lastStatus = eventLogDao.findByEventLogToiletRoomForArea(parameters);
        parameters.put("status", AdminResource.TOILET_ROOM_STATUS[1]);
        EventLogBean normalDatetime = eventLogDao.findByEventLogToiletRoomForArea(parameters);

        ModelAndView modelAndView = new ModelAndView();
        if(lastStatus!=null){
            modelAndView.addObject("status", lastStatus.getStatus());
        }
        if(normalDatetime!=null){
            modelAndView.addObject("eventDatetime", normalDatetime.getEventDatetime());
        }
        modelAndView.addObject("paramBean", parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView findListEventLogForExcel(HttpServletRequest request, HttpServletResponse response, Map<String, String> parameters) {
        List<EventLogBean> events = eventLogDao.findListEventLog(parameters);

        String[] heads = new String[]{"Area Name","Device Name","Event Name","Event Datetime"};
        String[] columns = new String[]{"areaName","deviceName","eventName","eventDatetimeStr"};

        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");

        ModelAndView modelAndView = new ModelAndView();
        POIExcelUtil.downloadExcel(modelAndView, "isaver_event_history_"+sdf.format(new Date()), events, columns, heads, "EventHistory");
        return modelAndView;
    }
}
