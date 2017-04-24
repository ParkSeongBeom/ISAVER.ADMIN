package spring;

import com.icent.isaver.admin.common.util.ResourceFinder;
import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;

import javax.annotation.Resource;
import javax.sql.DataSource;

@Configuration
@MapperScan(
        basePackages = {"com.icent.isaver.repository.dao.base"}
        ,sqlSessionFactoryRef = "isaverSqlSessionFactory"
)
public class MybatisConfigurer {

    @Resource(name = "isaverDataSource")
    private DataSource isaverDataSource;

    @Bean
    public SqlSessionFactory isaverSqlSessionFactory(){
        SqlSessionFactoryBean sqlSessionFactoryBean = null;
        SqlSessionFactory sqlSessionFactory = null;
        sqlSessionFactoryBean = new SqlSessionFactoryBean();
        sqlSessionFactoryBean.setDataSource(isaverDataSource);

        org.springframework.core.io.Resource[] resources = ResourceFinder.getResources("com/icent/isaver/repository/mapper/base/", "*.xml");
        sqlSessionFactoryBean.setMapperLocations(resources);
        sqlSessionFactoryBean.setTypeAliases(ResourceFinder.getClassesArray("com/icent/isaver/repository/bean"));

        try {
            sqlSessionFactory = sqlSessionFactoryBean.getObject();
        } catch (Exception e) {
            sqlSessionFactory = null;
            e.printStackTrace();
        }
        return sqlSessionFactory;
    }

    @Bean
    public SqlSessionTemplate isaverSqlSessionTemplate(){
        return new SqlSessionTemplate(isaverSqlSessionFactory());
    }

    @Bean(name = "isaverTxManager")
    public DataSourceTransactionManager isaverTxManager(){
        return new DataSourceTransactionManager(isaverDataSource);
    }
}
