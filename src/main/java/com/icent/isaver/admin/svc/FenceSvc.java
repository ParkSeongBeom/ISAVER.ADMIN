package com.icent.isaver.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

/**
 * 펜스 Service
 * @author : psb
 * @version : 1.0
 * @since : 2018. 7. 9.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2018. 7. 9.     psb           최초 생성
 * </pre>
 */
public interface FenceSvc {

    /**
     * 펜스 목록을 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    ModelAndView findListFence(Map<String, String> parameters);

    ModelAndView findListFenceForStatistics(Map<String, String> parameters);
}
