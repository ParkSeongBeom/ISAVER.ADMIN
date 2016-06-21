package com.icent.isaver.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

/**
 * 이벤트 로그 작업자 진출입 Service 관리
 * @author : psb
 * @version : 1.0
 * @since : 2016. 6. 21.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2016. 6. 21.     psb           최초 생성
 * </pre>
 */
public interface EventLogInoutSvc {

    /**
     * 작업자 진출입 데이터를 가져온다.
     *
     * @author dhj
     * @param parameters
     * @return
     */
    ModelAndView findListEventLogInout(Map<String, String> parameters);

    /**
     * 작업자 진출입 차트용 로그를 가져온다.
     * @param parameters
     * @return
     */
    ModelAndView findChartEventLogInout(Map<String, String> parameters);
}
