package com.icent.isaver.admin.svcImpl;

import antlr.StringUtils;
import com.icent.isaver.admin.bean.JabberException;
import com.icent.isaver.admin.svc.AlarmTargetDeviceSvc;
import com.icent.isaver.repository.bean.AlarmTargetDeviceConfigBean;
import com.icent.isaver.repository.dao.base.AlarmTargetDeviceConfigDao;
import com.kst.common.spring.TransactionUtil;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionStatus;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.inject.Inject;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Created by icent on 2016. 11. 22..
 */
@Service
public class AlarmTargetDeviceSvcImpl implements AlarmTargetDeviceSvc {

    @Resource(name="mybatisIsaverTxManager")
    private DataSourceTransactionManager transactionManager;

    @Inject
    private AlarmTargetDeviceConfigDao alarmTargetDeviceConfigDao;

    @Override
    public ModelAndView appendAlarmTargetDevice(Map<String, String> parameters) {

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        List<AlarmTargetDeviceConfigBean> alarmTargetDeviceConfigBeanList = new ArrayList<>();

        String[] alarmTargetDeviceList= null;

        if(parameters.get("aDeviceId") != null && !parameters.get("aDeviceId").trim().isEmpty()) {
            alarmTargetDeviceList = parameters.get("aDeviceId").split(",");
        }

        if (alarmTargetDeviceList !=null ) {
            for (Integer i=0;i < alarmTargetDeviceList.length;i++) {

                AlarmTargetDeviceConfigBean configBean = new AlarmTargetDeviceConfigBean();

                configBean.setTargetDeviceId(parameters.get("tDeviceId"));
                configBean.setAlarmDeviceId(alarmTargetDeviceList[i]);

                alarmTargetDeviceConfigBeanList.add(configBean);
            }
        }

        try {
            alarmTargetDeviceConfigDao.removeAlarmTargetDevice(parameters);
            if (alarmTargetDeviceConfigBeanList.size() > 0) {
                alarmTargetDeviceConfigDao.addAlarmTargetDevice(alarmTargetDeviceConfigBeanList);
            }

            transactionManager.commit(transactionStatus);
        } catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

}
