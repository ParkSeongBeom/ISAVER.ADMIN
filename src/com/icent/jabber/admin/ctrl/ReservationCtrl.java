package com.icent.jabber.admin.ctrl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.svc.CalendarSvc;
import com.icent.jabber.admin.svc.ReservationSvc;
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
 * 회의실예약 Controller
 *
 * @author : psb
 * @version : 1.0
 * @since : 2015. 07. 07.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2015. 07. 07.     psb           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value="/reservation/*")
public class ReservationCtrl {

    @Inject
    private ReservationSvc reservationSvc;

    private final static String[] findByReservationParam = new String[]{"reservationId"};

    /**
     * 회의실예약 상세정보를 반환 한다.
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/detail")
    public ModelAndView findByReservation(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        if(MapUtils.nullCheckMap(parameters, findByReservationParam)){
            throw new JabberException("");
        }

        ModelAndView modelAndView = reservationSvc.findByReservation(parameters);
        modelAndView.setViewName("noticeDetail");
        return modelAndView;
    }

    private final static String[] removeReservationParam = new String[]{"reservationId"};

    /**
     * 회의실예약을 제거한다.
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="remove")
    public ModelAndView removeReservation(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters, removeReservationParam)){
            throw new JabberException("");
        }

        ModelAndView modelAndView = reservationSvc.removeReservation(parameters);
        return modelAndView;
    }
}
