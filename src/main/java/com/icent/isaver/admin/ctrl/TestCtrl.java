package com.icent.isaver.admin.ctrl;

import com.icent.isaver.admin.common.resource.IsaverException;
import com.icent.isaver.admin.svc.TestSvc;
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
 * @author : psb
 * @version : 1.0
 * @since : 2018. 3. 20.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2018. 3. 20.     psb           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value="/test/*")
public class TestCtrl {

    @Inject
    private TestSvc testSvc;

    @RequestMapping(method={RequestMethod.GET}, value="/list")
    public ModelAndView testList(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = testSvc.testList(request, parameters);
        modelAndView.setViewName("testList");
        return modelAndView;
    }

    public final static String[] eventAddParam = new String[]{"eventData"};

    @RequestMapping(method={RequestMethod.POST}, value="/event")
    public ModelAndView eventSend(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        if(MapUtils.nullCheckMap(parameters, eventAddParam)){
            throw new IsaverException("");
        }
        return testSvc.eventSend(request, parameters);
    }

    @RequestMapping(method={RequestMethod.POST}, value="/guard")
    public ModelAndView guard(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        return testSvc.guard(request, parameters);
    }
}
