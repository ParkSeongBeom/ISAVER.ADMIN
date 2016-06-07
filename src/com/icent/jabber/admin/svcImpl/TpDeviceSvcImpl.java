package com.icent.jabber.admin.svcImpl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.svc.TpDeviceSvc;
import com.icent.jabber.admin.util.AdminHelper;
import com.icent.jabber.repository.bean.TpDeviceBean;
import com.icent.jabber.repository.bean.FindBean;
import com.icent.jabber.repository.dao.base.TpDeviceDao;
import com.kst.common.springutil.TransactionUtil;
import com.kst.common.util.StringUtils;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionStatus;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

/**
 * TP 장비 관리 Service Interface
 *
 * @author : psb
 * @version : 1.0
 * @since : 2014. 6. 10.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 6. 10.     psb           최초 생성
 * </pre>
 */
@Service
public class TpDeviceSvcImpl implements TpDeviceSvc {

    @Inject
    private TpDeviceDao tpDeviceDao;

    @Resource(name="mybatisBaseTxManager")
    private DataSourceTransactionManager transactionManager;

    @Override
    public ModelAndView findListTpDevice(Map<String, String> parameters) {
        FindBean paramBean = AdminHelper.convertMapToBean(parameters,FindBean.class);

        List<TpDeviceBean> tpDevices = tpDeviceDao.findListTpDevice(paramBean);
        Integer totalCount = tpDeviceDao.findCountTpDevice(paramBean);

        AdminHelper.setPageTotalCount(paramBean,totalCount);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("tpDevices",tpDevices);
        modelAndView.addObject("paramBean",paramBean);
        return modelAndView;
    }

    @Override
    public ModelAndView findByTpDevice(Map<String, String> parameters) {
        TpDeviceBean paramBean = AdminHelper.convertMapToBean(parameters,TpDeviceBean.class);

        TpDeviceBean tpDevice = null;

        if(StringUtils.notNullCheck(paramBean.getDeviceId())){
            tpDevice = tpDeviceDao.findByTpDevice(paramBean);
        }

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("tpDevice",tpDevice);
        return modelAndView;
    }

    @Override
    public ModelAndView addTpDevice(HttpServletRequest request, Map<String, String> parameters) {
        TpDeviceBean paramBean = AdminHelper.convertMapToBean(parameters,TpDeviceBean.class);

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try{
            paramBean.setDeviceId(StringUtils.getGUID36());
            tpDeviceDao.addTpDevice(paramBean);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView saveTpDevice(HttpServletRequest request, Map<String, String> parameters) {
        TpDeviceBean paramBean = AdminHelper.convertMapToBean(parameters,TpDeviceBean.class);

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try{
            tpDeviceDao.saveTpDevice(paramBean);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView removeTpDevice(Map<String, String> parameters) {
        TpDeviceBean paramBean = AdminHelper.convertMapToBean(parameters,TpDeviceBean.class);

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            String[] deviceId = paramBean.getDeviceId().split(",");

            for (int i=0; i<deviceId.length; i++){
                paramBean.setDeviceId(deviceId[i]);
                tpDeviceDao.removeTpDevice(paramBean);
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
