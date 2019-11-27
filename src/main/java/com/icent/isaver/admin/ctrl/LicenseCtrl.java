package com.icent.isaver.admin.ctrl;

import com.icent.isaver.admin.svc.LicenseSvc;
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
 * Created by icent on 16. 6. 1..
 */
@Controller
@RequestMapping(value="/license/*")
public class LicenseCtrl {
    @Inject
    private LicenseSvc licenseSvc;

    /**
     * 라이센스 목록을 가져온다.(USB Lock용)
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/list")
    public ModelAndView findListLicense(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = licenseSvc.findListLicense(parameters);
        return modelAndView;
    }
}
