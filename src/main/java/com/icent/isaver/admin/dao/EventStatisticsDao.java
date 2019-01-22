package main.java.com.icent.isaver.admin.dao;

import com.icent.isaver.admin.bean.EventStatisticsBean;

import java.util.List;
import java.util.Map;

/**
 * 이벤트 통계 Dao Interface
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
 *  2018. 2. 23.     psb           통계 테이블 변경으로 인한 수정
 * </pre>
 */
public interface EventStatisticsDao {
    /**
     * 시간별 이벤트 통계 목록을 가져온다.
     * @author psb
     * @return the list
     */
    public List<EventStatisticsBean> findListEventStatisticsHour(Map<String, String> parameters);

    /**
     * 일별 이벤트 통계 목록을 가져온다.
     * @author psb
     * @return the list
     */
    public List<EventStatisticsBean> findListEventStatisticsDay(Map<String, String> parameters);

    /**
     * 요일별 이벤트 통계 목록을 가져온다.
     * @author psb
     * @return the list
     */
    public List<EventStatisticsBean> findListEventStatisticsDow(Map<String, String> parameters);

    /**
     * 주별 이벤트 통계 목록을 가져온다.
     * @author psb
     * @return the list
     */
    public List<EventStatisticsBean> findListEventStatisticsWeek(Map<String, String> parameters);

    /**
     * 월별 이벤트 통계 목록을 가져온다.
     * @author psb
     * @return the list
     */
    public List<EventStatisticsBean> findListEventStatisticsMonth(Map<String, String> parameters);

    /**
     * 년별 이벤트 통계 목록을 가져온다.
     * @author psb
     * @return the list
     */
    public List<EventStatisticsBean> findListEventStatisticsYear(Map<String, String> parameters);
}
