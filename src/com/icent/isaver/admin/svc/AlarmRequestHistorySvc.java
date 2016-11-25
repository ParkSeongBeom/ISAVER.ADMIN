package com.icent.isaver.admin.svc;

import com.icent.isaver.repository.bean.AlarmRequestHistoryBean;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;
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
