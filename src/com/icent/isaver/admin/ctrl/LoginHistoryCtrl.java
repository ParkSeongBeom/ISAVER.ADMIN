package com.icent.isaver.admin.ctrl;

import com.icent.isaver.admin.svc.LoginHistorySvc;
import com.icent.isaver.admin.util.AdminHelper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import java.util.Map;

/**
 * 접속 로그 Controller
 *
 * @author : psb
 * @version : 1.0
 * @since : 2016. 6. 14.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2016. 6. 14.     psb           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value="/loginHistory/*")
public class LoginHistoryCtrl {

    @Inject
    private LoginHistorySvc loginHistorySvc;

    @Value("#{configProperties['cnf.defaultPageSize']}")
    private String defaultPageSize;

    /**
     * 접속 로그 목록을 가져온다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/list")
    public ModelAndView findListLoginHistory(@RequestParam Map<String, String> parameters) {
        AdminHelper.setPageParam(parameters,defaultPageSize);
        ModelAndView modelAndView = loginHistorySvc.findListLoginHistory(parameters);
        modelAndView.setViewName("loginHistoryList");
        return modelAndView;
    }
}
