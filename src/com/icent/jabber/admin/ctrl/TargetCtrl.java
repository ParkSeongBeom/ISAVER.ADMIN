package com.icent.jabber.admin.ctrl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.svc.TargetSvc;
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
 * 고객사 관리 Controller
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
@RequestMapping(value="/target/*")
public class TargetCtrl {

    @Inject
    private TargetSvc targetSvc;

    /**
     * 고객사 목록을 가져온다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="list")
    public ModelAndView findAllTarget(@RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = targetSvc.findAllTarget(parameters);
        modelAndView.setViewName("targetList");
        return modelAndView;
    }

    /**
     * 상세 고객사를 가져온다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="detail")
    public ModelAndView findByTarget(@RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = targetSvc.findByTarget(parameters);
        modelAndView.setViewName("targetDetail");
        return modelAndView;
    }

    private final static String[] saveTargetParam = new String[]{"targetId", "name", "code"};

    /**
     * 고객사를 저장한다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="save")
    public ModelAndView saveTarget(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, saveTargetParam)){
            throw new JabberException("");
        }

        parameters.put("updateUserId",AdminHelper.getAdminIdFromSession(request));

        ModelAndView modelAndView = targetSvc.saveTarget(parameters);
        modelAndView.setViewName("targetDetail");
        return modelAndView;
    }

    /**
     * 배포사이트에 고객사정보를 리셋한다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="reset")
    public ModelAndView resetTarget(@RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = targetSvc.resetTarget();
        return modelAndView;
    }
}
