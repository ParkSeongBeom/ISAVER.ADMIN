package com.icent.jabber.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

/**
 * 사업게시판 Service Interface
 *
 * @author : kst
 * @version : 1.0
 * @since : 2015. 8. 26.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2015. 8. 26.     kst          최초 생성
 * </pre>
 */
public interface BussinessBoardSvc {

    /**
     * 사업게시판 목록 가져오기
     * @author kst
     * @param parameters
     * @return
     */
    public ModelAndView findListBussinessBoard(Map<String, String> parameters);

    /**
     * 사업게시판 상세 가져오기
     * @author kst
     * @param parameters
     * @return
     */
    public ModelAndView findByBussinessBoard(Map<String, String> parameters);

    /**
     * 사업게시판 등록하기
     * @author kst
     * @param parameters
     * @return
     */
    public ModelAndView addBussinessBoard(Map<String, String> parameters);

    /**
     * 사업게시판 수정하기
     * @author kst
     * @param parameters
     * @return
     */
    public ModelAndView saveBussinessBoard(Map<String, String> parameters);

    /**
     * 사업게시판 제거하기
     * @author kst
     * @param parameters
     * @return
     */
    public ModelAndView removeBussinessBoard(Map<String, String> parameters);

}
