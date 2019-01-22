package main.java.com.icent.isaver.admin.ctrl;

import com.icent.isaver.admin.common.resource.IsaverException;
import com.icent.isaver.admin.svc.GroupCodeSvc;
import com.icent.isaver.admin.util.AdminHelper;
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
 * @author : kst
 * @version : 1.0
 * @since : 2014. 5. 30.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 5. 30.     kst           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value="/groupcode/*")
public class GroupCodeCtrl {

    @Inject
    private GroupCodeSvc groupCodeSvc;

    /**
     * 그룹코드 목록을 가져온다.
     *
     * @author kst
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/list")
    public ModelAndView findListGroupCode(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = groupCodeSvc.findListGroupCode(parameters);
        modelAndView.setViewName("groupCodeList");
        return modelAndView;
    }

    @RequestMapping(method={RequestMethod.POST},value="/detail")
    public ModelAndView findByGroupCode(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = groupCodeSvc.findByGroupCode(parameters);
        modelAndView.setViewName("groupCodeDetail");
        return modelAndView;
    }

    private final static String[] addGroupCodeParam = new String[]{"groupCodeId","groupName"};

    @RequestMapping(method={RequestMethod.POST}, value="/add")
    public ModelAndView addGroupCode(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        if(MapUtils.nullCheckMap(parameters, addGroupCodeParam)){
            throw new IsaverException("");
        }

        parameters.put("insertUserId",AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = groupCodeSvc.addGroupCode(parameters);
        modelAndView.setViewName("groupCodeDetail");


        return modelAndView;
    }

    private final static String[] saveGroupCodeParam = new String[]{"groupCodeId","groupName"};

    @RequestMapping(method={RequestMethod.POST}, value="/save")
    public ModelAndView saveGroupCode(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        if(MapUtils.nullCheckMap(parameters, saveGroupCodeParam)){
            throw new IsaverException("");
        }

        parameters.put("updateUserId",AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = groupCodeSvc.saveGroupCode(parameters);
        return modelAndView;
    }

    private final static String[] removeGroupCodeParam = new String[]{"groupCodeId","groupName"};

    @RequestMapping(method={RequestMethod.POST}, value="/remove")
    public ModelAndView removeGroupCode(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        if(MapUtils.nullCheckMap(parameters, removeGroupCodeParam)){
            throw new IsaverException("");
        }

        parameters.put("updateUserId",AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = groupCodeSvc.removeGroupCode(parameters);
        return modelAndView;
    }


}
