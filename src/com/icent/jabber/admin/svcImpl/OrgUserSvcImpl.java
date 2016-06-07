package com.icent.jabber.admin.svcImpl;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.svc.OrgUserSvc;
import com.icent.jabber.admin.util.AdminHelper;
import com.icent.jabber.repository.bean.FindBean;
import com.icent.jabber.repository.bean.OrgUserBean;
import com.icent.jabber.repository.dao.base.OrgUserDao;
import com.kst.common.springutil.TransactionUtil;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionStatus;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.inject.Inject;
import java.lang.reflect.Type;
import java.util.*;

/**
 * 사용자 조직도 Service
 *
 * @author : dhj
 * @version : 1.0
 * @since : 2014. 6. 17.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 6. 17.     dhj           최초 생성
 * </pre>
 */
@Service
public class OrgUserSvcImpl implements OrgUserSvc {

    @Inject
    private OrgUserDao orgUserDao;

    @Resource(name="mybatisBaseTxManager")
    private DataSourceTransactionManager transactionManager;

    @Override
    public ModelAndView findListOrgUser(Map<String, String> parameters) {
        FindBean paramBean = AdminHelper.convertMapToBean(parameters, FindBean.class);

        ArrayList<HashMap<String,Object>> orgUsers = orgUserDao.findAllOrgUserMap(paramBean);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("orgUsers",orgUsers);
        return modelAndView;
    }

    @Override
    public ModelAndView addOrgUser(Map<String, String> parameters) {

        String roleIds = "";
        if (!parameters.get("roleIds").isEmpty()) {
            roleIds = parameters.get("roleIds");
        }

        Gson gson = new Gson();

        Type typeOfObjectsList = new TypeToken<List<OrgUserBean>>() {}.getType();
        Collection<OrgUserBean> collection = gson.fromJson(roleIds, typeOfObjectsList);

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try {
            if (collection != null && collection.size() > 0) {
                orgUserDao.addAllOrgUser(collection);
            }
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView removeOrgUser(Map<String, String> parameters) {

        OrgUserBean paramBean = AdminHelper.convertMapToBean(parameters, OrgUserBean.class);

        String roleIds = "";
        if (!parameters.get("roleIds").isEmpty()) {
            roleIds = parameters.get("roleIds");
        }

        Gson gson = new Gson();

        Type typeOfObjectsList = new TypeToken<List<OrgUserBean>>() {}.getType();
        Collection<OrgUserBean> collection = gson.fromJson(roleIds, typeOfObjectsList);

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try {
            if (collection != null && collection.size() > 0) {
                orgUserDao.removeOrgUsers(collection);
            }
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView removeOrgUsers(Map<String, String> parameters) {

        String roleIds = "";
        if (!parameters.get("roleIds").isEmpty()) {
            roleIds = parameters.get("roleIds");
        }

        Gson gson = new Gson();

        Type typeOfObjectsList = new TypeToken<List<OrgUserBean>>() {}.getType();
        Collection<OrgUserBean> collection = gson.fromJson(roleIds, typeOfObjectsList);

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try {
            if (collection != null && collection.size() > 0) {
                orgUserDao.removeOrgUsers(collection);
            }
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }
}
