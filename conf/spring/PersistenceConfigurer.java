package spring;

import com.icent.isaver.admin.common.PropertyManager;
import org.apache.commons.dbcp2.BasicDataSource;
import org.jasypt.encryption.pbe.PooledPBEStringEncryptor;
import org.jasypt.encryption.pbe.StandardPBEStringEncryptor;
import org.jasypt.encryption.pbe.config.SimpleStringPBEConfig;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import javax.inject.Inject;
import javax.sql.DataSource;

@Configuration
public class PersistenceConfigurer {

    @Inject
    private PropertyManager propertyManager;

    @Bean
    public DataSource isaverDataSource() {
        BasicDataSource dataSource = new BasicDataSource();

//        StandardPBEStringEncryptor encryptor = new StandardPBEStringEncryptor();
//        encryptor.setAlgorithm("PBEWithMD5AndDES");
//        encryptor.setPassword("isaverPassKey");
//        System.out.println(encryptor.encrypt("jdbc:postgresql://172.16.110.200:5432/isaver?allowMultiQueries=true&useUnicode=true&characterEncoding=utf8"));
//        System.out.println(encryptor.encrypt("isaveruser"));

        dataSource.setDriverClassName(propertyManager.getProperty("db.isaver.driver"));
        dataSource.setUrl(propertyManager.getProperty("db.isaver.url"));
        dataSource.setUsername(propertyManager.getProperty("db.isaver.username"));
        dataSource.setPassword(propertyManager.getProperty("db.isaver.password"));
        dataSource.setValidationQuery(propertyManager.getProperty("db.isaver.validateQuery"));

        int maxConnect = Integer.valueOf(propertyManager.getProperty("db.isaver.maxconnect"));
        int minConnect = Integer.valueOf(propertyManager.getProperty("db.isaver.minconnect"));
        int wait = Integer.valueOf(propertyManager.getProperty("db.isaver.wait"));

        dataSource.setDefaultAutoCommit(false);
        dataSource.setInitialSize(minConnect);
        dataSource.setMaxTotal(maxConnect);
        dataSource.setMinIdle(minConnect);
        dataSource.setMaxIdle(maxConnect);
        dataSource.setMaxWaitMillis(wait);
        return dataSource;
    }
}
