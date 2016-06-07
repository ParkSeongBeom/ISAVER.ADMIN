package com.icent.jabber.admin.svcImpl;

import com.icent.jabber.admin.resource.AdminResource;
import com.icent.jabber.admin.svc.LogAuthClientUserSvc;
import com.icent.jabber.admin.util.AdminHelper;
import com.icent.jabber.repository.bean.AccountBean;
import com.icent.jabber.repository.bean.CodeBean;
import com.icent.jabber.repository.bean.FindBean;
import com.icent.jabber.repository.bean.LogAuthClientUserBean;
import com.icent.jabber.repository.dao.base.AccountDao;
import com.icent.jabber.repository.dao.base.CodeDao;
import com.icent.jabber.repository.dao.base.LogAuthClientUserDao;
import com.icent.jabber.repository.dao.base.TargetDao;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author : kst
 * @version : 1.0
 * @since : 2014. 6. 9.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 6. 9.     kst           최초 생성
 * </pre>
 */
@Service
public class LogAuthClientUserSvcImpl implements LogAuthClientUserSvc {

    @Inject
    private LogAuthClientUserDao logAuthClientUserDao;

    @Inject
    private CodeDao codeDao;

    @Inject
    private AccountDao accountDao;

    @Inject
    private TargetDao targetDao;

    @Override
    public ModelAndView findListLogAuthClientUser(Map<String, String> parameters) {
        FindBean paramBean = AdminHelper.convertMapToBean(parameters, FindBean.class);

        List<LogAuthClientUserBean> logAuthClientUsers = logAuthClientUserDao.findListLogAuthClientUser(paramBean);
        Integer totalCount = logAuthClientUserDao.findCountLogAuthClientUser(paramBean);

        AdminHelper.setPageTotalCount(paramBean,totalCount);

        FindBean codeParamBean = new FindBean();
        codeParamBean.setId("C005");
        codeParamBean.setUseYn(AdminResource.YES);
        List<CodeBean> deviceCodes = codeDao.findListCode(codeParamBean);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("logAuthClientUsers",logAuthClientUsers);
        modelAndView.addObject("paramBean",paramBean);
        modelAndView.addObject("deviceCodes", deviceCodes);
        return modelAndView;
    }

    @Override
    public ModelAndView findListUserByMain(Map<String, String> parameters) {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("newCnt", accountDao.findCountNewAccount());
        modelAndView.addObject("useCnt", accountDao.findCountUseAccount());
        modelAndView.addObject("license",targetDao.findByTargetLicense());
        return modelAndView;
    }

    @Override
    public ModelAndView findListLogAuthclientUserByMain(Map<String, String> parameters) {
        parameters = AdminHelper.checkSearchDate(parameters,6);
        List accountDateList = AdminHelper.findListDateTime(parameters.get("startDatetimeStr"),parameters.get("endDatetimeStr"));
        List<AccountBean> accounts = accountDao.findByDateAccount(parameters);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("accounts", accounts);
        modelAndView.addObject("accountDateList",accountDateList);
        return modelAndView;
    }
}
