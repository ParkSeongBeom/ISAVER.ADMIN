package com.icent.jabber.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
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
public interface UserSvc {


    /**
     * 사용자 전체 목록을 가져온다.
     *
     * @author kst
     * @param parameters
     * @return
     */
    public ModelAndView findAllUser(Map<String, String> parameters);

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
    public ModelAndView addUser(HttpServletRequest request, Map<String, String> parameters);

    /**
     * 사용자를 수정한다.
     *
     * @author kst
     * @param bparameters
     * @return
     */
    public ModelAndView saveUser(HttpServletRequest request, Map<String, String> bparameters);

    /**
     * 사용자를 제거한다.(flag)
     *
     * @author kst
     * @param parameters
     * @return
     */
    public ModelAndView removeUser(Map<String, String> parameters);

    /**
     * 사용자 조직도에 맵핑 되어 있지 않는 사용자 목록을 반환한다.
     * @param parameters
     * @return
     */
    public ModelAndView findListOrgUser(Map<String, String> parameters);

    /**
     * 사용자 정보를 엑셀로 등록한다.
     *
     * @author kst
     * @param request
     * - excel
     * @param parameters
     * - insertUserId : 등록자ID
     * @return
     */
    public ModelAndView uploadUserInfoExcel(HttpServletRequest request, Map<String, String> parameters);

    /**
     * 사용자 정보 엑셀문서를 다운로드한다.
     * @author kst
     * @param request
     * @param response
     */
    public void downloadUserInfoExcel(HttpServletRequest request, HttpServletResponse response);

    /**
     * 사진 파일을 다운로드 한다.
     * @param parameters
     * @return
     */
    public ModelAndView downloadUserPhotoFile(Map<String, String> parameters, HttpServletRequest request, HttpServletResponse response);


    /**
     * 사용자 정보를 등록/수정한다.
     *
     * @author psb
     * @param parameters
     * @return
     */
    public ModelAndView upsertAllUser(Map<String, String> parameters);
}
