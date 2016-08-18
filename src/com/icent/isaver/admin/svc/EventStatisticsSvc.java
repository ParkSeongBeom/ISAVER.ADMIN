package com.icent.isaver.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

/**
 * 이벤트 통계 Service Interface
 *
 * @author : psb
 * @version : 1.0
 * @since : 2016. 8. 4.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2016. 8. 4.     psb           최초 생성
 * </pre>
 */
public interface EventStatisticsSvc {

    /**
     * 구역별 이벤트 통계 목록을 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    public ModelAndView findListAreaEventStatistics(Map<String, String> parameters);

    /**
     * 작업자 이벤트 통계 목록을 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    public ModelAndView findListWorkerEventStatistics(Map<String, String> parameters);

    /**
     * 크레인 이벤트 통계 목록을 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    public ModelAndView findListCraneEventStatistics(Map<String, String> parameters);

    /**
     * 유해가스 이벤트 통계 목록을 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    public ModelAndView findListGasEventStatistics(Map<String, String> parameters);

    /**
     * 진출입자 이벤트 통계 목록을 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    public ModelAndView findListInoutEventStatistics(Map<String, String> parameters);
}
