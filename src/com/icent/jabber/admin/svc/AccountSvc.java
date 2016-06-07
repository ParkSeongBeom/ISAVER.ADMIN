package com.icent.jabber.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;

/**
 * 로그인통계 Service interface
 * @author  : psb
 * @version  : 1.0
 * @since  : 2014. 10. 22.
 * <pre>
 * == 개정이력(Modification Information) ====================
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 10. 22.     psb           최초 생성
 * </pre>
 */
public interface AccountSvc {


    /**
     * 로그인통계 현황을 반환 한다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView findListReportAccount(Map<String, String> parameters);

    /**
     * 로그인통계 부서별 목록을 가져온다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView findListOrgAccount(Map<String, String> parameters);

    /**
     * 로그인통계 개인별 목록을 가져온다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView findListUserAccount(Map<String, String> parameters);
}
