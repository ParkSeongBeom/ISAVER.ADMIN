package com.icent.isaver.admin.ctrl;

import com.icent.isaver.admin.common.resource.IcentException;
import com.icent.isaver.admin.svc.CriticalSvc;
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
 * @author dhj
 */
@Controller
@RequestMapping(value="/critical/*")
public class CriticalCtrl {

    @Value("${cnf.defaultPageSize}")
    private String defaultPageSize;

    @Inject
    private CriticalSvc criticalSvc;

    /**
     * 임계치 목록을 가져온다.
     *
     * @author dhj
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/list")
    public ModelAndView findListCritical(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        parameters = AdminHelper.checkReloadList(request, response, "eventList", parameters);
        AdminHelper.setPageParam(parameters, defaultPageSize);

        ModelAndView modelAndView = criticalSvc.findListCritical(parameters);
        modelAndView.setViewName("criticalList");
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }
    /**
     *  임계치 정보를 가져온다.
     *
     * @author dhj
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/detail")
    public ModelAndView findByCritical(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        ModelAndView modelAndView = criticalSvc.findByCritical(parameters);
        modelAndView.setViewName("criticalDetail");
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    private final static String[] addCriticalParam = new String[]{"eventId","criticalName","useYn","rangeYn","criticalInfo"};

    /**
     *  임계치를  등록 한다.
     *
     * @author dhj
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/add")
    public ModelAndView addCritical(HttpServletRequest request, @RequestParam Map<String, String> parameters) {

        if(MapUtils.nullCheckMap(parameters, addCriticalParam)){
            throw new IcentException("");
        }

        parameters.put("insertUserId",AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = criticalSvc.addCritical(request, parameters);
        return modelAndView;
    }

    private final static String[] saveCriticalParam = new String[]{"eventId","criticalName","useYn","rangeYn", "criticalInfo"};

    /**
     *  임계치를 수정 한다.
     *
     * @author dhj
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/save")
    public ModelAndView saveEvent(HttpServletRequest request, @RequestParam Map<String, String> parameters) {

        if(MapUtils.nullCheckMap(parameters, saveCriticalParam)){
            throw new IcentException("");
        }

        parameters.put("updateUserId",AdminHelper.getAdminIdFromSession(request));
        parameters.put("insertUserId",AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = criticalSvc.saveCritical(request, parameters);
        return modelAndView;
    }

    private final static String[] removeEventParam = new String[]{"eventId"};
    /**
     *  임계치를 제거 한다.
     *
     * @author dhj
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/remove")
    public ModelAndView removeCritical(HttpServletRequest request, @RequestParam Map<String, String> parameters) {

        if(MapUtils.nullCheckMap(parameters, removeEventParam)){
            throw new IcentException("");
        }

        parameters.put("updateUserId",AdminHelper.getAdminIdFromSession(request));

        ModelAndView modelAndView = criticalSvc.removeCritical(parameters);
        return modelAndView;
    }
}
