package com.icent.jabber.admin.ctrl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.svc.FnqSvc;
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
 * 도움말 Controller
 * @author : psb
 * @version : 1.0
 * @since : 2014. 10. 13.
 * <pre>
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 10. 13.     psb           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value="/fnq/*")
public class FnqCtrl {

    @Value("#{configProperties['cnf.defaultPageSize']}")
    private String defaultPageSize;

    @Inject
    private FnqSvc fnqSvc;

    /**
     * 도움말 목록을 가져온다.
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="list")
    public ModelAndView findAllFnq(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        parameters = AdminHelper.checkReloadList(request, response, "fnqList", parameters);
        AdminHelper.setPageParam(parameters, defaultPageSize);

        ModelAndView modelAndView = fnqSvc.findAllFnq(parameters);
        modelAndView.setViewName("fnqList");
        return modelAndView;
    }

    /**
     * 상세 도움말을 가져온다.
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="detail")
    public ModelAndView findByFnq(HttpServletRequest request, @RequestParam Map<String, String> parameters){

        ModelAndView modelAndView = fnqSvc.findByFnq(parameters);
        modelAndView.setViewName("fnqDetail");
        return modelAndView;
    }


    private final static String[] addFnqParam = new String[]{"title", "comment"};

    /**
     * 도움말을 등록한다.
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="add")
    public ModelAndView addFnq(HttpServletRequest request, @RequestParam Map<String, String> parameters) {

        if(MapUtils.nullCheckMap(parameters, addFnqParam)){
            throw new JabberException("");
        }

        parameters.put("insertUserId",AdminHelper.getAdminIdFromSession(request));

        ModelAndView modelAndView = fnqSvc.addFnq(request, parameters);
        modelAndView.setViewName("fnqDetail");
        return modelAndView;
    }

    private final static String[] updateFnqParam = new String[]{"fnqId", "title", "comment"};

    /**
     * 도움말을 저장한다.
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="save")
    public ModelAndView updateFnq(HttpServletRequest request, @RequestParam Map<String, String> parameters) {

        if(MapUtils.nullCheckMap(parameters, updateFnqParam)){
            throw new JabberException("");
        }

        parameters.put("updateUserId",AdminHelper.getAdminIdFromSession(request));

        ModelAndView modelAndView = fnqSvc.saveFnq(request, parameters);
        modelAndView.setViewName("fnqDetail");
        return modelAndView;
    }

    private final static String[] removeFnqParam = new String[]{"fnqId"};

    /**
     * 도움말을 제거한다.
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="remove")
    public ModelAndView removeFnq(HttpServletRequest request, @RequestParam Map<String, String> parameters) {

        if(MapUtils.nullCheckMap(parameters, removeFnqParam)){
            throw new JabberException("");
        }

        parameters.put("updateUserId",AdminHelper.getAdminIdFromSession(request));

        ModelAndView modelAndView = fnqSvc.removeFnq(parameters);
        return modelAndView;
    }

    private final static String[] downloadFnqParam = new String[]{"fnqId"};

    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="download")
    public ModelAndView downloadFnq(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, downloadFnqParam)){
            throw new JabberException("");
        }

        ModelAndView modelAndView = fnqSvc.downloadFnq(parameters, request, response);
        return modelAndView;
    }
}
