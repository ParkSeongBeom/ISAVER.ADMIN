package com.icent.isaver.admin.ctrl;

import com.icent.isaver.admin.common.resource.IcentException;
import com.icent.isaver.admin.svc.CriticalTargetSvc;
import com.kst.common.util.MapUtils;
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
 * 임계치별 대상장치 Controller
 *
 * @author : psb
 * @version : 1.0
 * @since : 2018. 9. 21.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2018. 9. 21.     psb           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value="/criticalTarget/*")
public class CriticalTargetCtrl {

    @Inject
    private CriticalTargetSvc criticalTargetSvc;

    private final static String[] findByCriticalTargetParam = new String[]{"criticalDetectId","targetDeviceId"};

    /**
     * 임계치별 대상장치 상세를 가져온다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/detail")
    public ModelAndView findByCriticalTarget(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        if(MapUtils.nullCheckMap(parameters, findByCriticalTargetParam)){
            throw new IcentException("");
        }

        ModelAndView modelAndView = criticalTargetSvc.findByCriticalTarget(parameters);
        return modelAndView;
    }

    private final static String[] addCriticalTargetParam = new String[]{"criticalDetectId","targetDeviceId"};

    /**
     * 임계치별 대상장치를 등록 한다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/add")
    public ModelAndView addCriticalTarget(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, addCriticalTargetParam)){
            throw new IcentException("");
        }
        ModelAndView modelAndView = criticalTargetSvc.addCriticalTarget(parameters);
        return modelAndView;
    }

    private final static String[] saveCriticalTargetParam = new String[]{"criticalDetectId","targetDeviceId"};

    /**
     * 임계치별 대상장치를 수정 한다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/save")
    public ModelAndView saveCriticalTarget(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, saveCriticalTargetParam)){
            throw new IcentException("");
        }
        ModelAndView modelAndView = criticalTargetSvc.saveCriticalTarget(parameters);
        return modelAndView;
    }

    private final static String[] removeCriticalTargetParam = new String[]{"criticalDetectId","targetDeviceId"};

    /**
     * 임계치별 대상장치를 제거 한다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/remove")
    public ModelAndView removeCriticalTarget(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, removeCriticalTargetParam)){
            throw new IcentException("");
        }

        ModelAndView modelAndView = criticalTargetSvc.removeCriticalTarget(parameters);
        return modelAndView;
    }
}
