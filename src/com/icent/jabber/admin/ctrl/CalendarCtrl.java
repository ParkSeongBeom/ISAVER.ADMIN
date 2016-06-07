package com.icent.jabber.admin.ctrl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.svc.CalendarSvc;
import com.icent.jabber.admin.util.AdminHelper;
import com.kst.common.util.MapUtils;
import com.kst.common.util.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;

/**
 * 일정 관리 Controller
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
@Controller
@RequestMapping(value="/calendar/*")
public class CalendarCtrl {

    @Value("#{configProperties['cnf.defaultPageSize']}")
    private String defaultPageSize;

    @Inject
    private CalendarSvc calendarSvc;

    /**
     * 일정 목록을 가져온다.
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="list")
    public ModelAndView findAllCalendar(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        parameters = AdminHelper.checkReloadList(request, response, "calendarList", parameters);
        AdminHelper.setPageParam(parameters, defaultPageSize);

        ModelAndView modelAndView = new ModelAndView();

        modelAndView.addObject("tabId",parameters.get("tabId"));
        modelAndView.addObject("paramBean",parameters);
        modelAndView.setViewName("calendarList");
        return modelAndView;
    }

    /**
     * 일정 달력으로보기.
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="calendarView")
    public ModelAndView findCalendarView(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = new ModelAndView();

        if(StringUtils.notNullCheck(parameters.get("startDatetimeStr")) && StringUtils.notNullCheck(parameters.get("endDatetimeStr"))){
            modelAndView = calendarSvc.findCalendarView(parameters);
        }

        modelAndView.setViewName("calendarView");
        return modelAndView;
    }

    /**
     * 일정 목록으로보기.
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="listView")
    public ModelAndView findListView(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        parameters = AdminHelper.checkReloadList(request, response, "calendarList", parameters);
        AdminHelper.setPageParam(parameters, defaultPageSize);

        ModelAndView modelAndView = calendarSvc.findListView(parameters);
        modelAndView.setViewName("listView");
        return modelAndView;
    }

    /**
     * 일정 사항을 가져온다.
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="detail")
    public ModelAndView findByCalendar(HttpServletRequest request, @RequestParam Map<String, String> parameters){

        ModelAndView modelAndView = calendarSvc.findByCalendar(parameters);
        modelAndView.setViewName("calendarDetail");
        return modelAndView;
    }


    private final static String[] addCalendarParam = new String[]{"title", "date", "type"};

    /**
     * 일정을 등록한다.
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="add")
    public ModelAndView addCalendar(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, addCalendarParam)){
            throw new JabberException("");
        }

        parameters.put("insertUserId",AdminHelper.getAdminIdFromSession(request));

        ModelAndView modelAndView = calendarSvc.addCalendar(parameters);
        return modelAndView;
    }

    private final static String[] updateCalendarParam = new String[]{"calendarId", "title", "date", "type"};

    /**
     * 일정을 저장한다.
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="save")
    public ModelAndView updateCalendar(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, updateCalendarParam)){
            throw new JabberException("");
        }

        parameters.put("updateUserId",AdminHelper.getAdminIdFromSession(request));

        ModelAndView modelAndView = calendarSvc.saveCalendar(parameters);
        return modelAndView;
    }

    private final static String[] removeCalendarParam = new String[]{"calendarId"};

    /**
     * 일정을 제거한다.
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="remove")
    public ModelAndView removeCalendar(HttpServletRequest request, @RequestParam Map<String, String> parameters) {

        if(MapUtils.nullCheckMap(parameters, removeCalendarParam)){
            throw new JabberException("");
        }

        parameters.put("updateUserId",AdminHelper.getAdminIdFromSession(request));

        ModelAndView modelAndView = calendarSvc.removeCalendar(parameters);
        return modelAndView;
    }
}
