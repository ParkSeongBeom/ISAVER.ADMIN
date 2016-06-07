package com.icent.jabber.admin.ctrl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.svc.ClientProductSvc;
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
 * @author : kst
 * @version : 1.0
 * @since : 2014. 8. 20.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 8. 20.     kst           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value="/product/*")
public class ClientProductCtrl {

    @Value("#{configProperties['cnf.defaultPageSize']}")
    private String defaultPageSize;

    @Inject
    private ClientProductSvc clientProductSvc;

    /**
     * 제품정보 목록을 가져온다.
     *
     * @author kst
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET}, value="/list")
    public ModelAndView findListClientProduct(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        parameters = AdminHelper.checkReloadList(request, response, "clientProductList", parameters);
        parameters = AdminHelper.setPageParam(parameters, defaultPageSize);

        ModelAndView modelAndView = clientProductSvc.findListClientProduct(parameters);
        modelAndView.setViewName("clientProductList");
        return modelAndView;
    }

    /**
     * 제품정보를 가져온다.
     *
     * @author kst
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/detail")
    public ModelAndView findByClientProduct(@RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = clientProductSvc.findByClientProduct(parameters);
        modelAndView.setViewName("clientProductDetail");
        return modelAndView;
    }


    /**
     * addClientProduct mendatory parameters
     */
    private final static String[] addClientProductParam = {"title","version"};

    /**
     * 제품정보를 수정한다.
     *
     * @author kst
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST},value = "/add")
    public ModelAndView addClientProduct(HttpServletRequest request, @RequestParam Map<String, String> parameters){

        if(MapUtils.nullCheckMap(parameters, addClientProductParam)){
            throw new JabberException("");
        }

        parameters.put("insertUserId",AdminHelper.getAdminIdFromSession(request));

        ModelAndView modelAndView = clientProductSvc.addClientProduct(request, parameters);
        return modelAndView;
    }

    private final static String[] saveClientProductParam = {"title","version"};

    /**
     * 제품정보를 수정한다.
     *
     * @author kst
     * @param request
     * @param parameters
     */
    @RequestMapping(method={RequestMethod.POST},value="/save")
    public ModelAndView saveClientProduct(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        if(MapUtils.nullCheckMap(parameters, saveClientProductParam)){
            throw new JabberException("");
        }

        parameters.put("updateUserId",AdminHelper.getAdminIdFromSession(request));

        ModelAndView modelAndView = clientProductSvc.saveClientProduct(request, parameters);
        return modelAndView;
    }

    private final static String[] removeClientProductParam = {"clientProductId"};

    /**
     * 제품정보를 제거한다.
     *
     * @author kst
     * @param parameters
     */
    @RequestMapping(method={RequestMethod.POST},value="/remove")
    public ModelAndView removeClientProduct(@RequestParam Map<String, String> parameters){
        if(MapUtils.nullCheckMap(parameters, removeClientProductParam)){
            throw new JabberException("");
        }

        ModelAndView modelAndView = clientProductSvc.removeClientProduct(parameters);
        return modelAndView;
    }
}
