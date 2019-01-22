package com.icent.isaver.admin.common;

import org.jasypt.commons.CommonUtils;
import org.jasypt.encryption.StringEncryptor;
import org.springframework.context.EnvironmentAware;
import org.springframework.core.env.Environment;

/**
 * Created by icent on 2017. 2. 1..
 */
public class PropertyManagerImpl implements EnvironmentAware, PropertyManager {

    private Environment environment;

    private final StringEncryptor stringEncryptor;

    public PropertyManagerImpl(StringEncryptor stringEncryptor) {
        CommonUtils.validateNotNull(stringEncryptor, "Encryptor cannot be null");
        this.stringEncryptor = stringEncryptor;
    }

    public void setEnvironment(Environment environment) {
        this.environment = environment;
    }

    public String getProperty(String key) {
        return this.environment == null?null:decryptText(this.environment.getProperty(key));
    }

    private String decryptText(String value){
        return isEncrypted(value) ? this.stringEncryptor.decrypt(unwrapEncryptedValue(value)) : value;
    }

    private boolean isEncrypted(String value) {
        return value != null?value.startsWith("ENC("):false;
    }

    private String unwrapEncryptedValue(String value) {
        return value.substring("ENC(".length(), value.length()-1);
    }
}
