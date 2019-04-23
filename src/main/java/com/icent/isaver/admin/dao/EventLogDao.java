package com.icent.isaver.admin.dao;

import com.icent.isaver.admin.bean.EventLogBean;

import java.util.List;
import java.util.Map;

/**
 * [DAO] 이벤트 로그
 * @author dhj
 * @since 2016. 06. 01.
 * @version 1.0
 * @see   <pre>
 * << 개정이력(Modification Information) >>
 *   수정일         수정자            수정내용
 *  ----------   --------  ----------------------
 *  2016.06.01  dhj     최초 생성
 * </pre>
 */
public interface EventLogDao {

    /**
     *
     * @param parameters
     * @author dhj
     * @return
     */
    List<EventLogBean> findListEventLog(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @author dhj
     * @return
     */
    EventLogBean findByEventLog(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @author dhj
     * @return
     */
    Integer findCountEventLog(Map<String, String> parameters);

    /**
     *
     * @author psb
     * @return
     */
    List<EventLogBean> findListEventLogForDashboard(Map<String, String> parameters);

    /**
     *
     * @author psb
     * @return
     */
    List<EventLogBean> findListEventLogBlinkerForArea(Map<String, String> parameters);

    /**
     *
     * @author psb
     * @return
     */
    EventLogBean findByEventLogToiletRoomForArea(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @author psb
     * @return
     */
    List<EventLogBean> findListEventLogChart(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @author psb
     * @return
     */
    List<EventLogBean> findListEventLogResourceChart(Map<String, String> parameters);
}