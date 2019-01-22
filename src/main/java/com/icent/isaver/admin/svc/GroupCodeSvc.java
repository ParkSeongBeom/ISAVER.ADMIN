package com.icent.isaver.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

/**
 * @author : kst
 * @version : 1.0
 * @since : 2014. 5. 30.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 5. 30.     kst           최초 생성
 * </pre>
 */
public interface GroupCodeSvc {


    /**
     * 그룹코드 목록ㅇ르 가져온다.
     *
     * @author kst
     * @param parameters
     * @return
     */
    public ModelAndView findListGroupCode(Map<String, String> parameters);

    /**
     * 그룹코드 정보를 가져온다.
     *
     * @author kst
     * @param parameters
     * @return
     */
    public ModelAndView findByGroupCode(Map<String, String> parameters);

    /**
     * 그룹코드를 등록한다.
     *
     * @author kst
     * @param parameters
     */
    public ModelAndView addGroupCode(Map<String, String> parameters);

    /**
     * 그룹코드를 수정한다.
     *
     * @author kst
     * @param parameters
     */
    public ModelAndView saveGroupCode(Map<String, String> parameters);

    /**
     * 그룹코드를 제거한다.
     *
     * @author kst
     * @param parameters
     * @return
     */
    public ModelAndView removeGroupCode(Map<String, String> parameters);
}
