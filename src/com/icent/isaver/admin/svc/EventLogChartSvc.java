package com.icent.isaver.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

/**
 * 이벤트 로그 차트용 Service 관리
 * @author : dhj
 * @version : 1.0
 * @since : 2016. 6. 21.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2016. 6. 21.     dhj           최초 생성
 * </pre>
 */
public interface EventLogChartSvc {

    /**
     * [전체] 분류별  차트용 로그를 가져온다.
     * @param parameters
     * @return
     */
    ModelAndView findAllChartEventLog(Map<String, String> parameters);

    /**
     * [상세] 분류별  차트용 로그를 가져온다.
     * @param parameters
     * @return
     */
    ModelAndView findDetailChartEventLog(Map<String, String> parameters);
}
