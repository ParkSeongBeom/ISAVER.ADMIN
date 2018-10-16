package com.icent.isaver.admin.ctrl;

import com.icent.isaver.admin.svc.DashBoardSvc;
import com.icent.isaver.admin.util.AdminHelper;
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
 * 대쉬보드 Controller
 *
 * @author : dhj
 * @version : 1.0
 * @since : 2016. 6. 15.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2016. 6. 15.     dhj           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value="/dashboard/*")
public class DashBoardCtrl {

    @Value("${cnf.defaultPageSize}")
    private String defaultPageSize;

    @Inject
    private DashBoardSvc dashBoardSvc;

    /**
     * 대쉬보드 화면를 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/list")
    public ModelAndView findListDashBoard(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        parameters = AdminHelper.reloadDashboasrd(request, response, "dashboardList", parameters);

        ModelAndView modelAndView = dashBoardSvc.findListDashBoard(parameters);
        modelAndView.setViewName("dashboardList");
        return modelAndView;
    }
}
