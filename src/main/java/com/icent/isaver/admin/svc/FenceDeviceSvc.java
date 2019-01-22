package main.java.com.icent.isaver.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

/**
 * 펜스 카메라 맵핑 Service
 * @author : psb
 * @version : 1.0
 * @since : 2018. 7. 10.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2018. 7. 10.     psb           최초 생성
 * </pre>
 */
public interface FenceDeviceSvc {

    /**
     * 펜스 카메라 맵핑 목록을 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    ModelAndView findListFenceDevice(Map<String, String> parameters);
}
