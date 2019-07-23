package com.icent.isaver.admin.dao;


import com.icent.isaver.admin.bean.NotiSendLogBean;

import java.util.List;
import java.util.Map;

/**
 * 외부연동용 이벤트 전송 이력 DAO
 * @author : psb
 * @version : 1.0
 * @since : 2019. 7. 23.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2019. 7. 23.     psb           최초 생성
 * </pre>
 */
public interface NotiSendLogDao {

    /**
     *
     * @param parameters
     * @author psb
     * @return
     */
    List<NotiSendLogBean> findListNotiSendLog(Map<String, String> parameters);
}