package com.icent.isaver.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

/**
 * Custom Map Service
 *
 * @author : psb
 * @version : 1.0
 * @since : 2018. 6. 14.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2018. 6. 14.     psb           최초 생성
 * </pre>
 */
public interface CustomMapLocationSvc {

    /**
     * Custom Map 목록을 가져온다.
     *
     * @author psb
     * @return
     */
    ModelAndView findListCustomMapLocation(Map<String, String> parameters);

    /**
     * Custom Map 설정을 저장한다.
     * @author psb
     */
    ModelAndView saveCustomMapLocation(Map<String, String> parameters);
}
