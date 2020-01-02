package com.icent.isaver.admin.dao;

import com.icent.isaver.admin.bean.VersionBean;

import java.util.Map;

public interface VersionDao {
    VersionBean findByVersion();

    void saveVersion(Map<String, String> parameters);
}
