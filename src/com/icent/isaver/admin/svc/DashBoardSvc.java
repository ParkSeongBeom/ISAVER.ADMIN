package com.icent.isaver.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

/**
 * 대쉬보드 Service
 * @author : psb
 * @version : 1.0
 * @since : 2016. 6. 16.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2016. 6. 16.     psb           최초 생성
 * </pre>
 */
public interface DashBoardSvc {

    /**
     * 대쉬보드를 가져온다.
     * @param parameters
     * @return
     */
    ModelAndView findAllDashBoard(Map<String, String> parameters);

    /**
     * 대쉬보드 상세를 가져온다.
     * @param parameters
     * @return
     */
    ModelAndView findByDashBoard(Map<String, String> parameters);
}
