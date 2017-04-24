package com.icent.isaver.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

/**
 * Created by icent on 2016. 11. 24..
 */
public interface AlarmRequestHistorySvc {

    /**
     * @author dhj
     * @param parameters
     * @return
     */
    ModelAndView findListAlarmRequestHistory(Map<String, String> parameters);

    ModelAndView findByAlarmRequestHistoryDetail(Map<String, String> parameters);
}
