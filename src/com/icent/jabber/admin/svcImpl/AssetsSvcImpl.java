package com.icent.jabber.admin.svcImpl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.svc.AssetsSvc;
import com.icent.jabber.admin.util.AdminHelper;
import com.icent.jabber.repository.bean.*;
import com.icent.jabber.repository.dao.base.AssetsDao;
import com.icent.jabber.repository.dao.base.UserAssetsDao;
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
 * 자원 관리 Service
 *
 * @author : psb
 * @version : 1.0
 * @since  : 2014. 10. 07.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 10. 07.     psb           최초 생성
 * </pre>
 */
@Service
public class AssetsSvcImpl implements AssetsSvc {

    @Inject
    private AssetsDao assetsDao;

    @Inject
    private UserAssetsDao userAssetsDao;

    @Resource(name="mybatisBaseTxManager")
    private DataSourceTransactionManager transactionManager;

    @Override
    public ModelAndView findListAssets(Map<String, String> parameters) {
        FindBean paramBean = AdminHelper.convertMapToBean(parameters,FindBean.class);

        List<AssetsBean> assetses = assetsDao.findListAssets(paramBean);
        Integer totalCount = assetsDao.findCountAssets(paramBean);

        AdminHelper.setPageTotalCount(paramBean,totalCount);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("assetses",assetses);
        modelAndView.addObject("paramBean",paramBean);
        return modelAndView;
    }

    @Override
    public ModelAndView findByAssets(Map<String, String> parameters) {
        AssetsBean paramBean = AdminHelper.convertMapToBean(parameters,AssetsBean.class);

        AssetsBean assets = null;
        List<UserAssetsBean> userAssetses = null;

        if(StringUtils.notNullCheck(paramBean.getAssetsId())){
            assets = assetsDao.findByAssets(paramBean);
            userAssetses = userAssetsDao.findListUserAssets(paramBean.getAssetsId());
        }

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("assets",assets);
        modelAndView.addObject("userAssetses",userAssetses);
        return modelAndView;
    }

    @Override
    public ModelAndView findListUserAssets(Map<String, String> parameters) {
        FindBean paramBean = AdminHelper.convertMapToBean(parameters, FindBean.class);

        List<UserBean> users = assetsDao.findListUser(paramBean);
        Integer totalCount = assetsDao.findCountUser(paramBean);

        AdminHelper.setPageTotalCount(paramBean, totalCount);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("users",users);
        modelAndView.addObject("paramBean",paramBean);
        return modelAndView;
    }

    @Override
    public ModelAndView addAssets(Map<String, String> parameters) {
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        AssetsBean paramBean = AdminHelper.convertMapToBean(parameters,AssetsBean.class);
        UserAssetsBean userAssetsBean = new UserAssetsBean();
        paramBean.setAssetsId(String.valueOf(UUID.randomUUID()));
        userAssetsBean.setAssetsId(paramBean.getAssetsId());

        try{
            assetsDao.addAssets(paramBean);

            if(StringUtils.notNullCheck(paramBean.getGroupUserId())){
                String[] groupList = paramBean.getGroupUserId().split(",");

                for(int i=0; i<groupList.length; i++){
                    userAssetsBean.setUserId(groupList[i]);

                    userAssetsDao.addUserAssets(userAssetsBean);
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
    public ModelAndView saveAssets(Map<String, String> parameters) {
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        AssetsBean paramBean = AdminHelper.convertMapToBean(parameters, AssetsBean.class);
        UserAssetsBean userAssetsBean = new UserAssetsBean();

        try{
            assetsDao.saveAssets(paramBean);
            userAssetsBean.setAssetsId(paramBean.getAssetsId());
            userAssetsDao.removeUserAssets(userAssetsBean);

            if(StringUtils.notNullCheck(paramBean.getGroupUserId())){
                String[] groupList = paramBean.getGroupUserId().split(",");

                for(int i=0; i<groupList.length; i++){
                    userAssetsBean.setUserId(groupList[i]);

                    userAssetsDao.addUserAssets(userAssetsBean);
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
    public ModelAndView removeAssets(Map<String, String> parameters) {
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        AssetsBean paramBean = AdminHelper.convertMapToBean(parameters, AssetsBean.class);
        UserAssetsBean userAssetsBean = new UserAssetsBean();

        try{
            userAssetsBean.setAssetsId(paramBean.getAssetsId());
            userAssetsDao.removeUserAssets(userAssetsBean);
            assetsDao.removeAssets(paramBean);

            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }
}
