package com.icent.isaver.admin.ctrl;

import com.icent.isaver.admin.common.resource.IsaverException;
import com.icent.isaver.admin.svc.CriticalDetectSvc;
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
 * 임계치별 감지장치 Controller
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
@RequestMapping(value="/criticalDetect/*")
public class CriticalDetectCtrl {

    @Inject
    private CriticalDetectSvc criticalDetectSvc;

    private final static String[] findByCriticalDetectParam = new String[]{"criticalDetectId"};

    /**
     * 임계치별 감지장치 상세를 가져온다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/detail")
    public ModelAndView findByCriticalDetect(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        if(MapUtils.nullCheckMap(parameters, findByCriticalDetectParam)){
            throw new IsaverException("");
        }

        ModelAndView modelAndView = criticalDetectSvc.findByCriticalDetect(parameters);
        return modelAndView;
    }

    private final static String[] addCriticalDetectParam = new String[]{"criticalId","detectDeviceId"};

    /**
     * 임계치별 감지장치를 등록 한다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/add")
    public ModelAndView addCriticalDetect(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, addCriticalDetectParam)){
            throw new IsaverException("");
        }
        ModelAndView modelAndView = criticalDetectSvc.addCriticalDetect(parameters);
        return modelAndView;
    }

    private final static String[] saveCriticalDetectParam = new String[]{"criticalDetectId","criticalId","detectDeviceId"};

    /**
     * 임계치별 감지장치를 수정 한다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/save")
    public ModelAndView saveCriticalDetect(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, saveCriticalDetectParam)){
            throw new IsaverException("");
        }
        ModelAndView modelAndView = criticalDetectSvc.saveCriticalDetect(parameters);
        return modelAndView;
    }

    private final static String[] removeCriticalDetectParam = new String[]{"criticalDetectId"};

    /**
     * 임계치별 감지장치를 제거 한다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/remove")
    public ModelAndView removeCriticalDetect(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, removeCriticalDetectParam)){
            throw new IsaverException("");
        }

        ModelAndView modelAndView = criticalDetectSvc.removeCriticalDetect(parameters);
        return modelAndView;
    }
}
