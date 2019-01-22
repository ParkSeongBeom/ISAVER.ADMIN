package com.icent.isaver.admin.common;

import javax.servlet.*;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Created by icent on 2017. 2. 1..
 */
public class CrossDomainFilter implements Filter {

    private static int CACHE_DURTION = 60;

    public CrossDomainFilter() {
    }

    public static void setCacheDurtion(int cacheDuration) {
        CACHE_DURTION = cacheDuration;
    }

    public void init(FilterConfig filterConfig) throws ServletException {
    }

    public void destroy() {
    }

    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        HttpServletResponse response = (HttpServletResponse)servletResponse;
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS, DELETE");
        response.setHeader("Access-Control-Max-Age", String.valueOf(CACHE_DURTION));
        response.setHeader("Access-Control-Allow-Headers", "x-requested-with");
        filterChain.doFilter(servletRequest, servletResponse);
    }
}
