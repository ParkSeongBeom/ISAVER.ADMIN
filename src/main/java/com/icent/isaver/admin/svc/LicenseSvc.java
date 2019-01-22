package main.java.com.icent.isaver.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

/**
 * 라이센스 Service 관리
 * @author : dhj
 * @version : 1.0
 * @since : 2016. 6. 1.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2016. 6. 1.     dhj           최초 생성
 * </pre>
 */
public interface LicenseSvc {

    /**
     * 라이센스 목록을 가져온다.
     *
     * @author dhj
     * @param parameters
     * @return
     */
    ModelAndView findListLicense(Map<String, String> parameters);

    /**
     * 라이센스 정보를 가져온다.
     *
     * @author dhj
     * @param parameters
     * @return
     */
    ModelAndView findByLicense(Map<String, String> parameters);

    /**
     * 라이센스를 등록한다.
     *
     * @author dhj
     * @param parameters
     * @return
     */
    ModelAndView addLicense(HttpServletRequest request, Map<String, String> parameters);

    /**
     * 라이센스를 수정한다.
     *
     * @author dhj
     * @param parameters
     * @return
     */
    ModelAndView saveLicense(HttpServletRequest request, Map<String, String> parameters);

    /**
     * 라이센스를 제거한다
     *
     * @author dhj
     * @param parameters
     * @return
     */
    ModelAndView removeLicense(Map<String, String> parameters);

}
