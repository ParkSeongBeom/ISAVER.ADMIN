package com.icent.jabber.admin.ctrl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.svc.SynchronizeSvc;
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
 * 동기화 Controller
 * @author : psb
 * @version : 1.0
 * @since : 2015. 12. 22.
 * <pre>
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2015. 12. 22.     psb           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value="/synchronize/*")
public class SynchronizeCtrl {

    @Value("#{configProperties['cnf.defaultPageSize']}")
    private String defaultPageSize;

    @Inject
    private SynchronizeSvc synchronizeSvc;

    /**
     * 동기화 요청 목록을 가져온다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/list")
    public ModelAndView findListRequestSynchronize(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters) {
        parameters = AdminHelper.checkReloadList(request, response, "requestSynchronizeList", parameters);
        AdminHelper.setPageParam(parameters, defaultPageSize);

        ModelAndView modelAndView = synchronizeSvc.findListRequestSynchronize(parameters);
        modelAndView.setViewName("requestSynchronizeList");
        return modelAndView;
    }

    private final static String[] findListSynchronizeUserParam = new String[]{"requestId"};

    /**
     * 동기화 사용자 목록을 가져온다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/detail")
    public ModelAndView findListSynchronizeUser(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, findListSynchronizeUserParam)){
            throw new JabberException("");
        }

        ModelAndView modelAndView = synchronizeSvc.findListSynchronizeUser(parameters);
        modelAndView.setViewName("synchronizeUserList");
        return modelAndView;
    }

    private final static String[] findListSynchronizeUserDetailParam = new String[]{"syncUserId"};

    /**
     * 동기화 요청 팝업
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/userDetail")
    public ModelAndView findListSynchronizeUserDetail(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, findListSynchronizeUserDetailParam)){
            throw new JabberException("");
        }

        ModelAndView modelAndView = synchronizeSvc.findListSynchronizeUserDetail(parameters);
        return modelAndView;
    }

    /**
     * 동기화 설정을 가져온다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/setting")
    public ModelAndView findAllSettingServerSynchronize(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        ModelAndView modelAndView = synchronizeSvc.findAllSettingServerSynchronize(parameters);
        modelAndView.setViewName("settingServerSynchronize");
        return modelAndView;
    }

    /**
     * 동기화 설정을 등록/수정한다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/upsertSetting")
    public ModelAndView upsertSettingServerSynchronize(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        ModelAndView modelAndView = synchronizeSvc.upsertSettingServerSynchronize(parameters);
        modelAndView.setViewName("settingServerSynchronize");
        return modelAndView;
    }

    private final static String[] addSynchronizeByUserParam = new String[]{"synchronizeUserList"};

    /**
     * 계정동기화요청(개별)을 한다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/addUser")
    public ModelAndView addSynchronizeByUser(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, addSynchronizeByUserParam)){
            throw new JabberException("");
        }

        parameters.put("authUserId",AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = synchronizeSvc.addSynchronizeByUser(parameters);
        return modelAndView;
    }

    /**
     * 계정동기화요청(전체)을 한다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/addAll")
    public ModelAndView addSynchronizeByAll(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        parameters.put("authUserId",AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = synchronizeSvc.addSynchronizeByAll(parameters);
        return modelAndView;
    }
}
