package com.icent.isaver.admin.ctrl;

import com.icent.isaver.admin.bean.JabberException;
import com.icent.isaver.admin.svc.ActionSvc;
import com.icent.isaver.admin.util.AdminHelper;
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
 * Created by icent on 16. 6. 1..
 */
@Controller
@RequestMapping(value="/action/*")
public class ActionCtrl {

    @Value("#{configProperties['cnf.defaultPageSize']}")
    private String defaultPageSize;


    @Inject
    private ActionSvc actionSvc;

    /**
     * 대응 목록을 가져온다.
     *
     * @author dhj
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/list")
    public ModelAndView findListAction(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        parameters = AdminHelper.checkReloadList(request, response, "actionList", parameters);
        AdminHelper.setPageParam(parameters, defaultPageSize);

        ModelAndView modelAndView = actionSvc.findListAction(parameters);
        modelAndView.setViewName("actionList");
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }
    /**
     * 대응 정보를 가져온다.
     *
     * @author dhj
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/detail")
    public ModelAndView findByAction(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        ModelAndView modelAndView = actionSvc.findByAction(parameters);
        modelAndView.setViewName("actionDetail");
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    /**
     * 이벤트 대응 정보를 가져온다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/eventDetail")
    public ModelAndView findByActionFromEventId(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        ModelAndView modelAndView = actionSvc.findByActionFromEventId(parameters);
        return modelAndView;
    }

    private final static String[] addActionParam = new String[]{"actionCode"};

    /**
     * 대응을 등록 한다.
     *
     * @author dhj
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/add")
    public ModelAndView addAction(HttpServletRequest request, @RequestParam Map<String, String> parameters) {

        if(MapUtils.nullCheckMap(parameters, addActionParam)){
            throw new JabberException("");
        }
        parameters.put("insertUserId",AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = actionSvc.addAction(request, parameters);
        return modelAndView;
    }

    private final static String[] saveActionParam = new String[]{"actionId", "actionCode"};

    /**
     * 대응을 수정 한다.
     *
     * @author dhj
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/save")
    public ModelAndView saveAction(HttpServletRequest request, @RequestParam Map<String, String> parameters) {

        if(MapUtils.nullCheckMap(parameters, saveActionParam)){
            throw new JabberException("");
        }
        parameters.put("updateUserId",AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = actionSvc.saveAction(request, parameters);
        return modelAndView;
    }

    private final static String[] removeActionParam = new String[]{"actionId"};

    /**
     * 대응을 제거 한다.
     *
     * @author dhj
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/remove")
    public ModelAndView removeAction(HttpServletRequest request, @RequestParam Map<String, String> parameters) {

        if(MapUtils.nullCheckMap(parameters, removeActionParam)){
            throw new JabberException("");
        }

        parameters.put("updateUserId",AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = actionSvc.removeAction(parameters);
        return modelAndView;
    }

}
