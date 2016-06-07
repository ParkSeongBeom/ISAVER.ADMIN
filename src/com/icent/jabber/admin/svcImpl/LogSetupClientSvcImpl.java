package com.icent.jabber.admin.svcImpl;

import com.icent.jabber.admin.resource.AdminResource;
import com.icent.jabber.admin.svc.LogSetupClientSvc;
import com.icent.jabber.admin.util.AdminHelper;
import com.icent.jabber.repository.bean.CodeBean;
import com.icent.jabber.repository.bean.FindBean;
import com.icent.jabber.repository.bean.LogSetupClientBean;
import com.icent.jabber.repository.dao.base.CodeDao;
import com.icent.jabber.repository.dao.base.LogSetupClientDao;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import java.util.List;
import java.util.Map;

/**
 * 클라이언트 설치 / 업데이트 내역 Service Implements
 *
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
public class LogSetupClientSvcImpl implements LogSetupClientSvc {

    @Inject
    private LogSetupClientDao logSetupClientDao;

    @Inject
    private CodeDao codeDao;

    @Override
    public ModelAndView findListLogSetupClient(Map<String, String> parameters) {
        FindBean paramBean = AdminHelper.convertMapToBean(parameters, FindBean.class);

        List<LogSetupClientBean> logSetupClients = logSetupClientDao.findListLogSetupClient(paramBean);
        Integer totalCount = logSetupClientDao.findCountLogSetupClient(paramBean);

        AdminHelper.setPageTotalCount(paramBean,totalCount);

        FindBean codeParamBean = new FindBean();
        codeParamBean.setId("C005");
        codeParamBean.setUseYn(AdminResource.YES);
        List<CodeBean> deviceCodes = codeDao.findListCode(codeParamBean);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("logSetupClients",logSetupClients);
        modelAndView.addObject("paramBean",paramBean);
        modelAndView.addObject("deviceCodes", deviceCodes);

        return modelAndView;
    }
}
