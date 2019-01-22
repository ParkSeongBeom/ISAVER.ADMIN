package main.java.context;

import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;
import spring.BeanConfigurer;
import spring.MybatisConfigurer;
import spring.PersistenceConfigurer;
import spring.WebConfigurer;

@Configuration
@Import({PersistenceConfigurer.class
        , BeanConfigurer.class
        , MybatisConfigurer.class
        , WebConfigurer.class
})
public class ApplicationContext {

}
