package com.icent.jabber.admin.svcImpl;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.resource.AdminResource;
import com.icent.jabber.admin.svc.SynchronizeSvc;
import com.icent.jabber.admin.util.AdminHelper;
import com.icent.jabber.admin.util.SynchronizeHelper;
import com.icent.jabber.repository.bean.*;
import com.icent.jabber.repository.dao.base.*;
import com.kst.common.springutil.TransactionUtil;
import com.kst.common.util.StringUtils;
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
 * 동기화 Service Implements
 * @author : psb
 * @version : 1.0
 * @since : 2015. 12. 22.
 * <pre>
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2015. 12. 22.     psb           최초 생성
 * </pre>
 */
@Service
public class SynchronizeSvcImpl implements SynchronizeSvc {
    @Inject
    private RequestSynchronizeDao requestSynchronizeDao;

    @Inject
    private SynchronizeUserDao synchronizeUserDao;

    @Inject
    private SynchronizeUserDetailDao synchronizeUserDetailDao;

    @Inject
    private SettingServerSynchronizeDao settingServerSynchronizeDao;

    @Inject
    private SynchronizeHelper synchronizeHelper;

    @Inject
    private ServerDao serverDao;

    @Resource(name="mybatisBaseTxManager")
    private DataSourceTransactionManager transactionManager;

    @Override
    public ModelAndView findListRequestSynchronize(Map<String, String> parameters) {
        List<RequestSynchronizeBean> requestSynchronizeList = requestSynchronizeDao.findListRequestSynchronize(parameters);
        Integer totalCount = requestSynchronizeDao.findCountRequestSynchronize(parameters);

        AdminHelper.setPageTotalCount(parameters, totalCount);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("requestSynchronizeList",requestSynchronizeList);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView findListSynchronizeUser(Map<String, String> parameters) {
        RequestSynchronizeBean requestSynchronize = requestSynchronizeDao.findByRequestSynchronize(parameters);
        List<SynchronizeUserBean> synchronizeUserList = synchronizeUserDao.findListSynchronizeUser(parameters);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("requestSynchronize",requestSynchronize);
        modelAndView.addObject("synchronizeUserList",synchronizeUserList);
        return modelAndView;
    }

    @Override
    public ModelAndView findListSynchronizeUserDetail(Map<String, String> parameters) {
        List<SynchronizeUserDetailBean> synchronizeUserDetailList = synchronizeUserDetailDao.findListSynchronizeUserDetail(parameters);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("synchronizeUserDetailList",synchronizeUserDetailList);
        return modelAndView;
    }

    @Override
    public ModelAndView findAllSettingServerSynchronize(Map<String, String> parameters) {
        List<SettingServerSynchronizeBean> settingServerSynchronizeList = settingServerSynchronizeDao.findAllSettingServerSynchronize();

        List<ServerBean> adServers = serverDao.findListServer(new HashMap<String, String>(){{put("type", AdminResource.SERVER_TYPE.get("ad"));}});
        List<ServerBean> ldapServers = serverDao.findListServer(new HashMap<String, String>(){{put("type", AdminResource.SERVER_TYPE.get("ldap"));}});
        List<ServerBean> cucmServers = serverDao.findListServer(new HashMap<String, String>(){{put("type", AdminResource.SERVER_TYPE.get("cucm"));}});
        List<ServerBean> cupServers = serverDao.findListServer(new HashMap<String, String>(){{put("type", AdminResource.SERVER_TYPE.get("cup"));}});
        List<ServerBean> cucServers = serverDao.findListServer(new HashMap<String, String>(){{put("type", AdminResource.SERVER_TYPE.get("cuc"));}});
        List<ServerBean> webexServers = serverDao.findListServer(new HashMap<String, String>(){{put("type", AdminResource.SERVER_TYPE.get("webex"));}});

        ModelAndView modelAndView = new ModelAndView();
        for (SettingServerSynchronizeBean settingServerSynchronize : settingServerSynchronizeList) {
            modelAndView.addObject(settingServerSynchronize.getSettingId(), settingServerSynchronize.getValue());
        }

        modelAndView.addObject("adServers",adServers);
        modelAndView.addObject("ldapServers",ldapServers);
        modelAndView.addObject("cucmServers",cucmServers);
        modelAndView.addObject("cupServers",cupServers);
        modelAndView.addObject("cucServers",cucServers);
        modelAndView.addObject("webexServers",webexServers);
        return modelAndView;
    }

    @Override
    public ModelAndView upsertSettingServerSynchronize(Map<String, String> parameters){
        String settingList = "";

        if (StringUtils.notNullCheck(parameters.get("settingList"))) {
            settingList = parameters.get("settingList");
        }

        Gson gson = new Gson();

        Type userType = new TypeToken<List<SettingServerSynchronizeBean>>() {}.getType();
        Collection<SettingServerSynchronizeBean> settingCollection = gson.fromJson(settingList, userType);

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try {
            if (settingCollection != null && settingCollection.size() > 0) {
                settingServerSynchronizeDao.upsertSettingServerSynchronize(settingCollection);
            }
            transactionManager.commit(transactionStatus);
        } catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView addSynchronizeByUser(Map<String, String> parameters){
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try {
            if(StringUtils.notNullCheck(parameters.get("synchronizeUserList"))){
                synchronizeHelper.addSynchronize(true, parameters.get("authUserId"),"0002","0001",parameters.get("synchronizeUserList"));
            }
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }catch(Exception e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView addSynchronizeByAll(Map<String, String> parameters){
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try {
            synchronizeHelper.addSynchronize(false, parameters.get("authUserId"),"0004","0001");
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }catch(Exception e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }
}
