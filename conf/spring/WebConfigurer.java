package spring;

import com.icent.isaver.admin.common.PropertyManager;
import com.icent.isaver.admin.common.resource.CommonResource;
import com.icent.isaver.admin.util.*;
import com.kst.common.util.POIExcelView;
import com.sun.org.glassfish.gmbal.Description;
import org.codehaus.jackson.map.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.MessageSource;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.FilterType;
import org.springframework.context.support.ReloadableResourceBundleMessageSource;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.json.MappingJacksonHttpMessageConverter;
import org.springframework.stereotype.Controller;
import org.springframework.web.accept.ContentNegotiationManager;
import org.springframework.web.accept.HeaderContentNegotiationStrategy;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;
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
import org.springframework.web.servlet.view.json.MappingJacksonJsonView;
import org.springframework.web.servlet.view.tiles3.TilesConfigurer;
import org.springframework.web.servlet.view.tiles3.TilesView;

import javax.inject.Inject;
import java.util.ArrayList;
import java.util.List;

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
        return interceptor;
    }

    @Override
    public void configureMessageConverters(List<HttpMessageConverter<?>> converters) {
        super.configureMessageConverters(converters);
        converters.add(htmlEscapingConveter());
    }

    private HttpMessageConverter<?> htmlEscapingConveter() {
        MappingJacksonHttpMessageConverter htmlEscapingConverter = new MappingJacksonHttpMessageConverter();
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
    public MappingJacksonJsonView jsonView() {
        return new MappingJacksonJsonView();
    }

//    @Bean
//    public Jaxb2Marshaller xmlMarshaller() {
//        XMLMarshaller xmlMarshaller = new XMLMarshaller();
//        List<String> packages = new ArrayList<String>() {{
//            add("**.bean");
//        }};
//        xmlMarshaller.setBasePackages(packages);
//        xmlMarshaller.addClasses(
//                "java.util.ArrayList"
//                , "java.util.HashMap"
//        );
//        return xmlMarshaller;
//    }
//
//    @Bean
//    public MarshallingView xmlView() {
//        MarshallingView marshallingView = new MarshallingView(xmlMarshaller());
//        marshallingView.setContentType("application/xml");
//        return marshallingView;
//    }

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
//            add(xmlView());
        }};

        viewResolver.setDefaultViews(views);
        return viewResolver;
    }

//    @Bean
//    public HandlerExceptionResolver exceptionResolver() {
//        ExceptionResolver exceptionResolver = new ExceptionResolver();
//
//        ResourceBundleMessageSource messageSource = new ResourceBundleMessageSource();
//        messageSource.setDefaultEncoding(CommonResource.CHARSET_UTF8);
//        messageSource.setBasenames(
//            "properties/message/error"
//        );
//
//        exceptionResolver.setMessageSource(messageSource);
//        return exceptionResolver;
//    }

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
            "classpath:properties/message/common"
            ,"classpath:properties/message/login"
            ,"classpath:properties/message/user"
            ,"classpath:properties/message/menu"
            ,"classpath:properties/message/role"
            ,"classpath:properties/message/rolemenu"
            ,"classpath:properties/message/action"
            ,"classpath:properties/message/event"
            ,"classpath:properties/message/eventlog"
            ,"classpath:properties/message/code"
            ,"classpath:properties/message/groupcode"
            ,"classpath:properties/message/license"
            ,"classpath:properties/message/resource"
            ,"classpath:properties/message/area"
            ,"classpath:properties/message/device"
            ,"classpath:properties/message/loginHistory"
            ,"classpath:properties/message/dashboard"
            ,"classpath:properties/message/statistics"
            ,"classpath:properties/message/deviceSyncRequest"
            ,"classpath:properties/message/file"
            ,"classpath:properties/message/critical"
            ,"classpath:properties/message/alarm"
            ,"classpath:properties/message/login"
            ,"classpath:properties/message/notification"
            ,"classpath:properties/message/target"
            ,"classpath:properties/message/deviceStatusHistory"
            ,"classpath:properties/message/videoHistory"
            ,"classpath:properties/message/fileSetting"
        );
        return messageSource;
    }

    @Bean
    public CommonsMultipartResolver multipartResolver() {
        CommonsMultipartResolver resolver=new CommonsMultipartResolver();
        resolver.setDefaultEncoding(CommonResource.CHARSET_UTF8);
        resolver.setMaxUploadSize(100000000);
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
    public HaspLicenseUtil haspLicenseUtil() {
        HaspLicenseUtil haspLicenseUtil=new HaspLicenseUtil();
        haspLicenseUtil.setHasp(propertyManager.getProperty("cnf.fileAddress"), propertyManager.getProperty("cnf.noneLicenseTargets"));
        return haspLicenseUtil;
    }

    @Bean
    public String printVersion() {
        String version = null;
        StringBuilder loggerBuiler = new StringBuilder();
        loggerBuiler.append("\n==============================");
        loggerBuiler.append("\n= iSaver Admin Version : ").append(propertyManager.getProperty("cnf.server.minorVersion"));
        loggerBuiler.append("\n==============================");
        version = loggerBuiler.toString();
        loggerBuiler.setLength(0);

        logger.info(version);
        return version;
    }
}