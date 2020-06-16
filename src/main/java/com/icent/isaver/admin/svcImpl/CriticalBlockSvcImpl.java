package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.common.resource.IsaverException;
import com.icent.isaver.admin.dao.ActionDao;
import com.icent.isaver.admin.dao.CriticalBlockDao;
import com.icent.isaver.admin.dao.DeviceDao;
import com.icent.isaver.admin.svc.CriticalBlockSvc;
import com.meous.common.spring.TransactionUtil;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionStatus;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import java.util.Map;

/**
 * 임계치 차단 Service Implements
 *
 * @author : psb
 * @version : 1.0
 * @since : 2020. 06. 04.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2020. 06. 04.     psb           최초 생성
 * </pre>
 */
@Service
public class CriticalBlockSvcImpl implements CriticalBlockSvc {

    @Resource(name="isaverTxManager")
    private DataSourceTransactionManager transactionManager;

    @Inject
    private CriticalBlockDao criticalBlockDao;

    @Override
    public ModelAndView addCriticalBlock(Map<String, String> parameters) {
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try {
            criticalBlockDao.addCriticalBlock(parameters);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new IsaverException("");
        }
        return new ModelAndView();
    }

    @Override
    public ModelAndView removeCriticalBlock(Map<String, String> parameters) {
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            criticalBlockDao.removeCriticalBlock(parameters);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new IsaverException("");
        }
        return new ModelAndView();
    }
}
