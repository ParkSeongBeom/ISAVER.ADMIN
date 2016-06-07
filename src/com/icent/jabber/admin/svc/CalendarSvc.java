package com.icent.jabber.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

/**
 * 일정 관리 Service interface
 * @author : psb
 * @version : 1.0
 * @since : 2014. 11. 27.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 11. 27.     psb           최초 생성
 * </pre>
 */
public interface CalendarSvc {

    /**
     * 일정 달력으로보기.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView findCalendarView(Map<String, String> parameters);

    /**
     * 일정 목록으로보기.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView findListView(Map<String, String> parameters);

    /**
     * 일정 정보를 반환 한다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView findByCalendar(Map<String, String> parameters);

    /**
     * 일정을 등록한다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView addCalendar(Map<String, String> parameters);

    /**
     * 일정을 저장한다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView saveCalendar(Map<String, String> parameters);

    /**
     * 일정을 제거한다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView removeCalendar(Map<String, String> parameters);
}
