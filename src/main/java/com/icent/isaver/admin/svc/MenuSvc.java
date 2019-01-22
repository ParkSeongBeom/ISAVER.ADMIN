package com.icent.isaver.admin.svc;

import com.icent.isaver.admin.bean.MenuBean;
import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

/**
 * 메뉴관리 Service Interface
 *
 * @author : dhj
 * @version : 1.0
 * @since : 2014. 5. 20.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 5. 20.     dhj           최초 생성
 * </pre>
 */
public interface MenuSvc {

    /**
     *
     * @param parameters
     * @return
     */
    public ModelAndView findAllMenuTree(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @return
     */
    public ModelAndView findAllMenuTopBar(Map<String, String> parameters);

    /**
     *
     * @return
     */
    public MenuBean findByMenuTree(MenuBean menuBean);

    /**
     *
     * @param parameters
     * @return
     */
    public ModelAndView findByMenu(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @return
     */
    public ModelAndView addMenu(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @return
     */
    public ModelAndView saveMenu(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @return
     */
    public ModelAndView removeMenu(Map<String, String> parameters);

}
