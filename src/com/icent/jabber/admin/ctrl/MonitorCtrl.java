package com.icent.jabber.admin.ctrl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.svc.MonitorSvc;
import com.icent.jabber.admin.util.AdminHelper;
import com.kst.common.util.MapUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import java.util.Map;

/**
 * 모니터링 Controller
 * @author : psb
 * @version : 1.0
 * @since : 2015. 04. 07.
 * <pre>
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2015. 04. 07.     psb           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value="/monitor/*")
public class MonitorCtrl {

    @Inject
    private MonitorSvc monitorSvc;

    /**
     * 모니터링 목록을 가져온다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="list")
    public ModelAndView findAllMonitor(@RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = monitorSvc.findAllMonitor(parameters);
        modelAndView.setViewName("monitorList");
        return modelAndView;
    }

    /**
     * 상세 모니터링을 가져온다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="detail")
    public ModelAndView findByMonitor(@RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = monitorSvc.findByMonitor(parameters);
        modelAndView.setViewName("monitorDetail");
        return modelAndView;
    }


    private final static String[] addMonitorParam = new String[]{"name", "ip", "id", "password", "useYn"};

    /**
     * 모니터링을 등록한다.
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="add")
    public ModelAndView addMonitor(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, addMonitorParam)){
            throw new JabberException("");
        }

        parameters.put("insertUserId",AdminHelper.getAdminIdFromSession(request));

        ModelAndView modelAndView = monitorSvc.addMonitor(parameters);
        return modelAndView;
    }

    private final static String[] updateMonitorParam = new String[]{"monitorId", "name", "ip", "id", "password", "useYn"};

    /**
     * 모니터링을 저장한다.
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="save")
    public ModelAndView updateMonitor(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, updateMonitorParam)){
            throw new JabberException("");
        }

        parameters.put("updateUserId", AdminHelper.getAdminIdFromSession(request));

        ModelAndView modelAndView = monitorSvc.saveMonitor(parameters);
        return modelAndView;
    }

    private final static String[] removeMonitorParam = new String[]{"monitorId"};

    /**
     * 모니터링을 제거한다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="remove")
    public ModelAndView removeMonitor(HttpServletRequest request,@RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, removeMonitorParam)){
            throw new JabberException("");
        }
        ModelAndView modelAndView = monitorSvc.removeMonitor(parameters);
        return modelAndView;
    }

    /**
     * 모니터링 서버 목록을 가져온다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="serverList")
    public ModelAndView findListMonitorServer(@RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = monitorSvc.findListMonitorServer(parameters);
        modelAndView.setViewName("mainMonitorServerList");
        return modelAndView;
    }

    private final static String[] findByMonitorServerParam = new String[]{"monitorId"};

    /**
     * 모니터링 서버상세.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="serverDetail")
    public ModelAndView findByMonitorServer(@RequestParam Map<String, String> parameters){
        if(MapUtils.nullCheckMap(parameters, findByMonitorServerParam)){
            throw new JabberException("");
        }

        ModelAndView modelAndView = monitorSvc.findByMonitorServer(parameters);
        return modelAndView;
    }
}
