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
 *  2018. 2. 21.     psb           통계 메뉴 정리
 *  2018. 2. 23.     psb           통계 테이블 변경으로 인한
 * </pre>
 */
public interface StatisticsSvc {

    /**
     * 이벤트 통계 목록을 가져온다.
     * @author psb
     * @return the list
     */
    ModelAndView findListStatistics(Map<String, String> parameters);

    /**
     * 이벤트 통계 목록을 가져온다.
     * @author psb
     * @return the list
     */
    ModelAndView findListStatisticsSearch(Map<String, String> parameters);

    /**
     * 이벤트 통계를 등록한다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    ModelAndView addStatistics(Map<String, String> parameters);

    /**
     * 이벤트 통계를 수정한다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    ModelAndView saveStatistics(Map<String, String> parameters);

    /**
     * 이벤트 통계를 제거한다
     *
     * @author psb
     * @param parameters
     * @return
     */
    ModelAndView removeStatistics(Map<String, String> parameters);
}
