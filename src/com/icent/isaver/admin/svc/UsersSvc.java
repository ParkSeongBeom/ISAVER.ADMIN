package com.icent.isaver.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

/**
 * @author : kst
 * @version : 1.0
 * @since : 2014. 6. 2.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 6. 2.     kst           최초 생성
 * </pre>
 */
public interface UsersSvc {

    /**
     * 사용자 목록을 가져온다.
     *
     * @author kst
     * @param parameters
     * @return
     */
    public ModelAndView findListUser(Map<String, String> parameters);

    /**
     * 사용자 정보를 가져온다.
     *
     * @author kst
     * @param parameters
     * @return
     */
    public ModelAndView findByUser(Map<String, String> parameters);

    /**
     * 사용자 존재여부를 확인판다.
     *
     * @author kst
     * @param parametes
     * @return
     */
    public ModelAndView findByUserCheckExist(Map<String, String> parametes);

    /**
     * 사용자를 등록한다.
     *
     * @author kst
     * @param parameters
     * @return
     */
    public ModelAndView addUser(Map<String, String> parameters);

    /**
     * 사용자를 수정한다.
     *
     * @author kst
     * @param bparameters
     * @return
     */
    public ModelAndView saveUser(Map<String, String> bparameters);

    /**
     * 사용자를 제거한다.(flag)
     *
     * @author kst
     * @param parameters
     * @return
     */
    public ModelAndView removeUser(Map<String, String> parameters);
}
