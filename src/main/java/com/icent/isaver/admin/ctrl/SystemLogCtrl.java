package com.icent.isaver.admin.ctrl;

import com.icent.isaver.admin.common.resource.IsaverException;
import com.icent.isaver.admin.svc.SystemLogSvc;
import com.icent.isaver.admin.svc.VideoHistorySvc;
import com.icent.isaver.admin.util.AdminHelper;
import com.meous.common.util.MapUtils;
import com.meous.common.util.StringUtils;
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
 * 시스템로그 Controller
 * @author : psb
 * @version : 1.0
 * @since : 2019. 10. 21.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2019. 10. 21.     psb           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value="/systemLog/*")
public class SystemLogCtrl {

    @Value("${cnf.defaultPageSize}")
    private String defaultPageSize;

    @Inject
    private SystemLogSvc systemLogSvc;

    /**
     * 시스템로그 목록을 가져온다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET}, value="/list")
    public ModelAndView findListSystemLog(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        parameters = AdminHelper.checkReloadList(request, response, "systemLogList", parameters);
        AdminHelper.setPageParam(parameters, defaultPageSize);

        ModelAndView modelAndView = systemLogSvc.findListSystemLog(parameters);
        modelAndView.setViewName("systemLogList");
        return modelAndView;
    }

    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="excute")
    public ModelAndView excuteSystemLog(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters) {
        ModelAndView modelAndView = systemLogSvc.excuteSystemLog(parameters, request, response);
        return modelAndView;
    }

    private final static String[] downloadFileParam = new String[]{"systemLogId"};

    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="download")
    public ModelAndView downloadFile(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, downloadFileParam)){
            throw new IsaverException("");
        }

        ModelAndView modelAndView = systemLogSvc.downloadFile(parameters, request, response);
        return modelAndView;
    }
}
