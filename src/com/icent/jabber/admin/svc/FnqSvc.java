package com.icent.jabber.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;

/**
 * 도움말 Service
 * @author : psb
 * @version : 1.0
 * @since : 2014. 10. 13.
 * <pre>
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 10. 13.     psb           최초 생성
 * </pre>
 */
public interface FnqSvc {

    /**
     * 도움말 목록을 반환 한다.
     *
     * @param parameters
     * - headerCode     : 구분
     * - title          : 제목
     * @return the model and view
     */
    public ModelAndView findAllFnq(Map<String, String> parameters);

    /**
     * 도움말 상세 정보를 반환한다.
     *
     * @param parameters
     * - fnqId       : 도움말 UUID
     * @return the model and view
     */
    public ModelAndView findByFnq(Map<String, String> parameters);

    /**
     * 도움말을 등록한다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView addFnq(HttpServletRequest request, Map<String, String> parameters);

    /**
     * 도움말을 저장한다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView saveFnq(HttpServletRequest request, Map<String, String> parameters);

    /**
     * 도움말을 제거한다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView removeFnq(Map<String, String> parameters);

    /**
     * 첨부 파일을 다운로드 한다.
     * @param parameters
     * @return
     */
    public ModelAndView downloadFnq(Map<String, String> parameters, HttpServletRequest request, HttpServletResponse response);
}
