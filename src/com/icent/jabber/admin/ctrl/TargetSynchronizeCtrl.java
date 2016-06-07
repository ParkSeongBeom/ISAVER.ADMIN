package com.icent.jabber.admin.ctrl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.svc.TargetSynchronizeSvc;
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
 * 대상서버 관리 Controller
 * @author : psb
 * @version : 1.0
 * @since : 2015. 12. 07.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2015. 12. 07.     psb           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value="/targetSynchronize/*")
public class TargetSynchronizeCtrl {

    @Inject
    private TargetSynchronizeSvc targetSynchronizeSvc;

    /**
     * 대상서버 전체 목록을 가져온다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="list")
    public ModelAndView findListTargetSynchronize(@RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = targetSynchronizeSvc.findListTargetSynchronize(parameters);
        modelAndView.setViewName("targetSynchronizeList");
        return modelAndView;
    }

    /**
     * 대상서버 상세를 가져온다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="detail")
    public ModelAndView findByTargetSynchronize(@RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = targetSynchronizeSvc.findByTargetSynchronize(parameters);
        modelAndView.setViewName("targetSynchronizeDetail");
        return modelAndView;
    }

    private final static String[] addTargetSynchronizeParam = new String[]{"name", "type", "useYn"};

    /**
     * 대상서버를 등록한다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="add")
    public ModelAndView addTargetSynchronize(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, addTargetSynchronizeParam)){
            throw new JabberException("");
        }

        parameters.put("insertUserId",AdminHelper.getAdminIdFromSession(request));

        ModelAndView modelAndView = targetSynchronizeSvc.addTargetSynchronize(parameters);
        return modelAndView;
    }

    private final static String[] saveTargetSynchronizeParam = new String[]{"targetId", "type", "name", "useYn"};

    /**
     * 대상서버를 저장한다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="save")
    public ModelAndView saveTargetSynchronize(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, saveTargetSynchronizeParam)){
            throw new JabberException("");
        }

        parameters.put("updateUserId",AdminHelper.getAdminIdFromSession(request));

        ModelAndView modelAndView = targetSynchronizeSvc.saveTargetSynchronize(parameters);
        return modelAndView;
    }

    private final static String[] removeTargetSynchronizeParam = new String[]{"targetId"};

    /**
     * 대상서버를 제거한다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="remove")
    public ModelAndView removeTargetSynchronize(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, removeTargetSynchronizeParam)){
            throw new JabberException("");
        }

        ModelAndView modelAndView = targetSynchronizeSvc.removeTargetSynchronize(parameters);
        return modelAndView;
    }
}
