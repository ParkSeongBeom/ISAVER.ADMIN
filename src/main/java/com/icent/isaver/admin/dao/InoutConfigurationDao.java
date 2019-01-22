package main.java.com.icent.isaver.admin.dao;

import com.icent.isaver.admin.bean.InoutConfigurationBean;

import java.util.List;
import java.util.Map;

/**
 * 진출입 환경 설정 Dao Interface
 *
 * @author : dhj
 * @version : 1.0
 * @since : 2016. 06. 20.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2016. 06. 20.     dhj           최초 생성
 * </pre>
 */
public interface InoutConfigurationDao {

    List<InoutConfigurationBean> findListInoutConfiguration(Map<String, String> parameters);

    /**
     *
     * @param parameterList
     * @return
     */
    void addInoutConfiguration(List<Map<String, String>> parameterList);

    /**
     *
     * @param parameters
     * @return
     */
    void removeInoutConfigurationFromArea(Map<String, String> parameters);
}
