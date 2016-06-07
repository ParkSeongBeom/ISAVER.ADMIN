package com.icent.jabber.admin.ctrl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.svc.UserSvc;
import com.icent.jabber.admin.util.AdminHelper;
import com.kst.common.util.MapUtils;
import com.kst.common.util.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;

/**
 * 사용자 관리
 *
 * @author : kst
 * @version : 1.0
 * @since : 2014. 6. 3.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 6. 3.     kst           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value="/user/*")
public class UserCtrl {

    @Value("#{configProperties['cnf.defaultPageSize']}")
    private String defaultPageSize;

    @Inject
    private UserSvc userSvc;


    /**
     * 사용자 전체 목록을 가져온다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/all")
    public ModelAndView findAllUser(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = userSvc.findAllUser(parameters);
        return modelAndView;
    }

    /**
     * 사용자 목록을 가져온다.
     *
     * @author kst
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/list")
    public ModelAndView findListUser(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        parameters = AdminHelper.checkReloadList(request, response, "userList", parameters);
        AdminHelper.setPageParam(parameters, defaultPageSize);

        ModelAndView modelAndView = userSvc.findListUser(parameters);
        modelAndView.setViewName("userList");

        return modelAndView;
    }


    /**
     * 사용자 정보를 가져온다.
     *
     * @author kst
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/detail")
    public ModelAndView findByUser(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        ModelAndView modelAndView = userSvc.findByUser(parameters);
        modelAndView.setViewName("userDetail");

        return modelAndView;
    }

    private final static String[] findByUserCheckExistParam = new String[]{"userId"};

    /**
     * 사용자ID 존재여부를 확인한다.
     *
     * @author kst
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value = "/exist")
    public ModelAndView findByUserCheckExist(@RequestParam Map<String, String> parameters){
        if(MapUtils.nullCheckMap(parameters, findByUserCheckExistParam)){
            throw new JabberException("");
        }

        ModelAndView modelAndView = userSvc.findByUserCheckExist(parameters);
        return modelAndView;
    }


    private final static String[] addUserParam = new String[]{"userId", "domain", "userName", "extension"};

    /**
     * 사용자 정보를 등록한다.
     *
     * @author kst
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/add")
    public ModelAndView addUser(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, addUserParam)){
            throw new JabberException("");
        }

        parameters.put("insertUserId",AdminHelper.getAdminIdFromSession(request));

        ModelAndView modelAndView = userSvc.addUser(request, parameters);
        modelAndView.setViewName("userDetail");

        return modelAndView;
    }

    private final static String[] saveUserParam = new String[]{"userId", "userName", "domain", "userName","extension"};

    /**
     * 사용자 정보를 수정한다.
     *
     * @author kst
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/save")
    public ModelAndView saveUser(HttpServletRequest request, @RequestParam Map<String, String> parameters) {

        MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest)request;
        if(MapUtils.nullCheckMap(parameters, saveUserParam)){
            throw new JabberException("");
        }

        parameters.put("updateUserId",AdminHelper.getAdminIdFromSession(request));

        ModelAndView modelAndView = userSvc.saveUser(request, parameters);
        modelAndView.setViewName("userDetail");

        return modelAndView;
    }

    private final static String[] removeUserParam = new String[]{"userId"};

    /**
     * 사용자를 제거한다.
     *
     * @author kst
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/remove")
    public ModelAndView removeUser(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, removeUserParam)){
            throw new JabberException("");
        }

        parameters.put("updateUserId",AdminHelper.getAdminIdFromSession(request));

        ModelAndView modelAndView = userSvc.removeUser(parameters);
        modelAndView.setViewName("userList");

        return modelAndView;
    }

    /**
     * 엑셀파일의 사용자 정보를 반영한다.
     *
     * @author kst
     * @param request
     * - excel
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/uploadExcel")
    public ModelAndView uploadExcel(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = userSvc.uploadUserInfoExcel(request, parameters);
        return modelAndView;
    }

    /**
     * 사용자 정보 엑셀파일 샘플을 다운로드한다.
     * @author kst
     * @param request
     * @param response
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET}, value="/downloadExcel")
    public void downloadExcel(HttpServletRequest request, HttpServletResponse response){
        userSvc.downloadUserInfoExcel(request, response);
    }

    private final static String[] downloadUserParam = new String[]{"userId"};

    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="download")
    public ModelAndView downloadUserPhotoFile(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, downloadUserParam)){
            throw new JabberException("");
        }

        ModelAndView modelAndView = userSvc.downloadUserPhotoFile(parameters, request, response);
        return modelAndView;
    }

    /**
     * 사용자 업로드.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/uploadList")
    public ModelAndView findListUserUpload(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("authUserId",AdminHelper.getAdminIdFromSession(request));
        modelAndView.setViewName("userUpload");
        return modelAndView;
    }

    private final static String[] upsertUserParam = new String[]{"synchronizeUserList"};

    /**
     * 사용자 정보를 등록/수정한다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/upsert")
    public ModelAndView upsertAllUser(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, upsertUserParam)){
            throw new JabberException("");
        }

        parameters.put("authUserId",AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = userSvc.upsertAllUser(parameters);
        return modelAndView;
    }
}
