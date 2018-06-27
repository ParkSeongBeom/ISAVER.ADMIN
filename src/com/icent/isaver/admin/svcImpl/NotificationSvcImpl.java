package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.common.resource.CommonResource;
import com.icent.isaver.admin.common.resource.IcentException;
import com.icent.isaver.admin.svc.NotificationSvc;
import com.icent.isaver.admin.util.AdminHelper;
import com.icent.isaver.admin.util.AlarmRequestUtil;
import com.icent.isaver.repository.bean.NotificationBean;
import com.icent.isaver.repository.dao.base.NotificationDao;
import com.kst.common.spring.TransactionUtil;
import com.kst.common.util.POIExcelUtil;
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
 * 알림센터 Service Interface
 * @author : psb
 * @version : 1.0
 * @since : 2018. 2. 20.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2018. 2. 20.     psb           최초 생성
 * </pre>
 */
@Service
public class NotificationSvcImpl implements NotificationSvc {

    @Value("${ws.server.domain}")
    private String wsDomain = null;

    @Value("${ws.server.port}")
    private String wsPort = null;

    @Value("${ws.server.projectName}")
    private String wsProjectName = null;

    @Value("${ws.server.urlSendEvent}")
    private String wsUrlSendEvent = null;

    @Resource(name="isaverTxManager")
    private DataSourceTransactionManager transactionManager;

    @Inject
    private NotificationDao notificationDao;

    @Override
    public ModelAndView findListNotification(Map<String, String> parameters) {
        List<NotificationBean> notifications = notificationDao.findListNotification(parameters);
        Integer totalCount = notificationDao.findCountNotification(parameters);

        AdminHelper.setPageTotalCount(parameters, totalCount);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("notifications", notifications);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView findListNotificationForDashboard(Map<String, String> parameters) {
        List<NotificationBean> notifications = notificationDao.findListNotificationForDashboard(parameters);
        List<NotificationBean> notiCountList = notificationDao.findListNotificationForDashboardCount();

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("notifications", notifications);
        modelAndView.addObject("notiCountList", notiCountList);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView saveNotification(Map<String, String> parameters) {
        String[] paramData = parameters.get("paramData").split(CommonResource.COMMA_STRING);

        List<Map<String, String>> parameterList = new ArrayList<>();

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");

        for (String data : paramData) {
            Map<String, String> notiMap = new HashMap<>();
            notiMap.put("notificationId", data.split("\\|")[0]);
            notiMap.put("areaId", data.split("\\|")[1]);
            notiMap.put("criticalLevel", data.split("\\|")[2]);
            notiMap.put("actionType", parameters.get("actionType"));
            notiMap.put("updateUserId", parameters.get("updateUserId"));
            notiMap.put("updateUserName", parameters.get("updateUserName"));
            notiMap.put("updateDatetime", sdf.format(new Date()));
            notiMap.put("cancelDesc", parameters.get("cancelDesc"));
            parameterList.add(notiMap);
        }

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            notificationDao.saveNotification(parameterList);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new IcentException("");
        }

        /**
         * = 웹소켓 서버로 알림 전송
         * @author psb
         * @date 2018.1.11
         */
        try {
            Map websocketParam = new HashMap();
            websocketParam.put("notification", parameterList);
            websocketParam.put("messageType","updateNotification");

            AlarmRequestUtil.sendAlarmRequestFunc(websocketParam, "http://" + wsDomain + ":" + wsPort + "/" + wsProjectName + wsUrlSendEvent, "form", "jsonData");
        } catch (IOException e) {
            e.printStackTrace();
        }

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView findListNotificationForExcel(HttpServletRequest request, HttpServletResponse response, Map<String, String> parameters) {
        List<NotificationBean> notifications = notificationDao.findListNotification(parameters);

        String[] heads = new String[]{"Event Datetime","Area Name","Device Name","Event Name","Critical Level","Confirm User Name","Confirm Datetime","Clear User Name","Clear Datetime","Clear Description"};
        String[] columns = new String[]{"eventDatetimeStr","areaName","deviceName","eventName","criticalLevelName","confirmUserName","confirmDatetimeStr","cancelUserName","cancelDatetimeStr","cancelDesc"};

        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");

        ModelAndView modelAndView = new ModelAndView("excelView");
        POIExcelUtil.downloadExcel(modelAndView, "isaver_notification_history_" + sdf.format(new Date()), notifications, columns, heads, "NotificationHistory");
        return modelAndView;
    }
}
