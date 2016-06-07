package com.icent.jabber.admin.ctrl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.svc.NoticeSvc;
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
 * 공지 관리 Controller
 * @author : dhj
 * @version : 1.0
 * @since : 2014. 6. 3.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 6. 13.     dhj           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value="/notice/*")
public class NoticeCtrl {

    @Inject
    private NoticeSvc noticeSvc;

    /**
     * 공지 사항 목록을 가져온다.
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="list")
    public ModelAndView findAllNotice(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        parameters = AdminHelper.checkReloadList(request, response, "noticeList", parameters);
//        parameters = AdminHelper.checkSearchDate(parameters,7);

        ModelAndView modelAndView = noticeSvc.findAllNotice(parameters);
        modelAndView.setViewName("noticeList");
        return modelAndView;
    }

    /**
     * 상세 공지 사항을 가져온다.
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="detail")
    public ModelAndView findByNotice(HttpServletRequest request, @RequestParam Map<String, String> parameters){

        ModelAndView modelAndView = noticeSvc.findByNotice(parameters);
        modelAndView.setViewName("noticeDetail");
        return modelAndView;
    }


    private final static String[] addNoticeParam = new String[]{"title", "comment"};

    /**
     * 공지사항을 등록한다.
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="add")
    public ModelAndView addNotice(HttpServletRequest request, @RequestParam Map<String, String> parameters) {

        if(MapUtils.nullCheckMap(parameters, addNoticeParam)){
            throw new JabberException("");
        }

        parameters.put("insertUserId",AdminHelper.getAdminIdFromSession(request));
        parameters.put("updateUserId",AdminHelper.getAdminIdFromSession(request));

        ModelAndView modelAndView = noticeSvc.addNotice(request, parameters);
        modelAndView.setViewName("noticeDetail");
        return modelAndView;
    }

    private final static String[] updateNoticeParam = new String[]{"noticeId", "title", "comment"};

    /**
     * 공지사항을 저장한다.
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="save")
    public ModelAndView updateNotice(HttpServletRequest request, @RequestParam Map<String, String> parameters) {

        if(MapUtils.nullCheckMap(parameters, updateNoticeParam)){
            throw new JabberException("");
        }

        parameters.put("updateUserId",AdminHelper.getAdminIdFromSession(request));

        ModelAndView modelAndView = noticeSvc.saveNotice(request, parameters);
        modelAndView.setViewName("noticeDetail");
        return modelAndView;
    }

    private final static String[] removeNoticeParam = new String[]{"noticeId"};

    /**
     * 공지사항을 제거한다.
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="remove")
    public ModelAndView removeNotice(HttpServletRequest request, @RequestParam Map<String, String> parameters) {

        if(MapUtils.nullCheckMap(parameters, removeNoticeParam)){
            throw new JabberException("");
        }

        parameters.put("updateUserId",AdminHelper.getAdminIdFromSession(request));

        ModelAndView modelAndView = noticeSvc.removeNotice(parameters);
        return modelAndView;
    }

    private final static String[] downloadNoticeParam = new String[]{"noticeId"};

    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="download")
    public ModelAndView downloadNotice(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, downloadNoticeParam)){
            throw new JabberException("");
        }

        ModelAndView modelAndView = noticeSvc.downloadNotice(parameters, request, response);
        return modelAndView;
    }
}
