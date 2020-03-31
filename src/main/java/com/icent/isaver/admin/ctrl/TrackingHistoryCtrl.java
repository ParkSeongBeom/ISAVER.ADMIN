package com.icent.isaver.admin.ctrl;

import com.icent.isaver.admin.common.resource.IsaverException;
import com.icent.isaver.admin.svc.TrackingHistorySvc;
import com.meous.common.util.MapUtils;
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
 * 이동경로 이력 Controller
 * @author : psb
 * @version : 1.0
 * @since : 2020. 3. 18.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2020. 3. 18.     psb           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value="/trackingHistory/*")
public class TrackingHistoryCtrl {

    @Inject
    private TrackingHistorySvc trackingHistorySvc;

    private final static String[] findByTrackingHistoryParam = new String[]{"notificationId"};

    /**
     * 이동경로 이력을 가져온다.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET}, value="/detail")
    public ModelAndView findByTrackingHistory(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        if(MapUtils.nullCheckMap(parameters, findByTrackingHistoryParam)){
            throw new IsaverException("");
        }

        ModelAndView modelAndView = trackingHistorySvc.findByTrackingHistory(parameters);
        return modelAndView;
    }
}
