package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.bean.RoleBean;
import com.icent.isaver.admin.bean.UsersBean;
import com.icent.isaver.admin.common.resource.IsaverException;
import com.icent.isaver.admin.dao.RoleDao;
import com.icent.isaver.admin.dao.UsersDao;
import com.icent.isaver.admin.svc.UsersSvc;
import com.icent.isaver.admin.util.AdminHelper;
import com.meous.common.resource.CommonResource;
import com.meous.common.spring.TransactionUtil;
import com.meous.digest.resource.DigestAlgorithm;
import com.meous.digest.util.DigestUtils;
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

    @Resource(name="isaverTxManager")
    private DataSourceTransactionManager transactionManager;

    @Override
    public ModelAndView findListUser(Map<String, String> parameters) {
        List<UsersBean> users = usersDao.findListUsers(parameters);
        Integer totalCount = usersDao.findCountUsers(parameters);

        AdminHelper.setPageTotalCount(parameters, totalCount);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("users",users);
        modelAndView.addObject("paramBean",parameters);
        modelAndView.addObject("roles",checkRole(roleDao.findListRole(null), parameters.get("roleId")));
        return modelAndView;
    }

    @Override
    public ModelAndView findByUser(Map<String, String> parameters) {
        UsersBean user = usersDao.findByUsers(parameters);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("user",user);
        modelAndView.addObject("roles",checkRole(roleDao.findListRole(null), parameters.get("roleId")));
        return modelAndView;
    }

    @Override
    public ModelAndView findByUserProfile(Map<String, String> parameters) {
        UsersBean user = usersDao.findByUsers(parameters);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("user",user);
        return modelAndView;
    }

    @Override
    public ModelAndView findByUserCheckExist(Map<String, String> parameters) {
        Integer count = usersDao.findByUserCheckExist(parameters);
        String existFlag = count > 0 ? CommonResource.YES : CommonResource.NO;

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("exist",existFlag);
        return modelAndView;
    }

    @Override
    public ModelAndView addUser(Map<String, String> parameters) {
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        parameters.put("userPassword", DigestUtils.digest(DigestAlgorithm.MD5, parameters.get("userPassword")));

        try {
            usersDao.addUsers(parameters);
            transactionManager.commit(transactionStatus);
        }catch(Exception e){
            transactionManager.rollback(transactionStatus);
            throw new IsaverException("");
        }
        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView saveUser(Map<String, String> parameters) {
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        if (!parameters.get("userPassword").isEmpty()) {
            parameters.put("userPassword", DigestUtils.digest(DigestAlgorithm.MD5, parameters.get("userPassword")));
        }

        try {
            usersDao.saveUsers(parameters);
            transactionManager.commit(transactionStatus);
        }catch(Exception e){
            transactionManager.rollback(transactionStatus);
            throw new IsaverException("");
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
            throw new IsaverException("");
        }
        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    private List<RoleBean> checkRole(List<RoleBean> roleBeans, String roleId){
        if(!roleId.equals("ROL000")){
            int index = -1;
            for(int i=0; i<roleBeans.size(); i++){
                RoleBean role = roleBeans.get(i);
                if(role.getRoleId().equals("ROL000")){
                    index = i;
                }
            }
            if(index > -1){
                roleBeans.remove(index);
            }
        }

        return roleBeans;
    }
}
