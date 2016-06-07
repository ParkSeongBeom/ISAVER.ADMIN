package com.icent.jabber.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;

/**
 * 공지 사항 관리 Service
 * @author  : dhj
 * @version  : 1.0
 * @since  : 2014. 6. 13.
 * <pre>
 * == 개정이력(Modification Information) ====================
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 6. 13.     kst           최초 생성
 * </pre>
 */
public interface NoticeSvc {

    /**
     * 공지 사항 목록을 반환 한다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView findAllNotice(Map<String, String> parameters);

    /**
     * 공지 사항 정보를 반환 한다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView findByNotice(Map<String, String> parameters);

    /**
     * 공지 사항을 등록한다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView addNotice(HttpServletRequest request, Map<String, String> parameters);

    /**
     * 공지 사항을 저장한다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView saveNotice(HttpServletRequest request, Map<String, String> parameters);

    /**
     * 공지 사항을 제거한다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView removeNotice(Map<String, String> parameters);

    /**
     * 첨부 파일을 다운로드 한다.
     * @param parameters
     * @return
     */
    public ModelAndView downloadNotice(Map<String, String> parameters, HttpServletRequest request, HttpServletResponse response);
}
