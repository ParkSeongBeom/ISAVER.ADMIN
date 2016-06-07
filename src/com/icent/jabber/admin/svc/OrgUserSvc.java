package com.icent.jabber.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

/**
 * 사용자 조직도 Service
 *
 * @author : dhj
 * @version : 1.0
 * @since : 2014. 6. 17.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 6. 17.     dhj           최초 생성
 * </pre>
 */
public interface OrgUserSvc {

    /**
     * 조직도 사용자를 조회한다.
     * @param parameters
     * @return
     */
    public ModelAndView findListOrgUser(Map<String, String> parameters);

    /**
     * 조직도 사용자를 추가한다.
     * @param parameters
     * @return
     */
    public ModelAndView addOrgUser(Map<String, String> parameters);

    /**
     * [단건] 조직도 사용자를 제거한다.
     * @param parameters
     * @return
     */
    public ModelAndView removeOrgUser(Map<String, String> parameters);

    /**
     * [복수] 조직도 사용자를 제거한다.
     * @param parameters
     * @return
     */
    public ModelAndView removeOrgUsers(Map<String, String> parameters);
}
