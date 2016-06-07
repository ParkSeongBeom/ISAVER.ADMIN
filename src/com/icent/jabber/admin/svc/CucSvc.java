package com.icent.jabber.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

/**
 * Cuc Service
 * @author : psb
 * @version : 1.0
 * @since : 2015. 12. 29.
 * <pre>
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2015. 12. 29.     psb           최초 생성
 * </pre>
 */
public interface CucSvc {

    /**
     * CUCM 재요청.
     *
     * @param parameters
     * @return the model and view
     */
    public ModelAndView requestCuc(Map<String, String> parameters);
}
