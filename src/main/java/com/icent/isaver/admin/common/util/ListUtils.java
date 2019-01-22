package main.java.com.icent.isaver.admin.common.util;

import java.util.List;

/**
 * Created by icent on 2017. 2. 1..
 */
public class ListUtils {
    public ListUtils() {
    }

    public static boolean notNullCheck(List list) {
        return !nullCheck(list);
    }

    public static boolean nullCheck(List list) {
        return list == null || list.size() <= 0;
    }
}
