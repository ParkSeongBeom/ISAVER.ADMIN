package com.icent.jabber.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

/**
 * 서버 관리 Service interface
 * @author : psb
 * @version : 1.0
 * @since : 2014. 10. 29.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 10. 29.     psb           최초 생성
 * </pre>
 */
public interface ServerSvc {

    /**
     * 서버 목록을 반환 한다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView findAllServer(Map<String, String> parameters);

    /**
     * 서버 상세 정보를 가져온다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView findByServer(Map<String, String> parameters);

    /**
     * 서버를 등록한다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView addServer(Map<String, String> parameters);

    /**
     * 서버를 저장한다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView saveServer(Map<String, String> parameters);

    /**
     * 서버를 제거한다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView removeServer(Map<String, String> parameters);

    /**
     * 서버정보 리셋.
     *
     * @return the model and view
     */
    public ModelAndView resetServer();


}
