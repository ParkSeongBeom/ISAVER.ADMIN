package com.icent.isaver.admin.ctrl;

import com.icent.isaver.admin.common.resource.IcentException;
import com.icent.isaver.admin.svc.AlarmTargetDeviceSvc;
import com.kst.common.util.MapUtils;
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
 * Created by icent on 2016. 11. 22..
 */
@Controller
@RequestMapping(value="/alarmTargetDevice/*")
public class AlarmTargetDeviceCtrl {

    @Inject
    private AlarmTargetDeviceSvc alarmTargetDeviceSvc;

    private final static String[] appendAlarmTargetDeviceParam = new String[]{"tDeviceId"};

    /**
     * 알림 장치 ID를 등록한다.
     *
     * @author dhj
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/append")
    public ModelAndView appendAlarmTargetDevice(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){

        if(MapUtils.nullCheckMap(parameters, appendAlarmTargetDeviceParam)){
            throw new IcentException("");
        }

        ModelAndView modelAndView = alarmTargetDeviceSvc.appendAlarmTargetDevice(parameters);
        return modelAndView;
    }
}
