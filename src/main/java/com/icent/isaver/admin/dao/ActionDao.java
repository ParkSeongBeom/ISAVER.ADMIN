package main.java.com.icent.isaver.admin.dao;


import com.icent.isaver.admin.bean.ActionBean;

import java.util.List;
import java.util.Map;


/**
 * [DAO] 대응
 * @author dhj
 * @since 2016. 06. 01.
 * @version 1.0
 * @see   <pre>
 * << 개정이력(Modification Information) >>
 *   수정일         수정자            수정내용
 *  ----------   --------  ----------------------
 *  2016.06.01  dhj    최초 생성
 * </pre>
 */
public interface ActionDao {

    /**
     *
     * @param parameters
     * @return
     */
    List<ActionBean> findListAction(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @return
     */
    Integer findCountAction(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @return
     */
    ActionBean findByAction(Map<String, String> parameters);


    /**
     *
     * @param parameters
     * @return
     */
    ActionBean findByActionFromEventId(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @return
     */
    Integer findByActionCheckExist(Map<String, String> parameters);

    /**
     *
     * @return
     */
    Integer findCountGenerator();

    /**
     *
     * @param parameters
     * @return
     */
    void addAction(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @return
     */
    void saveAction(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @return
     */
    void removeAction(Map<String, String> parameters);
}