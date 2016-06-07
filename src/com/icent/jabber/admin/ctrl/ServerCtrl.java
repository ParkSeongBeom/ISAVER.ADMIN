package com.icent.jabber.admin.ctrl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.svc.ServerSvc;
import com.icent.jabber.admin.util.AdminHelper;
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
 * 서버 관리 Controller
 * @author : psb
 * @version : 1.0
 * @since : 2014. 10. 29.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 10. 29.     psb           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value="/server/*")
public class ServerCtrl {

    @Inject
    private ServerSvc serverSvc;

    /**
     * 서버 목록을 가져온다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="list")
    public ModelAndView findAllServer(@RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = serverSvc.findAllServer(parameters);
        modelAndView.setViewName("serverList");
        return modelAndView;
    }

    /**
     * 상세 서버를 가져온다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="detail")
    public ModelAndView findByServer(@RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = serverSvc.findByServer(parameters);
        modelAndView.setViewName("serverDetail");
        return modelAndView;
    }

    private final static String[] addServerParam = new String[]{"type", "name", "useYn"};

    /**
     * 서버를 등록한다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="add")
    public ModelAndView addServer(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, addServerParam)){
            throw new JabberException("");
        }

        parameters.put("insertUserId",AdminHelper.getAdminIdFromSession(request));

        ModelAndView modelAndView = serverSvc.addServer(parameters);
        return modelAndView;
    }

    private final static String[] saveServerParam = new String[]{"serverId", "type", "name", "useYn"};

    /**
     * 서버를 저장한다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="save")
    public ModelAndView saveServer(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, saveServerParam)){
            throw new JabberException("");
        }

        parameters.put("updateUserId",AdminHelper.getAdminIdFromSession(request));

        ModelAndView modelAndView = serverSvc.saveServer(parameters);
        return modelAndView;
    }

    private final static String[] removeServerParam = new String[]{"serverId"};

    /**
     * 서버를 제거한다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="remove")
    public ModelAndView removeServer(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, removeServerParam)){
            throw new JabberException("");
        }

        ModelAndView modelAndView = serverSvc.removeServer(parameters);
        return modelAndView;
    }

    /**
     * 배포사이트에 서버정보를 리셋한다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="reset")
    public ModelAndView resetServer(@RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = serverSvc.resetServer();
        return modelAndView;
    }

}
