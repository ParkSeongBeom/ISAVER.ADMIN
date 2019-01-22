package com.icent.isaver.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

/**
 * 메뉴권한 Service Interface
 *
 * @author : psb
 * @version : 1.0
 * @since : 2016. 06. 08.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2016. 06. 08.     psb           최초 생성
 * </pre>
 */
public interface RoleMenuSvc {

    /**
     * 메뉴 권한 목록을 가져온다.
     *
     * @param parameters
     * @return
     */
    public ModelAndView findAllRoleMenu(Map<String, String> parameters);

    /**
     * 메뉴 권한을 저장한다.
     *
     * @param parameters
     * @return
     */
    public ModelAndView saveRoleMenu(Map<String, String> parameters);
}
