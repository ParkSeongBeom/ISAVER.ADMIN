package com.icent.isaver.admin.ctrl;

import com.icent.isaver.admin.common.resource.IsaverException;
import com.icent.isaver.admin.svc.CustomMapLocationSvc;
import com.meous.common.util.MapUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import java.util.Map;

/**
 * Custom Map 관리
 *
 * @author : psb
 * @version : 1.0
 * @since : 2018. 6. 14.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2018. 6. 14.     psb           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value="/customMapLocation/*")
public class CustomMapLocationCtrl {

    @Inject
    private CustomMapLocationSvc customMapLocationSvc;

    /**
     * Custom Map 목록을 가져온다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/list")
    public ModelAndView findListCustomMapLocation(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        ModelAndView modelAndView = customMapLocationSvc.findListCustomMapLocation(parameters);
        return modelAndView;
    }

    private final static String[] saveCustomMapLocationParam = new String[]{"areaId"};

    /**
     * Custom Map 설정을 저장한다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/save")
    public ModelAndView saveCustomMapLocation(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, saveCustomMapLocationParam)){
            throw new IsaverException("");
        }

        ModelAndView modelAndView = customMapLocationSvc.saveCustomMapLocation(parameters);
        return modelAndView;
    }
}
