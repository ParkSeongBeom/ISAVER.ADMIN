package com.icent.jabber.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;

/**
 * 고객사 관리 Service interface
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
public interface TargetSvc {

    /**
     * 고객사 목록을 반환 한다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView findAllTarget(Map<String, String> parameters);

    /**
     * 고객사 상세 정보를 가져온다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView findByTarget(Map<String, String> parameters);

    /**
     * 고객사를 저장한다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView saveTarget(Map<String, String> parameters);

    /**
     * 고객사를 파일 환경설정을 수정한다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView saveTargetFileSetting(Map<String, String> parameters);

    /**
     * 고객사정보 리셋.
     *
     * @return the model and view
     */
    public ModelAndView resetTarget();
}
