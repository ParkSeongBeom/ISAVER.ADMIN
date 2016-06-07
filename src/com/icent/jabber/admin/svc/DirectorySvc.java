package com.icent.jabber.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;

/**
 * AD/LDAP Service
 * @author : psb
 * @version : 1.0
 * @since : 2015. 12. 09.
 * <pre>
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2015. 12. 09.     psb           최초 생성
 * </pre>
 */
public interface DirectorySvc {

    /**
     * AD/LDAP 조직 목록 팝업.
     *
     * @param parameters
     * @return the model and view
     */
    public ModelAndView findAllDirectory(Map<String, String> parameters);

    /**
     * AD/LDAP 사용자 목록 가져오기.
     *
     * @param parameters
     * @return the model and view
     */
    public ModelAndView findListDirectoryUser(Map<String, String> parameters);

    /**
     * AD/LDAP 계정 재요청.
     *
     * @param parameters
     * @return the model and view
     */
    public ModelAndView requestDirectory(Map<String, String> parameters);
}
