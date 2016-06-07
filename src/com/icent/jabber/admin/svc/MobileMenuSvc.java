package com.icent.jabber.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

/**
 * MobileMenu Service Interface
 *
 * @author : psb
 * @version : 1.0
 * @since : 2016. 05. 03.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2016. 05. 03.     psb           최초 생성
 * </pre>
 */
public interface MobileMenuSvc {

    /**
     * 모바일메뉴 목록을 가져온다.
     *
     * @author psb
     * @return ModelAndView
     */
    public ModelAndView findListMobileMenu(Map<String, String> parameters);

    /**
     * 모바일메뉴 정보를 가져온다.
     *
     * @author psb
     * @param parameters
     * @return ModelAndView
     */
    public ModelAndView findByMobileMenu(Map<String, String> parameters);

    /**
     * 모바일메뉴를 등록한다.
     *
     * @author psb
     * @param parameters
     * @return ModelAndView
     */
    public ModelAndView addMobileMenu(Map<String, String> parameters);


    /**
     * 모바일메뉴를 수정한다.
     *
     * @author psb
     * @param parameters
     * @return ModelAndView
     */
    public ModelAndView saveMobileMenu(Map<String, String> parameters);

    /**
     * 모바일메뉴를 제거한다.
     *
     * @author psb
     * @param parameters
     * @return ModelAndView
     */
    public ModelAndView removeMobileMenu(Map<String, String> parameters);
}
