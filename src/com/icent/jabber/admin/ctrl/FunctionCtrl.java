package com.icent.jabber.admin.ctrl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.svc.FunctionSvc;
import com.icent.jabber.admin.util.AdminHelper;
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
 * 기능제한 관리 Controller
 * @author : psb
 * @version : 1.0
 * @since : 2014. 10. 29.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 10. 29.     psb           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value="/function/*")
public class FunctionCtrl {

    @Inject
    private FunctionSvc functionSvc;

    /**
     * 기능제한 목록을 가져온다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="list")
    public ModelAndView findAllFunction(@RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = functionSvc.findAllFunction(parameters);
        modelAndView.setViewName("functionList");
        return modelAndView;
    }

    /**
     * 상세 기능제한을 가져온다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="detail")
    public ModelAndView findByFunction(@RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = functionSvc.findByFunction(parameters);
        modelAndView.setViewName("functionDetail");
        return modelAndView;
    }

    private final static String[] saveFunctionParam = new String[]{"funcId", "funcName",  "useYn"};

    /**
     * 기능제한을 저장한다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="save")
    public ModelAndView saveFunction(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, saveFunctionParam)){
            throw new JabberException("");
        }

        ModelAndView modelAndView = functionSvc.saveFunction(parameters);
        modelAndView.setViewName("functionDetail");
        return modelAndView;
    }

    /**
     * 배포사이트에 기능제한을 리셋한다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="reset")
    public ModelAndView resetFunction(@RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = functionSvc.resetFunction();
        return modelAndView;
    }
}
