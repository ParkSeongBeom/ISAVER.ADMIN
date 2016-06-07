package com.icent.jabber.admin.ctrl;

import com.icent.jabber.admin.svc.AccountSvc;
import com.icent.jabber.admin.util.AdminHelper;
import com.kst.common.util.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import java.util.Calendar;
import java.util.Map;

/**
 * 로그인통계 Controller
 * @author  : psb
 * @version  : 1.0
 * @since  : 2014. 10. 22.
 * <pre>
 * == 개정이력(Modification Information) ====================
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 10. 22.     psb           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value="/account/*")
public class AccountCtrl {

    @Inject
    private AccountSvc accountSvc;

    /**
     * 로그인통계 목록을 가져온다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="list")
    public ModelAndView findAllFunction(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        parameters = AdminHelper.checkSearchDate(parameters, 2 , 6);

        ModelAndView modelAndView = new ModelAndView();

        modelAndView.addObject("tabId",parameters.get("tabId"));
        modelAndView.addObject("paramBean",parameters);
        modelAndView.setViewName("accountList");
        return modelAndView;
    }

    /**
     * 로그인통계 현황을 가져온다.
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="reportList")
    public ModelAndView findListReportAccount(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        if(StringUtils.nullCheck(parameters.get("reportDt"))){
            Calendar reportDt = Calendar.getInstance();
            parameters.put("reportDt", Integer.toString(reportDt.getWeekYear()));
        }

        ModelAndView modelAndView = accountSvc.findListReportAccount(parameters);
        modelAndView.setViewName("reportAccountList");
        return modelAndView;
    }

    /**
     * 로그인통계 부서별 목록을 가져온다.
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="orgList")
    public ModelAndView findListOrgAccount(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        parameters = AdminHelper.checkSearchDate(parameters, 2 , 6);

        ModelAndView modelAndView = accountSvc.findListOrgAccount(parameters);
        modelAndView.setViewName("orgAccountList");
        return modelAndView;
    }

    /**
     * 로그인통계 개인별 목록을 가져온다.
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="userList")
    public ModelAndView findListUserAccount(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        parameters = AdminHelper.checkSearchDate(parameters, 2 , 6);

        ModelAndView modelAndView = accountSvc.findListUserAccount(parameters);
        modelAndView.setViewName("userAccountList");
        return modelAndView;
    }
}
