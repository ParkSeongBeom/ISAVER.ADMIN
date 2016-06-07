package com.icent.jabber.admin.util;

import java.util.Locale;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

/**
 *
 *
 * @author : dhj
 * @version : 1.0
 * @since : 2014. 6. 3.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 6. 3.     dhj           최초 생성
 * </pre>
 */
public class AppContextUtil implements ApplicationContextAware {
    private static final AppContextUtil instance = new AppContextUtil();
    private ApplicationContext applicationContext = null;

    private AppContextUtil() {
    }

    public static AppContextUtil getInstance() {
        return instance;
    }

    public <T> T getBean(Class<T> clazz) {
        return applicationContext.getBean(clazz);
    }

    public Object getBean(String className) {
        return applicationContext.getBean(className);
    }

    public String getMeesage(String code) {

        return applicationContext.getMessage(code, null, Locale.KOREA);
    }

    public String getMeesage(String code, String[] args) {

        return applicationContext.getMessage(code, args, Locale.KOREA);
    }

    public String getMeesage(String code, Locale locale) {

        return applicationContext.getMessage(code, null, locale);
    }

    public String getMeesage(String code, String[] args, Locale locale) {

        return applicationContext.getMessage(code, args, locale);
    }

    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        instance.applicationContext = applicationContext;
    }
}
