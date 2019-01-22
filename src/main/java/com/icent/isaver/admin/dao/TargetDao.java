package com.icent.isaver.admin.dao;

import com.icent.isaver.admin.bean.TargetBean;

import java.util.Map;

/**
 * [DAO] 고객사
 *
 * @author : psb
 * @version : 1.0
 * @since : 2018. 5. 29.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2018. 5. 29.     psb           최초 생성
 * </pre>
 */
public interface TargetDao {

    /**
     *
     * @param parameters
     * @return
     */
    TargetBean findByTarget(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @return
     */
    void saveTarget(Map<String, String> parameters);
}