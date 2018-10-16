package com.icent.isaver.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

/**
 * 임계치별 대상장치 Service
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
public interface CriticalTargetSvc {

    /**
     * 임계치별 대상장치 상세를 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    ModelAndView findByCriticalTarget(Map<String, String> parameters);

    /**
     * 임계치별 대상장치를 등록한다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    ModelAndView addCriticalTarget(Map<String, String> parameters);

    /**
     * 임계치별 대상장치를 수정한다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    ModelAndView saveCriticalTarget(Map<String, String> parameters);

    /**
     * 임계치별 대상장치를 제거한다
     *
     * @author psb
     * @param parameters
     * @return
     */
    ModelAndView removeCriticalTarget(Map<String, String> parameters);
}