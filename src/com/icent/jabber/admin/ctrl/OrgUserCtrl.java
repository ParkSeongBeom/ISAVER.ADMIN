package com.icent.jabber.admin.ctrl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.svc.OrgUserSvc;
import com.kst.common.util.MapUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import java.util.Map;

/**
 * 사용자 조직도 Controller
 *
 * @author : dhj
 * @version : 1.0
 * @since : 2014. 6. 17.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 6. 17.     dhj           최초 생성
 * </pre>
 */
@Controller("orgUserCtrl")
@RequestMapping(value="/orgUser/*")
public class OrgUserCtrl {

    @Inject
    private OrgUserSvc orgUserSvc;


    private final static String[] addOrgUserParam = new String[]{"roleIds"};

    /**
     * 조직도 트리를 가져온다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/userList")
    public ModelAndView findListOrgUser(@RequestParam Map<String, String> parameters) {
        ModelAndView modelAndView = orgUserSvc.findListOrgUser(parameters);
        return modelAndView;
    }

    /**
     * [단건] 사용자 조직도를 등록한다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/add")
    public ModelAndView addOrgUser(@RequestParam Map<String, String> parameters) {

        if(MapUtils.nullCheckMap(parameters, addOrgUserParam)){
            throw new JabberException("");
        }

        ModelAndView modelAndView = orgUserSvc.addOrgUser(parameters);
        return modelAndView;
    }

    private final static String[] removeOrgUserParam = new String[]{"roleIds"};
    /**
     * [단건] 사용자 조직도를 제거한다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/remove")
    public ModelAndView removeOrgUser(@RequestParam Map<String, String> parameters) {

        if(MapUtils.nullCheckMap(parameters, removeOrgUserParam)){
            throw new JabberException("");
        }

        ModelAndView modelAndView = orgUserSvc.removeOrgUser(parameters);
        return modelAndView;
    }

    /**
     * [복수] 사용자 조직도를 제거한다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/removes")
    public ModelAndView removeOrgUsers(@RequestParam Map<String, String> parameters) {

        if(MapUtils.nullCheckMap(parameters, removeOrgUserParam)){
            throw new JabberException("");
        }

        ModelAndView modelAndView = orgUserSvc.removeOrgUsers(parameters);
        return modelAndView;
    }

}
