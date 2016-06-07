package com.icent.jabber.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

/**
 * 모니터링 프로세스 Service
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
public interface MonitorProcessSvc {

    /**
     * 모니터링 프로세스 목록을 반환 한다.
     *
     * @param parameters
     * @return the model and view
     */
    public ModelAndView findAllProcess(Map<String, String> parameters);

    /**
     * 모니터링 프로세스 상세 정보를 반환한다.
     *
     * @param parameters
     * - monitorId       : 모니터링 프로세스 UUID
     * @return the model and view
     */
    public ModelAndView findByProcess(Map<String, String> parameters);

    /**
     * 모니터링 프로세스을 등록한다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView addMonitorProcess(Map<String, String> parameters);

    /**
     * 모니터링 프로세스을 저장한다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView saveMonitorProcess(Map<String, String> parameters);

    /**
     * 모니터링 프로세스을 제거한다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView removeMonitorProcess(Map<String, String> parameters);

    /**
     * 모니터링 프로세스 목록.
     *
     * @return the model and view
     */
    public ModelAndView findListMonitorProcess(Map<String, String> parameters);

    /**
     * 모니터링 프로세스상세.
     *
     * @return the model and view
     */
    public ModelAndView findByMonitorProcess(Map<String, String> parameters);
}
