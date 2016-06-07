package com.icent.jabber.admin.ctrl;

import com.icent.jabber.admin.svc.LogAuthClientUserSvc;
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
 * @since : 2014. 6. 9.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 6. 9.     kst           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value = "/logauthuser/*")
public class LogAuthClientUserCtrl {

    @Value("#{configProperties['cnf.defaultPageSize']}")
    private String defaultPageSize;

    @Inject
    private LogAuthClientUserSvc logAuthClientUserSvc;

    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET}, value="/list")
    public ModelAndView findListLogAuthclientUser(@RequestParam Map<String, String> parameters){
        AdminHelper.setPageParam(parameters, defaultPageSize);

        ModelAndView modelAndView = logAuthClientUserSvc.findListLogAuthClientUser(parameters);
        modelAndView.setViewName("logAuthClientUserList");
        return modelAndView;
    }

    /**
     * 사용자정보 유저현황을 가져온다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="userList")
    public ModelAndView findListUserByMain(@RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = logAuthClientUserSvc.findListUserByMain(parameters);
        modelAndView.setViewName("mainUserList");
        return modelAndView;
    }

    /**
     * 사용자정보 접속현황을 가져온다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="logUserList")
    public ModelAndView findListLogAuthclientUserByMain(@RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = logAuthClientUserSvc.findListLogAuthclientUserByMain(parameters);
        modelAndView.setViewName("mainLogUserList");
        return modelAndView;
    }
}
