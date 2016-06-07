package com.icent.jabber.admin.ctrl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.svc.OrganizationSvc;
import com.icent.jabber.admin.svc.UserSvc;
import com.icent.jabber.admin.util.AdminHelper;
import com.icent.jabber.repository.bean.OrganizationBean;
import com.kst.common.util.MapUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

/**
 * 조직도 Controller
 *
 * @author : dhj
 * @version : 1.0
 * @since : 2014. 5. 20.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 5. 20.     dhj           최초 생성
 * </pre>
 */
@Controller("organizationCtrl")
@RequestMapping(value="/organization/*")
public class OrganizationCtrl {

    @Value("#{configProperties['cnf.defaultPageSize']}")
    private String defaultPageSize;

    @Inject
    private OrganizationSvc organizationSvc;
    @Inject
    private UserSvc userSvc;

    /**
     * 트리 형식의 조직도를 가져온다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/list")
    public ModelAndView findAllOrganization(@RequestParam Map<String, String> parameters) {
        ModelAndView modelAndView = organizationSvc.findAllOrganizationTree(parameters);
        modelAndView.setViewName("organizationList");
        return modelAndView;
    }

    /**
     * 트리 형식의 메뉴를 가져온다.
     * @param parameters
     * @see dhj
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/treeList")
    public ModelAndView findAllOrganizationTree(HttpServletRequest request, @RequestParam Map<String, String> parameters) {

        ModelAndView modelAndView = organizationSvc.findAllOrganizationTree(parameters);
        return modelAndView;
    }

    private final static String[] findByOrganizationParam = new String[]{"idSeq"};

    /**
     * 단건에 대한 조직 정보를 반환한다.
     * @param parameters
     * @see dhj
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/detail")
    public ModelAndView findByOrganization(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
//        if(MapUtils.nullCheckMap(parameters, findByOrganizationParam)){
//            throw new JabberException("");
//        }
        ModelAndView modelAndView = organizationSvc.findByOrganization(parameters);

        return modelAndView;
    }

    private final static String[] findAllUserParam = new String[]{"orgId", "id"};

    /**
     * [팝업] 유저 목록을 가져온다.
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/detailUserPopup")
    public ModelAndView findAllUser(HttpServletRequest request, @RequestParam Map<String, String> parameters) {

//        if(MapUtils.nullCheckMap(parameters, findAllUserParam)){
//            throw new JabberException("");
//        }

        AdminHelper.setPageParam(parameters, defaultPageSize);
        ModelAndView modelAndView = userSvc.findListOrgUser(parameters);
        List<OrganizationBean> organizations= organizationSvc.orgTreeDataStructure(null);
        modelAndView.addObject("organizationList", organizations);
        modelAndView.setViewName("organizationDetailUserPopup");
        return modelAndView;
    }

    private final static String[] addOrganizationParam = new String[]{"upOrgId"};
    /**
     * 조직도를 등록한다.
     * @return
     */
    @RequestMapping(method={RequestMethod.POST},value="/add")
    public ModelAndView addOrganization(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters,addOrganizationParam)){
            throw new JabberException("");
        }
        parameters.put("insertUserId",AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = organizationSvc.addOrganization(parameters);
        return modelAndView;
    }

    private final static String[] saveOrganizationParam = new String[]{"orgId", "orgName", "sortOrder"};
    /**
     * 조직도를 저장한다.
     * @return
     */
    @RequestMapping(method={RequestMethod.POST},value="/save")
    public ModelAndView saveOrganization(HttpServletRequest request, @RequestParam Map<String, String> parameters) {

        if(MapUtils.nullCheckMap(parameters,saveOrganizationParam)){
            throw new JabberException("");
        }
        parameters.put("updateUserId",AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = organizationSvc.saveOrganization(parameters);
        return modelAndView;
    }

    private final static String[] removeOrganizationParam = new String[]{"orgId"};
    /**
     * 단건에 대한 조직을 삭제한다.
     * @return
     */
    @RequestMapping(method={RequestMethod.POST},value="/remove")
    public ModelAndView removeOrganization(HttpServletRequest request, @RequestParam Map<String, String> parameters) {

        if(MapUtils.nullCheckMap(parameters,removeOrganizationParam)){
            throw new JabberException("");
        }
        ModelAndView modelAndView = organizationSvc.removeOrganization(parameters);
        return modelAndView;
    }

    /**
     * 조직도 팝업.
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/organizationPopup")
    public ModelAndView findAllOrganization(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("paramBean",parameters);
        modelAndView.setViewName("organizationPopup");
        return modelAndView;
    }

    /**
     * 조직도 트리를 가져온다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/orgTree")
    public ModelAndView findListOrganizationTree(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        ModelAndView modelAndView = organizationSvc.findListOrganizationTree(parameters);
        return modelAndView;
    }
}
