package com.icent.jabber.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

/**
 * 회의실예약 Service interface
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
public interface ReservationSvc {

    /**
     * 회의실예약 상세정보를 반환 한다.
     * @param parameters
     * - reservationId        : 회의실 UUID
     * @return
     */
    public ModelAndView findByReservation(Map<String, String> parameters);

    /**
     * 회의실예약을 제거한다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView removeReservation(Map<String, String> parameters);
}
