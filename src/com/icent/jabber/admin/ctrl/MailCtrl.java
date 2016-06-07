package com.icent.jabber.admin.ctrl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.svc.MailSvc;
import com.kst.common.util.MapUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import java.util.Map;

/**
 * 메일 발송 관리 Controller
 * @author : psb
 * @version : 1.0
 * @since : 2015. 02. 17.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2015. 02. 17.     psb           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value="/mail/*")
public class MailCtrl {

    @Inject
    private MailSvc mailSvc;

    /**
     * 메일 발송 목록을 가져온다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="list")
    public ModelAndView findAllMail(@RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = mailSvc.findAllMail(parameters);
        modelAndView.setViewName("mailList");
        return modelAndView;
    }

    /**
     * 메일 발송 상세 정보를 가져온다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="detail")
    public ModelAndView findByMail(@RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = mailSvc.findByMail(parameters);
        modelAndView.setViewName("mailDetail");
        return modelAndView;
    }

    private final static String[] saveMailParam = new String[]{"mailType"};

    /**
     * 메일 발송 정보를 저장한다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="save")
    public ModelAndView saveMail(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, saveMailParam)){
            throw new JabberException("");
        }

        ModelAndView modelAndView = mailSvc.saveMail(parameters);
        return modelAndView;
    }
}
