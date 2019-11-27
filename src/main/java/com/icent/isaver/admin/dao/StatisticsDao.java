package com.icent.isaver.admin.dao;

import com.icent.isaver.admin.bean.StatisticsBean;

import java.util.List;
import java.util.Map;

/**
 * 통계 Dao Interface
 *
 * @author : psb
 * @version : 1.0
 * @since : 2019. 10. 24.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2019. 10. 24.     psb           최초 생성
 * </pre>
 */
public interface StatisticsDao {

    /**
     *
     * @author psb
     * @return
     */
    List<StatisticsBean> findListStatistics();

    /**
     *
     * @param parameters
     * @author psb
     * @return
     */
    void addStatistics(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @author psb
     * @return
     */
    void saveStatistics(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @author psb
     * @return
     */
    void removeStatistics(Map<String, String> parameters);
}