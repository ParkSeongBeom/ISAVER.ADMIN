package com.icent.isaver.admin.dao;


import com.icent.isaver.admin.bean.VideoHistoryBean;

import java.util.List;
import java.util.Map;

/**
 * 영상이력 Dao Interface
 * @author : psb
 * @version : 1.0
 * @since : 2018. 8. 16.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2018. 8. 16.     psb           최초 생성
 * </pre>
 */
public interface VideoHistoryDao {

    /**
     *
     * @param parameters
     * @author psb
     * @return
     */
    List<VideoHistoryBean> findListVideoHistory(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @author psb
     * @return
     */
    Integer findCountVideoHistory(Map<String, String> parameters);
}