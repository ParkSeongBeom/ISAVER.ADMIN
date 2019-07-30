package com.icent.isaver.admin.common.util;

import com.meous.common.util.StringUtils;
import org.springframework.beans.factory.BeanDefinitionStoreException;
import org.springframework.beans.factory.config.BeanDefinition;
import org.springframework.context.annotation.ScannedGenericBeanDefinition;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.core.type.classreading.CachingMetadataReaderFactory;
import org.springframework.core.type.classreading.MetadataReader;
import org.springframework.util.ClassUtils;
import org.springframework.util.SystemPropertyUtils;

import java.io.IOException;
import java.util.*;

/**
 * Created by icent on 2017. 2. 1..
 */
public class ResourceFinder {
    private static final String DEFAULT_CLASS_PATTERN = "**/*.class";
    private static final String DEFAULT_RESOURCE_PATTERN = "**/*";

    public ResourceFinder() {
    }

    public static List<Class<?>> getClassesListFromName(String... names) {
        ArrayList classes = new ArrayList();
        String[] arr$ = names;
        int len$ = names.length;

        for(int i$ = 0; i$ < len$; ++i$) {
            String name = arr$[i$];
            classes.add(ClassUtils.resolveClassName(name, ClassUtils.getDefaultClassLoader()));
        }

        return classes;
    }

    public static Class<?>[] getClassesArrayFromName(String... names) {
        List classList = getClassesListFromName(names);
        Class[] classes = new Class[classList.size()];
        int index = 0;

        for(Iterator i$ = classList.iterator(); i$.hasNext(); ++index) {
            Class clazz = (Class)i$.next();
            classes[index] = (Class)classList.get(index);
        }

        return classes;
    }

    public static List<Class<?>> getClassesList(String basePackage) {
        return getClassesList(basePackage, "**/*.class");
    }

    public static List<Class<?>> getClassesList(String basePackage, String resourcePattern) {
        Set beans = findClassesBiz(basePackage, resourcePattern);
        ArrayList classes = new ArrayList();
        Iterator i$ = beans.iterator();

        while(i$.hasNext()) {
            BeanDefinition tempBean = (BeanDefinition)i$.next();
            classes.add(ClassUtils.resolveClassName(tempBean.getBeanClassName(), ClassUtils.getDefaultClassLoader()));
        }

        return classes;
    }

    public static Class<?>[] getClassesArray(String basePackage) {
        return getClassesArray(basePackage, "**/*.class");
    }

    public static Class<?>[] getClassesArray(String basePackage, String resourcePattern) {
        Set beans = findClassesBiz(basePackage, resourcePattern);
        Class[] classes = new Class[beans.size()];
        int count = 0;

        for(Iterator i$ = beans.iterator(); i$.hasNext(); ++count) {
            BeanDefinition tempBean = (BeanDefinition)i$.next();
            classes[count] = ClassUtils.resolveClassName(tempBean.getBeanClassName(), ClassUtils.getDefaultClassLoader());
        }

        return classes;
    }

    public static List<Resource> getResourceList(String basePackage) {
        return getResourceList(basePackage, (String)null);
    }

    public static List<Resource> getResourceList(String basePackage, String resourcePattern) {
        if(!StringUtils.notNullCheck(resourcePattern)) {
            resourcePattern = "**/*";
        }

        ArrayList resources = new ArrayList();
        Resource[] arr$ = findResources(basePackage, resourcePattern);
        int len$ = arr$.length;

        for(int i$ = 0; i$ < len$; ++i$) {
            Resource resource = arr$[i$];
            resources.add(resource);
        }

        return resources;
    }

    public static Resource[] getResources(String basePackage) {
        return findResources(basePackage, "**/*");
    }

    public static Resource[] getResources(String basePackage, String resourcePattern) {
        if(!StringUtils.notNullCheck(resourcePattern)) {
            resourcePattern = "**/*";
        }

        return findResources(basePackage, resourcePattern);
    }

    private static Set<BeanDefinition> findClassesBiz(String basePackage, String resourcePattern) {
        LinkedHashSet candidates = new LinkedHashSet();
        PathMatchingResourcePatternResolver resourcePatternResolver = new PathMatchingResourcePatternResolver();
        CachingMetadataReaderFactory metadataReaderFactory = new CachingMetadataReaderFactory(resourcePatternResolver);
        Resource[] resources = findResources(basePackage, resourcePattern);
        if(resources != null) {
            Resource[] arr$ = resources;
            int len$ = resources.length;

            for(int i$ = 0; i$ < len$; ++i$) {
                Resource resource = arr$[i$];
                if(resource.isReadable()) {
                    try {
                        MetadataReader ex = metadataReaderFactory.getMetadataReader(resource);
                        ScannedGenericBeanDefinition sbd = new ScannedGenericBeanDefinition(ex);
                        sbd.setResource(resource);
                        sbd.setSource(resource);
                        candidates.add(sbd);
                    } catch (Throwable var12) {
                        throw new BeanDefinitionStoreException("Failed to read candidate component class: " + resource, var12);
                    }
                }
            }
        }

        return candidates;
    }

    private static Resource[] findResources(String basePackage, String resourcePattern) {
        Resource[] resources = null;
        PathMatchingResourcePatternResolver resourcePatternResolver = new PathMatchingResourcePatternResolver();
        String packageSearchPath = "classpath*:" + ClassUtils.convertClassNameToResourcePath(SystemPropertyUtils.resolvePlaceholders(basePackage)) + resourcePattern;

        try {
            resources = resourcePatternResolver.getResources(packageSearchPath);
        } catch (IOException var6) {
            var6.printStackTrace();
        }

        return resources;
    }
}