package spring;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.icent.isaver.admin.common.PropertyManager;
import com.icent.isaver.admin.common.XMLMarshaller;
import com.icent.isaver.admin.common.resource.CommonResource;
import com.icent.isaver.admin.svc.DatabaseSvc;
import com.icent.isaver.admin.util.*;
import com.meous.common.util.POIExcelView;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.MessageSource;
import org.springframework.context.annotation.*;
import org.springframework.context.support.ReloadableResourceBundleMessageSource;
import org.springframework.context.support.ResourceBundleMessageSource;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.oxm.jaxb.Jaxb2Marshaller;
import org.springframework.stereotype.Controller;
import org.springframework.web.accept.ContentNegotiationManager;
import org.springframework.web.accept.HeaderContentNegotiationStrategy;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.HandlerExceptionResolver;
import org.springframework.web.servlet.View;
import org.springframework.web.servlet.ViewResolver;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;
import org.springframework.web.servlet.i18n.LocaleChangeInterceptor;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;
import org.springframework.web.servlet.view.BeanNameViewResolver;
import org.springframework.web.servlet.view.ContentNegotiatingViewResolver;
import org.springframework.web.servlet.view.UrlBasedViewResolver;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;
import org.springframework.web.servlet.view.tiles3.TilesConfigurer;
import org.springframework.web.servlet.view.tiles3.TilesView;
import org.springframework.web.servlet.view.xml.MarshallingView;

import javax.inject.Inject;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Configuration
@EnableWebMvc
@ComponentScan(
        basePackages = "com.icent.isaver.admin"
        , useDefaultFilters = false
        , includeFilters = {
        @ComponentScan.Filter(type = FilterType.ANNOTATION, value = Controller.class)
}
)
public class WebConfigurer extends WebMvcConfigurerAdapter {
    static Logger logger = LoggerFactory.getLogger(WebConfigurer.class);

    @Inject
    private PropertyManager propertyManager;

    @Override
    @Description("HTML 정적 리소스 세팅")
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/assets/**").addResourceLocations("/assets/").setCachePeriod(31556926);
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(localeChangeInterceptor());
        registry.addInterceptor(authorizationInterceptor());
        registry.addInterceptor(xssInterceptor());
    }

    @Bean
    public AuthorizationInterceptor authorizationInterceptor() {
        AuthorizationInterceptor interceptor = new AuthorizationInterceptor();
        interceptor.setNoneAuthorTargets(propertyManager.getProperty("cnf.noneAuthTargets"));
        interceptor.setAliveCheckDelay(propertyManager.getProperty("aliveCheckDelay"));
        return interceptor;
    }

    @Override
    public void configureMessageConverters(List<HttpMessageConverter<?>> converters) {
        super.configureMessageConverters(converters);
        converters.add(htmlEscapingConveter());
    }

    private HttpMessageConverter<?> htmlEscapingConveter() {
        MappingJackson2HttpMessageConverter htmlEscapingConverter = new MappingJackson2HttpMessageConverter();
        ObjectMapper objectMapper = new ObjectMapper();
        objectMapper.getJsonFactory().setCharacterEscapes(new HTMLCharacterEscapes());
        htmlEscapingConverter.setObjectMapper(objectMapper);
        return htmlEscapingConverter;
    }

    @Bean
    public XSSInterceptor xssInterceptor() {
        XSSInterceptor interceptor = new XSSInterceptor();
        return interceptor;
    }

    @Bean
    public MappingJackson2JsonView jsonView() {
        return new MappingJackson2JsonView();
    }

    @Bean
    public Jaxb2Marshaller xmlMarshaller() {
        XMLMarshaller xmlMarshaller = new XMLMarshaller();
        List<String> packages = new ArrayList<String>() {{
            add("com/icent/isaver/admin/bean");
        }};
        xmlMarshaller.setBasePackages(packages);
        xmlMarshaller.addClasses(
                "java.util.ArrayList"
                , "java.util.HashMap"
        );
        return xmlMarshaller;
    }

    @Bean
    public MarshallingView xmlView() {
        MarshallingView marshallingView = new MarshallingView(xmlMarshaller());
//        marshallingView.setContentType("application/xml");
        marshallingView.setContentType("text/xml;charset=UTF-8");
        return marshallingView;
    }

    @Bean
    public ContentNegotiationManager negotiationManager() {
        ContentNegotiationManager negotiationManager = new ContentNegotiationManager(new HeaderContentNegotiationStrategy());
        return negotiationManager;
    }

    @Bean
    public ViewResolver contentNegotiatingViewResolver() {
        ContentNegotiatingViewResolver viewResolver = new ContentNegotiatingViewResolver();
        viewResolver.setOrder(1);
        viewResolver.setContentNegotiationManager(negotiationManager());

        List<View> views = new ArrayList<View>() {{
            add(jsonView());
            add(xmlView());
        }};

        viewResolver.setDefaultViews(views);
        return viewResolver;
    }

    @Bean
    public HandlerExceptionResolver exceptionResolver() {
        ExceptionResolver exceptionResolver = new ExceptionResolver();

        ResourceBundleMessageSource messageSource = new ResourceBundleMessageSource();
        messageSource.setDefaultEncoding(CommonResource.CHARSET_UTF8);
        messageSource.setBasenames(
            "properties/message/error"
        );

        exceptionResolver.setMessageSource(messageSource);
        return exceptionResolver;
    }

    @Bean
    public UrlBasedViewResolver viewResolver() {
        UrlBasedViewResolver resolver = new UrlBasedViewResolver();
        resolver.setViewClass(TilesView.class);
        resolver.setOrder(2);
        resolver.setCache(true);
        return resolver;
    }

    @Bean
    @Description("tiles 설정 로드")
    public TilesConfigurer tilesConfigurer() {
        TilesConfigurer configure = new TilesConfigurer();
        configure.setDefinitions("classpath:tiles/tiles.xml");
        return configure;
    }

    @Bean
    public MessageSource messageSource(){
        ReloadableResourceBundleMessageSource messageSource=new ReloadableResourceBundleMessageSource();
        messageSource.setDefaultEncoding(CommonResource.CHARSET_UTF8);
        messageSource.setBasenames(
                "classpath:properties/message/action"
                , "classpath:properties/message/area"
                , "classpath:properties/message/code"
                , "classpath:properties/message/common"
                , "classpath:properties/message/critical"
                , "classpath:properties/message/dashboard"
                , "classpath:properties/message/device"
                , "classpath:properties/message/deviceStatusHistory"
                , "classpath:properties/message/deviceSyncRequest"
                , "classpath:properties/message/event"
                , "classpath:properties/message/eventlog"
                , "classpath:properties/message/file"
                , "classpath:properties/message/fileSetting"
                , "classpath:properties/message/groupcode"
                , "classpath:properties/message/license"
                , "classpath:properties/message/login"
                , "classpath:properties/message/loginHistory"
                , "classpath:properties/message/menu"
                , "classpath:properties/message/notification"
                , "classpath:properties/message/resource"
                , "classpath:properties/message/role"
                , "classpath:properties/message/rolemenu"
                , "classpath:properties/message/statistics"
                , "classpath:properties/message/target"
                , "classpath:properties/message/user"
                , "classpath:properties/message/videoHistory"
                , "classpath:properties/message/systemLog"
        );
        return messageSource;
    }

    @Bean
    public CommonsMultipartResolver multipartResolver() {
        CommonsMultipartResolver resolver=new CommonsMultipartResolver();
        resolver.setDefaultEncoding(CommonResource.CHARSET_UTF8);
        resolver.setMaxUploadSize(5242880000L);
        return resolver;
    }

    @Bean
    public LocaleChangeInterceptor localeChangeInterceptor(){
        LocaleChangeInterceptor localeChangeInterceptor=new LocaleChangeInterceptor();
        //request로 넘어오는 language parameter를 받아서 locale로 설정 한다.
        localeChangeInterceptor.setParamName("lang");
        return localeChangeInterceptor;
    }

    @Bean
    public SessionLocaleResolver localeResolver() {
        SessionLocaleResolver localeResolver = new SessionLocaleResolver();
//        localeResolver.setDefaultLocale(Locale.KOREA); // change this
        return localeResolver;
    }

    @Bean
    public BeanNameViewResolver beanNameViewResolver() {
        BeanNameViewResolver resolver=new BeanNameViewResolver();
        resolver.setOrder(2);
        return resolver;
    }

    @Bean
    public POIExcelView excelDownloadView() {
        POIExcelView view=new POIExcelView();
        view.setFileExtension(".xls");
        return view;
    }

    @Bean
    public AppContextUtil appContextUtil() {
        AppContextUtil contextUtil=new AppContextUtil();
        return contextUtil;
    }

    @Bean
    public IsaverCriticalUtil isaverCriticalUtil() {
        IsaverCriticalUtil criticalUtil=new IsaverCriticalUtil();
        return criticalUtil;
    }

    @Bean
    public IsaverTargetUtil isaverTargetUtil() {
        IsaverTargetUtil targetUtil=new IsaverTargetUtil();
        return targetUtil;
    }

    @Bean
    public ExcuteHelper excuteHelper() {
        ExcuteHelper excuteHelper=new ExcuteHelper();
        return excuteHelper;
    }

    @Bean
    public HaspLicenseUtil haspLicenseUtil() {
        HaspLicenseUtil haspLicenseUtil=new HaspLicenseUtil();
        haspLicenseUtil.setHasp(propertyManager.getProperty("cnf.hostIp"), propertyManager.getProperty("cnf.noneLicenseTargets"), propertyManager.getProperty("deployMode"));
        return haspLicenseUtil;
    }

    @Bean
    public MqttUtil mqttUtil() {
        MqttUtil mqttUtil=new MqttUtil();
        mqttUtil.setIsMqtt(propertyManager.getProperty("socketMode").equals("mqtt"));
        if(mqttUtil.getIsMqtt()){
            mqttUtil.connect("tcp://"+ propertyManager.getProperty("mqtt.server.domain") +":"+propertyManager.getProperty("mqtt.server.port")
                    ,propertyManager.getProperty("mqttClientId")
                    ,propertyManager.getProperty("mqtt.server.userName")
                    ,propertyManager.getProperty("mqtt.server.password"));
        }
        return mqttUtil;
    }

    @Bean
    public String printVersion() {
        String version = null;
        StringBuilder loggerBuiler = new StringBuilder();
        loggerBuiler.append("\n==============================");
        loggerBuiler.append("\n= iSaver Admin");
        loggerBuiler.append("\n= Version : " + propertyManager.getProperty("cnf.server.minorVersion"));
        loggerBuiler.append("\n= DeployMode : " + propertyManager.getProperty("deployMode"));
        loggerBuiler.append("\n= SocketMode : " + propertyManager.getProperty("socketMode"));
        loggerBuiler.append("\n==============================");
        version = loggerBuiler.toString();
        loggerBuiler.setLength(0);
        logger.info(version);
        return version;
    }

    @Inject
    private DatabaseSvc databaseSvc;

    @Bean
    public String dbMigration() {
        Map<String, String> parameters = new HashMap<>();
        ModelAndView modelAndView = databaseSvc.postgresqlMigration(parameters);
        List<Map> resultList = (List<Map>) modelAndView.getModel().get("result");
        StringBuilder loggerBuiler = new StringBuilder();
        loggerBuiler.append("\n==============================");
        loggerBuiler.append("\n= Start Database Migration");
        for (Map result : resultList) {
            loggerBuiler.append("\n= " + result.get("version") + "[" + result.get("code") + "] - " + result.get("message"));
        }
        loggerBuiler.append("\n==============================");
        logger.info(loggerBuiler.toString());
        loggerBuiler.setLength(0);
        return null;
    }
}