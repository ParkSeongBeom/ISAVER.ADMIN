package com.icent.jabber.admin.svcImpl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.svc.HubTabSvc;
import com.icent.jabber.admin.util.AdminHelper;
import com.icent.jabber.repository.bean.FindBean;
import com.icent.jabber.repository.bean.HubTabBean;
import com.icent.jabber.repository.dao.base.CodeDao;
import com.icent.jabber.repository.dao.base.HubTabDao;
import com.kst.common.springutil.TransactionUtil;
import com.kst.common.util.StringUtils;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionStatus;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.inject.Inject;
import java.util.List;
import java.util.Map;

/**
 * HubTab Service Implements
 *
 * @author : kst
 * @version : 1.0
 * @since : 2014. 5. 28.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 5. 28.     kst           최초 생성
 * </pre>
 */
@Service
public class HubTabSvcImpl implements HubTabSvc {

    @Inject
    private HubTabDao hubTabDao;

    @Inject
    private CodeDao codeDao;

    @Resource(name="mybatisBaseTxManager")
    private DataSourceTransactionManager transactionManager;

    @Override
    public ModelAndView findListHubTab(Map<String, String> parameters) {
        FindBean paramBean = AdminHelper.convertMapToBean(parameters,FindBean.class);

        List<HubTabBean> hubTabs = hubTabDao.findListHubTab(paramBean);
        Integer totalCount = hubTabDao.findCountHubTab(paramBean);

        AdminHelper.setPageTotalCount(paramBean,totalCount);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("hubTabs",hubTabs);
        modelAndView.addObject("paramBean",paramBean);

        return modelAndView;
    }

    @Override
    public ModelAndView findByHubTab(Map<String, String> parameters){
        HubTabBean paramBean = AdminHelper.convertMapToBean(parameters,HubTabBean.class);

        HubTabBean hubTab = null;
        if(StringUtils.notNullCheck(paramBean.getTabId())){
            hubTab = hubTabDao.findByHubTab(paramBean);
        }

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("hubTab",hubTab);
        return modelAndView;
    }

    @Override
    public ModelAndView addHubTab(Map<String, String> parameters) {
        HubTabBean paramBean = AdminHelper.convertMapToBean(parameters, HubTabBean.class);
        paramBean.setTabId(StringUtils.getGUID36());

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            hubTabDao.addHubTab(paramBean);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView saveHubTab(Map<String, String> parameters) {
        HubTabBean paramBean = AdminHelper.convertMapToBean(parameters, HubTabBean.class);

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            hubTabDao.saveHubTab(paramBean);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView removeHubTab(Map<String, String> parameters) {
        HubTabBean paramBean = AdminHelper.convertMapToBean(parameters, HubTabBean.class);

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            hubTabDao.removeHubTab(paramBean);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }
}
