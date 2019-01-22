package main.java.com.icent.isaver.admin.ctrl;

import com.icent.isaver.admin.common.resource.IsaverException;
import com.icent.isaver.admin.svc.TargetSvc;
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
 * 고객사 관리
 *
 * @author : psb
 * @version : 1.0
 * @since : 2018. 5. 29.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2018. 5. 29.     psb           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value="/target/*")
public class TargetCtrl {

    @Inject
    private TargetSvc targetSvc;

    /**
     * 고객사 정보를 가져온다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/detail")
    public ModelAndView findByTarget(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        ModelAndView modelAndView = targetSvc.findByTarget(parameters);
        modelAndView.setViewName("targetDetail");
        return modelAndView;
    }

    private final static String[] saveTargetParam = new String[]{"targetId", "targetName"};

    /**
     * 고객사 정보를 수정한다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/save")
    public ModelAndView saveTarget(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, saveTargetParam)){
            throw new IsaverException("");
        }

        ModelAndView modelAndView = targetSvc.saveTarget(parameters);
        return modelAndView;
    }
}
