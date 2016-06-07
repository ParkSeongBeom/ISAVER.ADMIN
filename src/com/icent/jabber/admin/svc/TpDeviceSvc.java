package com.icent.jabber.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;

/**
 * TP 장비 관리 Service Interface
 *
 * @author : psb
 * @version : 1.0
 * @since : 2014. 6. 10.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 6. 10.     psb           최초 생성
 * </pre>
 */
public interface TpDeviceSvc {

    /**
     * TP 장비 목록을 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    public ModelAndView findListTpDevice(Map<String, String> parameters);

    /**
     * TP 장비 정보를 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    public ModelAndView findByTpDevice(Map<String, String> parameters);

    /**
     * TP 장비를 등록한다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    public ModelAndView addTpDevice(HttpServletRequest request, Map<String, String> parameters);

    /**
     * TP 장비를 수정한다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    public ModelAndView saveTpDevice(HttpServletRequest request, Map<String, String> parameters);

    /**
     * TP 장비를 제거한다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    public ModelAndView removeTpDevice(Map<String, String> parameters);
}
