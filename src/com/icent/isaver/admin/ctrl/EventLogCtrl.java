package com.icent.isaver.admin.ctrl;

import com.icent.jabber.admin.util.AdminHelper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;

/**
 * Created by icent on 16. 6. 1..
 */
@Controller
@RequestMapping(value="/eventLog/*")
public class EventLogCtrl {

    @Value("#{configProperties['cnf.defaultPageSize']}")
    private String defaultPageSize;
    /**
     * 이벤트 로그 목록을 가져온다.
     *
     * @author dhj
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/list")
    public ModelAndView findListEventLog(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        parameters = AdminHelper.checkReloadList(request, response, "userList", parameters);
        AdminHelper.setPageParam(parameters, defaultPageSize);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("eventLogList");
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    /**
     *  이벤트 로그 정보를 가져온다.
     *
     * @author dhj
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/detail")
    public ModelAndView findByEventLog(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("eventLogDeatil");
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }


}
