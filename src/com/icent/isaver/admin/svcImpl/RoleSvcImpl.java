package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.bean.JabberException;
import com.icent.isaver.admin.svc.RoleSvc;
import com.icent.isaver.admin.util.AdminHelper;
import com.icent.isaver.repository.bean.RoleBean;
import com.icent.isaver.repository.dao.base.UsersDao;
import com.icent.isaver.repository.dao.base.RoleMenuDao;
import com.icent.isaver.repository.dao.base.RoleDao;
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

    @Resource(name="mybatisIsaverTxManager")
    private DataSourceTransactionManager transactionManager;

    @Inject
    private RoleDao roleDao;

    @Inject
    private RoleMenuDao roleMenuDao;

    @Inject
    private UsersDao usersDao;

    @Override
    public ModelAndView findListRole(Map<String, String> parameters) {
        ModelAndView modelAndView = new ModelAndView();
        List<RoleBean> roles = roleDao.findListRole(parameters);
        Integer totalCount = roleDao.findCountRole(parameters);

        AdminHelper.setPageTotalCount(parameters,totalCount);

        modelAndView.addObject("roles", roles);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;

    }

    @Override
    public ModelAndView findByRole(Map<String, String> parameters) {
        RoleBean role = null;
        if(StringUtils.notNullCheck(parameters.get("id")) ){
            role = roleDao.findByRole(parameters);
        }

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("role",role);

        return modelAndView;
    }

    @Override
    public ModelAndView addRole(Map<String, String> parameters) {
        parameters.put("roleId",StringUtils.getGUID36());

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            roleDao.addRole(parameters);
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
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            roleDao.saveRole(parameters);
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
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            roleMenuDao.removeRoleMenuForRole(parameters);
            usersDao.saveUsersForRole(parameters);
            roleDao.removeRole(parameters);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }
}
