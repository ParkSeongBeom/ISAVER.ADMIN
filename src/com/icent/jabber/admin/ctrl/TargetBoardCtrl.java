package com.icent.jabber.admin.ctrl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.svc.TargetBoardSvc;
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
 * 고객사 게시판 관리 Controller
 * @author : psb
 * @version : 1.0
 * @since : 2014. 11. 26.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 11. 26.     psb           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value="/targetboard/*")
public class TargetBoardCtrl {

    @Value("#{configProperties['cnf.defaultPageSize']}")
    private String defaultPageSize;

    @Inject
    private TargetBoardSvc targetBoardSvc;

    /**
     * 고객사 게시판 목록을 가져온다.
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="list")
    public ModelAndView findAllTargetBoard(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        AdminHelper.setPageParam(parameters, defaultPageSize);

        ModelAndView modelAndView = targetBoardSvc.findAllTargetBoard(parameters);
        modelAndView.setViewName("targetBoardList");
        return modelAndView;
    }

    /**
     * 고객사 게시판 사항을 가져온다.
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="detail")
    public ModelAndView findByTargetBoard(HttpServletRequest request, @RequestParam Map<String, String> parameters){

        ModelAndView modelAndView = targetBoardSvc.findByTargetBoard(parameters);
        modelAndView.setViewName("targetBoardDetail");
        return modelAndView;
    }


    private final static String[] addTargetBoardParam = new String[]{"title", "comment"};

    /**
     * 고객사 게시판을 등록한다.
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="add")
    public ModelAndView addTargetBoard(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, addTargetBoardParam)){
            throw new JabberException("");
        }

        parameters.put("insertUserId",AdminHelper.getAdminIdFromSession(request));

        ModelAndView modelAndView = targetBoardSvc.addTargetBoard(request, parameters);
        return modelAndView;
    }

    private final static String[] updateTargetBoardParam = new String[]{"boardId", "title", "comment"};

    /**
     * 고객사 게시판을 저장한다.
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="save")
    public ModelAndView updateTargetBoard(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, updateTargetBoardParam)){
            throw new JabberException("");
        }

        parameters.put("updateUserId",AdminHelper.getAdminIdFromSession(request));

        ModelAndView modelAndView = targetBoardSvc.saveTargetBoard(request, parameters);
        return modelAndView;
    }

    private final static String[] removeTargetBoardParam = new String[]{"boardId"};

    /**
     * 고객사 게시판을 제거한다.
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="remove")
    public ModelAndView removeTargetBoard(HttpServletRequest request, @RequestParam Map<String, String> parameters) {

        if(MapUtils.nullCheckMap(parameters, removeTargetBoardParam)){
            throw new JabberException("");
        }

        parameters.put("updateUserId",AdminHelper.getAdminIdFromSession(request));

        ModelAndView modelAndView = targetBoardSvc.removeTargetBoard(parameters);
        return modelAndView;
    }

    private final static String[] downloadTargetBoardParam = new String[]{"boardId"};

    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="download")
    public ModelAndView downloadTargetBoard(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, downloadTargetBoardParam)){
            throw new JabberException("");
        }

        ModelAndView modelAndView = targetBoardSvc.downloadTargetBoard(parameters, request, response);
        return modelAndView;
    }
}
