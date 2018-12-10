package com.icent.isaver.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

/**
 * 관리자 인가처리 Service Interface
 *
 * @author : kst
 * @version : 1.0
 * @since : 2014. 6. 2.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 6. 2.     kst           최초 생성
 * </pre>
 */
public interface AuthorizationSvc {

    /**
     * index.
     *
     * @author psb
     * @return
     */
    public ModelAndView index();

    /**
     * 관리자 로그인 처리를 한다.
     *
     * @author kst
     * @return
     */
    public ModelAndView login(HttpServletRequest request, Map<String, String> parameters);

    /**
     * 관리자 사용자 확인.
     *
     * @author psb
     * @return
     */
    public ModelAndView authorizeCheck(HttpServletRequest request, Map<String, String> parameters);

    /**
     * 관리자 로그인 처리를 한다.(텔코웨어 전용)
     *
     * @author psb
     * @return
     */
    public ModelAndView externalLogin(HttpServletRequest request, Map<String, String> parameters);

    /**
     * 관리자 로그아웃 처리를 한다.
     *
     * @author kst
     * @return
     */
    public ModelAndView logout(HttpServletRequest request);
}
