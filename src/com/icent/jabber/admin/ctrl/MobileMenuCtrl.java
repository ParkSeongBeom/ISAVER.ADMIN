package com.icent.jabber.admin.ctrl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.svc.MobileMenuSvc;
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
 * MobileMenu Controller
 *
 * @author : psb
 * @version : 1.0
 * @since : 2016. 05. 03.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2016. 05. 03.     psb           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value="/mobileMenu/*")
public class MobileMenuCtrl {

    @Value(value = "#{configProperties['cnf.defaultPageSize']}")
    private String defaultPageSize;

    @Inject
    private MobileMenuSvc mobileMenuSvc;

    /**
     * 허브탭 목록을 가져온다.
     *
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/list")
    public ModelAndView findListMobileMenu(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        parameters = AdminHelper.checkReloadList(request, response, "MobileMenuList", parameters);
        parameters = AdminHelper.setPageParam(parameters,defaultPageSize);

        ModelAndView modelAndView = mobileMenuSvc.findListMobileMenu(parameters);
        modelAndView.setViewName("mobileMenuList");

        return modelAndView;
    }

    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET}, value="/detail")
    public ModelAndView findByMobileMenu(@RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = mobileMenuSvc.findByMobileMenu(parameters);
        modelAndView.setViewName("mobileMenuDetail");
        return modelAndView;
    }

    private final static String[] addMobileMenuParam = new String[]{"device","menuType","menuName","useYn"};

    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value = "add")
    public ModelAndView addMobileMenu(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        if(MapUtils.nullCheckMap(parameters, addMobileMenuParam)){
            throw new JabberException("");
        }

        parameters.put("insertUserId",AdminHelper.getAdminIdFromSession(request));

        ModelAndView modelAndView = mobileMenuSvc.addMobileMenu(parameters);
        return modelAndView;
    }

    private final static String[] saveMobileMenuParam = new String[]{"menuId"};

    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value = "save")
    public ModelAndView saveMobileMenu(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        if(MapUtils.nullCheckMap(parameters, saveMobileMenuParam)){
            throw new JabberException("");
        }

        parameters.put("updateUserId",AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = mobileMenuSvc.saveMobileMenu(parameters);
        return modelAndView;
    }

    private final static String[] removeMobileMenuParam = new String[]{"menuId"};

    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value = "remove")
    public ModelAndView removeMobileMenu(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        if(MapUtils.nullCheckMap(parameters, removeMobileMenuParam)){
            throw new JabberException("");
        }

        parameters.put("updateUserId",AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = mobileMenuSvc.removeMobileMenu(parameters);
        return modelAndView;
    }
}
