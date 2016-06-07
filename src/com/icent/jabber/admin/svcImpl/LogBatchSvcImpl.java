package com.icent.jabber.admin.svcImpl;

import com.icent.jabber.admin.svc.LogBatchSvc;
import com.icent.jabber.admin.util.AdminHelper;
import com.icent.jabber.repository.bean.FindBean;
import com.icent.jabber.repository.bean.LogBatchBean;
import com.icent.jabber.repository.dao.base.LogBatchDao;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import java.util.List;
import java.util.Map;

/**
 * @author : kst
 * @version : 1.0
 * @since : 2014. 6. 11.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 6. 11.     kst           최초 생성
 * </pre>
 */
@Service
public class LogBatchSvcImpl implements LogBatchSvc{

    @Inject
    private LogBatchDao logBatchDao;

    @Override
    public ModelAndView findListLogBatch(Map<String, String> parameters) {
        FindBean paramBean = AdminHelper.convertMapToBean(parameters, FindBean.class);

        List<LogBatchBean> logBatchs = logBatchDao.findListLogBatch(paramBean);
        Integer totalCount = logBatchDao.findCountLogBatch(paramBean);

        AdminHelper.setPageTotalCount(paramBean, totalCount);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("logBatchs",logBatchs);
        modelAndView.addObject("paramBean",paramBean);
        return modelAndView;
    }

    @Override
    public ModelAndView findListLogBatchByMain(Map<String, String> parameters) {
        List<LogBatchBean> logBatchs = logBatchDao.findMainLogBatch();

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("logBatchs",logBatchs);
        return modelAndView;
    }
}
