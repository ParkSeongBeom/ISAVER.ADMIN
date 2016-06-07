package com.icent.jabber.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

/**
 * 관리자 로그 관리 Service Interface
 *
 * @author : kst
 * @version : 1.0
 * @since : 2014. 6. 10.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 6. 10.     kst           최초 생성
 * </pre>
 */
public interface LogAuthAdminUserSvc {

    /**
     * 관리자 로그 목록을 가져온다.
     *
     * @author kst
     * @param parameters
     * @return
     */
    public ModelAndView findListLogAuthAdminUser(Map<String, String> parameters);


    /**
     * 메인 - 관리자 로그 목록을 가져온다.
     *
     * @author kst
     * @param parameters
     * @return
     */
    public ModelAndView findListLogAuthAdminUserByMain(Map<String, String> parameters);

    /**
     * 관리자 로그를 등록한다.
     *
     * @author kst
     * @return
     */
    public ModelAndView addLogAuthAdminUser(Map<String, String> parameters);
}
