package com.icent.isaver.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

/**
 * 이동경로 이력 Service
 * @author : psb
 * @version : 1.0
 * @since : 2020. 3. 18.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2020. 3. 18.     psb           최초 생성
 * </pre>
 */
public interface TrackingHistorySvc {

    /**
     * 이동경로 이력을 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    ModelAndView findByTrackingHistory(Map<String, String> parameters);
}
