package com.icent.jabber.admin.svcImpl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.svc.GroupCodeSvc;
import com.icent.jabber.admin.util.AdminHelper;
import com.icent.jabber.repository.bean.CodeBean;
import com.icent.jabber.repository.bean.FindBean;
import com.icent.jabber.repository.bean.GroupCodeBean;
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
public class GroupCodeSvcImpl implements GroupCodeSvc{

    @Inject
    private GroupCodeDao groupCodeDao;

    @Inject
    private CodeDao codeDao;

    @Resource(name="mybatisBaseTxManager")
    private DataSourceTransactionManager transactionManager;

    @Override
    public ModelAndView findListGroupCode(Map<String, String> parameters) {
        FindBean paramBean = AdminHelper.convertMapToBean(parameters, FindBean.class);

        List<GroupCodeBean> groupCodes = groupCodeDao.findListGroupCode(paramBean);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("groupCodes", groupCodes);
        return modelAndView;
    }

    @Override
    public ModelAndView findByGroupCode(Map<String, String> parameters) {
        GroupCodeBean paramBean = AdminHelper.convertMapToBean(parameters, GroupCodeBean.class);

        GroupCodeBean groupCode = null;
        if(StringUtils.notNullCheck(paramBean.getGroupCodeId())){
            groupCode = groupCodeDao.findByGroupCode(paramBean);
        }

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("groupCode",groupCode);
        return modelAndView;
    }

    @Override
    public ModelAndView addGroupCode(Map<String, String> parameters) {
        GroupCodeBean paramBean = AdminHelper.convertMapToBean(parameters, GroupCodeBean.class);

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            groupCodeDao.addGroupCode(paramBean);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.commit(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView saveGroupCode(Map<String, String> parameters) {
        GroupCodeBean paramBean = AdminHelper.convertMapToBean(parameters, GroupCodeBean.class);

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            groupCodeDao.saveGroupCode(paramBean);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.commit(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView removeGroupCode(Map<String, String> parameters) {
        GroupCodeBean paramBean = AdminHelper.convertMapToBean(parameters, GroupCodeBean.class);

        FindBean codeParamBean = new FindBean();
        codeParamBean.setId(paramBean.getGroupCodeId());
        List<CodeBean> codes = codeDao.findListCode(codeParamBean);

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            for(CodeBean code : codes){
                codeDao.removeCode(code);
            }

            groupCodeDao.removeGroupCode(paramBean);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.commit(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }
}
