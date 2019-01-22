package main.java.com.icent.isaver.admin.dao;

import com.icent.isaver.admin.bean.CriticalDetectBean;

import java.util.List;
import java.util.Map;

/**
 * 임계치별 감지장치 상세 Dao Interface
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
public interface CriticalDetectDao {
    CriticalDetectBean findByCriticalDetect(Map<String, String> parameters);
    List<CriticalDetectBean> findExistCriticalDetect(Map<String, String> parameters);
    void addCriticalDetect(Map<String, String> parameters);
    void saveCriticalDetect(Map<String, String> parameters);
    void removeCriticalDetect(Map<String, String> parameters);
}
