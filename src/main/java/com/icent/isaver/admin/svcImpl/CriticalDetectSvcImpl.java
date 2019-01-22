package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.bean.CriticalDetectBean;
import com.icent.isaver.admin.common.resource.IsaverException;
import com.icent.isaver.admin.dao.CriticalDetectDao;
import com.icent.isaver.admin.svc.CriticalDetectSvc;
import com.kst.common.spring.TransactionUtil;
import com.kst.common.util.ListUtils;
import com.kst.common.util.StringUtils;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionStatus;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.inject.Inject;
import java.util.Map;

/**
 * 임계치별 감지장치 Service Implements
 * @author : psb
 * @version : 1.0
 * @since : 2018. 9. 21.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2018. 9. 21.     psb           최초 생성
 * </pre>
 */
@Service
public class CriticalDetectSvcImpl implements CriticalDetectSvc {

    @Resource(name="isaverTxManager")
    private DataSourceTransactionManager transactionManager;

    @Inject
    private CriticalDetectDao criticalDetectDao;

    @Override
    public ModelAndView findByCriticalDetect(Map<String, String> parameters) {
        CriticalDetectBean criticalDetect = criticalDetectDao.findByCriticalDetect(parameters);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("criticalDetect", criticalDetect);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView addCriticalDetect(Map<String, String> parameters) {
        ModelAndView modelAndView = new ModelAndView();
        if(ListUtils.notNullCheck(criticalDetectDao.findExistCriticalDetect(parameters))){
            modelAndView.addObject("resultCode", "ERR101");
        }else{
            TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
            parameters.put("criticalDetectId", StringUtils.getGUID32());
            try {
                criticalDetectDao.addCriticalDetect(parameters);
                transactionManager.commit(transactionStatus);
            }catch(DataAccessException e){
                transactionManager.rollback(transactionStatus);
                throw new IsaverException("");
            }
        }
        return modelAndView;
    }

    @Override
    public ModelAndView saveCriticalDetect(Map<String, String> parameters) {
        ModelAndView modelAndView = new ModelAndView();
        if(ListUtils.notNullCheck(criticalDetectDao.findExistCriticalDetect(parameters))){
            modelAndView.addObject("resultCode", "ERR101");
        }else {
            TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
            try {
                criticalDetectDao.saveCriticalDetect(parameters);
                transactionManager.commit(transactionStatus);
            } catch (DataAccessException e) {
                transactionManager.rollback(transactionStatus);
                throw new IsaverException("");
            }
        }
        return modelAndView;
    }

    @Override
    public ModelAndView removeCriticalDetect(Map<String, String> parameters) {
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try{
            criticalDetectDao.removeCriticalDetect(parameters);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new IsaverException("");
        }
        return new ModelAndView();
    }

}
