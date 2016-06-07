package com.icent.jabber.admin.ctrl;

import com.icent.jabber.admin.svc.LogAuthAdminUserSvc;
import com.icent.jabber.admin.util.AdminHelper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import java.util.Map;

/**
 * @author : kst
 * @version : 1.0
 * @since : 2014. 6. 10.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 6. 10.     kst           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value="/logauthadmin/*")
public class LogAuthAdminUserCtrl {

    @Value("#{configProperties['cnf.defaultPageSize']}")
    private String defaultPageSize;

    @Inject
    private LogAuthAdminUserSvc logAuthAdminUserSvc;

    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET}, value="list")
    public ModelAndView findListLogAuthAdminUser(@RequestParam Map<String, String> parameters){
        AdminHelper.setPageParam(parameters, defaultPageSize);

        ModelAndView modelAndView = logAuthAdminUserSvc.findListLogAuthAdminUser(parameters);
        modelAndView.setViewName("logAuthAdminUserList");
        return modelAndView;
    }

    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET}, value="mainList")
    public ModelAndView findListLogAuthAdminUserByMain(@RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = logAuthAdminUserSvc.findListLogAuthAdminUserByMain(parameters);
        modelAndView.setViewName("mainLogAuthAdminUserList");
        return modelAndView;
    }
}
