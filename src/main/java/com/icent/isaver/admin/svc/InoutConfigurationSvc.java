package com.icent.isaver.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

/**
 * 진출입자 조회 주기 Service Interface
 *
 * @author : psb
 * @version : 1.0
 * @since : 2016. 6. 27.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2016. 6. 27.     psb           최초 생성
 * </pre>
 */
public interface InoutConfigurationSvc {
    /**
     * 진출입자 조회 주기 목록을 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    public ModelAndView findListInoutConfiguration(Map<String, String> parameters);

    /**
     * 진출입자 조회 주기를 저장한다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    public ModelAndView saveInoutConfiguration(Map<String, String> parameters);
}
