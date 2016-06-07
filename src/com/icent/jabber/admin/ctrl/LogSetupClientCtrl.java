package com.icent.jabber.admin.ctrl;

import com.icent.jabber.admin.svc.LogSetupClientSvc;
import com.icent.jabber.admin.util.AdminHelper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import java.util.Map;

/**
 * 클라이언트 설치 / 업데이트 Controller
 *
 * @author : kst
 * @version : 1.0
 * @since : 2014. 6. 9.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 6. 9.     kst           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value="/logsetupclient/*")
public class LogSetupClientCtrl {

    @Value("#{configProperties['cnf.defaultPageSize']}")
    private String defaultPageSize;

    @Inject
    private LogSetupClientSvc logSetupClientSvc;

    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET}, value="/list")
    public ModelAndView findListLogSetupClient(@RequestParam Map<String, String> parameters){
        AdminHelper.setPageParam(parameters, defaultPageSize);

        ModelAndView modelAndView = logSetupClientSvc.findListLogSetupClient(parameters);
        modelAndView.setViewName("logSetupClientList");
        return modelAndView;
    }
}
