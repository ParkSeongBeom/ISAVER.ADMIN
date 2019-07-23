package com.icent.isaver.admin.ctrl;

import com.icent.isaver.admin.svc.NotiSendLogSvc;
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
 * 외부연동용 이벤트 전송 이력 Controller
 * @author : psb
 * @version : 1.0
 * @since : 2019. 7. 23.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2019. 7. 23.     psb           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value="/notiSendLog/*")
public class NotiSendLogCtrl {

    @Inject
    private NotiSendLogSvc notiSendLogSvc;

    /**
     * 알림센터 이력 목록을 가져온다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET}, value="/list")
    public ModelAndView findListNotiSendLog(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = notiSendLogSvc.findListNotiSendLog(parameters);
        return modelAndView;
    }
}
