package com.icent.isaver.admin.dao;

import com.icent.isaver.admin.bean.DeviceStatusHistoryBean;

import java.util.List;
import java.util.Map;

public interface DeviceStatusHistoryDao {
    List<DeviceStatusHistoryBean> findListDeviceStatusHistory(Map<String, String> parameters);

    Integer findCountDeviceStatusHistory(Map<String, String> parameters);
}
