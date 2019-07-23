package com.icent.isaver.admin.dao;

import com.icent.isaver.admin.bean.FenceBean;

import java.util.List;
import java.util.Map;

public interface FenceDao {
    List<FenceBean> findListFence(Map<String, String> parameters);

    List<FenceBean> findListFenceForNotification();

    List<FenceBean> findListFenceForTest();

    void addFence(List<FenceBean> parameterList);

    void saveFence(Map<String, String> parameters);

    void removeFence(Map<String, String> parameters);
}
