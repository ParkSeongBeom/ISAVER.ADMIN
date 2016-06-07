package com.icent.jabber.admin.svcImpl;

import com.icent.jabber.admin.resource.AdminSyncResource;
import com.icent.jabber.admin.svc.SettingServerSynchronizeSvc;
import com.icent.jabber.repository.bean.SettingServerSynchronizeBean;
import com.icent.jabber.repository.dao.base.SettingServerSynchronizeDao;
import org.springframework.stereotype.Service;

import javax.inject.Inject;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by icent on 16. 1. 13..
 */
@Service
public class SettingServerSynchronizeSvcImpl implements SettingServerSynchronizeSvc{

    @Inject
    private SettingServerSynchronizeDao settingServerSynchronizeDao;


    @Override
    public Map<String, String> getSettingServerSyncFunc() {
        Boolean cucDetailLoadFlag = false;

        Map<String, String> objectAsMap = new HashMap<>();
        List<SettingServerSynchronizeBean> settings =  settingServerSynchronizeDao.findListSettingServerSynchronize(new HashMap<String, String>(){{put("searchId","UseYn"); put("value","Y");}});
        for (SettingServerSynchronizeBean bean : settings) {
            objectAsMap.put(bean.getSettingId(), bean.getValue());

            if (AdminSyncResource.CUC_USE_YN.equals(bean.getSettingId())) {
                cucDetailLoadFlag = true;
            }
        }

        if (cucDetailLoadFlag) {
            settings =  settingServerSynchronizeDao.findListSettingServerSynchronizeCucDetail();
            for (SettingServerSynchronizeBean bean : settings) {
                objectAsMap.put(bean.getSettingId(), bean.getValue());
            }
        }

        return objectAsMap;
    }
}
