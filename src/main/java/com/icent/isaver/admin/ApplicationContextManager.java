package main.java.com.icent.isaver.admin;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.context.NoSuchMessageException;
import org.springframework.context.support.ResourceBundleMessageSource;

import java.util.Locale;

/**
 * Created by icent on 2017. 2. 1..
 */
public class ApplicationContextManager implements ApplicationContextAware {
    private static final ApplicationContextManager instance = new ApplicationContextManager();
    private ApplicationContext applicationContext = null;
    private ResourceBundleMessageSource messageSource = null;

    public ApplicationContextManager() {
    }

    public void setApplicationContext(ApplicationContext arg0) throws BeansException {
        instance.applicationContext = arg0;
    }

    public static ApplicationContextManager getInstance() {
        return instance;
    }

    public <T> T getBean(Class<T> clazz) {
        return this.applicationContext.getBean(clazz);
    }

    public Object getBean(String className) {
        return this.applicationContext.getBean(className);
    }

    public void setMessageSource(ResourceBundleMessageSource messageSource) {
        this.messageSource = messageSource;
    }

    public String getMessage(String key) {
        String returnMessage = null;

        try {
            returnMessage = this.messageSource.getMessage(key, (Object[])null, Locale.getDefault());
        } catch (NoSuchMessageException var4) {
            var4.printStackTrace();
        }

        return returnMessage;
    }

    public String getMessage(String key, String expMessage) {
        String returnMessage = null;

        try {
            returnMessage = this.messageSource.getMessage(key, (Object[])null, Locale.getDefault());
        } catch (NoSuchMessageException var5) {
            if(expMessage != null) {
                returnMessage = expMessage;
            } else {
                returnMessage = "";
            }
        }

        return returnMessage;
    }
}
