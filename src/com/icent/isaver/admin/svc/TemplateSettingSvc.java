package com.icent.isaver.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

/**
 * Dashboard Template 환경설정 Service
 *
 * @author : psb
 * @version : 1.0
 * @since : 2018. 6. 12.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2018. 6. 12.     psb           최초 생성
 * </pre>
 */
public interface TemplateSettingSvc {

    /**
     * Dashboard Template 환경설정 목록을 가져온다.
     *
     * @author psb
     * @return
     */
    Map<String, String> findListTemplateSetting();

    /**
     * Dashboard Template 환경설정 항목을 가져온다.
     *
     * @author psb
     * @return
     */
    String findByTemplateSetting(String key);

    /**
     * Dashboard Template 환경설정을 저장한다.
     * @author psb
     */
    ModelAndView saveTemplateSetting(Map<String, String> parameters);
}
