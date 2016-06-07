package com.icent.jabber.admin.ctrl;


import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.svc.BussinessBoardSvc;
import com.icent.jabber.admin.util.AdminHelper;
import com.kst.common.util.MapUtils;
import com.kst.common.util.StringUtils;
import org.apache.poi.util.StringUtil;
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
 * 사업게시판 Controller
 *
 * @author : kst
 * @version : 1.0
 * @since : 2015. 8. 26.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2015. 8. 26.     kst           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value="/bussinessboard/*")
public class BussinessBoardCtrl {

    @Value("#{configProperties['cnf.defaultPageSize']}")
    private String defaultPageSize;

    @Inject
    private BussinessBoardSvc bussinessBoardSvc;

    /**
     * 사업게시판 화면 가져오기
     * @author kst
     * @return
     */
    @RequestMapping(method = {RequestMethod.POST,RequestMethod.GET},value = "/view")
    public ModelAndView findListBussinessBoard(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        AdminHelper.setPageParam(parameters, defaultPageSize);

        ModelAndView modelAndView = new ModelAndView();

        modelAndView.addObject("tabId",parameters.get("tabId"));
        modelAndView.addObject("paramBean",parameters);
        modelAndView.setViewName("bussinessBoardList");
        return modelAndView;
    }

    /**
     * 사업게시판 목록 가져오기.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="list")
    public ModelAndView findCalendarView(@RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = new ModelAndView();

        if(StringUtils.notNullCheck(parameters.get("viewType"))){
            if(parameters.get("viewType").equals("listView")){
                AdminHelper.setPageParam(parameters, defaultPageSize);
            }
            modelAndView = bussinessBoardSvc.findListBussinessBoard(parameters);

            if(parameters.get("viewType").equals("calendarView")){
                modelAndView.setViewName("bussinessBoardCalendarView");
            }else if(parameters.get("viewType").equals("listView")){
                modelAndView.setViewName("bussinessBoardListView");
            }
        }
        return modelAndView;
    }

    private final static String[] findByBussinessBoardParam = {"id"};

    /**
     * 사업게시판 상세 가져오기
     * @author kst
     * @param parameters
     * @return
     */
    @RequestMapping(method = {RequestMethod.POST,RequestMethod.GET},value = "/detail")
    public ModelAndView findByBussinessBoard(@RequestParam Map<String, String> parameters){
        if(MapUtils.nullCheckMap(parameters, findByBussinessBoardParam)){
            throw new JabberException("");
        }

        ModelAndView modelAndView = bussinessBoardSvc.findByBussinessBoard(parameters);
        return modelAndView;
    }

    private final static String[] addBussinessBoardParam = {"title","startDatetime","endDatetime","alldayYn"};

    /**
     * 사업게시판 등록하기
     * @author kst
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method = {RequestMethod.POST},value = "/add")
    public ModelAndView addBussinessBoard(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        if(MapUtils.nullCheckMap(parameters, addBussinessBoardParam)){
            throw new JabberException("");
        }
        parameters.put("insertUserId", AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = bussinessBoardSvc.addBussinessBoard(parameters);
        return modelAndView;
    }

    private final static String[] saveBussinessBoardParam = {"bussinessId"};

    /**
     * 사업게시판 수정하기
     * @author kst
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method = {RequestMethod.POST},value = "/save")
    public ModelAndView saveBussinessBoard(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        if(MapUtils.nullCheckMap(parameters, addBussinessBoardParam)){
            throw new JabberException("");
        }
        parameters.put("updateUserId", AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = bussinessBoardSvc.saveBussinessBoard(parameters);
        return modelAndView;
    }

    private final static String[] removeBussinessBoardParam = {"bussinessId"};

    /**
     * 사업게시판 제거하기
     * @author kst
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method = {RequestMethod.POST},value = "/remove")
    public ModelAndView removeBussinessBoard(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        if(MapUtils.nullCheckMap(parameters, removeBussinessBoardParam)){
            throw new JabberException("");
        }
        parameters.put("updateUserId", AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = bussinessBoardSvc.removeBussinessBoard(parameters);
        return modelAndView;
    }
}
