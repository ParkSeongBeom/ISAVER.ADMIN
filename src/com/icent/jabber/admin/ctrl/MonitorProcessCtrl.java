package com.icent.jabber.admin.ctrl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.svc.MonitorProcessSvc;
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
 * 모니터링 프로세스 Controller
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
@RequestMapping(value="/monitorProcess/*")
public class MonitorProcessCtrl {

    @Inject
    private MonitorProcessSvc monitorProcessSvc;

    /**
     * 모니터링 프로세스 목록을 가져온다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="list")
    public ModelAndView findAllProcess(@RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = monitorProcessSvc.findAllProcess(parameters);
        modelAndView.setViewName("monitorProcessList");
        return modelAndView;
    }

    /**
     * 상세 모니터링 프로세스을 가져온다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="detail")
    public ModelAndView findByProcess(@RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = monitorProcessSvc.findByProcess(parameters);
        modelAndView.setViewName("monitorProcessDetail");
        return modelAndView;
    }


    private final static String[] addMonitorProcessParam = new String[]{"monitorId", "processCode", "serviceName"};

    /**
     * 모니터링 프로세스을 등록한다.
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="add")
    public ModelAndView addMonitorProcess(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, addMonitorProcessParam)){
            throw new JabberException("");
        }

        parameters.put("insertUserId",AdminHelper.getAdminIdFromSession(request));

        ModelAndView modelAndView = monitorProcessSvc.addMonitorProcess(parameters);
        return modelAndView;
    }

    private final static String[] updateMonitorProcessParam = new String[]{"processId", "monitorId", "processCode", "serviceName"};

    /**
     * 모니터링 프로세스을 저장한다.
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="save")
    public ModelAndView updateMonitorProcess(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, updateMonitorProcessParam)){
            throw new JabberException("");
        }

        parameters.put("updateUserId", AdminHelper.getAdminIdFromSession(request));

        ModelAndView modelAndView = monitorProcessSvc.saveMonitorProcess(parameters);
        return modelAndView;
    }

    private final static String[] removeMonitorProcessParam = new String[]{"processId"};

    /**
     * 모니터링 프로세스을 제거한다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="remove")
    public ModelAndView removeMonitorProcess(HttpServletRequest request,@RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, removeMonitorProcessParam)){
            throw new JabberException("");
        }
        ModelAndView modelAndView = monitorProcessSvc.removeMonitorProcess(parameters);
        return modelAndView;
    }

    /**
     * 모니터링 서버 목록을 가져온다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="processList")
    public ModelAndView findListMonitorProcess(@RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = monitorProcessSvc.findListMonitorProcess(parameters);
        modelAndView.setViewName("mainMonitorProcessList");
        return modelAndView;
    }

    /**
     * 모니터링 프로세스상세.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="processDetail")
    public ModelAndView findByMonitorProcess(@RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = monitorProcessSvc.findByMonitorProcess(parameters);
        return modelAndView;
    }
}
