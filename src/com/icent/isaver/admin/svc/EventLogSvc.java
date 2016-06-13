package com.icent.isaver.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

/**
 * 이벤트 로그 Service 관리
 * @author : dhj
 * @version : 1.0
 * @since : 2016. 6. 13.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2016. 6. 13.     dhj           최초 생성
 * </pre>
 */
public interface EventLogSvc {

    /**
     * 이벤트 로그 목록을 가져온다.
     *
     * @author dhj
     * @param parameters
     * @return
     */
    ModelAndView findListEventLog(Map<String, String> parameters);

    /**
     * 이벤트 로그 상세을 가져온다.
     *
     * @author dhj
     * @param parameters
     * @return
     */
    ModelAndView findByEventLog(Map<String, String> parameters);
}
