package com.icent.isaver.admin.ctrl;

import com.icent.isaver.admin.bean.JabberException;
import com.icent.isaver.admin.svc.DeviceSvc;
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
 * Created by icent on 16. 5. 31..
 */
@Controller
@RequestMapping(value="/device/*")
public class DeviceCtrl {

    @Value("#{configProperties['cnf.defaultPageSize']}")
    private String defaultPageSize;

    @Inject
    private DeviceSvc deviceSvc;

    /**
     * 장치 트리를 가져온다.
     *
     * @author dhj
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/treeList")
    public ModelAndView findListTree(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){

        ModelAndView modelAndView = deviceSvc.findAllDeviceTree(parameters);
        return modelAndView;
    }

    /**
     * 장치 목록을 가져온다.
     *
     * @author dhj
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/list")
    public ModelAndView findListDevice(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        parameters = AdminHelper.checkReloadList(request, response, "deviceList", parameters);
        AdminHelper.setPageParam(parameters, defaultPageSize);

        ModelAndView modelAndView = deviceSvc.findListDevice(parameters);
        modelAndView.setViewName("deviceList");
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }
    /**
     * 장치 정보를 가져온다.
     *
     * @author dhj
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/detail")
    public ModelAndView findByDevice(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        ModelAndView modelAndView = deviceSvc.findByDevice(parameters);
        modelAndView.setViewName("deviceDetail");
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    private final static String[] addDeviceParam = new String[]{"deviceName", "deviceTypeCode", "deviceType", "deviceCode"};

    /**
     * 장치를 등록 한다.
     *
     * @author dhj
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/add")
    public ModelAndView addDevice(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, addDeviceParam)){
            throw new JabberException("");
        }
        ModelAndView modelAndView = deviceSvc.addDevice(request, parameters);
        return modelAndView;
    }

    private final static String[] saveDeviceParam = new String[]{"deviceId", "deviceName", "deviceTypeCode", "deviceType", "deviceCode"};

    /**
     *  장치를 수정 한다.
     *
     * @author dhj
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/save")
    public ModelAndView saveDevice(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, saveDeviceParam)){
            throw new JabberException("");
        }
        ModelAndView modelAndView = deviceSvc.saveDevice(request, parameters);
        return modelAndView;
    }

    private final static String[] removeDeviceParam = new String[]{"deviceId"};

    /**
     *  장치를 제거 한다.
     *
     * @author dhj
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/remove")
    public ModelAndView removeDevice(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, removeDeviceParam)){
            throw new JabberException("");
        }
        ModelAndView modelAndView = deviceSvc.removeDevice(parameters);
        return modelAndView;
    }
}
