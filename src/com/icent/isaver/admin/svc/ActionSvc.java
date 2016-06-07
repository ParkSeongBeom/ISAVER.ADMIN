package com.icent.isaver.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

/**
 * 조치 Service 관리
 * @author : dhj
 * @version : 1.0
 * @since : 2016. 6. 1.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2016. 6. 1.     dhj           최초 생성
 * </pre>
 */
public interface ActionSvc {

    /**
     * 조치 목록을 가져온다.
     *
     * @author dhj
     * @param parameters
     * @return
     */
    ModelAndView findListAction(Map<String, String> parameters);

    /**
     * 조치 정보를 가져온다.
     *
     * @author dhj
     * @param parameters
     * @return
     */
    ModelAndView findByAction(Map<String, String> parameters);

    /**
     * 조치를 등록한다.
     *
     * @author dhj
     * @param parameters
     * @return
     */
    ModelAndView addAction(HttpServletRequest request, Map<String, String> parameters);

    /**
     * 조치를 수정한다.
     *
     * @author dhj
     * @param parameters
     * @return
     */
    ModelAndView saveAction(HttpServletRequest request, Map<String, String> parameters);

    /**
     * 조치를 제거한다
     *
     * @author dhj
     * @param parameters
     * @return
     */
    ModelAndView removeAction(Map<String, String> parameters);

}
