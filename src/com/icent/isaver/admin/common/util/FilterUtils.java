package com.icent.isaver.admin.common.util;

import com.icent.isaver.admin.common.CrossDomainFilter;
import org.springframework.web.filter.CharacterEncodingFilter;

import javax.servlet.FilterRegistration;
import javax.servlet.ServletContext;
import java.util.EnumSet;

/**
 * Created by icent on 2017. 2. 1..
 */
public class FilterUtils {

    public FilterUtils() {
    }

    public static void useEncoding(ServletContext servletContext, String charset, String path) {
        FilterRegistration.Dynamic filter = servletContext.addFilter("CHARACTER_ENCODING_FILTER", CharacterEncodingFilter.class);
        filter.setInitParameter("encoding", charset);
        filter.setInitParameter("forceEncoding", "true");
        filter.addMappingForUrlPatterns((EnumSet)null, false, new String[]{path});
    }

    public static void useCrossDomain(ServletContext servletContext, String path) {
        servletContext.addFilter("crossDomainFilter", CrossDomainFilter.class).addMappingForUrlPatterns((EnumSet)null, false, new String[]{path});
    }
}
