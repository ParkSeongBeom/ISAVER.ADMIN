package com.icent.jabber.admin.svcImpl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.resource.AdminResource;
import com.icent.jabber.admin.svc.AdminSvc;
import com.icent.jabber.admin.util.AdminHelper;
import com.icent.jabber.repository.bean.AdminBean;
import com.icent.jabber.repository.bean.FindBean;
import com.icent.jabber.repository.dao.base.AdminDao;
import com.icent.jabber.repository.dao.base.RoleDao;
import com.kst.common.springutil.TransactionUtil;
import com.kst.common.util.StringUtils;
import com.kst.digest.resource.DigestAlgorithm;
import com.kst.digest.util.DigestUtils;
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
 * 관리자 관리 Service Implements
 *
 * @author : kst
 * @version : 1.0
 * @since : 2014. 5. 29.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 5. 29.     kst           최초 생성
 * </pre>
 */
@Service
public class AdminSvcImpl implements AdminSvc {

    @Inject
    private AdminDao adminDao;

    @Inject
    private RoleDao roleDao;

    @Resource(name="mybatisBaseTxManager")
    private DataSourceTransactionManager transactionManager;

    @Override
    public ModelAndView findListAdmin(Map<String, String> parameters) {
        FindBean paramBean = AdminHelper.convertMapToBean(parameters,FindBean.class);

        List<AdminBean> admins = adminDao.findListAdmin(paramBean);
        Integer totalCount = adminDao.findCountAdmin(paramBean);

        AdminHelper.setPageTotalCount(paramBean,totalCount);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("admins",admins);
        modelAndView.addObject("paramBean",paramBean);
        return modelAndView;
    }

    @Override
    public ModelAndView findByAdmin(Map<String, String> parameters) {
        AdminBean paramBean = AdminHelper.convertMapToBean(parameters,AdminBean.class);

        AdminBean admin = null;
        if(StringUtils.notNullCheck(paramBean.getAdminId())){
            admin = adminDao.findByAdmin(paramBean);
        }

        FindBean roleParamBean = new FindBean();
        roleParamBean.setUseYn(AdminResource.YES);
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("admin",admin);
        modelAndView.addObject("roles",roleDao.findListRole(roleParamBean));
        return modelAndView;
    }

    @Override
    public ModelAndView addAdmin(Map<String, String> parameters) {
        AdminBean paramBean = AdminHelper.convertMapToBean(parameters,AdminBean.class);
        paramBean.setPassword(DigestUtils.digest(DigestAlgorithm.MD5, paramBean.getPassword()));

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            adminDao.addAdmin(paramBean);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView saveAdmin(Map<String, String> parameters) {
        AdminBean paramBean = AdminHelper.convertMapToBean(parameters,AdminBean.class);

        if(StringUtils.notNullCheck(paramBean.getPassword())){
            paramBean.setPassword(DigestUtils.digest(DigestAlgorithm.MD5,paramBean.getPassword()));
        }

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            adminDao.saveAdmin(paramBean);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView removeAdmin(Map<String, String> parameters) {
        AdminBean paramBean = AdminHelper.convertMapToBean(parameters,AdminBean.class);

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            adminDao.removeAdmin(paramBean);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }
}
