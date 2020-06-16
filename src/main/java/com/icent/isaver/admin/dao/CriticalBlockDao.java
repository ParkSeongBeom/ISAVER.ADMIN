package com.icent.isaver.admin.dao;

import com.icent.isaver.admin.bean.CriticalBlockBean;

import java.util.List;
import java.util.Map;

/**
 * Critical Block Dao Interface
 *
 * @author : psb
 * @version : 1.0
 * @since : 2020. 06. 04.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2020. 06. 04.     psb           최초 생성
 * </pre>
 */
public interface CriticalBlockDao {

    /**
     *
     * @return
     */
    List<CriticalBlockBean> findListCriticalBlock(Map<String, String> parameters);

    /**
     *
     * @return
     */
    void addCriticalBlock(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @return
     */
    void removeCriticalBlock(Map<String, String> parameters);
}
