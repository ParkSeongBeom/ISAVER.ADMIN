package com.icent.isaver.admin.ctrl;

import com.icent.isaver.admin.svc.AuthorizationSvc;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;

/**
 * @author : kst
 * @version : 1.0
 * @since : 2014. 6. 2.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 6. 2.     kst           최초 생성
 * </pre>
 */
@Controller
public class AuthorizationCtrl {

    @Inject
    private AuthorizationSvc authorizationSvc;

    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET}, value="/index")
    public ModelAndView index(){
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("login");
        return modelAndView;
    }

    @RequestMapping(method={RequestMethod.POST}, value="/login")
    public ModelAndView login(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = authorizationSvc.login(request, parameters);
        modelAndView.setViewName("main");

        return modelAndView;
    }

    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET}, value="/logout")
    public ModelAndView logout(HttpServletRequest request){
        ModelAndView modelAndView = authorizationSvc.logout(request);
        modelAndView.setViewName("login");

        return modelAndView;
    }

    @RequestMapping(method={RequestMethod.GET}, value="/vms")
    public ModelAndView vms(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        parameters.put("userId","admin");

        ModelAndView modelAndView = authorizationSvc.externalLogin(request, parameters);
        RedirectView rv = new RedirectView(request.getContextPath()+"/dashboard/all.html");
        rv.setExposeModelAttributes(false);
        modelAndView.setView(rv);
        return modelAndView;
    }

    /**
     * 기동여부를 확인한다.
     * @author psb
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET}, value="/alive")
    public ModelAndView alive(){
        return new ModelAndView();
    }
}
