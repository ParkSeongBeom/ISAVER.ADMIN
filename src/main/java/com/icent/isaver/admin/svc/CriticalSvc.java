package main.java.com.icent.isaver.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

/**
 * 임계치 Service
 * @author : psb
 * @version : 1.0
 * @since : 2018. 9. 21.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2018. 9. 21.     psb           최초 생성
 * </pre>
 */
public interface CriticalSvc {

    /**
     * 임계치 목록을 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    ModelAndView findListCritical(Map<String, String> parameters);

    /**
     * 임계치 상세를 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    ModelAndView findByCritical(Map<String, String> parameters);

    /**
     * 임계치를 등록한다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    ModelAndView addCritical(Map<String, String> parameters);

    /**
     * 임계치를 수정한다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    ModelAndView saveCritical(Map<String, String> parameters);

    /**
     * 임계치를 제거한다
     *
     * @author psb
     * @param parameters
     * @return
     */
    ModelAndView removeCritical(Map<String, String> parameters);
}
