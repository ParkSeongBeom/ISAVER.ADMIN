package com.icent.jabber.admin.svc;

import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;

/**
 * 의뢰사항 Service Interface
 *
 * @author : dhj
 * @version : 1.0
 * @since : 2014. 5. 20.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 5. 20.     dhj           최초 생성
 * </pre>
 */
public interface MaintenanceSvc {

    /**
     * 의뢰 사항 목록을 반환 한다.
     * @param parameters
     * @return
     */
    public ModelAndView findAllMaintenance(Map<String, String> parameters);

    /**
     * 의뢰 사항 단건을 반환 한다.
     * @param parameters
     * @return
     */
    public ModelAndView findByMaintenance(Map<String, String> parameters);

    /**
     * 의뢰 사항을 저장한다.
     * @param parameters
     * @return
     */
    public ModelAndView saveMaintenance(HttpServletRequest request, Map<String, String> parameters);

    /**
     * 의뢰사항은 제거한다.
     * @param parameters
     * @return
     */
    public ModelAndView removeMaintenance(Map<String, String> parameters);

    /**
     * 의뢰사항 첨부 파일을 다운로드한다.
     * @param request
     * @param parameters
     * @return
     */
    public ModelAndView fileDownloadMaintenance(HttpServletRequest request, HttpServletResponse response, Map<String, String> parameters);

    /**
     * 메인 - 의뢰 사항 목록을 반환 한다.
     * @param parameters
     * @return
     */
    public ModelAndView findListMaintenanceByMain(Map<String, String> parameters);
}
