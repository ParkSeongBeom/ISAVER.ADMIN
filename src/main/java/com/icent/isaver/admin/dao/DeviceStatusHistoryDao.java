package com.icent.isaver.admin.dao;

import com.icent.isaver.admin.bean.DeviceStatusHistoryBean;

import java.util.List;
import java.util.Map;

public interface DeviceStatusHistoryDao {
    List<DeviceStatusHistoryBean> findListDeviceStatusHistory(Map<String, String> parameters);

    Integer findCountDeviceStatusHistory(Map<String, String> parameters);

    /**
     * 엑셀다운로드용
     * @return the list
     */
    List<DeviceStatusHistoryBean> findListDeviceStatusHistoryForExcel(Map<String, String> parameters);
}
