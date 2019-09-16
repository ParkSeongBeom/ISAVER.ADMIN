package com.icent.isaver.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;

/**
 * 장치 상태 Service
 * @author : psb
 * @version : 1.0
 * @since : 2018. 7. 12.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2018. 7. 12.     psb           최초 생성
 * </pre>
 */
public interface DeviceStatusHistorySvc {

    /**
     * 장치 상태 목록을 조회한다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    ModelAndView findListDeviceStatusHistory(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @return
     */
    ModelAndView findListDeviceStatusHistoryForExcel(HttpServletRequest request, HttpServletResponse response, Map<String, String> parameters);
}
