package com.icent.isaver.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

/**
 * Created by icent on 2016. 11. 22..
 */
public interface AlarmTargetDeviceSvc {

    /**
     *
     * @param parameters
     * @return
     * @author dhj
     */
    ModelAndView appendAlarmTargetDevice(Map<String, String> parameters);

}
