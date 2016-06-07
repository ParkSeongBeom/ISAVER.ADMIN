package com.icent.jabber.admin.svcImpl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.svc.MobileMenuSvc;
import com.icent.jabber.admin.util.AdminHelper;
import com.icent.jabber.repository.bean.MobileMenuBean;
import com.icent.jabber.repository.dao.base.CodeDao;
import com.icent.jabber.repository.dao.base.MobileMenuDao;
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
 * MobileMenu Service Implements
 *
 * @author : psb
 * @version : 1.0
 * @since : 2016. 05. 03.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2016. 05. 03.     psb           최초 생성
 * </pre>
 */
@Service
public class MobileMenuSvcImpl implements MobileMenuSvc {
    @Inject
    private MobileMenuDao mobileMenuDao;

    @Resource(name="mybatisBaseTxManager")
    private DataSourceTransactionManager transactionManager;

    @Override
    public ModelAndView findListMobileMenu(Map<String, String> parameters) {
        List<MobileMenuBean> mobileMenuList = mobileMenuDao.findListMobileMenu(parameters);
        Integer totalCount = mobileMenuDao.findCountMobileMenu(parameters);

        AdminHelper.setPageTotalCount(parameters,totalCount);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("mobileMenuList",mobileMenuList);
        modelAndView.addObject("paramBean",parameters);

        return modelAndView;
    }

    @Override
    public ModelAndView findByMobileMenu(Map<String, String> parameters){
        MobileMenuBean mobileMenu = null;
        if(StringUtils.notNullCheck(parameters.get("menuId"))){
            mobileMenu = mobileMenuDao.findByMobileMenu(parameters);
        }

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("mobileMenu",mobileMenu);
        return modelAndView;
    }

    @Override
    public ModelAndView addMobileMenu(Map<String, String> parameters) {
        MobileMenuBean paramBean = AdminHelper.convertMapToBean(parameters, MobileMenuBean.class);
        paramBean.setMenuId(StringUtils.getGUID36());

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            mobileMenuDao.addMobileMenu(paramBean);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView saveMobileMenu(Map<String, String> parameters) {
        MobileMenuBean paramBean = AdminHelper.convertMapToBean(parameters, MobileMenuBean.class);

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            mobileMenuDao.saveMobileMenu(paramBean);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView removeMobileMenu(Map<String, String> parameters) {
        MobileMenuBean paramBean = AdminHelper.convertMapToBean(parameters, MobileMenuBean.class);

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            mobileMenuDao.removeMobileMenu(paramBean);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }
}
