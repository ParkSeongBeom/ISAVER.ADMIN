package spring;


import com.icent.isaver.admin.ApplicationContextManager;
import com.icent.isaver.admin.common.PropertyManager;
import com.icent.isaver.admin.common.PropertyManagerImpl;
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
    public static PropertySourcesPlaceholderConfigurer placeholderConfigurer() {
        return new PropertySourcesPlaceholderConfigurer();
    }

    @Bean
    public PropertyManager propertyManager() {
        return new PropertyManagerImpl();
    }

    @Bean
    public ApplicationContextManager applicationContextManager() {
        return new ApplicationContextManager();
    }
}
