package com.icent.isaver.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

/**
 * 장치 Service 관리
 * @author : dhj
 * @version : 1.0
 * @since : 2016. 6. 1.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2016. 6. 1.     dhj           최초 생성
 * </pre>
 */
public interface DeviceSvc {

    /**
     * 장치 목록을 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    ModelAndView findListDevice(Map<String, String> parameters);

    /**
     * 장치 목록을 가져온다. 자원모니터링용
     *
     * @author psb
     * @param parameters
     * @return
     */
    ModelAndView findListDeviceForResource(Map<String, String> parameters);

    /**
     * 장치를 등록한다.
     *
     * @author dhj
     * @param parameters
     * @return
     */
    ModelAndView addDevice(HttpServletRequest request, Map<String, String> parameters);

    /**
     * 장치를 수정한다.
     *
     * @author dhj
     * @param parameters
     * @return
     */
    ModelAndView saveDevice(HttpServletRequest request, Map<String, String> parameters);

    /**
     * 장치를 제거한다
     *
     * @author dhj
     * @param parameters
     * @return
     */
    ModelAndView removeDevice(HttpServletRequest request, Map<String, String> parameters);
}
