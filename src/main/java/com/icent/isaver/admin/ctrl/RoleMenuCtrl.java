package com.icent.isaver.admin.ctrl;

import com.icent.isaver.admin.common.resource.IsaverException;
import com.icent.isaver.admin.svc.RoleMenuSvc;
import com.icent.isaver.admin.util.AdminHelper;
import com.meous.common.util.MapUtils;
import com.meous.common.util.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import java.util.Map;

/**
 * 메뉴 권한 관리 Controller
 *
 * @author : psb
 * @version : 1.0
 * @since : 2016. 06. 08.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2016. 06. 08.     psb           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value="/roleMenu/*")
public class RoleMenuCtrl {

    @Inject
    private RoleMenuSvc roleMenuSvc;

    /**
     * 권한 목록을 가져온다.
     * @author psb
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/list")
    public ModelAndView findAllRoleMenu(@RequestParam Map<String, String> parameters) {
        ModelAndView modelAndView = roleMenuSvc.findAllRoleMenu(parameters);
        if(StringUtils.nullCheck(parameters.get("mode"))){
            modelAndView.setViewName("roleMenuList");
        }
        return modelAndView;
    }

    private final static String[] saveRoleParam = new String[]{"roleId"};

    /**
     * 메뉴 권한을 저장한다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/save")
    public ModelAndView saveRoleMenu(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        if(MapUtils.nullCheckMap(parameters, saveRoleParam)){
            throw new IsaverException("");
        }

        parameters.put("insertUserId",AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = roleMenuSvc.saveRoleMenu(parameters);
        return modelAndView;
    }
}
