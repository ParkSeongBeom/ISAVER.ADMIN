package com.icent.isaver.admin.ctrl;

import com.icent.isaver.admin.common.resource.IcentException;
import com.icent.isaver.admin.svc.DeviceSyncRequestSvc;
import com.icent.isaver.admin.util.AdminHelper;
import com.kst.common.util.MapUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import java.util.Map;

/**
 * 장치 동기화 요청 Controller
 * @author : psb
 * @version : 1.0
 * @since : 2016. 10. 25.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2016. 10. 25.     psb           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value="/deviceSyncRequest/*")
public class DeviceSyncRequestCtrl {

    @Inject
    private DeviceSyncRequestSvc deviceSyncRequestSvc;

    @Value("${cnf.defaultPageSize}")
    private String defaultPageSize;

    /**
     * 장치 동기화 요청 목록을 가져온다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/list")
    public ModelAndView findListDeviceSyncRequest(@RequestParam Map<String, String> parameters) {
        AdminHelper.setPageParam(parameters,defaultPageSize);
        ModelAndView modelAndView = deviceSyncRequestSvc.findListDeviceSyncRequest(parameters);
        modelAndView.setViewName("deviceSyncRequestList");
        return modelAndView;
    }

    private final static String[] saveDeviceSyncRequestParam = new String[]{"deviceSyncRequestIds"};

    /**
     * 장치 동기화 요청 정보를 수정한다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/save")
    public ModelAndView saveDeviceSyncRequest(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, saveDeviceSyncRequestParam)){
            throw new IcentException("");
        }

        ModelAndView modelAndView = deviceSyncRequestSvc.saveDeviceSyncRequest(request, parameters);
        return modelAndView;
    }
}
