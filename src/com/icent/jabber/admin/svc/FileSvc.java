package com.icent.jabber.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import java.util.Map;

/**
 * 파일 Service Interface
 *
 * @author : kst
 * @version : 1.0
 * @since : 2015. 2. 5.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2015. 2. 5.     kst           최초 생성
 * </pre>
 */
public interface FileSvc {

    /**
     * 파일 목록을 가져온다.
     * @author kst
     * @param parameters
     * @return
     */
    public ModelAndView findListFile(Map<String, String> parameters);

    /**
     * 파일을 삭제한다.
     * @author kst
     * @param parameters
     * @return
     */
    public ModelAndView deleteFile(Map<String, String> parameters);
}
