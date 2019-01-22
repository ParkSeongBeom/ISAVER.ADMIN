package com.icent.isaver.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

/**
 * 장치 동기화 요청 Service
 * @author : psb
 * @version : 1.0
 * @since : 2016. 10. 24.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2016. 10. 24.     psb           최초 생성
 * </pre>
 */
public interface DeviceSyncRequestSvc {

    /**
     * 장치 동기화 요청 목록을 가져온다.
     * @author psb
     */
    public ModelAndView findListDeviceSyncRequest(Map<String, String> parameters);

    /**
     * 장치 동기화 요청을 등록한다.
     * @author psb
     */
    public ModelAndView addDeviceSyncRequest(HttpServletRequest request, Map<String, String> parameters);

    /**
     * 장치 동기화 요청을 저장한다.
     * @author psb
     */
    public ModelAndView saveDeviceSyncRequest(HttpServletRequest request, Map<String, String> parameters);
}
