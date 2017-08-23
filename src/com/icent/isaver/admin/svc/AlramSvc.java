package com.icent.isaver.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

/**
 * 임계치알림 Service
 * @author : psb
 * @version : 1.0
 * @since : 2017. 08. 22.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2017. 08. 22.     psb           최초 생성
 * </pre>
 */
public interface AlramSvc {

    /**
     * 임계치알림 목록을 가져온다.
     * @author psb
     */
    public ModelAndView findListAlram(Map<String, String> parameters);

    /**
     * 임계치알림 상세를 가져온다.
     * @author psb
     */
    public ModelAndView findByAlram(Map<String, String> parameters);

    /**
     * 임계치알림을 등록한다.
     * @author psb
     */
    public ModelAndView addAlram(HttpServletRequest request, Map<String, String> parameters);

    /**
     * 임계치알림을 저장한다.
     * @author psb
     */
    public ModelAndView saveAlram(HttpServletRequest request, Map<String, String> parameters);

    /**
     * 임계치알림을 저장한다.
     * @author psb
     */
    public ModelAndView removeAlram(HttpServletRequest request, Map<String, String> parameters);

}
