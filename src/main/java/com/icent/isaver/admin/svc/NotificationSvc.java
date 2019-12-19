package com.icent.isaver.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;

/**
 * 알림센터 Service
 * @author : psb
 * @version : 1.0
 * @since : 2018. 2. 20.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2018. 2. 20.     psb           최초 생성
 * </pre>
 */
public interface NotificationSvc {

    /**
     * 알림센터 이력 목록을 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    ModelAndView findListNotification(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @return
     */
    ModelAndView findListNotificationForExcel(HttpServletRequest request, HttpServletResponse response, Map<String, String> parameters);

    /**
     * 알림센터 목록을 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    ModelAndView findListNotificationForDashboard(Map<String, String> parameters);

    /**
     * 알림센터를 저장한다. (해제, 확인)
     *
     * @author psb
     * @param parameters
     * @return
     */
    ModelAndView saveNotification(Map<String, String> parameters);

    /**
     * 알림센터 전체를 해제한다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    ModelAndView allCancelNotification(Map<String, String> parameters);

    /**
     * 알림센터 목록을 가져온다. 히트맵용
     *
     * @author psb
     * @param parameters
     * @return
     */
    ModelAndView findListNotificationForHeatMap(Map<String, String> parameters);
}
