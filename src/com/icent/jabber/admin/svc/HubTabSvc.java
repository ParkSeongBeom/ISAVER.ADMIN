package com.icent.jabber.admin.svc;

import com.icent.jabber.repository.bean.HubTabBean;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;
import java.util.Map;

/**
 * HubTab Service Interface
 *
 * @author : kst
 * @version : 1.0
 * @since : 2014. 5. 28.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 5. 28.     kst           최초 생성
 * </pre>
 */
public interface HubTabSvc {

    /**
     * 탭 목록을 가져온다.
     *
     * @author kst
     * @return ModelAndView
     */
    public ModelAndView findListHubTab(Map<String, String> parameters);

    /**
     * 탭 정보를 가져온다.
     *
     * @author kst
     * @param parameters
     * @return ModelAndView
     */
    public ModelAndView findByHubTab(Map<String, String> parameters);

    /**
     * 탭을 등록한다.
     *
     * @author kst
     * @param parameters
     * @return ModelAndView
     */
    public ModelAndView addHubTab(Map<String, String> parameters);


    /**
     * 탭 정보를 수정한다.
     *
     * @author kst
     * @param parameters
     * @return ModelAndView
     */
    public ModelAndView saveHubTab(Map<String, String> parameters);

    /**
     * 탭을 제거한다.
     *
     * @author kst
     * @param parameters
     * @return ModelAndView
     */
    public ModelAndView removeHubTab(Map<String, String> parameters);
}
