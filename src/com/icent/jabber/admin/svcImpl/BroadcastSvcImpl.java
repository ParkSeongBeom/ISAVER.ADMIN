package com.icent.jabber.admin.svcImpl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.svc.BroadcastSvc;
import com.icent.jabber.admin.util.AdminHelper;
import com.icent.jabber.repository.bean.BroadcastBean;
import com.icent.jabber.repository.bean.FindBean;
import com.icent.jabber.repository.bean.UserBean;
import com.icent.jabber.repository.dao.base.BroadcastDao;
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
import java.util.UUID;

/**
 * 동보방송 관리 Service Interface
 *
 * @author : psb
 * @version : 1.0
 * @since : 2014. 6. 2.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 6. 2.     psb           최초 생성
 * </pre>
 */
@Service
public class BroadcastSvcImpl implements BroadcastSvc {

    @Inject
    private BroadcastDao broadcastDao;

    @Resource(name="mybatisBaseTxManager")
    private DataSourceTransactionManager transactionManager;

    @Override
    public ModelAndView findListBroadcast(Map<String, String> parameters) {
        FindBean paramBean = AdminHelper.convertMapToBean(parameters,FindBean.class);

        List<BroadcastBean> broadcasts = broadcastDao.findListBroadcast(paramBean);
        Integer totalCount = broadcastDao.findCountBroadcast(paramBean);

        AdminHelper.setPageTotalCount(paramBean,totalCount);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("broadcasts",broadcasts);
        modelAndView.addObject("paramBean",paramBean);
        return modelAndView;
    }

    @Override
    public ModelAndView findListUser(Map<String, String> parameters) {
        FindBean paramBean = AdminHelper.convertMapToBean(parameters, FindBean.class);

        List<UserBean> users = broadcastDao.findListUser(paramBean);
        Integer totalCount = broadcastDao.findCountUser(paramBean);

        AdminHelper.setPageTotalCount(paramBean, totalCount);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("users",users);
        modelAndView.addObject("paramBean",paramBean);
        return modelAndView;
    }

    @Override
    public ModelAndView findByBroadcast(Map<String, String> parameters) {
        BroadcastBean paramBean = AdminHelper.convertMapToBean(parameters,BroadcastBean.class);

        BroadcastBean broadcast = null;
        List<BroadcastBean> broadcastGroups = null;

        if(StringUtils.notNullCheck(paramBean.getBroadcastId())){
            broadcast = broadcastDao.findByBroadcast(paramBean);
            broadcastGroups = broadcastDao.findListBroadcastGroup(paramBean);
        }

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("broadcast",broadcast);
        modelAndView.addObject("broadcastGroups",broadcastGroups);
        return modelAndView;
    }

    @Override
    public ModelAndView addBroadcast(Map<String, String> parameters) {
        BroadcastBean paramBean = AdminHelper.convertMapToBean(parameters,BroadcastBean.class);

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            paramBean.setBroadcastId(String.valueOf(UUID.randomUUID()));

            broadcastDao.addBroadcast(paramBean);

            String[] groupList = paramBean.getBroadcastGroup().split("\\|");

            for(int i=0; i<groupList.length; i++){
                String gubn = groupList[i].split(",")[0];
                String userId = groupList[i].split(",")[1];

                paramBean.setUserId(userId);
                paramBean.setBroadcastGroupId(String.valueOf(UUID.randomUUID()));
                if(gubn.equals("O")){
                    broadcastDao.addBroadcastOwner(paramBean);
                }else if(gubn.equals("U")) {
                    broadcastDao.addBroadcastUser(paramBean);
                }
            }

            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            e.printStackTrace();
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView saveBroadcast(Map<String, String> parameters) {
        BroadcastBean paramBean = AdminHelper.convertMapToBean(parameters,BroadcastBean.class);

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            broadcastDao.saveBroadcast(paramBean);
            broadcastDao.removeBroadcastOwner(paramBean);
            broadcastDao.removeBroadcastUser(paramBean);

            String[] groupList = paramBean.getBroadcastGroup().split("\\|");

            for(int i=0; i<groupList.length; i++){
                String gubn = groupList[i].split(",")[0];
                String userId = groupList[i].split(",")[1];

                paramBean.setUserId(userId);
                paramBean.setBroadcastGroupId(String.valueOf(UUID.randomUUID()));
                if(gubn.equals("O")){
                    broadcastDao.addBroadcastOwner(paramBean);
                }else if(gubn.equals("U")) {
                    broadcastDao.addBroadcastUser(paramBean);
                }
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
    public ModelAndView removeBroadcast(Map<String, String> parameters) {
        BroadcastBean paramBean = AdminHelper.convertMapToBean(parameters,BroadcastBean.class);

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            broadcastDao.removeBroadcastOwner(paramBean);
            broadcastDao.removeBroadcastUser(paramBean);
            broadcastDao.removeBroadcast(paramBean);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }
}
