package context;

import ch.qos.logback.core.joran.spi.JoranException;
import ch.qos.logback.ext.spring.LogbackConfigurer;
import com.kst.common.resource.CommonResource;
import com.kst.common.spring.FilterUtils;
import org.springframework.web.context.ContextLoaderListener;
import org.springframework.web.context.support.AnnotationConfigWebApplicationContext;
import org.springframework.web.filter.CharacterEncodingFilter;
import org.springframework.web.servlet.DispatcherServlet;

import javax.servlet.*;
import javax.servlet.ServletContext;
import java.io.FileNotFoundException;
import java.util.EnumSet;

/**
 * Created by icent on 2017. 2. 1..
 */
public class WebApplicationInitializer implements org.springframework.web.WebApplicationInitializer {

    @Override
    public void onStartup(ServletContext servletContext) throws ServletException {
        AnnotationConfigWebApplicationContext applicationContext = new AnnotationConfigWebApplicationContext();
        applicationContext.register(ApplicationContext.class);

        servletContext.addListener(new ContextLoaderListener(applicationContext));
        FilterUtils.useEncoding(servletContext, CommonResource.CHARSET_UTF8, "/*");
        FilterUtils.useCrossDomain(servletContext,"/*");

        try {
            LogbackConfigurer.initLogging("classpath:logback/logback.xml");
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (JoranException e) {
            e.printStackTrace();
        }


        AnnotationConfigWebApplicationContext restContext = new AnnotationConfigWebApplicationContext();
        restContext.register(context.ServletContext.class);

//        ServletRegistration.Dynamic dispatcher = servletContext.addServlet("rest-servlet",new DispatcherServlet(restContext));
//        dispatcher.setLoadOnStartup(1);
//        dispatcher.addMapping("/*");
        ServletRegistration.Dynamic dispatcher = servletContext.addServlet("dispatcher",new DispatcherServlet(restContext));
        dispatcher.setLoadOnStartup(1);
        dispatcher.addMapping("/");

        FilterRegistration.Dynamic characterEncodingFilter = servletContext.addFilter("characterEncodingFilter", new CharacterEncodingFilter());
        characterEncodingFilter.addMappingForUrlPatterns(EnumSet.allOf(DispatcherType.class), true, "/*");
        characterEncodingFilter.setInitParameter("encoding", "UTF-8");
        characterEncodingFilter.setInitParameter("forceEncoding", "true");
    }
}
