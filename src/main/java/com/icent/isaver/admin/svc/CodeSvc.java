package com.icent.isaver.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

/**
 * 코드관리 Service Interface
 *
 * @author : kst
 * @version : 1.0
 * @since : 2014. 5. 20.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 5. 20.     kst           최초 생성
 * </pre>
 */
public interface CodeSvc {

    /**
     * 코드 목록을 가져온다.
     *
     * @author kst
     * @param parameters
     * @return
     */
    public ModelAndView findListCode(Map<String, String> parameters);

    /**
     * 코드 상세정보를 가져온다.
     *
     * @author kst
     * @param parameters
     * @return
     */
    public ModelAndView findByCode(Map<String, String> parameters);

    /**
     * 코드를 등록한다.
     *
     * @author kst
     * @param parameters
     */
    public ModelAndView addCode(Map<String, String> parameters);

    /**
     * 코드를 수정한다.
     *
     * @author kst
     * @param parameters
     */
    public ModelAndView saveCode(Map<String, String> parameters);

    /**
     * 코드를 제거한다.
     *
     * @author kst
     * @param parameters
     */
    public ModelAndView removeCode(Map<String, String> parameters);
}
