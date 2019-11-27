package com.icent.isaver.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;

/**
 * 시스템로그 Service
 * @author : psb
 * @version : 1.0
 * @since : 2019. 10. 21.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2019. 10. 21.     psb           최초 생성
 * </pre>
 */
public interface SystemLogSvc {

    /**
     * 시스템로그 목록을 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    ModelAndView findListSystemLog(Map<String, String> parameters);

    /**
     * 시스템로그 스크립트를 실행한다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    ModelAndView excuteSystemLog(Map<String, String> parameters, HttpServletRequest request, HttpServletResponse response);

    /**
     * 첨부 파일을 다운로드 한다.
     * @param parameters
     * @return
     */
    ModelAndView downloadFile(Map<String, String> parameters, HttpServletRequest request, HttpServletResponse response);
}
