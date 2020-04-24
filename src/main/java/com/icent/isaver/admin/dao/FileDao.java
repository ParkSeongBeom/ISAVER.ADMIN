package com.icent.isaver.admin.dao;

import com.icent.isaver.admin.bean.FileBean;

import java.util.List;
import java.util.Map;

/**
 * 파일 Dao Interface
 *
 * @author : psb
 * @version : 1.0
 * @since : 2016. 12. 20.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2016. 12. 20.     psb           최초 생성
 * </pre>
 */
public interface FileDao {
    /**
     *
     * @param parameters
     * @author psb
     * @return
     */
    List<FileBean> findListFile(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @author psb
     * @return
     */
    FileBean findByFile(Map<String, String> parameters);

    /**
     *
     * @author psb
     * @return
     */
    FileBean findByFileByLogo();

    /**
     *
     * @param parameters
     * @author psb
     * @return
     */
    Integer findCountFile(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @author psb
     * @return
     */
    void addFile(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @author psb
     * @return
     */
    void saveFile(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @author psb
     * @return
     */
    void removeFile(Map<String, String> parameters);
}