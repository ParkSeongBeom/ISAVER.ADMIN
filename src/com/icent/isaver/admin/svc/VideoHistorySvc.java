package com.icent.isaver.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

/**
 * 영상이력 Service
 * @author : psb
 * @version : 1.0
 * @since : 2018. 8. 16.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2018. 8. 16.     psb           최초 생성
 * </pre>
 */
public interface VideoHistorySvc {

    /**
     * 영상이력 목록을 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    ModelAndView findListVideoHistory(Map<String, String> parameters);
}
