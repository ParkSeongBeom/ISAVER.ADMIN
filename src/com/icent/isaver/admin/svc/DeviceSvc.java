package com.icent.isaver.admin.svc;

import com.icent.isaver.repository.bean.AreaBean;
import com.icent.isaver.repository.bean.DeviceBean;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
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
     * 장치 트리를 가져온다.
     * @param parameters
     * @return
     */
    ModelAndView findAllDeviceTree(Map<String, String> parameters);

    /**
     * 장치 트리를 가져온다.
     * @param parameters
     * @return
     */
    ModelAndView findListDeviceArea(Map<String, String> parameters);

    /**
     * 장치 목록을 가져온다.
     *
     * @author dhj
     * @param parameters
     * @return
     */
    ModelAndView findListDevice(Map<String, String> parameters);

    /**
     * 장치 정보를 가져온다.
     *
     * @author dhj
     * @param parameters
     * @return
     */
    ModelAndView findByDevice(Map<String, String> parameters);

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
    ModelAndView removeDevice(Map<String, String> parameters);

    /**
     * 전체 장치 트리를 반환한다.
     * @param parameters
     * - 없음
     * @return
     */
    List<DeviceBean> deviceTreeDataStructure(Map<String, String> parameters);
}
