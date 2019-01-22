package com.icent.isaver.admin.ctrl;

import com.icent.isaver.admin.svc.FenceDeviceSvc;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import java.util.Map;

/**
 * 펜스 카메라 맵핑 Controller
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
@Controller
@RequestMapping(value="/fenceDevice/*")
public class FenceDeviceCtrl {
    @Inject
    private FenceDeviceSvc fenceDeviceSvc;

    /**
     * 펜스 카메라 맵핑 목록을 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/list")
    public ModelAndView findListFenceDevice(@RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = fenceDeviceSvc.findListFenceDevice(parameters);
        return modelAndView;
    }
}
