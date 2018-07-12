package com.icent.isaver.admin.ctrl;

import com.icent.isaver.admin.svc.DeviceStatusHistorySvc;
import com.icent.isaver.admin.util.AdminHelper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;

/**
 * 장치 상태 Controller
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
@Controller
@RequestMapping(value="/deviceStatusHistory/*")
public class DeviceStatusHistoryCtrl {

    @Value("${cnf.defaultPageSize}")
    private String defaultPageSize;

    @Inject
    private DeviceStatusHistorySvc deviceStatusHistorySvc;

    /**
     * 장치 상태 목록을 조회한다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/list")
    public ModelAndView findListDeviceStatusHistory(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        parameters = AdminHelper.checkReloadList(request, response, "deviceStatusHistoryList", parameters);
        AdminHelper.setPageParam(parameters, defaultPageSize);

        ModelAndView modelAndView = deviceStatusHistorySvc.findListDeviceStatusHistory(parameters);
        modelAndView.setViewName("deviceStatusHistoryList");
        return modelAndView;
    }
}
