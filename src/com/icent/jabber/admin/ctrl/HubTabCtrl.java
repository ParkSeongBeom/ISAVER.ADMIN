package com.icent.jabber.admin.ctrl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.svc.HubTabSvc;
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
 * HubTab Controller
 *
 * @author : kst
 * @version : 1.0
 * @since : 2014. 5. 19.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 5. 19.     kst           최초 생성
 *  2015. 6. 25.     psb           관리자 리뉴얼
 * </pre>
 */
@Controller
@RequestMapping(value="/hubtab/*")
public class HubTabCtrl {

    @Value(value = "#{configProperties['cnf.defaultPageSize']}")
    private String defaultPageSize;

    @Inject
    private HubTabSvc hubTabSvc;

    /**
     * 허브탭 목록을 가져온다.
     *
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/list")
    public ModelAndView findListHubTab(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        parameters = AdminHelper.checkReloadList(request, response, "hubTabList", parameters);
        parameters = AdminHelper.setPageParam(parameters,defaultPageSize);

        ModelAndView modelAndView = hubTabSvc.findListHubTab(parameters);
        modelAndView.setViewName("hubTabList");

        return modelAndView;
    }

    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET}, value="/detail")
    public ModelAndView findByHubtab(@RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = hubTabSvc.findByHubTab(parameters);

        modelAndView.setViewName("hubTabDetail");
        return modelAndView;
    }

    private final static String[] addHubTabParam = new String[]{"tabLinkType","tabName"};

    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value = "add")
    public ModelAndView addHubTab(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        if(MapUtils.nullCheckMap(parameters, addHubTabParam)){
            throw new JabberException("");
        }

        parameters.put("insertUserId",AdminHelper.getAdminIdFromSession(request));

        ModelAndView modelAndView = hubTabSvc.addHubTab(parameters);
        modelAndView.setViewName("hubTabDetail");
        return modelAndView;
    }

    private final static String[] saveHubTabParam = new String[]{"tabId"};

    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value = "save")
    public ModelAndView saveHubTab(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        if(MapUtils.nullCheckMap(parameters, saveHubTabParam)){
            throw new JabberException("");
        }

        parameters.put("updateUserId",AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = hubTabSvc.saveHubTab(parameters);
        modelAndView.setViewName("hubTabDetail");
        return modelAndView;
    }

    private final static String[] removeHubTabParam = new String[]{"tabId"};

    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value = "remove")
    public ModelAndView removeHubTab(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        if(MapUtils.nullCheckMap(parameters, removeHubTabParam)){
            throw new JabberException("");
        }

        parameters.put("updateUserId",AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = hubTabSvc.removeHubTab(parameters);
        modelAndView.setViewName("hubTabList");
        return modelAndView;
    }
}
