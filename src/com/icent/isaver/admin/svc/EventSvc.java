package com.icent.isaver.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

/**
 * 이벤트 Service 관리
 * @author : dhj
 * @version : 1.0
 * @since : 2016. 6. 1.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2016. 6. 1.     dhj           최초 생성
 * </pre>
 */
public interface EventSvc {

    /**
     * 이벤트 목록을 가져온다.
     *
     * @author dhj
     * @param parameters
     * @return
     */
    ModelAndView findListEvent(Map<String, String> parameters);

    /**
     * 이벤트 정보를 가져온다.
     *
     * @author dhj
     * @param parameters
     * @return
     */
    ModelAndView findByEvent(Map<String, String> parameters);

    /**
     * 이벤트를 등록한다.
     *
     * @author dhj
     * @param parameters
     * @return
     */
    ModelAndView addEvent(HttpServletRequest request, Map<String, String> parameters);

    /**
     * 이벤트를 수정한다.
     *
     * @author dhj
     * @param parameters
     * @return
     */
    ModelAndView saveEvent(HttpServletRequest request, Map<String, String> parameters);

    /**
     * 이벤트 조치를 수정한다.
     *
     * @author dhj
     * @param parameters
     * @return
     */
    ModelAndView saveEventAction(HttpServletRequest request, Map<String, String> parameters);

    /**
     * 이벤트를 제거한다
     *
     * @author dhj
     * @param parameters
     * @return
     */
    ModelAndView removeEvent(Map<String, String> parameters);

}
