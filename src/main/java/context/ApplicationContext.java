package context;

import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;
import spring.*;

@Configuration
@Import({PersistenceConfigurer.class
        , BeanConfigurer.class
        , MybatisConfigurer.class
        , WebConfigurer.class
        , MongoConfigurer.class
})
public class ApplicationContext {

}
