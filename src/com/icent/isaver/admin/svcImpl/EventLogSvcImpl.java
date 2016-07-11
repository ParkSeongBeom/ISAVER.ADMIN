package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.bean.JabberException;
import com.icent.isaver.admin.svc.EventLogSvc;
import com.icent.isaver.admin.util.AdminHelper;
import com.icent.isaver.repository.bean.EventLogBean;
import com.icent.isaver.repository.dao.base.ActionDao;
import com.icent.isaver.repository.dao.base.EventLogDao;
import com.kst.common.resource.CommonResource;
import com.kst.common.spring.TransactionUtil;
import com.kst.common.util.POIExcelUtil;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionStatus;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Created by icent on 16. 6. 13..
 */
@Service
public class EventLogSvcImpl implements EventLogSvc {

    @Resource(name="mybatisIsaverTxManager")
    private DataSourceTransactionManager transactionManager;

    @Inject
    private EventLogDao eventLogDao;

    @Inject
    private ActionDao actionDao;

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

    @Override
    public ModelAndView cancelEventLog(Map<String, String> parameters) {
        String[] eventLogIds = parameters.get("eventLogIds").split(CommonResource.COMMA_STRING);

        List<Map<String, String>> parameterList = new ArrayList<>();
        for (String eventLogId : eventLogIds) {
            Map<String, String> eventLogParamMap = new HashMap<>();
            eventLogParamMap.put("eventLogId", eventLogId);
            eventLogParamMap.put("eventCancelUserId", parameters.get("eventCancelUserId"));
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
        POIExcelUtil.downloadExcel(modelAndView, "isaver_event_history_"+sdf.format(new Date()), events, columns, heads, "이벤트이력");
        return modelAndView;
    }
}
