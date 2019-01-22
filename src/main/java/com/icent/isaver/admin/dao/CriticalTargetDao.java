package main.java.com.icent.isaver.admin.dao;

import com.icent.isaver.admin.bean.CriticalTargetBean;

import java.util.Map;

/**
 * 임계치별 대상장치 상세 Dao Interface
 *
 * @author : psb
 * @version : 1.0
 * @since : 2017. 9. 22.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2017. 9. 21.     psb           최초 생성
 * </pre>
 */
public interface CriticalTargetDao {
    CriticalTargetBean findByCriticalTarget(Map<String, String> parameters);
    void addCriticalTarget(Map<String, String> parameters);
    void saveCriticalTarget(Map<String, String> parameters);
    void removeCriticalTarget(Map<String, String> parameters);
}
