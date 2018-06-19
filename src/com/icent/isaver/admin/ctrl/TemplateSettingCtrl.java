package com.icent.isaver.admin.ctrl;

import com.icent.isaver.admin.common.resource.IcentException;
import com.icent.isaver.admin.svc.TargetSvc;
import com.icent.isaver.admin.svc.TemplateSettingSvc;
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
 * Dashboard Template 환경설정 관리
 *
 * @author : psb
 * @version : 1.0
 * @since : 2018. 6. 12.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2018. 6. 12.     psb           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value="/templateSetting/*")
public class TemplateSettingCtrl {

    @Inject
    private TemplateSettingSvc templateSettingSvc;

    /**
     * Dashboard Template 환경설정 목록을 가져온다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/list")
    public ModelAndView findListTemplateSetting(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("templateSetting",templateSettingSvc.findListTemplateSetting());
        return modelAndView;
    }

    private final static String[] saveTemplateSettingParam = new String[]{"paramData"};

    /**
     * Dashboard Template 환경설정을 수정한다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/save")
    public ModelAndView saveTemplateSetting(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, saveTemplateSettingParam)){
            throw new IcentException("");
        }

        ModelAndView modelAndView = templateSettingSvc.saveTemplateSetting(parameters);
        return modelAndView;
    }
}
