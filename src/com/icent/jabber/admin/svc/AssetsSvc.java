package com.icent.jabber.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

/**
 * 자원 관리 Service Interface
 *
 * @author : psb
 * @version : 1.0
 * @since  : 2014. 10. 07.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 10. 07.     psb           최초 생성
 * </pre>
 */
public interface AssetsSvc {

    /**
     * 자원 목록을 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    public ModelAndView findListAssets(Map<String, String> parameters);

    /**
     * 자원 정보를 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    public ModelAndView findByAssets(Map<String, String> parameters);

    /**
     * 사용자 목록을 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    public ModelAndView findListUserAssets(Map<String, String> parameters);

    /**
     * 자원을 등록한다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    public ModelAndView addAssets(Map<String, String> parameters);

    /**
     * 자원을 수정한다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    public ModelAndView saveAssets(Map<String, String> parameters);

    /**
     * 자원을 제거한다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    public ModelAndView removeAssets(Map<String, String> parameters);
}
