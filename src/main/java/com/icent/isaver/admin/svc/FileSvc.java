package main.java.com.icent.isaver.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;

/**
 * 파일 Service 관리
 * @author : psb
 * @version : 1.0
 * @since : 2016. 12. 20.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2016. 12. 20.     psb           최초 생성
 * </pre>
 */
public interface FileSvc {

    /**
     * 파일 목록을 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    ModelAndView findListFile(Map<String, String> parameters);

    /**
     * 파일 목록을 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    ModelAndView findListFileForDevice(Map<String, String> parameters);

    /**
     * 파일 상세을 가져온다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    ModelAndView findByFile(Map<String, String> parameters);

    /**
     * 파일을 등록한다.
     * @author psb
     */
    ModelAndView addFile(HttpServletRequest request, Map<String, String> parameters);

    /**
     * 파일을 저장한다.
     * @author psb
     */
    ModelAndView saveFile(HttpServletRequest request, Map<String, String> parameters);

    /**
     * 파일을 제거한다.
     * @author psb
     */
    ModelAndView removeFile(HttpServletRequest request, Map<String, String> parameters);

    /**
     * 첨부 파일을 다운로드 한다.
     * @param parameters
     * @return
     */
    ModelAndView downloadFile(Map<String, String> parameters, HttpServletRequest request, HttpServletResponse response);
}
