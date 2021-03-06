package com.icent.isaver.admin.ctrl;

import com.icent.isaver.admin.svc.VideoHistorySvc;
import com.icent.isaver.admin.util.AdminHelper;
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
 * 영상이력 Controller
 * @author : psb
 * @version : 1.0
 * @since : 2018. 8. 16.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2018. 8. 16.     psb           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value="/videoHistory/*")
public class VideoHistoryCtrl {

    @Value("${cnf.defaultPageSize}")
    private String defaultPageSize;

    @Inject
    private VideoHistorySvc videoHistorySvc;

    /**
     * 영상이력 목록을 가져온다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET}, value="/list")
    public ModelAndView findListVideoHistory(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        parameters = AdminHelper.checkSearchDate(parameters,0);
        if(StringUtils.nullCheck(parameters.get("mode")) && StringUtils.nullCheck(parameters.get("videoType"))){
            parameters.put("videoType","event");
        }

        ModelAndView modelAndView = videoHistorySvc.findListVideoHistory(parameters);
        if(StringUtils.nullCheck(parameters.get("mode"))){
            modelAndView.setViewName("videoHistoryList");
        }
        return modelAndView;
    }

    /**
     * 영상이력 목록을 가져온다. 알림이력용
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET}, value="/notiList")
    public ModelAndView findListVideoHistoryForNotificaion(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = videoHistorySvc.findListVideoHistoryForNotificaion(parameters);
        return modelAndView;
    }
}
