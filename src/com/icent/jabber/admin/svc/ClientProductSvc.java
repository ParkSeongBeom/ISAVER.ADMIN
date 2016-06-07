package com.icent.jabber.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

/**
 * 제품정보 Service Interface
 *
 * @author : kst
 * @version : 1.0
 * @since : 2014. 8. 20.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 8. 20.     kst           최초 생성
 * </pre>
 */
public interface ClientProductSvc {

    /**
     * 제품정보 목록을 가져온다.
     *
     * @author kst
     * @param parameters
     * @return
     */
    public ModelAndView findListClientProduct(Map<String, String> parameters);

    /**
     * 제품정보를 가져온다.
     *
     * @author kst
     * @param parameters
     * @return
     */
    public ModelAndView findByClientProduct(Map<String, String> parameters);

    /**
     * 제품정보를 수정한다.
     *
     * @author kst
     * @param request
     * @param parameters
     * @return
     */
    public ModelAndView addClientProduct(HttpServletRequest request, Map<String, String> parameters);

    /**
     * 제품정보를 수정한다.
     *
     * @author kst
     * @param request
     * @param parameters
     */
    public ModelAndView saveClientProduct(HttpServletRequest request, Map<String, String> parameters);

    /**
     * 제품정보를 제거한다.
     *
     * @author kst
     * @param parameters
     */
    public ModelAndView removeClientProduct(Map<String, String> parameters);
}
