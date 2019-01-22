package com.icent.isaver.admin.common;

import com.icent.isaver.admin.common.util.ListUtils;
import com.icent.isaver.admin.common.util.ResourceFinder;
import org.springframework.oxm.jaxb.Jaxb2Marshaller;
import org.springframework.util.CollectionUtils;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

/**
 * Created by icent on 2017. 2. 1..
 */
public class XMLMarshaller extends Jaxb2Marshaller {
    public XMLMarshaller() {
    }

    public void setBasePackage(String basePackage) {
        Class[] classes = ResourceFinder.getClassesArray(basePackage);
        super.setClassesToBeBound(classes);
    }

    public void setBasePackages(List<String> basePackages) {
        Class[] classes = null;
        ArrayList classesList = new ArrayList();
        Iterator index = basePackages.iterator();

        while (index.hasNext()) {
            String i$ = (String) index.next();
            List tempClass = ResourceFinder.getClassesList(i$);
            classesList.addAll(tempClass);
        }

        classes = new Class[classesList.size()];
        int var7 = 0;

        for (Iterator var8 = classesList.iterator(); var8.hasNext(); ++var7) {
            Class var9 = (Class) var8.next();
            classes[var7] = var9;
        }

        classesList = null;
        super.setClassesToBeBound(classes);
    }

    public void addClasses(List<Class<?>> classList) {
        if (ListUtils.notNullCheck(classList)) {
            List oldList = CollectionUtils.arrayToList(super.getClassesToBeBound());
            classList.addAll(oldList);
            Class[] tempClasses = new Class[classList.size()];
            int index = 0;

            for (Iterator i$ = classList.iterator(); i$.hasNext(); ++index) {
                Class tempClass = (Class) i$.next();
                tempClasses[index] = tempClass;
            }

            classList = null;
            super.setClassesToBeBound(tempClasses);
        }

    }

    public void addClasses(String... names) {
        this.addClasses(ResourceFinder.getClassesListFromName(names));
    }
}