package com.icent.isaver.admin.dao;

import com.icent.isaver.admin.bean.FenceDeviceBean;

import java.util.List;
import java.util.Map;

public interface FenceDeviceDao {
    List<FenceDeviceBean> findListFenceDevice(Map<String, String> parameters);

    void addFenceDevice(List<FenceDeviceBean> parameterList);

    void removeFenceDevice(Map<String, String> parameters);
}
