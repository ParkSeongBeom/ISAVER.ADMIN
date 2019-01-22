package main.java.com.icent.isaver.admin.ctrl;


import com.icent.isaver.admin.common.resource.IsaverException;
import com.icent.isaver.admin.svc.MenuSvc;
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
 * 메뉴 관리 Controller
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
 *  2014. 6. 09.     kst           탑메뉴 인자 변경
 * </pre>
 */
@Controller("menuCtrl")
@RequestMapping(value="/menu/*")
public class MenuCtrl {

    @Inject
    private MenuSvc menuSvc;

    private final static String[] findAllMenuTreeParam = new String[]{"menuId"};
    /**
     * 트리 형식의 메뉴를 가져온다.
     * @param parameters
     * @see dhj
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/list")
    public ModelAndView findAllMenu(@RequestParam Map<String, String> parameters) {

        ModelAndView modelAndView = menuSvc.findAllMenuTree(parameters);
        modelAndView.setViewName("menuList");
        return modelAndView;
    }

    /**
     * 트리 형식의 메뉴를 가져온다.
     * @param parameters
     * @see dhj
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/treeList")
    public ModelAndView findAllMenuTree(HttpServletRequest request, @RequestParam Map<String, String> parameters) {

        ModelAndView modelAndView = menuSvc.findAllMenuTree(parameters);
        return modelAndView;
    }

    /**
     * 메뉴바 형식의 메뉴를 가져온다.
     * @param parameters
     * @see dhj
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/menuBarList")
    public ModelAndView menuBarList(HttpServletRequest request, @RequestParam Map<String, String> parameters) {

        parameters.put("id",AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = menuSvc.findAllMenuTopBar(parameters);
        return modelAndView;
    }

    private final static String[] findByMenuParam = new String[]{"menuId"};

    /**
     * 단건에 대한 메뉴 정보를 반환한다.
     * @param parameters
     * @see dhj
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/detail")
    public ModelAndView findByMenu(HttpServletRequest request, @RequestParam Map<String, String> parameters) {

        if(MapUtils.nullCheckMap(parameters, findByMenuParam)){
            throw new IsaverException("");
        }

        ModelAndView modelAndView = menuSvc.findByMenu(parameters);

        return modelAndView;
    }

    private final static String[] addMenuParam = new String[]{"menuName", "sortOrder", "parentMenuId"};

    /**
     * 단일 메뉴를 생성한다.
     * @param parameters
     * @see dhj
     * @return
     */

    @RequestMapping(method={RequestMethod.POST},value="/add")
    public ModelAndView addMenu(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, addMenuParam)){
            throw new IsaverException("");
        }

        parameters.put("insertUserId",AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = menuSvc.addMenu(parameters);
        return modelAndView;
    }

    private final static String[] saveMenuParam = new String[]{"menuId", "menuName", "sortOrder", "menuPath", "menuFlag"};

    /**
     * 메뉴를 수정한다.
     * @param parameters
     * @see dhj
     * @return
     */
    @RequestMapping(method={RequestMethod.POST},value="/save")
    public ModelAndView saveMenu(HttpServletRequest request, @RequestParam Map<String, String> parameters) {

        if(MapUtils.nullCheckMap(parameters,saveMenuParam)){
            throw new IsaverException("");
        }

        parameters.put("updateUserId",AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = menuSvc.saveMenu(parameters);
        return modelAndView;
    }

    private final static String[] removeMenuParam = new String[]{"menuId"};

    /**
     * 메뉴를 제거한다.
     * @param parameters
     * @see dhj
     * @return
     */
    @RequestMapping(method={RequestMethod.POST},value="/remove")
    public ModelAndView removeMenu(HttpServletRequest request, @RequestParam Map<String, String> parameters) {

        if(MapUtils.nullCheckMap(parameters,removeMenuParam)){
            throw new IsaverException("");
        }

        ModelAndView modelAndView = menuSvc.removeMenu(parameters);
        return modelAndView;
    }
}
