package com.icent.jabber.admin.svcImpl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.svc.RoleSvc;
import com.icent.jabber.admin.util.AdminHelper;
import com.icent.jabber.repository.bean.*;
import com.icent.jabber.repository.dao.base.AdminDao;
import com.icent.jabber.repository.dao.base.MenuRoleDao;
import com.icent.jabber.repository.dao.base.RoleDao;
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
 * 권한 관리 Service Implements
 *
 * @author : dhj
 * @version : 1.0
 * @since : 2014. 5. 24.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 5. 24.     dhj           최초 생성
 *  2014. 6. 02.     kst           권한삭제 로직 수정
 * </pre>
 */
@Service
public class RoleSvcImpl implements RoleSvc {

    @Resource(name="mybatisBaseTxManager")
    private DataSourceTransactionManager transactionManager;

    @Inject
    private RoleDao roleDao;

    @Inject
    private MenuRoleDao menuRoleDao;

    @Inject
    private AdminDao adminDao;

    @Override
    public ModelAndView findListRole(Map<String, String> parameters) {
        FindBean paramBean = AdminHelper.convertMapToBean(parameters, FindBean.class);

        ModelAndView modelAndView = new ModelAndView();
        List<RoleBean> roles = roleDao.findListRole(paramBean);
        Integer totalCount = roleDao.findCountRole(paramBean);

        AdminHelper.setPageTotalCount(paramBean,totalCount);

        modelAndView.addObject("roles", roles);
        modelAndView.addObject("paramBean",paramBean);
        return modelAndView;

    }

    @Override
    public ModelAndView findByRole(Map<String, String> parameters) {
        FindBean paramBean = AdminHelper.convertMapToBean(parameters, FindBean.class);
        RoleBean role = null;
        if(StringUtils.notNullCheck(paramBean.getId()) ){
            role = roleDao.findByRole(paramBean);
        }

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("role",role);

        return modelAndView;
    }

    @Override
    public ModelAndView addRole(Map<String, String> parameters) {
        RoleBean paramBean = AdminHelper.convertMapToBean(parameters, RoleBean.class);
        paramBean.setRoleId(StringUtils.getGUID36());

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            roleDao.addRole(paramBean);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView saveRole(Map<String, String> parameters) {
        RoleBean paramBean = AdminHelper.convertMapToBean(parameters, RoleBean.class);

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            roleDao.saveRole(paramBean);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView removeRole(Map<String, String> parameters) {
        RoleBean paramBean = AdminHelper.convertMapToBean(parameters, RoleBean.class);

        MenuRoleBean menuRoleParamBean = new MenuRoleBean();
        menuRoleParamBean.setRoleId(paramBean.getRoleId());
        AdminBean adminParamBean = new AdminBean();
        adminParamBean.setRoleId(paramBean.getRoleId());
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            menuRoleDao.removeMenuRoleForRole(menuRoleParamBean);
            adminDao.saveAdminForRole(adminParamBean);
            roleDao.removeRole(paramBean);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }
}
