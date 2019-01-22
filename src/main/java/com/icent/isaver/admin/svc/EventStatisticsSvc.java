package main.java.com.icent.isaver.admin.svc;

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
public interface EventStatisticsSvc {

    /**
     * 이벤트 통계 목록을 가져온다.
     * @author psb
     * @return the list
     */
    public ModelAndView findListEventStatistics(Map<String, String> parameters);

    /**
     * 시간별 이벤트 통계 목록을 가져온다.
     * @author psb
     * @return the list
     */
    public ModelAndView findListEventStatisticsHour(Map<String, String> parameters);

    /**
     * 일별 이벤트 통계 목록을 가져온다.
     * @author psb
     * @return the list
     */
    public ModelAndView findListEventStatisticsDay(Map<String, String> parameters);

    /**
     * 요일별 이벤트 통계 목록을 가져온다.
     * @author psb
     * @return the list
     */
    public ModelAndView findListEventStatisticsDow(Map<String, String> parameters);

    /**
     * 주별 이벤트 통계 목록을 가져온다.
     * @author psb
     * @return the list
     */
    public ModelAndView findListEventStatisticsWeek(Map<String, String> parameters);

    /**
     * 월별 이벤트 통계 목록을 가져온다.
     * @author psb
     * @return the list
     */
    public ModelAndView findListEventStatisticsMonth(Map<String, String> parameters);

    /**
     * 년별 이벤트 통계 목록을 가져온다.
     * @author psb
     * @return the list
     */
    public ModelAndView findListEventStatisticsYear(Map<String, String> parameters);
}
