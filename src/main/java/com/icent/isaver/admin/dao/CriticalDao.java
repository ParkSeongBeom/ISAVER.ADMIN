package com.icent.isaver.admin.dao;

import com.icent.isaver.admin.bean.CriticalBean;

import java.util.List;
import java.util.Map;

/**
 * 임계치 Dao Implements
 * @author : psb
 * @version : 1.0
 * @since : 2018. 9. 21.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2018. 9. 21.     psb           최초 생성
 * </pre>
 */
public interface CriticalDao {
    List<CriticalBean> findListCritical(Map<String, String> parameters);
    void saveCritical(List<CriticalBean> parameterList);
    void removeCritical(Map<String, String> parameters);
}
