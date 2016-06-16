package com.icent.isaver.admin.ctrl;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

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

    @Value("#{configProperties['cnf.defaultPageSize']}")
    private String defaultPageSize;

    /**
     * 대쉬보드 전체 화면를 가져온다.
     *
     * @author dhj
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/all")
    public ModelAndView findAllDashBoard(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("allDashboard");
        return modelAndView;
    }

    /**
     * 대쉬보드 상세 화면를 가져온다.
     *
     * @author dhj
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/detail")
    public ModelAndView findByDashBoard(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("detailDashboard");
        return modelAndView;
    }
}
