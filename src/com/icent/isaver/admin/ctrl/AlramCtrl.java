package com.icent.isaver.admin.ctrl;

import com.icent.isaver.admin.common.resource.IcentException;
import com.icent.isaver.admin.svc.AlramSvc;
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
import java.util.Map;

/**
 * 임계치알림 Controller
 * @author : psb
 * @version : 1.0
 * @since : 2017. 08. 22.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2017. 08. 22.     psb           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value="/alram/*")
public class AlramCtrl {

    @Inject
    private AlramSvc alramSvc;

    @Value("${cnf.defaultPageSize}")
    private String defaultPageSize;

    /**
     * 임계치알림 목록을 가져온다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/list")
    public ModelAndView findListAlram(@RequestParam Map<String, String> parameters) {
        AdminHelper.setPageParam(parameters,defaultPageSize);
        ModelAndView modelAndView = alramSvc.findListAlram(parameters);
        modelAndView.setViewName("alramList");
        return modelAndView;
    }

    /**
     * 임계치알림 상세를 가져온다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/detail")
    public ModelAndView findByAlram(@RequestParam Map<String, String> parameters) {
        ModelAndView modelAndView = alramSvc.findByAlram(parameters);
        modelAndView.setViewName("alramDetail");
        return modelAndView;
    }

    private final static String[] addAlramParam = new String[]{"alramInfo","alramName","useYn"};

    /**
     * 임계치알림을 등록한다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/add")
    public ModelAndView addAlram(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, addAlramParam)){
            throw new IcentException("");
        }

        parameters.put("insertUserId",AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = alramSvc.addAlram(request, parameters);
        return modelAndView;
    }

    private final static String[] saveAlramParam = new String[]{"alramId","alramName","useYn","alramInfo"};

    /**
     * 임계치알림을 수정한다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/save")
    public ModelAndView saveAlram(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, saveAlramParam)){
            throw new IcentException("");
        }

        parameters.put("updateUserId",AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = alramSvc.saveAlram(request, parameters);
        return modelAndView;
    }

    private final static String[] removeAlramParam = new String[]{"alramId"};

    /**
     * 임계치알림을 삭제한다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/remove")
    public ModelAndView removeAlram(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, removeAlramParam)){
            throw new IcentException("");
        }

        ModelAndView modelAndView = alramSvc.removeAlram(request, parameters);
        return modelAndView;
    }
}
