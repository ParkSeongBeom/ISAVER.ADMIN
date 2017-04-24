package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.common.resource.IcentException;
import com.icent.isaver.admin.svc.GroupCodeSvc;
import com.icent.isaver.repository.bean.GroupCodeBean;
import com.icent.isaver.repository.dao.base.CodeDao;
import com.icent.isaver.repository.dao.base.GroupCodeDao;
import com.kst.common.spring.TransactionUtil;
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
 * @author : kst
 * @version : 1.0
 * @since : 2014. 5. 30.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 5. 30.     kst           최초 생성
 * </pre>
 */
@Service
public class GroupCodeSvcImpl implements GroupCodeSvc {

    @Inject
    private GroupCodeDao groupCodeDao;

    @Inject
    private CodeDao codeDao;

    @Resource(name="isaverTxManager")
    private DataSourceTransactionManager transactionManager;

    @Override
    public ModelAndView findListGroupCode(Map<String, String> parameters) {
        List<GroupCodeBean> groupCodes = groupCodeDao.findListGroupCode();

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("groupCodes", groupCodes);
        return modelAndView;
    }

    @Override
    public ModelAndView findByGroupCode(Map<String, String> parameters) {
        GroupCodeBean groupCode = null;
        if(StringUtils.notNullCheck(parameters.get("groupCodeId"))){
            groupCode = groupCodeDao.findByGroupCode(parameters);
        }

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("groupCode",groupCode);
        return modelAndView;
    }

    @Override
    public ModelAndView addGroupCode(Map<String, String> parameters) {
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            groupCodeDao.addGroupCode(parameters);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.commit(transactionStatus);
            throw new IcentException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView saveGroupCode(Map<String, String> parameters) {
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            groupCodeDao.saveGroupCode(parameters);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.commit(transactionStatus);
            throw new IcentException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView removeGroupCode(Map<String, String> parameters) {
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            codeDao.removeCode(parameters);
            groupCodeDao.removeGroupCode(parameters);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.commit(transactionStatus);
            throw new IcentException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }
}
