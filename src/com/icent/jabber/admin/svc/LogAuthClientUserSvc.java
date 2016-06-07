package com.icent.jabber.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

/**
 * 인가내역 관리 Service Implements
 *
 * @author : kst
 * @version : 1.0
 * @since : 2014. 6. 9.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 6. 9.     kst           최초 생성
 * </pre>
 */
public interface LogAuthClientUserSvc {

    /**
     * 인가내역 목록을 가져온다.
     *
     * @author kst
     * @param parameters
     * @return
     */
    public ModelAndView findListLogAuthClientUser(Map<String, String> parameters);

    /**
     * 사용자정보 유저현황을 가져온다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView findListUserByMain(Map<String, String> parameters);

    /**
     * 사용자정보 접속현황을 가져온다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView findListLogAuthclientUserByMain(Map<String, String> parameters);
}
