package psb;

import org.junit.Test;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by icent on 16. 6. 27..
 */
public class test02 {

    @Test
    public void test() {
        List<Map<String, String>> parameterList = new ArrayList<>();

        for (int i=0; i<1000; i++) {
            Map<String, String> notiMap = new HashMap<>();
            notiMap.put("notificationId", "a"+i);
            parameterList.add(notiMap);
        }

        List<List<Map<String, String>>> ret = split(parameterList, 200);
        for (int i = 0; i <ret.size(); i++) {
            System.out.println(ret.get(i));
        }
    }

    public static <T> List<List<T>> split(List<T> resList, int count) {
        if (resList == null || count <1)
            return null;
        List<List<T>> ret = new ArrayList<List<T>>();
        int size = resList.size();
        if (size <= count) {
            // 데이터 부족 count 지정 크기
            ret.add(resList);
        } else {
            int pre = size / count;
            int last = size % count;
            // 앞 pre 개 집합, 모든 크기 다 count 가지 요소
            for (int i = 0; i <pre; i++) {
                List<T> itemList = new ArrayList<T>();
                for (int j = 0; j <count; j++) {
                    itemList.add(resList.get(i * count + j));
                }
                ret.add(itemList);
            }
            // last 진행이 처리
            if (last > 0) {
                List<T> itemList = new ArrayList<T>();
                for (int i = 0; i <last; i++) {
                    itemList.add(resList.get(pre * count + i));
                }
                ret.add(itemList);
            }
        }
        return ret;
    }
}
