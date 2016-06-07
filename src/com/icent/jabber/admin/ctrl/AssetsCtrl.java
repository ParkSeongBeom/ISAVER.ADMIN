package com.icent.jabber.admin.ctrl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.svc.AssetsSvc;
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
 * 자원 관리 Controller
 *
 * @author : psb
 * @version : 1.0
 * @since  : 2014. 10. 07.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 10. 07.     psb           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value="/assets/*")
public class AssetsCtrl {

    @Value("#{configProperties['cnf.defaultPageSize']}")
    private String defaultPageSize;

    @Inject
    private AssetsSvc assetsSvc;

    /**
     * 자원 목록을 가져온다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="list")
    public ModelAndView findListAssets(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        parameters = AdminHelper.checkReloadList(request, response, "assetsList", parameters);
        AdminHelper.setPageParam(parameters,defaultPageSize);

        ModelAndView modelAndView = assetsSvc.findListAssets(parameters);
        modelAndView.setViewName("assetsList");

        return modelAndView;
    }

    /**
     * 자원 정보를 가져온다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="detail")
    public ModelAndView findByAssets(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = assetsSvc.findByAssets(parameters);
        modelAndView.setViewName("assetsDetail");

        return modelAndView;
    }

    /**
     * 자원 관리자를 가져오기위한 POPUP.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="popup")
    public ModelAndView findListUserAssets(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        AdminHelper.setPageParam(parameters, defaultPageSize);

        ModelAndView modelAndView = assetsSvc.findListUserAssets(parameters);
        modelAndView.setViewName("assetsDetailUserPopup");

        return modelAndView;
    }

    private final static String[] addAssetsParam = new String[]{"assetsName", "codeId", "useYn"};

    /**
     * 자원을 등록한다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="add")
    public ModelAndView addAssets(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        if(MapUtils.nullCheckMap(parameters,addAssetsParam)){
            throw new JabberException("");
        }

        parameters.put("insertUserId",AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = assetsSvc.addAssets(parameters);
        modelAndView.setViewName("assetsDetail");

        return modelAndView;
    }

    private final static String[] saveAssetsParam = new String[]{"assetsId", "assetsName", "codeId", "useYn"};

    /**
     * 자원을 수정한다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="save")
    public ModelAndView saveAssets(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        if(MapUtils.nullCheckMap(parameters,saveAssetsParam)){
            throw new JabberException("");
        }

        parameters.put("updateUserId",AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = assetsSvc.saveAssets(parameters);
        modelAndView.setViewName("assetsDetail");

        return modelAndView;
    }

    private final static String[] removeAssetsParam = new String[]{"assetsId"};

    /**
     * 자원을 제거한다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="remove")
    public ModelAndView removeAssets(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        if(MapUtils.nullCheckMap(parameters,removeAssetsParam)){
            throw new JabberException("");
        }

        ModelAndView modelAndView = assetsSvc.removeAssets(parameters);
        modelAndView.setViewName("assetsDetail");

        return modelAndView;
    }
}
