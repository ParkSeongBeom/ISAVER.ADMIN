package main.java.com.icent.isaver.admin.dao;

import com.icent.isaver.admin.bean.CustomMapLocationBean;

import java.util.List;
import java.util.Map;

/**
 * [DAO] Custom Map
 *
 * @author : psb
 * @version : 1.0
 * @since : 2018. 6. 14.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2018. 6. 14.     psb           최초 생성
 * </pre>
 */
public interface CustomMapLocationDao {

    /**
     *
     * @return
     */
    List<CustomMapLocationBean> findListCustomMapLocation(Map<String, String> parameters);

    /**
     *
     * @return
     */
    void addCustomMapLocation(List<CustomMapLocationBean> parameterList);

    /**
     *
     * @return
     */
    void removeCustomMapLocation(Map<String, String> parameters);
}