package com.icent.isaver.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

/**
 * 파일 환경설정 Service
 *
 * @author : psb
 * @version : 1.0
 * @since : 2018. 10. 29.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2018. 10. 29.     psb           최초 생성
 * </pre>
 */
public interface FileSettingSvc {

    /**
     * 파일 환경설정 상세를 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    ModelAndView findByFileSetting(Map<String, String> parameters);

    /**
     * 파일 환경설정을 저장한다.
     * @author psb
     */
    ModelAndView saveFileSetting(Map<String, String> parameters);
}
