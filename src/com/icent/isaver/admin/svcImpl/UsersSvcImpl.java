package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.bean.JabberException;
import com.icent.isaver.admin.svc.UsersSvc;
import com.icent.isaver.admin.util.AdminHelper;
import com.icent.isaver.repository.bean.UsersBean;
import com.icent.isaver.repository.dao.base.RoleDao;
import com.icent.isaver.repository.dao.base.UsersDao;
import com.kst.common.bean.CommonResourceBean;
import com.kst.common.springutil.TransactionUtil;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionStatus;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.inject.Inject;
import java.util.List;
import java.util.Map;

/**
 * 사용자 관리 Service Implements
 *
 * @author : kst
 * @version : 1.0
 * @since : 2014. 6. 2.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 6. 2.     kst           최초 생성
 * </pre>
 */
@Service
public class UsersSvcImpl implements UsersSvc {

    @Inject
    private UsersDao usersDao;

    @Inject
    private RoleDao roleDao;

    @Resource(name="mybatisIsaverTxManager")
    private DataSourceTransactionManager transactionManager;

    @Override
    public ModelAndView findListUser(Map<String, String> parameters) {
        List<UsersBean> users = usersDao.findListUsers(parameters);
        Integer totalCount = usersDao.findCountUsers(parameters);

        AdminHelper.setPageTotalCount(parameters, totalCount);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("users",users);
        modelAndView.addObject("paramBean",parameters);
        modelAndView.addObject("roles",roleDao.findListRole(null));
        return modelAndView;
    }

    @Override
    public ModelAndView findByUser(Map<String, String> parameters) {
        UsersBean user = usersDao.findByUsers(parameters);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("user",user);
        modelAndView.addObject("roles",roleDao.findListRole(null));
        return modelAndView;
    }

    @Override
    public ModelAndView findByUserCheckExist(Map<String, String> parameters) {
        Integer count = usersDao.findByUserCheckExist(parameters);
        String existFlag = count > 0 ? CommonResourceBean.YES : CommonResourceBean.NO;

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("exist",existFlag);
        return modelAndView;
    }

    @Override
    public ModelAndView addUser(Map<String, String> parameters) {
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try {
            usersDao.addUsers(parameters);
            transactionManager.commit(transactionStatus);
        }catch(Exception e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }
        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView saveUser(Map<String, String> parameters) {
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try {
            usersDao.saveUsers(parameters);
            transactionManager.commit(transactionStatus);
        }catch(Exception e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }
        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView removeUser(Map<String, String> parameters) {
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try {
            usersDao.removeUsers(parameters);
            transactionManager.commit(transactionStatus);
        }catch(Exception e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }
        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }
}
