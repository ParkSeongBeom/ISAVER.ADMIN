package com.icent.jabber.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

/**
 * 동기화 Service
 * @author : psb
 * @version : 1.0
 * @since : 2015. 12. 22.
 * <pre>
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2015. 12. 22.     psb           최초 생성
 * </pre>
 */
public interface SynchronizeSvc {

    /**
     * 동기화 요청 목록을 가져온다.
     *
     * @param parameters
     * @return the model and view
     */
    public ModelAndView findListRequestSynchronize(Map<String, String> parameters);

    /**
     * 동기화 사용자 목록을 가져온다.
     *
     * @param parameters
     * @return the model and view
     */
    public ModelAndView findListSynchronizeUser(Map<String, String> parameters);

    /**
     * 동기화 사용자 상세 목록을 가져온다.
     *
     * @param parameters
     * @return the model and view
     */
    public ModelAndView findListSynchronizeUserDetail(Map<String, String> parameters);

    /**
     * 동기화 설정을 가져온다.
     *
     * @param parameters
     * @return the model and view
     */
    public ModelAndView findAllSettingServerSynchronize(Map<String, String> parameters);

    /**
     * 동기화 설정을 등록/수정한다.
     *
     * @param parameters
     * @return the model and view
     */
    public ModelAndView upsertSettingServerSynchronize(Map<String, String> parameters);

    /**
     * 계정동기화요청(개별)을 한다.
     *
     * @param parameters
     * @return the model and view
     */
    public ModelAndView addSynchronizeByUser(Map<String, String> parameters);

    /**
     * 계정동기화요청(전체)을 한다.
     *
     * @param parameters
     * @return the model and view
     */
    public ModelAndView addSynchronizeByAll(Map<String, String> parameters);
}
