package com.icent.jabber.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;

/**
 * 고객사 게시판 관리 Service interface
 * @author : psb
 * @version : 1.0
 * @since : 2014. 11. 26.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 11. 26.     psb           최초 생성
 * </pre>
 */
public interface TargetBoardSvc {

    /**
     * 고객사 게시판 목록을 반환 한다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView findAllTargetBoard(Map<String, String> parameters);

    /**
     * 고객사 게시판 정보를 반환 한다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView findByTargetBoard(Map<String, String> parameters);

    /**
     * 고객사 게시판을 등록한다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView addTargetBoard(HttpServletRequest request, Map<String, String> parameters);

    /**
     * 고객사 게시판을 저장한다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView saveTargetBoard(HttpServletRequest request, Map<String, String> parameters);

    /**
     * 고객사 게시판을 제거한다.
     *
     * @param parameters the parameters
     * @return the model and view
     */
    public ModelAndView removeTargetBoard(Map<String, String> parameters);

    /**
     * 첨부 파일을 다운로드 한다.
     * @param parameters
     * @return
     */
    public ModelAndView downloadTargetBoard(Map<String, String> parameters, HttpServletRequest request, HttpServletResponse response);
}
