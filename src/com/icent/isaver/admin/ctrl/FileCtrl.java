package com.icent.isaver.admin.ctrl;

import com.icent.isaver.admin.common.resource.IsaverException;
import com.icent.isaver.admin.resource.AdminResource;
import com.icent.isaver.admin.svc.FileSvc;
import com.icent.isaver.admin.util.AdminHelper;
import com.icent.isaver.admin.util.SessionUtil;
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
 * 파일 Controller
 * @author : psb
 * @version : 1.0
 * @since : 2016. 12. 20.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2016. 12. 20.     psb           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value="/file/*")
public class FileCtrl {

    @Value("${cnf.defaultPageSize}")
    private String defaultPageSize;

    @Inject
    private FileSvc fileSvc;

    @Inject
    private SessionUtil sessionUtil;

    /**
     * 알람 파일 목록을 가져온다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/alarmList")
    public ModelAndView findListFileForAlarm(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        parameters = AdminHelper.checkReloadList(request, response, "alarmFileList", parameters);
        AdminHelper.setPageParam(parameters, defaultPageSize);
        parameters.put("fileType", AdminResource.FILE_TYPE.get("alarm"));

        ModelAndView modelAndView = fileSvc.findListFile(parameters);
        modelAndView.setViewName("alarmFileList");
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    /**
     * Map 파일 목록을 가져온다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/mapList")
    public ModelAndView findListFileForMap(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        parameters = AdminHelper.checkReloadList(request, response, "mapFileList", parameters);
        AdminHelper.setPageParam(parameters, defaultPageSize);
        parameters.put("fileType", AdminResource.FILE_TYPE.get("map"));

        ModelAndView modelAndView = fileSvc.findListFile(parameters);
        modelAndView.setViewName("mapFileList");
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    /**
     * 파일 목록을 가져온다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/deviceFileList")
    public ModelAndView findListFileForDevice(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = fileSvc.findListFileForDevice(parameters);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    /**
     * 알람 파일 정보를 가져온다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/alarmDetail")
    public ModelAndView findByFileForAlarm(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        ModelAndView modelAndView = fileSvc.findByFile(parameters);
        modelAndView.setViewName("alarmFileDetail");
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    /**
     * Map 파일 정보를 가져온다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/mapDetail")
    public ModelAndView findByFileForMap(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        ModelAndView modelAndView = fileSvc.findByFile(parameters);
        modelAndView.setViewName("mapFileDetail");
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    private final static String[] addFileParam = new String[]{"title","useYn"};

    /**
     * 파일을 등록 한다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/add")
    public ModelAndView addFile(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, addFileParam)){
            throw new IsaverException("");
        }

        parameters.put("insertUserId",sessionUtil.getSession(request.getSession()).getUserId());
        ModelAndView modelAndView = fileSvc.addFile(request, parameters);
        return modelAndView;
    }

    private final static String[] saveFileParam = new String[]{"fileId","title","useYn"};
    /**
     * 파일을 수정 한다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/save")
    public ModelAndView saveFile(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, saveFileParam)){
            throw new IsaverException("");
        }

        parameters.put("updateUserId",sessionUtil.getSession(request.getSession()).getUserId());
        ModelAndView modelAndView = fileSvc.saveFile(request, parameters);
        return modelAndView;
    }

    private final static String[] removeFileParam = new String[]{"fileId"};

    /**
     * 파일을 제거 한다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/remove")
    public ModelAndView removeFile(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, removeFileParam)){
            throw new IsaverException("");
        }

        parameters.put("updateUserId",sessionUtil.getSession(request.getSession()).getUserId());
        ModelAndView modelAndView = fileSvc.removeFile(request, parameters);
        return modelAndView;
    }

    private final static String[] downloadFileParam = new String[]{"fileId"};

    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="download")
    public ModelAndView downloadFile(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, downloadFileParam)){
            throw new IsaverException("");
        }

        ModelAndView modelAndView = fileSvc.downloadFile(parameters, request, response);
        return modelAndView;
    }
}
