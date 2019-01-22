package com.icent.isaver.admin.dao;

import com.icent.isaver.admin.bean.EventBean;

import java.util.List;
import java.util.Map;

/**
 * [DAO] 이벤트
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
public interface EventDao {

    /**
     *
     * @param parameters
     * @author dhj
     * @return
     */
    List<EventBean> findListEvent(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @author psb
     * @return
     */
    List<EventBean> findListEventForDashBoard(Map<String, Object> parameters);


    /**
     * 이벤트 목록을 가져온다(임계치 등록된 이벤트 제외)
     * @return
     * @author dhj
     */
    List<EventBean> findListNotInCriticalList(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @author dhj
     * @return
     */
    EventBean findByEvent(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @author dhj
     * @return
     */
    Integer findCountEvent(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @author dhj
     * @return
     */
    Integer findByEventCheckExist(Map<String, String> parameters);

    /**
     *
     * @return
     */
    Integer findCountGenerator();
    
    /**
     *
     * @param parameters
     * @author dhj
     * @return
     */
    void addEvent(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @author dhj
     * @return
     */
    void saveEvent(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @author dhj
     * @return
     */
    void removeEvent(Map<String, String> parameters);

}