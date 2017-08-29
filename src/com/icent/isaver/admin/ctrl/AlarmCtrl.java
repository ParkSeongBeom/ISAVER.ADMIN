package com.icent.isaver.admin.ctrl;

import com.icent.isaver.admin.common.resource.IcentException;
import com.icent.isaver.admin.svc.AlarmSvc;
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
import java.util.Map;

/**
 * 임계치알림 Controller
 * @author : psb
 * @version : 1.0
 * @since : 2017. 08. 22.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2017. 08. 22.     psb           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value="/alarm/*")
public class AlarmCtrl {

    @Inject
    private AlarmSvc alarmSvc;

    @Value("${cnf.defaultPageSize}")
    private String defaultPageSize;

    /**
     * 임계치알림 목록을 가져온다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/list")
    public ModelAndView findListAlarm(@RequestParam Map<String, String> parameters) {
        AdminHelper.setPageParam(parameters,defaultPageSize);
        ModelAndView modelAndView = alarmSvc.findListAlarm(parameters);
        modelAndView.setViewName("alarmList");
        return modelAndView;
    }

    /**
     * 임계치알림 상세를 가져온다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/detail")
    public ModelAndView findByAlarm(@RequestParam Map<String, String> parameters) {
        ModelAndView modelAndView = alarmSvc.findByAlarm(parameters);
        modelAndView.setViewName("alarmDetail");
        return modelAndView;
    }

    private final static String[] addAlarmParam = new String[]{"alarmInfo","alarmName","useYn"};

    /**
     * 임계치알림을 등록한다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/add")
    public ModelAndView addAlarm(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, addAlarmParam)){
            throw new IcentException("");
        }

        parameters.put("insertUserId",AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = alarmSvc.addAlarm(request, parameters);
        return modelAndView;
    }

    private final static String[] saveAlarmParam = new String[]{"alarmId","alarmName","useYn","alarmInfo"};

    /**
     * 임계치알림을 수정한다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/save")
    public ModelAndView saveAlarm(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, saveAlarmParam)){
            throw new IcentException("");
        }

        parameters.put("updateUserId",AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = alarmSvc.saveAlarm(request, parameters);
        return modelAndView;
    }

    private final static String[] removeAlarmParam = new String[]{"alarmId"};

    /**
     * 임계치알림을 삭제한다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/remove")
    public ModelAndView removeAlarm(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, removeAlarmParam)){
            throw new IcentException("");
        }

        ModelAndView modelAndView = alarmSvc.removeAlarm(request, parameters);
        return modelAndView;
    }
}
