package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.bean.CodeBean;
import com.icent.isaver.admin.bean.GroupCodeBean;
import com.icent.isaver.admin.common.resource.IsaverException;
import com.icent.isaver.admin.dao.CodeDao;
import com.icent.isaver.admin.dao.GroupCodeDao;
import com.icent.isaver.admin.svc.CodeSvc;
import com.meous.common.spring.TransactionUtil;
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
 * 코드관리 Service Implements
 *
 * @author : kst
 * @version : 1.0
 * @since : 2014. 5. 20.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 5. 20.     kst           최초 생성
 * </pre>
 */
@Service
public class CodeSvcImpl implements CodeSvc {

    @Resource(name="isaverTxManager")
    private DataSourceTransactionManager transactionManager;

    @Inject
    private GroupCodeDao groupCodeDao;

    @Inject
    private CodeDao codeDao;

    @Override
    public ModelAndView findListCode(Map<String, String> parameters) {
        List<GroupCodeBean> groupCodes = groupCodeDao.findListGroupCode();
        List<CodeBean> codes = codeDao.findListCode(parameters);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("groupCodeList",groupCodes);
        modelAndView.addObject("codeList",codes);
        return modelAndView;
    }

    @Override
    public ModelAndView addCode(Map<String, String> parameters) {
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            codeDao.addCode(parameters);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new IsaverException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView saveCode(Map<String, String> parameters) {
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            codeDao.saveCode(parameters);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new IsaverException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView removeCode(Map<String, String> parameters) {
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            codeDao.removeCode(parameters);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new IsaverException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }
}
