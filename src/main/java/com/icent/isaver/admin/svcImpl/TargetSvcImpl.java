package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.bean.TargetBean;
import com.icent.isaver.admin.common.resource.IsaverException;
import com.icent.isaver.admin.dao.TargetDao;
import com.icent.isaver.admin.svc.TargetSvc;
import com.icent.isaver.admin.util.IsaverTargetUtil;
import com.meous.common.spring.TransactionUtil;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionStatus;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.inject.Inject;
import java.util.Map;

/**
 * 고객사 Service Implements
 *
 * @author : psb
 * @version : 1.0
 * @since : 2018. 5. 29.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2018. 5. 29.     psb           최초 생성
 * </pre>
 */
@Service
public class TargetSvcImpl implements TargetSvc {

    @Resource(name="isaverTxManager")
    private DataSourceTransactionManager transactionManager;

    @Inject
    private TargetDao targetDao;

    @Inject
    private IsaverTargetUtil isaverTargetUtil;

    @Override
    public ModelAndView findByTarget(Map<String, String> parameters) {
        ModelAndView modelAndView = new ModelAndView();

        TargetBean target = targetDao.findByTarget(parameters);
        modelAndView.addObject("target", target);
        return modelAndView;
    }


    @Override
    public ModelAndView saveTarget(Map<String, String> parameters) {
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try {
            targetDao.saveTarget(parameters);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new IsaverException("");
        }
        isaverTargetUtil.reset();
        return new ModelAndView();
    }
}
