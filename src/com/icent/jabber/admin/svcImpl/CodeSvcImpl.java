package com.icent.jabber.admin.svcImpl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.svc.CodeSvc;
import com.icent.jabber.admin.util.AdminHelper;
import com.icent.jabber.repository.bean.CodeBean;
import com.icent.jabber.repository.bean.FindBean;
import com.icent.jabber.repository.dao.base.CodeDao;
import com.icent.jabber.repository.dao.base.GroupCodeDao;
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
public class CodeSvcImpl implements CodeSvc{

    @Resource(name="mybatisBaseTxManager")
    private DataSourceTransactionManager transactionManager;

    @Inject
    private CodeDao codeDao;

    @Inject
    private GroupCodeDao groupCodeDao;

    @Override
    public ModelAndView findListCode(Map<String, String> parameters) {
        FindBean paramBean = AdminHelper.convertMapToBean(parameters, FindBean.class);
        List<CodeBean> codes = codeDao.findListCode(paramBean);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("codes",codes);
        //modelAndView.addObject("paramBean",paramBean);

        return modelAndView;
    }

    @Override
    public ModelAndView findByCode(Map<String, String> parameters) {
        CodeBean paramBean = AdminHelper.convertMapToBean(parameters, CodeBean.class);

        CodeBean code = null;
        if(StringUtils.notNullCheck(paramBean.getGroupCodeId()) && StringUtils.notNullCheck(paramBean.getCodeId())){
            code = codeDao.findByCode(paramBean);
        }

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("code",code);
        modelAndView.addObject("paramBean",paramBean);

        return modelAndView;
    }

    @Override
    public ModelAndView addCode(Map<String, String> parameters) {
        CodeBean paramBean = AdminHelper.convertMapToBean(parameters, CodeBean.class);

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            codeDao.addCode(paramBean);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView saveCode(Map<String, String> parameters) {
        CodeBean paramBean = AdminHelper.convertMapToBean(parameters, CodeBean.class);

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            codeDao.saveCode(paramBean);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView removeCode(Map<String, String> parameters) {
        CodeBean paramBean = AdminHelper.convertMapToBean(parameters, CodeBean.class);

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            codeDao.removeCode(paramBean);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }
}
