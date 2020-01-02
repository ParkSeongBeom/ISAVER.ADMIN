package com.icent.isaver.admin.dao;

import java.util.Map;

public interface PgsqlMigrationDao {
    void migration(Map<String, String> parameters);
}
