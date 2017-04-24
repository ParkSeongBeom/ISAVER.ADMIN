package com.icent.isaver.admin.common;


import org.springframework.context.EnvironmentAware;
import org.springframework.core.env.Environment;

/**
 * Created by icent on 2017. 2. 1..
 */
public class PropertyManagerImpl implements EnvironmentAware, PropertyManager {

    private Environment environment;

    public PropertyManagerImpl() {
    }

    public void setEnvironment(Environment environment) {
        this.environment = environment;
    }

    public String getProperty(String key) {
        return this.environment == null?null:this.environment.getProperty(key);
    }
}
