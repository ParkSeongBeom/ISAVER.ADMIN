package com.icent.jabber.admin.ctrl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.svc.MaintenanceSvc;
import com.icent.jabber.admin.util.AdminHelper;
import com.icent.jabber.repository.bean.MaintenanceBean;
import com.kst.common.util.MapUtils;
import com.kst.common.util.StringUtils;
import org.apache.commons.beanutils.ConvertUtils;
import org.apache.commons.beanutils.converters.DateConverter;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;

/**
 * 의뢰사항 관리 Controller
 *
 * @author : dhj
 * @version : 1.0
 * @since : 2014. 6. 11.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 6. 11.     dhj           최초 생성
 * </pre>
 */
@Controller("maintenanceCtrl")
@RequestMapping(value="/maintenance/*")
public class MaintenanceCtrl {

    @Inject
    private MaintenanceSvc maintenanceSvc;

    @Value("#{configProperties['cnf.defaultPageSize']}")
    private String defaultPageSize;


    /**
     * 의뢰 사항 목록을 반환 한다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/list")
    public ModelAndView findAllMaintenance(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        parameters = AdminHelper.checkReloadList(request, response, "maintenanceList", parameters);
        AdminHelper.setPageParam(parameters, defaultPageSize);
//        parameters = AdminHelper.checkSearchDate(parameters, 7);

        ModelAndView modelAndView = maintenanceSvc.findAllMaintenance(parameters);
        modelAndView.setViewName("maintenanceList");
        return modelAndView;

    }

    /**
     * 의뢰 사항 단건을 반환 한다.
     * @param parameters
     * @author dhj
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/detail")
    public ModelAndView findByMaintenance(@RequestParam Map<String, String> parameters) {

        ModelAndView modelAndView = maintenanceSvc.findByMaintenance(parameters);
        modelAndView.setViewName("maintenanceDetail");
        return modelAndView;
    }

    private final static String[] saveMaintenanceParam = new String[]{"maintenanceId"};

    /**
     * 의뢰 사항을 저장한다.
     * @param parameters
     * @author dhj
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/save")
    public ModelAndView saveMaintenance(HttpServletRequest request, @RequestParam Map<String, String> parameters) {

        if (!StringUtils.notNullCheck(parameters.get("reviewStartDate"))) {
            parameters.remove("reviewStartDate");
        }

        if (!StringUtils.notNullCheck(parameters.get("reviewEndDate"))) {
            parameters.remove("reviewEndDate");
        }

        MaintenanceBean paramBean = AdminHelper.convertMapToBean(parameters, MaintenanceBean.class);

        if(MapUtils.nullCheckMap(parameters, saveMaintenanceParam)){
            throw new JabberException("");
        }

        parameters.put("reviewUserId",AdminHelper.getAdminIdFromSession(request));
        ModelAndView modelAndView = maintenanceSvc.saveMaintenance(request, parameters);
        modelAndView.setViewName("maintenanceDetail");
        return modelAndView;
    }

    private final static String[] removeMaintenanceParam = new String[]{"maintenanceId"};

    /**
     * 의뢰 사항을 제거한다.
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/remove")
    public ModelAndView removeMaintenance(HttpServletRequest request, @RequestParam Map<String, String> parameters) {

        if(MapUtils.nullCheckMap(parameters,removeMaintenanceParam)){
            throw new JabberException("");
        }

        parameters.remove("reviewStartDate");
        parameters.remove("reviewEndDate");
        ModelAndView modelAndView = maintenanceSvc.removeMaintenance(parameters);
        modelAndView.setViewName("maintenanceList");
        return modelAndView;
    }

    private final static String[] downloadMaintenanceParam = new String[]{"id"};

    /**
     * 의뢰사항 첨부 파일을 다운로드 한다.
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/download")
    public ModelAndView fileDownloadMaintenance(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters) {
        if(MapUtils.nullCheckMap(parameters,downloadMaintenanceParam)){
            throw new JabberException("");
        }
        ModelAndView modelAndView = maintenanceSvc.fileDownloadMaintenance(request, response, parameters);
        return modelAndView;
    }

    /**
     * 의뢰 사항 목록을 반환 한다.
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET},value="/mainList")
    public ModelAndView findListMaintenanceByMain(@RequestParam Map<String, String> parameters) {
        ModelAndView modelAndView = maintenanceSvc.findListMaintenanceByMain(parameters);
        modelAndView.setViewName("mainMaintenanceList");
        return modelAndView;

    }
}
