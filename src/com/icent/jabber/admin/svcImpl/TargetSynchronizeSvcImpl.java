package com.icent.jabber.admin.svcImpl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.svc.TargetSynchronizeSvc;
import com.icent.jabber.admin.util.AdminHelper;
import com.icent.jabber.admin.util.ServerConfigHelper;
import com.icent.jabber.repository.bean.TargetSynchronizeBean;
import com.icent.jabber.repository.dao.base.TargetSynchronizeDao;
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
 * 대상서버 관리 Service
 * @author : psb
 * @version : 1.0
 * @since : 2015. 12. 07.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2015. 12. 07.     psb           최초 생성
 * </pre>
 */
@Service
public class TargetSynchronizeSvcImpl implements TargetSynchronizeSvc {

    @Inject
    private TargetSynchronizeDao targetSynchronizeDao;

    @Resource(name="mybatisBaseTxManager")
    private DataSourceTransactionManager transactionManager;

    @Inject
    private ServerConfigHelper serverConfigHelper;

    @Override
    public ModelAndView findListTargetSynchronize(Map<String, String> parameters) {
        List<TargetSynchronizeBean> targetSynchronizes = targetSynchronizeDao.findListTargetSynchronize(parameters);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("targetSynchronizes",targetSynchronizes);
        return modelAndView;
    }

    @Override
    public ModelAndView findByTargetSynchronize(Map<String, String> parameters) {
        TargetSynchronizeBean paramBean = AdminHelper.convertMapToBean(parameters, TargetSynchronizeBean.class);

        TargetSynchronizeBean targetSynchronizeBean = null;

        if(StringUtils.notNullCheck(paramBean.getTargetId())) {
            targetSynchronizeBean = targetSynchronizeDao.findByTargetSynchronize(paramBean);
        }

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("targetSynchronize",targetSynchronizeBean);
        return modelAndView;
    }

    @Override
    public ModelAndView addTargetSynchronize(Map<String, String> parameters) {
        TargetSynchronizeBean paramBean = AdminHelper.convertMapToBean(parameters, TargetSynchronizeBean.class, "yyyy-MM-dd HH:mm:ss");
        paramBean.setTargetId(StringUtils.getGUID36());

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try {
            targetSynchronizeDao.addTargetSynchronize(paramBean);
            transactionManager.commit(transactionStatus);
        } catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView saveTargetSynchronize(Map<String, String> parameters) {
        TargetSynchronizeBean paramBean = AdminHelper.convertMapToBean(parameters, TargetSynchronizeBean.class, "yyyy-MM-dd HH:mm:ss");

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try {
            targetSynchronizeDao.saveTargetSynchronize(paramBean);
            transactionManager.commit(transactionStatus);
        } catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView removeTargetSynchronize(Map<String, String> parameters) {
        TargetSynchronizeBean paramBean = AdminHelper.convertMapToBean(parameters, TargetSynchronizeBean.class);

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try {
            targetSynchronizeDao.removeTargetSynchronize(paramBean);
            transactionManager.commit(transactionStatus);
        } catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }
}
