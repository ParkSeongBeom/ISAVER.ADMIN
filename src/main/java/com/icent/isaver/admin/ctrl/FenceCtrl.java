package com.icent.isaver.admin.ctrl;

import com.icent.isaver.admin.svc.FenceSvc;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import java.util.Map;

/**
 * 펜스 Controller
 * @author : psb
 * @version : 1.0
 * @since : 2018. 7. 9.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2018. 7. 9.     psb           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value="/fence/*")
public class FenceCtrl {
    @Inject
    private FenceSvc fenceSvc;

    /**
     * 펜스 목록을 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/list")
    public ModelAndView findListFence(@RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = fenceSvc.findListFence(parameters);
        return modelAndView;
    }

    /**
     * 펜스 목록을 가져온다. (이벤트 통계용)
     *
     * @author psb
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/statistics")
    public ModelAndView findListFenceForStatistics(@RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = fenceSvc.findListFenceForStatistics(parameters);
        return modelAndView;
    }
}
