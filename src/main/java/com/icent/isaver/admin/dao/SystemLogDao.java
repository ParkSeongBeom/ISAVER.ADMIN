package com.icent.isaver.admin.dao;


import com.icent.isaver.admin.bean.SystemLogBean;

import java.util.List;
import java.util.Map;

/**
 * 시스템로그 Dao Interface
 * @author : psb
 * @version : 1.0
 * @since : 2019. 10. 21.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2019. 10. 21.     psb           최초 생성
 * </pre>
 */
public interface SystemLogDao {

    /**
     *
     * @param parameters
     * @author psb
     * @return
     */
    List<SystemLogBean> findListSystemLog(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @author psb
     * @return
     */
    Integer findCountSystemLog(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @author psb
     * @return
     */
    SystemLogBean findBySystemLog(Map<String, String> parameters);
}