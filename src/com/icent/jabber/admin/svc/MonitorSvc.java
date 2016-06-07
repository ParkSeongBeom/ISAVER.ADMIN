package com.icent.jabber.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

/**
 * 모니터링 Service
 * @author : psb
 * @version : 1.0
 * @since : 2015. 04. 07.
 * <pre>
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2015. 04. 07.     psb           최초 생성
 * </pre>
 */
public interface MonitorSvc {

    /**
     * 모니터링 목록을 반환 한다.
     *
     * @param parameters
     * @return the model and view
     */
    public ModelAndView findAllMonitor(Map<String, String> parameters);

    /**
     * 모니터링 상세 정보를 반환한다.
     *
     * @param parameters
     * - monitorId       : 모니터링 UUID
     * @return the model and view
     */
    public ModelAndView findByMonitor(Map<String, String> parameters);

    /**
     * 모니터링을 등록한다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView addMonitor(Map<String, String> parameters);

    /**
     * 모니터링을 저장한다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView saveMonitor(Map<String, String> parameters);

    /**
     * 모니터링을 제거한다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView removeMonitor(Map<String, String> parameters);

    /**
     * 모니터링 서버 목록.
     *
     * @return the model and view
     */
    public ModelAndView findListMonitorServer(Map<String, String> parameters);

    /**
     * 모니터링 서버상세.
     *
     * @return the model and view
     */
    public ModelAndView findByMonitorServer(Map<String, String> parameters);
}
