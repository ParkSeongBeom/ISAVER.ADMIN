package com.icent.isaver.admin.dao;

import com.icent.isaver.admin.bean.LicenseBean;

import java.util.List;
import java.util.Map;

/**
 * [DAO] 라이센스
 * @author dhj
 * @since 2016. 06. 02.
 * @version 1.0
 * @see   <pre>
 * << 개정이력(Modification Information) >>
 *   수정일         수정자            수정내용
 *  ----------   --------  ----------------------
 *  2016.06.02  dhj     최초 생성
 * </pre>
 */
public interface LicenseDao {

    /**
     *
     * @param parameters
     * @author dhj
     * @return
     */
    List<LicenseBean> findListLicense(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @author dhj
     * @return
     */
    LicenseBean findByLicense(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @author dhj
     * @return
     */
    Integer findCountLicense(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @author dhj
     * @return
     */
    void addLicense(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @author dhj
     * @return
     */
    void saveLicense(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @author dhj
     * @return
     */
    void removeLicense(Map<String, String> parameters);

}