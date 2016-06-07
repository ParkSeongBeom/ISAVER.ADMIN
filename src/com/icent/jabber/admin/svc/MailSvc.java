package com.icent.jabber.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

/**
 * 메일 발송 관리 Service interface
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
public interface MailSvc {

    /**
     * 메일 발송 목록을 반환 한다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView findAllMail(Map<String, String> parameters);

    /**
     * 메일 발송 상세 정보를 가져온다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView findByMail(Map<String, String> parameters);

    /**
     * 메일 발송 정보를 저장한다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView saveMail(Map<String, String> parameters);
}
