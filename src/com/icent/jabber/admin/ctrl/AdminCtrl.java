package com.icent.jabber.admin.ctrl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.svc.AdminSvc;
import com.icent.jabber.admin.util.AdminHelper;
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
 * 관리자 관리 Controller
 *
 * @author : kst
 * @version : 1.0
 * @since : 2014. 5. 29.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 5. 29.     kst           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value="/admin/*")
public class AdminCtrl {

    @Value("#{configProperties['cnf.defaultPageSize']}")
    private String defaultPageSize;

    @Inject
    private AdminSvc adminSvc;

    /**
     * 관리자 목록을 가져온다.
     *
     * @author kst
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="list")
    public ModelAndView findListAdmin(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        parameters = AdminHelper.checkReloadList(request, response, "adminList", parameters);
        parameters = AdminHelper.setPageParam(parameters,defaultPageSize);

        ModelAndView modelAndView = adminSvc.findListAdmin(parameters);
        modelAndView.setViewName("adminList");

        //
        return modelAndView;
    }

    /**
     * 관리자 정보를 가져온다.
     *
     * @author kst
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="detail")
    public ModelAndView findByAdmin(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = adminSvc.findByAdmin(parameters);
        modelAndView.setViewName("adminDetail");

        //
        return modelAndView;
    }

    private final static String[] addAdminParam = new String[]{"adminId","password","name"};

    /**
     * 관리자를 등록한다.
     *
     * @author kst
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="add")
    public ModelAndView addAdmin(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        if(MapUtils.nullCheckMap(parameters,addAdminParam)){
            throw new JabberException("");
        }

        parameters.put("insertUserId",AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = adminSvc.addAdmin(parameters);
        modelAndView.setViewName("adminDetail");

        return modelAndView;
    }

    private final static String[] saveAdminParam = new String[]{"adminId"};

    /**
     * 관리자를 수정한다.
     *
     * @author kst
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="save")
    public ModelAndView saveAdmin(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        if(MapUtils.nullCheckMap(parameters,saveAdminParam)){
            throw new JabberException("");
        }

        parameters.put("updateUserId",AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = adminSvc.saveAdmin(parameters);
        modelAndView.setViewName("adminDetail");

        return modelAndView;
    }

    private final static String[] removeAdminParam = new String[]{"adminId"};

    /**
     * 관리자를 제거한다.
     *
     * @author kst
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="remove")
    public ModelAndView removeAdmin(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        if(MapUtils.nullCheckMap(parameters,removeAdminParam)){
            throw new JabberException("");
        }

        parameters.put("updateUserId",AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = adminSvc.removeAdmin(parameters);
        modelAndView.setViewName("adminDetail");

        return modelAndView;
    }
}
