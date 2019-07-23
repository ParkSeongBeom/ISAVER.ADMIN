package com.icent.isaver.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

/**
 * 외부연동용 이벤트 전송 이력 Service
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
public interface NotiSendLogSvc {

    /**
     * 외부연동용 이벤트 전송 이력 목록을 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    ModelAndView findListNotiSendLog(Map<String, String> parameters);
}
