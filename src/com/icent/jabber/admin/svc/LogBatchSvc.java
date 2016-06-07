package com.icent.jabber.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

/**
 * 배치로그 관리 Service Interface
 *
 * @author : kst
 * @version : 1.0
 * @since : 2014. 6. 11.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 6. 11.     kst           최초 생성
 * </pre>
 */
public interface LogBatchSvc {

    /**
     * 배치로그 목록을 가져온다.
     *
     * @author kst
     * @param parameters
     * @return
     */
    public ModelAndView findListLogBatch(Map<String, String> parameters);


    /**
     * 메인 - 배치로그 목록을 가져온다.
     *
     * @author kst
     * @param parameters
     * @return
     */
    public ModelAndView findListLogBatchByMain(Map<String, String> parameters);
}
