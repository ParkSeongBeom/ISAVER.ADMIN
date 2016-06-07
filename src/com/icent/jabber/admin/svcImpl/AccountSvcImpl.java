package com.icent.jabber.admin.svcImpl;

import com.icent.jabber.admin.svc.AccountSvc;
import com.icent.jabber.admin.util.AdminHelper;
import com.icent.jabber.repository.bean.*;
import com.icent.jabber.repository.dao.base.AccountDao;
import com.icent.jabber.repository.dao.base.OrganizationDao;
import com.icent.jabber.repository.dao.base.TargetDao;
import com.kst.common.util.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import java.util.*;

/**
 * 로그인통계 Service
 * @author  : psb
 * @version  : 1.0
 * @since  : 2014. 10. 22.
 * <pre>
 * == 개정이력(Modification Information) ====================
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 10. 22.     psb           최초 생성
 * </pre>
 */
@Service
public class AccountSvcImpl implements AccountSvc {

    @Inject
    private AccountDao accountDao;

    @Inject
    private TargetDao targetDao;

    @Inject
    private OrganizationDao organizationDao;

    @Override
    public ModelAndView findListReportAccount(Map<String, String> parameters) {
        Integer useAccount = accountDao.findCountUseAccount();
        Integer summeryAccount = accountDao.findCountSummeryAccount(parameters);
        Integer license = targetDao.findByTargetLicense();
        List<AccountBean> reports = accountDao.findListReportAccount(parameters);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("useAccount",useAccount);
        modelAndView.addObject("summeryAccount",summeryAccount);
        modelAndView.addObject("license",license);
        modelAndView.addObject("reports",reports);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView findListOrgAccount(Map<String, String> parameters) {
        Map param = new HashMap<>();
        List<String> dateLists = AdminHelper.findListDateTime(parameters.get("startDatetimeStr"),parameters.get("endDatetimeStr"));
        param.put("dateLists",dateLists);
        param.put("startDatetimeStr",parameters.get("startDatetimeStr"));
        param.put("endDatetimeStr",parameters.get("endDatetimeStr"));
        List<Map<String, String>> accounts = accountDao.findListOrgAccount(param);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("accounts",accounts);
        modelAndView.addObject("dateLists",AdminHelper.findListDateTime(parameters.get("startDatetimeStr"),parameters.get("endDatetimeStr")));
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView findListUserAccount(Map<String, String> parameters) {
        Map param = new HashMap<>();
        List<String> dateLists = AdminHelper.findListDateTime(parameters.get("startDatetimeStr"),parameters.get("endDatetimeStr"));
        param.put("dateLists",dateLists);
        param.put("startDatetimeStr",parameters.get("startDatetimeStr"));
        param.put("endDatetimeStr",parameters.get("endDatetimeStr"));
        if(StringUtils.notNullCheck(parameters.get("id"))){
            param.put("orgId",parameters.get("id"));
        }
        if(StringUtils.notNullCheck(parameters.get("type"))){
            param.put("type",parameters.get("type"));
        }

        List<Map<String, String>> accounts = accountDao.findListUserAccount(param);
        List<OrganizationBean> organizationTreeList = organizationDao.findAllOrganizationTree(null);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("accounts",accounts);
        modelAndView.addObject("organizationList", organizationTreeList);
        modelAndView.addObject("dateLists",AdminHelper.findListDateTime(parameters.get("startDatetimeStr"),parameters.get("endDatetimeStr")));
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }
}
