package com.icent.isaver.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

/**
 *  임계치 Service 관리
 * @author : dhj
 * @version : 1.0
 * @since : 2017. 6. 15.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2017. 6. 15.     dhj           최초 생성
 * </pre>
 */
public interface CriticalSvc {

    /**
     * 임계치 목록을 가져온다.
     *
     * @author dhj
     * @param parameters
     * @return
     */
    ModelAndView findListCritical(Map<String, String> parameters);

    /**
     * 임계치 정보를 가져온다.
     *
     * @author dhj
     * @param parameters
     * @return
     */
    ModelAndView findByCritical(Map<String, String> parameters);

    /**
     * 이벤트를 등록한다.
     *
     * @author dhj
     * @param parameters
     * @return
     */
    ModelAndView addCritical(HttpServletRequest request, Map<String, String> parameters);

    /**
     * 임계치를 수정한다.
     *
     * @author dhj
     * @param parameters
     * @return
     */
    ModelAndView saveCritical(HttpServletRequest request, Map<String, String> parameters);

    /**
     * 임계치를 제거한다
     *
     * @author dhj
     * @param parameters
     * @return
     */
    ModelAndView removeCritical(Map<String, String> parameters);

}
