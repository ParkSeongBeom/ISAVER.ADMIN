package com.icent.jabber.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

/**
 * 기능제한 관리 Service interface
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
public interface FunctionSvc {

    /**
     * 기능제한 목록을 반환 한다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView findAllFunction(Map<String, String> parameters);

    /**
     * 기능제한 상세 정보를 가져온다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView findByFunction(Map<String, String> parameters);

    /**
     * 기능제한을 저장한다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView saveFunction(Map<String, String> parameters);

    /**
     * 기능제한 리셋.
     *
     * @return the model and view
     */
    public ModelAndView resetFunction();
}
