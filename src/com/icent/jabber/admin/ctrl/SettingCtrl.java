package com.icent.jabber.admin.ctrl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.svc.FunctionSvc;
import com.kst.common.util.MapUtils;
import com.kst.common.util.StringUtils;
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
@RequestMapping(value="/setting/*")
public class SettingCtrl {
    /**
     * 환경설정 목록을 가져온다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="list")
    public ModelAndView findAllFunction(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = new ModelAndView();

        modelAndView.addObject("tabId",parameters.get("tabId"));
        modelAndView.setViewName("settingList");
        return modelAndView;
    }
}
