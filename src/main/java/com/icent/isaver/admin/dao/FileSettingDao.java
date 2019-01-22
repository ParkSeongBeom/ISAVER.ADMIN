package com.icent.isaver.admin.dao;

import com.icent.isaver.admin.bean.FileSettingBean;

import java.util.Map;

/**
 * 파일 환경설정 Dao Interface
 *
 * @author : psb
 * @version : 1.0
 * @since : 2018. 10. 29.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2018. 10. 29.     psb           최초 생성
 * </pre>
 */
public interface FileSettingDao {

    /**
     *
     * @param parameters
     * @author psb
     * @return
     */
    FileSettingBean findByFileSetting(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @author psb
     * @return
     */
    void saveFileSetting(Map<String, String> parameters);
}