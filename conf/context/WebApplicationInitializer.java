package context;

import ch.qos.logback.core.joran.spi.JoranException;
import ch.qos.logback.ext.spring.LogbackConfigurer;
import com.icent.dhj.util.FindSystemUtil;
import com.icent.dhj.util.ResultSystemBean;
import com.kst.common.resource.CommonResource;
import com.kst.common.spring.FilterUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.context.ContextLoaderListener;
import org.springframework.web.context.support.AnnotationConfigWebApplicationContext;
import org.springframework.web.filter.CharacterEncodingFilter;
import org.springframework.web.servlet.DispatcherServlet;

import javax.servlet.*;
import javax.servlet.ServletContext;
import java.io.FileNotFoundException;
import java.util.EnumSet;
import java.util.HashSet;

/**
 * Created by icent on 2017. 2. 1..
 */
public class WebApplicationInitializer implements org.springframework.web.WebApplicationInitializer {

    static Logger logger = LoggerFactory.getLogger(WebApplicationInitializer.class);

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

        // jsessionid 값이 url에 노출되는것을 방지
        HashSet<SessionTrackingMode> set = new HashSet<SessionTrackingMode>();
        set.add(SessionTrackingMode.COOKIE);
        servletContext.setSessionTrackingModes(set);

        // H/W 라이선스 체크
        FindSystemUtil findSystemUtil = new FindSystemUtil();
//        ResultSystemBean resultSystemBean = findSystemUtil.loadSystemUUID("dev", "/isaver/was/bin/uuid.key");
        ResultSystemBean resultSystemBean = findSystemUtil.loadSystemUUID("icent", "/isaver/was/bin/uuid.key");

        if(!resultSystemBean.getaBoolean()){
            logger.error(resultSystemBean.getLogdata());
            System.exit(0);

//            try {
//                Process p = Runtime.getRuntime().exec("systemctl stop isaver_web");
//            } catch (IOException e1) {
//                e1.printStackTrace();
//            }
        }
    }
}
