package main.java.com.icent.isaver.admin.dao;

import com.icent.isaver.admin.bean.FenceLocationBean;

import java.util.List;
import java.util.Map;

public interface FenceLocationDao {
    void addFenceLocation(List<FenceLocationBean> parameterList);

    void removeFenceLocation(Map<String, String> parameters);
}
