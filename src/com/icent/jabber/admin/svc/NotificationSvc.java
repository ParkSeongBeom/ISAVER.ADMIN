package com.icent.jabber.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

/**
 * 미리알림 관리 Service
 * @author : psb
 * @version : 1.0
 * @since : 2015. 02. 11.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2015. 02. 11.     psb           최초 생성
 * </pre>
 */

public interface NotificationSvc {

    /**
     * 미리알림 목록을 반환 한다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView findAllNotification(Map<String, String> parameters);

    /**
     * 미리알림 정보를 반환 한다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView findByNotification(Map<String, String> parameters);

    /**
     * 미리알림을 저장한다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView saveNotification(Map<String, String> parameters);
}
