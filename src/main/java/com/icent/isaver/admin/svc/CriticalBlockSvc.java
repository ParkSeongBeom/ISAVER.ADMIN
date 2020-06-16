package com.icent.isaver.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

/**
 * 임계치 차단 Service
 *
 * @author : psb
 * @version : 1.0
 * @since : 2020. 06. 04.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2020. 06. 04.     psb           최초 생성
 * </pre>
 */
public interface CriticalBlockSvc {

    /**
     * 임계치를 전체 차단한다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    ModelAndView addCriticalBlock(Map<String, String> parameters);

    /**
     * 임계치를 차단을 해제 한다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    ModelAndView removeCriticalBlock(Map<String, String> parameters);

}
