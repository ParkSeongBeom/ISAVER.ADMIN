package main.java.com.icent.isaver.admin.ctrl;

import com.icent.isaver.admin.common.resource.IsaverException;
import com.icent.isaver.admin.svc.CriticalSvc;
import com.kst.common.util.MapUtils;
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
 * 임계치 Controller
 *
 * @author : psb
 * @version : 1.0
 * @since : 2018. 9. 21.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2018. 9. 21.     psb           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value="/critical/*")
public class CriticalCtrl {

    @Inject
    private CriticalSvc criticalSvc;

    /**
     * 임계치 목록을 가져온다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/list")
    public ModelAndView findListCritical(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = criticalSvc.findListCritical(parameters);
        modelAndView.setViewName("criticalList");
        return modelAndView;
    }

    private final static String[] findByCriticalParam = new String[]{"criticalId"};

    /**
     * 임계치 상세를 가져온다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/detail")
    public ModelAndView findByCritical(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        if(MapUtils.nullCheckMap(parameters, findByCriticalParam)){
            throw new IsaverException("");
        }

        ModelAndView modelAndView = criticalSvc.findByCritical(parameters);
        return modelAndView;
    }

    private final static String[] addCriticalParam = new String[]{"criticalLevel"};

    /**
     * 임계치를 등록 한다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/add")
    public ModelAndView addCritical(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, addCriticalParam)){
            throw new IsaverException("");
        }
        ModelAndView modelAndView = criticalSvc.addCritical(parameters);
        return modelAndView;
    }

    private final static String[] saveCriticalParam = new String[]{"criticalId","criticalLevel"};

    /**
     * 임계치를 수정 한다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/save")
    public ModelAndView saveCritical(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, saveCriticalParam)){
            throw new IsaverException("");
        }
        ModelAndView modelAndView = criticalSvc.saveCritical(parameters);
        return modelAndView;
    }

    private final static String[] removeCriticalParam = new String[]{"criticalId"};

    /**
     * 임계치를 제거 한다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/remove")
    public ModelAndView removeCritical(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, removeCriticalParam)){
            throw new IsaverException("");
        }

        ModelAndView modelAndView = criticalSvc.removeCritical(parameters);
        return modelAndView;
    }
}
