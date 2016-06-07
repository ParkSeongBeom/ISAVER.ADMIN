package com.icent.jabber.admin.svc;

import java.util.Map;

/**
 * @author : dhj
 * @version : 1.0
 * @since : 2016. 1. 13.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 6. 2.     kst           최초 생성
 * </pre>
 */
public interface SettingServerSynchronizeSvc {

    /**
     * 동기화 설정 정보를 반환한다
     * @return
     */
    Map<String, String> getSettingServerSyncFunc();
}
