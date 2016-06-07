package com.icent.jabber.admin.ctrl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.svc.FileSvc;
import com.icent.jabber.admin.svc.TargetSvc;
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
 * 파일관리 Controller
 *
 * @author : kst
 * @version : 1.0
 * @since : 2015. 2. 5.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2015. 2. 5.     kst           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value = "/file/*")
public class FileCtrl {

    @Value("#{configProperties['cnf.defaultPageSize']}")
    private String defaultPageSize;

    @Inject
    private FileSvc fileSvc;

    @Inject
    private TargetSvc targetSvc;

    /**
     * 파일목록을 가져온다.
     * @author kst
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/list")
    public ModelAndView findListFile(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        parameters = AdminHelper.checkReloadList(request, response, "fileList", parameters);
        parameters = AdminHelper.setPageParam(parameters, defaultPageSize);

        ModelAndView modelAndView = fileSvc.findListFile(parameters);
        modelAndView.setViewName("fileList");

//        return null;
        return modelAndView;
    }

    /**
     * 파일관리 환경설정을 가져온다.
     * @author psb
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/setting")
    public ModelAndView findByFileSetting(@RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = targetSvc.findAllTarget(parameters);
        modelAndView.setViewName("fileSetting");
        return modelAndView;
    }


    private final static String[] findByFileSettingDetailParam = new String[]{"targetId"};

    /**
     * 파일관리 환경설정 상세정보를 가져온다.
     * @author psb
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/settingDetail")
    public ModelAndView findByFileSettingDetail(@RequestParam Map<String, String> parameters){
        if(MapUtils.nullCheckMap(parameters, findByFileSettingDetailParam)){
            throw new JabberException("");
        }

        ModelAndView modelAndView = targetSvc.findByTarget(parameters);
        modelAndView.setViewName("fileSettingDetail");
        return modelAndView;
    }

    private final static String[] saveFileSettingParam = new String[]{"targetId"};

    /**
     * 파일관리 환경설정을 저장한다.
     * @author psb
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/settingSave")
    public ModelAndView saveFileSetting(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        if(MapUtils.nullCheckMap(parameters, saveFileSettingParam)){
            throw new JabberException("");
        }

        parameters.put("updateUserId",AdminHelper.getAdminIdFromSession(request));

        ModelAndView modelAndView = targetSvc.saveTargetFileSetting(parameters);
        modelAndView.setViewName("fileSettingDetail");
        return modelAndView;
    }

    /**
     * 파일을 삭제한다.
     * @author kst
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/delete")
    public ModelAndView deleteFile(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        parameters.put("userId", AdminHelper.getAdminInfo(request).getAdminId());
        ModelAndView modelAndView = fileSvc.deleteFile(parameters);
        return modelAndView;
    }
}
