package com.icent.isaver.admin.svc;

import com.icent.isaver.repository.bean.AreaBean;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

/**
 * 구역 Service 관리
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
public interface AreaSvc {

    /**
     * 구역 트리를 가져온다.
     * @param parameters
     * @return
     */
    ModelAndView findAllAreaTree(Map<String, String> parameters);

    /**
     * 구역 목록을 가져온다.
     *
     * @author dhj
     * @param parameters
     * @return
     */
    ModelAndView findListArea(Map<String, String> parameters);

    /**
     * 구역 정보를 가져온다.
     *
     * @author dhj
     * @param parameters
     * @return
     */
    ModelAndView findByArea(Map<String, String> parameters);

    /**
     * 구역를 등록한다.
     *
     * @author dhj
     * @param parameters
     * @return
     */
    ModelAndView addArea(HttpServletRequest request, Map<String, String> parameters);

    /**
     * 구역를 수정한다.
     *
     * @author dhj
     * @param parameters
     * @return
     */
    ModelAndView saveArea(HttpServletRequest request, Map<String, String> parameters);

    /**
     * 구역를 제거한다
     *
     * @author dhj
     * @param parameters
     * @return
     */
    ModelAndView removeArea(HttpServletRequest request, Map<String, String> parameters);
}
