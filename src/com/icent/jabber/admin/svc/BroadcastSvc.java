package com.icent.jabber.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

/**
 * 동보방송 관리 Service Interface
 *
 * @author : psb
 * @version : 1.0
 * @since : 2014. 6. 2.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 6. 2.     psb           최초 생성
 * </pre>
 */
public interface BroadcastSvc {

    /**
     * 동보방송 목록을 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    public ModelAndView findListBroadcast(Map<String, String> parameters);

    /**
     * 동보방송 정보를 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    public ModelAndView findByBroadcast(Map<String, String> parameters);

    /**
     * 사용자 목록을 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    public ModelAndView findListUser(Map<String, String> parameters);


    /**
     * 동보방송을 등록한다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    public ModelAndView addBroadcast(Map<String, String> parameters);

    /**
     * 동보방송을 수정한다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    public ModelAndView saveBroadcast(Map<String, String> parameters);

    /**
     * 동보방송을 제거한다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    public ModelAndView removeBroadcast(Map<String, String> parameters);
}
