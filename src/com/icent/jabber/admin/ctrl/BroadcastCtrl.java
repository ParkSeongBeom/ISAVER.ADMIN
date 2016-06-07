package com.icent.jabber.admin.ctrl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.svc.BroadcastSvc;
import com.icent.jabber.admin.svc.UserSvc;
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
 * 동보방송 관리 Controller
 *
 * @author : psb
 * @version : 1.0
 * @since : 2014. 6. 2.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 6. 2.     psb           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value="/broadcast/*")
public class BroadcastCtrl {

    @Value("#{configProperties['cnf.defaultPageSize']}")
    private String defaultPageSize;

    @Inject
    private BroadcastSvc broadcastSvc;

    @Inject
    private UserSvc userSvc;

    /**
     * 동보방송 목록을 가져온다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="list")
    public ModelAndView findListBroadcast(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        parameters = AdminHelper.checkReloadList(request, response, "broadcastList", parameters);
        AdminHelper.setPageParam(parameters,defaultPageSize);

        ModelAndView modelAndView = broadcastSvc.findListBroadcast(parameters);
        modelAndView.setViewName("broadcastList");

        return modelAndView;
    }

    /**
     * 동보방송 정보를 가져온다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="detail")
    public ModelAndView findByBroadcast(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = broadcastSvc.findByBroadcast(parameters);
        modelAndView.setViewName("broadcastDetail");

        return modelAndView;
    }

    /**
     * 동보방송 오너,유저를 가져오기위한 POPUP.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="popup")
    public ModelAndView findListBroadcastUser(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        AdminHelper.setPageParam(parameters, defaultPageSize);

        ModelAndView modelAndView = broadcastSvc.findListUser(parameters);
        modelAndView.setViewName("broadcastDetailUserPopup");

        return modelAndView;
    }

    private final static String[] addBroadcastParam = new String[]{"broadcastName"};

    /**
     * 동보방송을 등록한다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="add")
    public ModelAndView addBroadcast(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        if(MapUtils.nullCheckMap(parameters,addBroadcastParam)){
            throw new JabberException("");
        }

        parameters.put("insertUserId","admin"); // 임시
        ModelAndView modelAndView = broadcastSvc.addBroadcast(parameters);
        modelAndView.setViewName("broadcastDetail");

        return modelAndView;
    }

    private final static String[] saveBroadcastParam = new String[]{"broadcastId", "broadcastName"};

    /**
     * 동보방송을 수정한다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="save")
    public ModelAndView saveBroadcast(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        if(MapUtils.nullCheckMap(parameters,saveBroadcastParam)){
            throw new JabberException("");
        }

        parameters.put("insertUserId","admin"); // 임시
        parameters.put("updateUserId","admin"); // 임시
        ModelAndView modelAndView = broadcastSvc.saveBroadcast(parameters);
        modelAndView.setViewName("broadcastDetail");

        return modelAndView;
    }

    private final static String[] removeBroadcastParam = new String[]{"broadcastId"};

    /**
     * 동보방송을 제거한다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="remove")
    public ModelAndView removeBroadcast(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        if(MapUtils.nullCheckMap(parameters,removeBroadcastParam)){
            throw new JabberException("");
        }

        parameters.put("updateUserId","admin"); // 임시
        ModelAndView modelAndView = broadcastSvc.removeBroadcast(parameters);
        modelAndView.setViewName("broadcastDetail");

        return modelAndView;
    }
}
