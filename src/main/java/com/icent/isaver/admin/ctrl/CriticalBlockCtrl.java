package com.icent.isaver.admin.ctrl;

import com.icent.isaver.admin.common.resource.IsaverException;
import com.icent.isaver.admin.svc.CriticalBlockSvc;
import com.icent.isaver.admin.svc.CriticalSvc;
import com.meous.common.util.MapUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;

/**
 * 임계치 차단 Controller
 *
 * @author : psb
 * @version : 1.0
 * @since : 2020. 06. 04.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2020. 06. 04.     psb           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value="/criticalBlock/*")
public class CriticalBlockCtrl {

    @Inject
    private CriticalBlockSvc criticalBlockSvc;

    /**
     * 임계치를 차단 한다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/add")
    public ModelAndView addCriticalBlock(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        return criticalBlockSvc.addCriticalBlock(parameters);
    }

    /**
     * 임계치 차단을 해제한다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/remove")
    public ModelAndView removeCriticalBlock(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        return criticalBlockSvc.removeCriticalBlock(parameters);
    }
}
