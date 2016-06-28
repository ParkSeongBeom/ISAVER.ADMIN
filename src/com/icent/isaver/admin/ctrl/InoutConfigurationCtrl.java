package com.icent.isaver.admin.ctrl;

import com.icent.isaver.admin.bean.JabberException;
import com.icent.isaver.admin.svc.InoutConfigurationSvc;
import com.icent.isaver.admin.util.AdminHelper;
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
 * 진출입자 조회 주기 Controller
 *
 * @author : psb
 * @version : 1.0
 * @since : 2016. 6. 27.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2016. 6. 27.     psb           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value="/inoutConfiguration/*")
public class InoutConfigurationCtrl {

    @Inject
    private InoutConfigurationSvc inoutConfigurationSvc;

    /**
     * 진출입자 조회 주기 목록을 가져온다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/list")
    public ModelAndView findListInoutConfiguration(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        parameters.put("userId",AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = inoutConfigurationSvc.findListInoutConfiguration(parameters);
        return modelAndView;
    }

    private final static String[] saveInoutConfigurationParam = new String[]{"areaId","inoutDatetimes"};

    /**
     * 진출입자 조회 주기를 저장한다.
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/save")
    public ModelAndView saveInoutConfiguration(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, saveInoutConfigurationParam)){
            throw new JabberException("");
        }

        parameters.put("userId",AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = inoutConfigurationSvc.saveInoutConfiguration(parameters);
        return modelAndView;
    }
}
