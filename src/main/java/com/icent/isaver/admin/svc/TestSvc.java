package com.icent.isaver.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

/**
 * 테스트 시뮬레이터 Service Interface
 *
 * @author : psb
 * @version : 1.0
 * @since : 2018. 3. 20.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2018. 3. 20.     psb           최초 생성
 * </pre>
 */

public interface TestSvc {
    public ModelAndView testList(HttpServletRequest request, Map<String, String> parameters);

    public ModelAndView eventSend(HttpServletRequest request, Map<String, String> parameters);

    public ModelAndView guard(HttpServletRequest request, Map<String, String> parameters);
}
