package com.icent.jabber.admin.ctrl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.svc.TpDeviceSvc;
import com.icent.jabber.admin.svc.UserSvc;
import com.icent.jabber.admin.util.AdminHelper;
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
 * TP 장비 관리 Controller
 *
 * @author : psb
 * @version : 1.0
 * @since : 2014. 6. 10.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 6. 10.     psb           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value="/tpdevice/*")
public class TpDeviceCtrl {

    @Value("#{configProperties['cnf.defaultPageSize']}")
    private String defaultPageSize;

    @Inject
    private TpDeviceSvc tpDeviceSvc;

    @Inject
    private UserSvc userSvc;

    /**
     * TP 장비 목록을 가져온다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="list")
    public ModelAndView findListTpDevice(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        parameters = AdminHelper.checkReloadList(request, response, "tpDeviceList", parameters);
        AdminHelper.setPageParam(parameters,defaultPageSize);

        ModelAndView modelAndView = tpDeviceSvc.findListTpDevice(parameters);
        modelAndView.setViewName("tpDeviceList");

        return modelAndView;
    }

    /**
     * TP 장비 정보를 가져온다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="detail")
    public ModelAndView findByTpDevice(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = tpDeviceSvc.findByTpDevice(parameters);
        modelAndView.setViewName("tpDeviceDetail");

        return modelAndView;
    }

    private final static String[] addTpDeviceParam = new String[]{"deviceName"};

    /**
     * TP 장비을 등록한다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="add")
    public ModelAndView addTpDevice(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        if(MapUtils.nullCheckMap(parameters,addTpDeviceParam)){
            throw new JabberException("");
        }

        parameters.put("roomId","001"); // 임시
        parameters.put("insertUserId","admin"); // 임시
        ModelAndView modelAndView = tpDeviceSvc.addTpDevice(request, parameters);
        modelAndView.setViewName("tpDeviceDetail");

        return modelAndView;
    }

    private final static String[] saveTpDeviceParam = new String[]{"deviceId", "deviceName"};

    /**
     * TP 장비을 수정한다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="save")
    public ModelAndView saveTpDevice(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        if(MapUtils.nullCheckMap(parameters,saveTpDeviceParam)){
            throw new JabberException("");
        }

        parameters.put("updateUserId","admin"); // 임시
        ModelAndView modelAndView = tpDeviceSvc.saveTpDevice(request, parameters);
        modelAndView.setViewName("tpDeviceDetail");

        return modelAndView;
    }

    private final static String[] removeTpDeviceParam = new String[]{"deviceId"};

    /**
     * TP 장비을 제거한다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="remove")
    public ModelAndView removeTpDevice(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        if(MapUtils.nullCheckMap(parameters,removeTpDeviceParam)){
            throw new JabberException("");
        }

        parameters.put("updateUserId","admin"); // 임시
        ModelAndView modelAndView = tpDeviceSvc.removeTpDevice(parameters);
        modelAndView.setViewName("tpDeviceDetail");

        return modelAndView;
    }
}
