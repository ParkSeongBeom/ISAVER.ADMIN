package com.icent.isaver.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

/**
 * 고객사 Service 관리
 *
 * @author : psb
 * @version : 1.0
 * @since : 2018. 5. 29.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2018. 5. 29.     psb           최초 생성
 * </pre>
 */
public interface TargetSvc {

    /**
     * 고객사 상세을 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    ModelAndView findByTarget(Map<String, String> parameters);

    /**
     * 고객사를 저장한다.
     * @author psb
     */
    ModelAndView saveTarget(Map<String, String> parameters);
}
