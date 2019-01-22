package main.java.com.icent.isaver.admin.dao;

import com.icent.isaver.admin.bean.EventActionBean;

import java.util.List;
import java.util.Map;

/**
 * [DAO] 이벤트 & 대응
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
public interface EventActionDao {

    /**
     *
     * @param parameters
     * @author dhj
     * @return
     */
    List<EventActionBean> findListEventAction(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @author dhj
     * @return
     */
    EventActionBean findByEventAction(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @author dhj
     * @return
     */
    void addEventAction(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @author dhj
     * @return
     */
    void saveEventAction(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @author dhj
     * @return
     */
    void removeEventAction(Map<String, String> parameters);

}