package com.icent.jabber.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

/**
 * Cucm Service
 * @author : psb
 * @version : 1.0
 * @since : 2015. 12. 11.
 * <pre>
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2015. 12. 11.     psb           최초 생성
 * </pre>
 */
public interface CucmSvc {

    /**
     * Cucm 장비 목록 팝업.
     *
     * @param parameters
     * @return the model and view
     */
    public ModelAndView findAllDevice(Map<String, String> parameters);

    /**
     * Cucm 사용자 목록을 가져온다.
     *
     * @param parameters
     * @return the model and view
     */
    public ModelAndView findAllUser(Map<String, String> parameters);

    /**
     * Cucm 장비 목록 팝업(userId).
     *
     * @param parameters
     * @return the model and view
     */
    public ModelAndView findListDeviceByUserId(Map<String, String> parameters);

    /**
     * Cucm 연결테스트.
     *
     * @param parameters
     * @return the model and view
     */
    public ModelAndView connect(Map<String, String> parameters);

    /**
     * CUCM 재요청.
     *
     * @param parameters
     * @return the model and view
     */
    public ModelAndView requestCucm(Map<String, String> parameters);
}
