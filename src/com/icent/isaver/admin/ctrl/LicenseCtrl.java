package com.icent.isaver.admin.ctrl;

import com.icent.isaver.admin.svc.LicenseSvc;
import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.util.AdminHelper;
import com.kst.common.util.MapUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;

/**
 * Created by icent on 16. 6. 1..
 */
@Controller
@RequestMapping(value="/license/*")
public class LicenseCtrl {

    @Value("#{configProperties['cnf.defaultPageSize']}")
    private String defaultPageSize;

    @Inject
    private LicenseSvc licenseSvc;

    /**
     * 라이센스 목록을 가져온다.
     *
     * @author dhj
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/list")
    public ModelAndView findListLicense(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        parameters = AdminHelper.checkReloadList(request, response, "userList", parameters);
        AdminHelper.setPageParam(parameters, defaultPageSize);

        ModelAndView modelAndView = licenseSvc.findListLicense(parameters);
        modelAndView.setViewName("licenseList");
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }
    /**
     *  라이센스 정보를 가져온다.
     *
     * @author dhj
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/detail")
    public ModelAndView findByLicense(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        ModelAndView modelAndView = licenseSvc.findByLicense(parameters);
        modelAndView.setViewName("licenseDetail");
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    private final static String[] addLicenseParam = new String[]{"licenseKey","deviceCode","expireDate", "licenseCount"};

    /**
     *  라이센스를 등록 한다.
     *
     * @author dhj
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/add")
    public ModelAndView addLicense(HttpServletRequest request, @RequestParam Map<String, String> parameters) {

        if(MapUtils.nullCheckMap(parameters, addLicenseParam)){
            throw new JabberException("");
        }

        ModelAndView modelAndView = licenseSvc.addLicense(request, parameters);
        return modelAndView;
    }

    private final static String[] saveLicenseParam = new String[]{"licenseKey","deviceCode","expireDate", "licenseCount"};

    /**
     *  라이센스를 수정 한다.
     *
     * @author dhj
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/save")
    public ModelAndView saveLicense(HttpServletRequest request, @RequestParam Map<String, String> parameters) {

        if(MapUtils.nullCheckMap(parameters, saveLicenseParam)){
            throw new JabberException("");
        }

        ModelAndView modelAndView = licenseSvc.saveLicense(request, parameters);
        return modelAndView;
    }

    private final static String[] removeLicenseParam = new String[]{"licenseId"};

    /**
     *  라이센스를 제거 한다.
     *
     * @author dhj
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST}, value="/remove")
    public ModelAndView removeLicense(HttpServletRequest request, @RequestParam Map<String, String> parameters) {

        if(MapUtils.nullCheckMap(parameters, removeLicenseParam)){
            throw new JabberException("");
        }


        ModelAndView modelAndView = licenseSvc.removeLicense(parameters);
        return modelAndView;
    }

}
