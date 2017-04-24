package com.icent.isaver.admin.ctrl;

import com.icent.isaver.admin.common.resource.IcentException;
import com.icent.isaver.admin.svc.CodeSvc;
import com.icent.isaver.admin.util.AdminHelper;
import com.kst.common.util.MapUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import java.util.Map;

/**
 * 코드관리 Controller
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
 *  2014. 6. 17.     kst           코드상세 필수인자 추가
 * </pre>
 */
@Controller
@RequestMapping(value="/code/*")
public class CodeCtrl {

    @Inject
    private CodeSvc codeSvc;

    private final static String[] findListCodeParam = new String[]{"groupCodeId"};

    /**
     * 코드 목록을 가져온다.
     *
     * @author kst
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/list")
    public ModelAndView findListCode(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        if(MapUtils.nullCheckMap(parameters, findListCodeParam)){
            throw new IcentException("");
        }

        ModelAndView modelAndView = codeSvc.findListCode(parameters);
        return modelAndView;
    }

    private final static String[] findByCodeParam = new String[]{"groupCodeId"};

    /**
     * 코드 상세정보를 가져온다.
     *
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/detail")
    public ModelAndView findByCode(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        if(MapUtils.nullCheckMap(parameters, findByCodeParam)){
            throw new IcentException("");
        }

        ModelAndView modelAndView = codeSvc.findByCode(parameters);
        modelAndView.setViewName("codeDetail");
        return modelAndView;
    }

    private final static String[] addCodeParam = new String[]{"groupCodeId","codeId","codeName","useYn"};

    /**
     * 코드를 등록한다.
     *
     * @author kst
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/add")
    public ModelAndView addCode(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        if(MapUtils.nullCheckMap(parameters, addCodeParam)){
            throw new IcentException("");
        }
        parameters.put("insertUserId", AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = codeSvc.addCode(parameters);
        return modelAndView;
    }

    private final static String[] saveCodeParam = new String[]{"groupCodeId","codeId","codeName","useYn"};

    /**
     * 코드를 수정한다.
     *
     * @author kst
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/save")
    public ModelAndView saveCode(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        if(MapUtils.nullCheckMap(parameters, saveCodeParam)){
            throw new IcentException("");
        }

        parameters.put("updateUserId",AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = codeSvc.saveCode(parameters);
        return modelAndView;
    }

    private final static String[] removeCodeParam = new String[]{"groupCodeId","codeId"};

    /**
     * 코드를 제거한다.
     *
     * @author kst
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/remove")
    public ModelAndView removeCode(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        if(MapUtils.nullCheckMap(parameters, removeCodeParam)){
            throw new IcentException("");
        }

        parameters.put("updateUserId",AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = codeSvc.removeCode(parameters);
        return modelAndView;
    }
}
