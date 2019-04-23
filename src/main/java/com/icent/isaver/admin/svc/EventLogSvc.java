package com.icent.isaver.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
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
     * 이벤트 로그 차트를 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    ModelAndView findListEventLogChart(Map<String, String> parameters);

    /**
     * 이벤트 로그 자원모니터링 차트를 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    ModelAndView findListEventLogResourceChart(Map<String, String> parameters);

    /**
     * 이벤트 로그 목록을 가져온다. (진출입)
     *
     * @author psb
     * @param parameters
     * @return
     */
    ModelAndView findListEventLogBlinkerForArea(Map<String, String> parameters);

    /**
     * 이벤트 로그 목록을 가져온다. (화장실재실)
     *
     * @author psb
     * @param parameters
     * @return
     */
    ModelAndView findByEventLogToiletRoomForArea(Map<String, String> parameters);

    /**
     * 이벤트 로그 상세을 가져온다.
     *
     * @author dhj
     * @param parameters
     * @return
     */
    ModelAndView findByEventLog(Map<String, String> parameters);

    /**
     * 대쉬보드 데이터를 가져온다.
     *
     * @author dhj
     * @param parameters
     * @return
     */
    ModelAndView findListEventLogForDashboard(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @return
     */
    ModelAndView findListEventLogForExcel(HttpServletRequest request, HttpServletResponse response, Map<String, String> parameters);
}
