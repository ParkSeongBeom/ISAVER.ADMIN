package com.icent.isaver.admin.dao;


import com.icent.isaver.admin.bean.NotificationBean;

import java.util.List;
import java.util.Map;

/**
 * [DAO] 알림센터
 * @author psb
 * @since 2018. 1. 11.
 * @version 1.0
 * @see   <pre>
 * << 개정이력(Modification Information) >>
 *   수정일         수정자            수정내용
 *  ----------   --------  ----------------------
 *  2018. 1. 11     psb     최초 생성
 * </pre>
 */
public interface NotificationDao {

    /**
     *
     * @param parameters
     * @author psb
     * @return
     */
    List<NotificationBean> findListNotification(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @author psb
     * @return
     */
    Integer findCountNotification(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @author psb
     * @return
     */
    List<NotificationBean> findListNotificationForDashboard(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @author psb
     * @return
     */
    List<NotificationBean> findListNotificationExcel(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @author psb
     * @return
     */
    List<NotificationBean> findListNotificationForHeatMap(Map<String, String> parameters);

    /**
     *
     * @author psb
     * @return
     */
    List<NotificationBean> findListNotificationForDashboardCount();

    /**
     *
     * @param parameters
     * @return
     */
    List<NotificationBean> findListNotificationForArea(Map<String, String> parameters);

    /**
     *
     * @author psb
     * @return
     */
    void saveNotification(List<Map<String, String>> parameterList);

    /**
     *
     * @author psb
     * @return
     */
    void allCancelNotification(Map<String, Object> parameters);
}