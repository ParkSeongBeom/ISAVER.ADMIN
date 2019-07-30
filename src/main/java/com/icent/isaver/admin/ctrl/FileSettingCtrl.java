package com.icent.isaver.admin.ctrl;

import com.icent.isaver.admin.common.resource.IsaverException;
import com.icent.isaver.admin.resource.AdminResource;
import com.icent.isaver.admin.svc.FileSettingSvc;
import com.meous.common.util.MapUtils;
import com.meous.common.util.StringUtils;
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
 * 파일 환경설정 Controller
 *
 * @author : psb
 * @version : 1.0
 * @since : 2018. 10. 29.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2018. 10. 29.     psb           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value="/fileSetting/*")
public class FileSettingCtrl {

    @Inject
    private FileSettingSvc fileSettingSvc;

    /**
     * Map 파일 목록을 가져온다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/detail")
    public ModelAndView findByFileSetting(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        if(StringUtils.nullCheck(parameters.get("fileType"))){
            parameters.put("fileType", AdminResource.FILE_TYPE.get("video"));
        }
        ModelAndView modelAndView = fileSettingSvc.findByFileSetting(parameters);
        modelAndView.setViewName("fileSettingDetail");
        return modelAndView;
    }

    private final static String[] saveFileSettingParam = new String[]{"fileType"};
    /**
     * 파일을 수정 한다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/save")
    public ModelAndView saveFileSetting(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, saveFileSettingParam)){
            throw new IsaverException("");
        }

        ModelAndView modelAndView = fileSettingSvc.saveFileSetting(parameters);
        return modelAndView;
    }
}
