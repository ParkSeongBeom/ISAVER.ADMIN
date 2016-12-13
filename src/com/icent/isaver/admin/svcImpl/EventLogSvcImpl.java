package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.bean.JabberException;
import com.icent.isaver.admin.resource.AdminResource;
import com.icent.isaver.admin.svc.EventLogSvc;
import com.icent.isaver.admin.util.AdminHelper;
import com.icent.isaver.admin.util.AlarmRequestUtil;
import com.icent.isaver.repository.bean.EventLogBean;
import com.icent.isaver.repository.dao.base.EventLogDao;
import com.kst.common.resource.CommonResource;
import com.kst.common.spring.TransactionUtil;
import com.kst.common.util.POIExcelUtil;
import com.kst.common.util.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionStatus;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Created by icent on 16. 6. 13..
 */
@Service
public class EventLogSvcImpl implements EventLogSvc {

    @Value("#{configProperties['api.server.address']}")
    private String urlApiSocketUrl = null;

    @Resource(name="mybatisIsaverTxManager")
    private DataSourceTransactionManager transactionManager;

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
        Map param = new HashMap();
        StringBuilder builder = new StringBuilder();

        for(int index=0; index< AdminResource.ALRAM_EVENT.size(); index++){
            if(index!=0){builder.append(CommonResource.COMMA_STRING);}
            builder.append(AdminResource.ALRAM_EVENT.get(index));
        }
        if(StringUtils.notNullCheck(parameters.get("datetime"))){
            param.put("datetime", parameters.get("datetime"));
        }
        param.put("alramEventId", builder.toString());
        param.put("craneEventIds", AdminResource.CRANE_EVENT_ID_DETAIL);
        param.put("workerEventIds", AdminResource.WORKER_EVENT_ID_DETAIL);

        List<EventLogBean> events = eventLogDao.findListEventLogForAlram(param);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("eventLogs", events);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView cancelEventLog(Map<String, String> parameters) {
        String[] eventLogIds = parameters.get("eventLogIds").split(CommonResource.COMMA_STRING);

        List<Map<String, String>> parameterList = new ArrayList<>();
        for (String eventLogId : eventLogIds) {
            Map<String, String> eventLogParamMap = new HashMap<>();
            eventLogParamMap.put("eventLogId", eventLogId);
            eventLogParamMap.put("eventCancelUserId", parameters.get("eventCancelUserId"));
            eventLogParamMap.put("eventCancelDesc", parameters.get("eventCancelDesc"));
            parameterList.add(eventLogParamMap);
        }

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            eventLogDao.cancelEventLog(parameterList);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }


        try {
            AlarmRequestUtil.sendAlarmRequestFunc(parameters, urlApiSocketUrl + AdminResource.API_PATH_URL_SENDEVENT);
        } catch (IOException e) {
            e.printStackTrace();
        }

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView findListEventLogForExcel(HttpServletRequest request, HttpServletResponse response, Map<String, String> parameters) {
        List<EventLogBean> events = eventLogDao.findListEventLogForExcel(parameters);

        String[] heads = new String[]{"구역","이벤트유형","장치유형","이벤트발생일시","이벤트명","이벤트해제자","이벤트해제일시"};
        String[] columns = new String[]{"areaName","eventFlag","deviceCode","eventDatetimeStr","eventName","eventCancelUserName","eventCancelDatetimeStr"};

        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");

        ModelAndView modelAndView = new ModelAndView("excelView");
        POIExcelUtil.downloadExcel(modelAndView, "이벤트이력_"+sdf.format(new Date()), events, columns, heads, "이벤트이력");
        //POIExcelUtil.downloadExcel(modelAndView, "isaver_event_history_"+sdf.format(new Date()), events, columns, heads, "이벤트이력");
        return modelAndView;
    }
}
