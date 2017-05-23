package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.common.resource.IcentException;
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
import java.net.InetAddress;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Created by icent on 16. 6. 13..
 */
@Service
public class EventLogSvcImpl implements EventLogSvc {

    @Value("${ws.server.address}")
    private String wsAddress = null;

    @Value("${ws.server.port}")
    private String wsPort = null;

    @Value("${ws.server.projectName}")
    private String wsProjectName = null;

    @Value("${ws.server.urlSendEvent}")
    private String wsUrlSendEvent = null;

    @Value("${vms.server.logSendFlag}")
    private String vmsLogSend = null;

    @Value("${vms.server.address}")
    private String vmsAddress = null;

    @Value("${vms.server.port}")
    private String vmsPort = null;

    @Value("${vms.server.projectName}")
    private String vmsProjectName = null;

    @Value("${vms.server.urlSendEvent}")
    private String vmsUrlSendEvent = null;

    @Resource(name="isaverTxManager")
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
    public ModelAndView findListEventLogForAlarm(Map<String, String> parameters) {
        Map param = new HashMap();
        StringBuilder builder = new StringBuilder();

        for(int index=0; index< AdminResource.ALARM_EVENT.size(); index++){
            if(index!=0){builder.append(CommonResource.COMMA_STRING);}
            builder.append(AdminResource.ALARM_EVENT.get(index));
        }
        if(StringUtils.notNullCheck(parameters.get("datetime"))){
            param.put("datetime", parameters.get("datetime"));
        }
        param.put("alarmEventId", builder.toString());
        param.put("craneEventIds", AdminResource.CRANE_EVENT_ID_DETAIL);
        param.put("workerEventIds", AdminResource.WORKER_EVENT_ID_DETAIL);

        List<EventLogBean> events = eventLogDao.findListEventLogForAlarm(param);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("eventLogs", events);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView cancelEventLog(Map<String, String> parameters) {
        String[] eventLogIds = parameters.get("eventLogIds").split(CommonResource.COMMA_STRING);

        List<Map<String, String>> parameterList = new ArrayList<>();

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String eventCancelDatetime = sdf.format(new Date());

        for (String eventLogId : eventLogIds) {
            Map<String, String> eventLogParamMap = new HashMap<>();
            eventLogParamMap.put("eventLogId", eventLogId);
            eventLogParamMap.put("eventCancelUserId", parameters.get("eventCancelUserId"));
            eventLogParamMap.put("eventCancelDesc", parameters.get("eventCancelDesc"));
            eventLogParamMap.put("eventCancelDatetime", eventCancelDatetime);
            parameterList.add(eventLogParamMap);
        }

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            eventLogDao.cancelEventLog(parameterList);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new IcentException("");
        }

        /**
         * = 웹소켓 서버로 알림 전송
         * @author psb
         * @date 2016.12.15
         */
        try {
            Map websocketParam = new HashMap();
            Map warnParam = new HashMap();
            warnParam.put("eventLogIds", parameters.get("eventLogIds"));
            websocketParam.put("alarmEventLog", warnParam);
            websocketParam.put("messageType","removeAlarmEvent");

            InetAddress address = InetAddress.getByName(wsAddress);
            AlarmRequestUtil.sendAlarmRequestFunc(websocketParam, "http://" + address.getHostAddress() + ":" + wsPort + "/" + wsProjectName + wsUrlSendEvent, true);
        } catch (IOException e) {
            e.printStackTrace();
        }

        /**
         * VMS에 이벤트 해제 데이터 전송 (Restful)
         * @author psb
         * @date 2017.05.19
         */
        if (StringUtils.notNullCheck(parameters.get("alarmIds")) && vmsLogSend.equals(CommonResource.YES)) {
            try {
                Map<String, String> vmsParam = new HashMap();
                vmsParam.put("alarmId",parameters.get("alarmIds"));
                vmsParam.put("time",eventCancelDatetime);

                AlarmRequestUtil.sendAlarmRequestFunc(vmsParam, "http://" + vmsAddress + ":" + vmsPort + vmsUrlSendEvent, false);
            } catch (IOException e) {
                e.printStackTrace();
            }
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
