package main.java.com.icent.isaver.admin.ctrl;

import com.icent.isaver.admin.common.resource.IsaverException;
import com.icent.isaver.admin.svc.RoleSvc;
import com.icent.isaver.admin.util.AdminHelper;
import com.kst.common.util.MapUtils;
import org.springframework.beans.factory.annotation.Value;
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
 * 권한 관리 Controller
 *
 * @author : dhj
 * @version : 1.0
 * @since : 2014. 5. 24.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 5. 24.     dhj           최초 생성
 *  2014. 6. 02.     kst           목록 페이징 처리 추가
 *  2015. 6. 25.     psb           관리자 리뉴얼
 * </pre>
 */
@Controller
@RequestMapping(value="/role/*")
public class RoleCtrl {

    @Inject
    private RoleSvc roleSvc;

    @Value("${cnf.defaultPageSize}")
    private String defaultPageSize;

    /**
     * 권한 목록을 가져온다.
     * @param parameters
     * @see dhj
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/list")
    public ModelAndView findAllRole(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters) {
        parameters = AdminHelper.checkReloadList(request, response, "roleList", parameters);
        AdminHelper.setPageParam(parameters,defaultPageSize);

        ModelAndView modelAndView = roleSvc.findListRole(parameters);
        modelAndView.setViewName("roleList");
        return modelAndView;
    }

    /**
     * 권한 상세 목록을 가져온다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/detail")
    public ModelAndView findByRole(@RequestParam Map<String, String> parameters) {
        ModelAndView modelAndView = roleSvc.findByRole(parameters);
        modelAndView.setViewName("roleDetail");
        return modelAndView;
    }

    private final static String[] addRoleParam = new String[]{"roleName"};

    /**
     * 권한을 등록한다.
     *
     * @author dhj
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/add")
    public ModelAndView addRole(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        if(MapUtils.nullCheckMap(parameters, addRoleParam)){
            throw new IsaverException("");
        }

        parameters.put("insertUserId",AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = roleSvc.addRole(parameters);

        return modelAndView;
    }

    private final static String[] saveRoleParam = new String[]{"roleId","roleName"};

    /**
     * 권한을 수정한다.
     *
     * @author dhj
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/save")
    public ModelAndView saveRole(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        if(MapUtils.nullCheckMap(parameters, saveRoleParam)){
            throw new IsaverException("");
        }

        parameters.put("updateUserId",AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = roleSvc.saveRole(parameters);

        return modelAndView;
    }

    private final static String[] removeRoleParam = new String[]{"roleId"};

    /**
     * 권한을 삭제한다.
     *
     * @author dhj
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/remove")
    public ModelAndView removeRole(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        if(MapUtils.nullCheckMap(parameters, removeRoleParam)){
            throw new IsaverException("");
        }

        ModelAndView modelAndView = roleSvc.removeRole(parameters);

        return modelAndView;
    }
}
