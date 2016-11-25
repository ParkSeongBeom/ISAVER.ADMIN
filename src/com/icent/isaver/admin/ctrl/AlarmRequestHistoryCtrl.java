package com.icent.isaver.admin.ctrl;

import com.icent.isaver.admin.bean.JabberException;
import com.icent.isaver.admin.svc.AlarmRequestHistorySvc;
import com.icent.isaver.admin.util.AdminHelper;
import com.kst.common.util.MapUtils;
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
 * Created by icent on 2016. 11. 24..
 */
@Controller
@RequestMapping(value="/alarmRequestHistory/*")
public class AlarmRequestHistoryCtrl {

    @Value("#{configProperties['cnf.defaultPageSize']}")
    private String defaultPageSize;

    @Inject
    private AlarmRequestHistorySvc alarmRequestHistorySvc;

    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/list")
    public ModelAndView findListAlarmRequestHistory(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        parameters = AdminHelper.checkReloadList(request, response, "alarmRequestHistoryList", parameters);
        AdminHelper.setPageParam(parameters, defaultPageSize);

        ModelAndView modelAndView = alarmRequestHistorySvc.findListAlarmRequestHistory(parameters);
        modelAndView.setViewName("alarmRequestHistoryList");
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    private final static String[] findByAlarmRequestHistoryParam = new String[]{"alarmRequestId"};

    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/detail")
    public ModelAndView findByAlarmRequestHistory(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){

        if(MapUtils.nullCheckMap(parameters, findByAlarmRequestHistoryParam)){
            throw new JabberException("");
        }
        return alarmRequestHistorySvc.findByAlarmRequestHistoryDetail(parameters);
    }
}
