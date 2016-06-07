package com.icent.jabber.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;

/**
 * Common Service Interface
 *
 * @author : psb
 * @version : 1.0
 * @since : 2014. 7. 28.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 7. 28.     psb           최초 생성
 * </pre>
 */
public interface CommonSvc {

    /**
     * 이미지를 첨부한다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    public ModelAndView uploadImage(HttpServletRequest request, Map<String, String> parameters);
}
