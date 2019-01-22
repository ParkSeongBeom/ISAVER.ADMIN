package main.java.spring;

import com.icent.isaver.admin.ApplicationContextManager;
import com.icent.isaver.admin.common.PropertyManager;
import com.icent.isaver.admin.common.PropertyManagerImpl;
import org.jasypt.encryption.StringEncryptor;
import org.jasypt.encryption.pbe.StandardPBEStringEncryptor;
import org.jasypt.encryption.pbe.config.EnvironmentStringPBEConfig;
import org.jasypt.spring31.properties.EncryptablePropertySourcesPlaceholderConfigurer;
import org.springframework.context.annotation.*;
import org.springframework.context.support.PropertySourcesPlaceholderConfigurer;
import org.springframework.stereotype.Service;

@Configuration
@ComponentScan(
        basePackages = "com.icent.isaver.admin"
        , useDefaultFilters = false
        , includeFilters = {
        @ComponentScan.Filter(type = FilterType.ANNOTATION, value = Service.class)
}
)
@PropertySource("classpath:properties/config.properties")
public class BeanConfigurer {
    @Bean
    public static EnvironmentStringPBEConfig environmentVariablesConfiguration() {
        EnvironmentStringPBEConfig environmentVariablesConfiguration = new EnvironmentStringPBEConfig();
        environmentVariablesConfiguration.setAlgorithm("PBEWithMD5AndDES");
        environmentVariablesConfiguration.setPassword("isaverPassKey");
        return environmentVariablesConfiguration;
    }

    @Bean
    public static StringEncryptor configurationEncryptor() {
        StandardPBEStringEncryptor configurationEncryptor = new StandardPBEStringEncryptor();
        configurationEncryptor.setConfig(environmentVariablesConfiguration());
        return configurationEncryptor;
    }

    @Bean
    public static PropertySourcesPlaceholderConfigurer placeholderConfigurer() {
        return new EncryptablePropertySourcesPlaceholderConfigurer(configurationEncryptor());
    }

//    @Bean
//    public static PropertySourcesPlaceholderConfigurer placeholderConfigurer() {
//        return new PropertySourcesPlaceholderConfigurer();
//    }

    @Bean
    public PropertyManager propertyManager() {
        return new PropertyManagerImpl(configurationEncryptor());
//        return new PropertyManagerImpl();
    }

    @Bean
    public ApplicationContextManager applicationContextManager() {
        return new ApplicationContextManager();
    }
}
