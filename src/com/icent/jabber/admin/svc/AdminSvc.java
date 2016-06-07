package com.icent.jabber.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

/**
 * 관리자 관리 Service Interface
 *
 * @author : kst
 * @version : 1.0
 * @since : 2014. 5. 29.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 5. 29.     kst           최초 생성
 * </pre>
 */
public interface AdminSvc {

    /**
     * 관리자 목록을 가져온다.
     *
     * @author kst
     * @param parameters
     * @return
     */
    public ModelAndView findListAdmin(Map<String, String> parameters);

    /**
     * 관리자 정보를 가져온다.
     *
     * @author kst
     * @param parameters
     * @return
     */
    public ModelAndView findByAdmin(Map<String, String> parameters);

    /**
     * 관리자를 등록한다.
     *
     * @author kst
     * @param parameters
     * @return
     */
    public ModelAndView addAdmin(Map<String, String> parameters);

    /**
     * 관리자를 수정한다.
     *
     * @author kst
     * @param parameters
     * @return
     */
    public ModelAndView saveAdmin(Map<String, String> parameters);

    /**
     * 관리자를 제거한다.
     *
     * @author kst
     * @param parameters
     * @return
     */
    public ModelAndView removeAdmin(Map<String, String> parameters);
}
