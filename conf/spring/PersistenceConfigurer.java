package spring;

import com.icent.isaver.admin.common.PropertyManager;
import org.apache.commons.dbcp2.BasicDataSource;
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
