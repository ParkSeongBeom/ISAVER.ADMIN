package com.icent.isaver.admin.ctrl;

import com.icent.isaver.admin.bean.UsersBean;
import com.icent.isaver.admin.common.resource.IsaverException;
import com.icent.isaver.admin.svc.UsersSvc;
import com.icent.isaver.admin.util.AdminHelper;
import com.meous.common.util.MapUtils;
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
 * 사용자 관리
 *
 * @author : kst
 * @version : 1.0
 * @since : 2014. 6. 3.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 6. 3.     kst           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value="/user/*")
public class UsersCtrl {

    @Value("${cnf.defaultPageSize}")
    private String defaultPageSize;

    @Inject
    private UsersSvc usersSvc;

    /**
     * 사용자 목록을 가져온다.
     *
     * @author kst
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET}, value="/list")
    public ModelAndView findListUser(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        parameters = AdminHelper.checkReloadList(request, response, "userList", parameters);
        AdminHelper.setPageParam(parameters, defaultPageSize);

        UsersBean usersBean = AdminHelper.getAdminInfo(request);
        if(usersBean != null) {
            parameters.put("roleId", usersBean.getRoleId());
        }

        ModelAndView modelAndView = usersSvc.findListUser(parameters);
        modelAndView.setViewName("userList");
        return modelAndView;
    }


    /**
     * 사용자 정보를 가져온다.
     *
     * @author kst
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/detail")
    public ModelAndView findByUser(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        parameters.put("roleId", AdminHelper.getAdminInfo(request).getRoleId());
        ModelAndView modelAndView = usersSvc.findByUser(parameters);
        modelAndView.setViewName("userDetail");

        return modelAndView;
    }


    /**
     * 사용자 프로필 정보를 가져온다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/profile")
    public ModelAndView findByUserProfile(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        ModelAndView modelAndView = usersSvc.findByUserProfile(parameters);
        return modelAndView;
    }

    private final static String[] findByUserCheckExistParam = new String[]{"userId"};

    /**
     * 사용자ID 존재여부를 확인한다.
     *
     * @author kst
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value = "/exist")
    public ModelAndView findByUserCheckExist(@RequestParam Map<String, String> parameters){
        if(MapUtils.nullCheckMap(parameters, findByUserCheckExistParam)){
            throw new IsaverException("");
        }

        ModelAndView modelAndView = usersSvc.findByUserCheckExist(parameters);
        return modelAndView;
    }


    private final static String[] addUserParam = new String[]{"userId", "userPassword", "userName"};

    /**
     * 사용자 정보를 등록한다.
     *
     * @author kst
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/add")
    public ModelAndView addUser(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, addUserParam)){
            throw new IsaverException("");
        }

        parameters.put("insertUserId",AdminHelper.getAdminIdFromSession(request));

        ModelAndView modelAndView = usersSvc.addUser(parameters);
        return modelAndView;
    }

    private final static String[] saveUserParam = new String[]{"userId", "userName"};

    /**
     * 사용자 정보를 수정한다.
     *
     * @author kst
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/save")
    public ModelAndView saveUser(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, saveUserParam)){
            throw new IsaverException("");
        }

        parameters.put("updateUserId",AdminHelper.getAdminIdFromSession(request));

        ModelAndView modelAndView = usersSvc.saveUser(parameters);
        return modelAndView;
    }

    private final static String[] removeUserParam = new String[]{"userId"};

    /**
     * 사용자를 제거한다.
     *
     * @author kst
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/remove")
    public ModelAndView removeUser(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, removeUserParam)){
            throw new IsaverException("");
        }

        parameters.put("updateUserId",AdminHelper.getAdminIdFromSession(request));

        ModelAndView modelAndView = usersSvc.removeUser(parameters);
        return modelAndView;
    }
}
