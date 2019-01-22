package main.java.com.icent.isaver.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;

/**
 * 접속 로그 Service Interface
 *
 * @author : psb
 * @version : 1.0
 * @since : 2016. 6. 14.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2016. 6. 14.     psb           최초 생성
 * </pre>
 */
public interface LoginHistorySvc {

    /**
     * 접속 로그 목록을 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    public ModelAndView findListLoginHistory(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @return
     */
    ModelAndView findListLoginHistoryForExcel(HttpServletRequest request, HttpServletResponse response, Map<String, String> parameters);
}
