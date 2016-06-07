package com.icent.jabber.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

/**
 * 대상서버 관리 Service interface
 * @author : psb
 * @version : 1.0
 * @since : 2015. 12. 07.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2015. 12. 07.     psb           최초 생성
 * </pre>
 */
public interface TargetSynchronizeSvc {

    /**
     * 대상서버 목록을 반환 한다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView findListTargetSynchronize(Map<String, String> parameters);

    /**
     * 대상서버 상세 정보를 가져온다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView findByTargetSynchronize(Map<String, String> parameters);

    /**
     * 대상서버를 등록한다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView addTargetSynchronize(Map<String, String> parameters);

    /**
     * 대상서버를 저장한다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView saveTargetSynchronize(Map<String, String> parameters);

    /**
     * 대상서버를 제거한다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView removeTargetSynchronize(Map<String, String> parameters);
}
