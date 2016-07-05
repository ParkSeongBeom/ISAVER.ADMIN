package com.icent.isaver.admin.ctrl;

import com.icent.isaver.admin.bean.JabberException;
import com.icent.isaver.admin.svc.AreaSvc;
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
 * Created by icent on 16. 5. 31..
 */
@Controller
@RequestMapping(value="/area/*")
public class AreaCtrl {

    @Value("#{configProperties['cnf.defaultPageSize']}")
    private String defaultPageSize;

    @Inject
    private AreaSvc areaSvc;

    /**
     * 구역 트리를 가져온다.
     *
     * @author dhj
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/treeList")
    public ModelAndView findListTree(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){

        ModelAndView modelAndView = areaSvc.findAllAreaTree(parameters);
        return modelAndView;
    }

    /**
     * 구역 목록을 가져온다.
     *
     * @author dhj
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/list")
    public ModelAndView findListArea(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        parameters = AdminHelper.checkReloadList(request, response, "areaList", parameters);
        AdminHelper.setPageParam(parameters, defaultPageSize);

        ModelAndView modelAndView = areaSvc.findListArea(parameters);
        modelAndView.setViewName("areaList");
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }
    /**
     *  구역 정보를 가져온다.
     *
     * @author dhj
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/detail")
    public ModelAndView findByArea(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        ModelAndView modelAndView = areaSvc.findByArea(parameters);
        modelAndView.setViewName("areaDetail");
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    private final static String[] addAreaParam = new String[]{"areaName", "sortOrder"};

    /**
     *  구역을 등록 한다.
     *
     * @author dhj
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/add")
    public ModelAndView addArea(HttpServletRequest request, @RequestParam Map<String, String> parameters) {

        if(MapUtils.nullCheckMap(parameters, addAreaParam)){
            throw new JabberException("");
        }

        parameters.put("insertUserId",AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = areaSvc.addArea(request, parameters);
        return modelAndView;
    }

    private final static String[] saveAreaParam = new String[]{"areaId", "areaName", "sortOrder"};

    /**
     *  구역을 수정 한다.
     *
     * @author dhj
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/save")
    public ModelAndView saveArea(HttpServletRequest request, @RequestParam Map<String, String> parameters) {

        if(MapUtils.nullCheckMap(parameters, saveAreaParam)){
            throw new JabberException("");
        }

        parameters.put("updateUserId",AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView =areaSvc.saveArea(request, parameters);
        return modelAndView;
    }

    private final static String[] removeAreaParam = new String[]{"areaId"};

    /**
     *  구역을 제거 한다.
     *
     * @author dhj
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/remove")
    public ModelAndView removeArea(HttpServletRequest request, @RequestParam Map<String, String> parameters) {

        if(MapUtils.nullCheckMap(parameters, removeAreaParam)){
            throw new JabberException("");
        }

        parameters.put("updateUserId",AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = areaSvc.removeArea(parameters);
        return modelAndView;
    }
}
