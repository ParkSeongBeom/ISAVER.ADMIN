package main.java.com.icent.isaver.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

/**
 * User: dhj
 * Date: 2014. 5. 24.
 * Time: 오후 10:32
 */
public interface RoleSvc {

    /**
     * 권한 목록을 가져온다.
     *
     * @param parameters
     * @return
     */
    public ModelAndView findListRole(Map<String, String> parameters);

    /**
     * 권한 정보를 가져온다.
     *
     * @param parameters
     * @return
     */
    public ModelAndView findByRole(Map<String, String> parameters);

    /**
     * 권한을 등록한다.
     *
     * @param parameters
     * @return
     */
    public ModelAndView addRole(Map<String, String> parameters);

    /**
     * 권한을 수정한다.
     *
     * @param parameters
     * @return
     */
    public ModelAndView saveRole(Map<String, String> parameters);

    /**
     * 권한을 제거한다.
     *
     * @param parameters
     * @return
     */
    public ModelAndView removeRole(Map<String, String> parameters);
}
