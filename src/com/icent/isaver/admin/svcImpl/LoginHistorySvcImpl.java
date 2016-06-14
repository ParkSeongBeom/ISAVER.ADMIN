package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.svc.LoginHistorySvc;
import com.icent.isaver.admin.util.AdminHelper;
import com.icent.isaver.repository.bean.LoginHistoryBean;
import com.icent.isaver.repository.dao.base.LoginHistoryDao;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import java.util.List;
import java.util.Map;

/**
 * 접속 로그 관리 Service Implements
 *
 * @author : psb
 * @version : 1.0
 * @since : 2016. 06. 14.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2016. 06. 14.     psb           최초 생성
 * </pre>
 */
@Service
public class LoginHistorySvcImpl implements LoginHistorySvc {
    @Inject
    private LoginHistoryDao loginHistoryDao;

    @Override
    public ModelAndView findListLoginHistory(Map<String, String> parameters) {
        List<LoginHistoryBean> loginHistoryList = loginHistoryDao.findListLoginHistory(parameters);
        Integer totalCount = loginHistoryDao.findCountLoginHistory(parameters);

        AdminHelper.setPageTotalCount(parameters, totalCount);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("loginHistoryList",loginHistoryList);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }
}
