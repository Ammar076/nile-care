package com.nilecare.config;

import org.springframework.web.servlet.support.AbstractAnnotationConfigDispatcherServletInitializer;

public class WebAppInitializer extends AbstractAnnotationConfigDispatcherServletInitializer {

    @Override
    protected Class<?>[] getRootConfigClasses() {
        return new Class[]{RootConfig.class}; // Loads Database/Services
    }

    @Override
    protected Class<?>[] getServletConfigClasses() {
        return new Class[]{WebConfig.class}; // Loads Controllers/Views
    }

    @Override
    protected String[] getServletMappings() {
        return new String[]{"/"}; // Map all requests to DispatcherServlet
    }
}