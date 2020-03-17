package com.icent.isaver.admin.util;

import com.icent.isaver.admin.bean.UsersBean;
import com.icent.isaver.admin.common.resource.IsaverException;
import com.icent.isaver.admin.resource.AdminResource;
import com.meous.common.resource.CommonResource;
import com.meous.common.util.BeanUtils;
import com.meous.common.util.CookieUtils;
import com.meous.common.util.StringUtils;
import org.apache.commons.beanutils.ConvertUtils;
import org.apache.commons.beanutils.converters.DateConverter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * 관리자 Helper Utils
 *
 * @author : kst
 * @version : 1.0
 * @since : 2014. 5. 20.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 5. 20.     kst           최초 생성
 *  2015. 2. 11.     kst           convertMapToBean 확장
 * </pre>
 */
public class AdminHelper {
    private static Logger logger = LoggerFactory.getLogger(AdminHelper.class);

    /**
     * 클라이언트에서 넘어온 파라미터(map)에서 페이징 인자를 셋팅한다.</br>
     * - FindBean에 맞춰 제작
     *
     * @author kst
     * @Date 2013. 10. 31.
     * @param parameters 파라미터
     * @param defaultPageSize 기본 페이징 사이즈
     * @return pageNumber, pageSize, pageIndex
     */
    public static Map<String, String> setPageParam(Map<String, String> parameters, String defaultPageSize){
        if(parameters == null) {
            parameters = new HashMap<>();
        }

        Integer pageNumber = parameters.get("pageNumber") == null || AdminResource.EMPTY_STRING.equals(parameters.get("pageNumber"))
                ? 1 : Integer.parseInt(parameters.get("pageNumber"));
        Integer pageSize = parameters.get("pageSize") == null || AdminResource.EMPTY_STRING.equals(parameters.get("pageSize"))
                ? Integer.parseInt(defaultPageSize) : Integer.parseInt(parameters.get("pageSize"));

        Integer pageIndex = (pageNumber - 1) * pageSize;

        parameters.remove("pageNumber");
        parameters.remove("pageSize");

        parameters.put("pageNumber", String.valueOf(pageNumber));
        parameters.put("pageRowNumber", String.valueOf(pageSize));
        parameters.put("pageIndex", String.valueOf(pageIndex));

        return parameters;
    }

    /**
     * Map을 해당 Class의 instance를 생성하여 convert한다.
     *
     * @author kst
     * @param parameters
     * @param clazz
     * @param <T>
     * @return
     */
    public static <T> T convertMapToBean(Map<String, String> parameters, Class<T> clazz){
        return convertMapToBean(parameters, clazz, false, "yyyy-MM-dd");
    }

    /**
     * Map을 해당 Class의 instance를 생성하여 convert한다.
     *
     * @author kst
     * @param parameters
     * @param clazz
     * @param datePattern
     * @param <T>
     * @return
     */
    public static <T> T convertMapToBean(Map<String, String> parameters, Class<T> clazz, String datePattern){
        return convertMapToBean(parameters, clazz, false, datePattern);
    }

    /**
     * Map을 해당 Class의 instance를 생성하여 convert한다.
     *
     * @author kst
     * @param parameters
     * @param clazz
     * @param emptyNullFlag
     * @param <T>
     * @return
     */
    public static <T> T convertMapToBean(Map<String, String> parameters, Class<T> clazz, boolean emptyNullFlag, String datePattern){
        if(emptyNullFlag){

            List<String> removeKeys = new ArrayList<>();
            for(String key : parameters.keySet()){
                if(StringUtils.nullCheck(parameters.get(key))){
                    removeKeys.add(key);
                }
            }

            for(String key : removeKeys){
                parameters.remove(key);
            }
        }

        T bean = null;
        try {

            DateConverter dateConverter = new DateConverter();
            dateConverter.setPattern(datePattern);
            ConvertUtils.register(dateConverter, Date.class);

            bean = BeanUtils.convertMapToBean(parameters, clazz);
        } catch (IllegalAccessException | InstantiationException | InvocationTargetException e) {
            logger.error(e.getMessage());
        }

        return bean;
    }

    /**
     * map에 페이징 관련 인자를 설정한다.
     *
     * @author psb
     * @param parameters
     * @param totalCount
     */
    public static void setPageTotalCount(Map<String, String> parameters, Long totalCount){
        parameters.put("totalCount", String.valueOf(totalCount));
        parameters.put("pageTotalCount", String.valueOf((int) Math.ceil(totalCount / Double.valueOf(parameters.get("pageRowNumber")))));
    }

    /**
     * map에 페이징 관련 인자를 설정한다.
     *
     * @author psb
     * @param parameters
     * @param totalCount
     */
    public static void setPageTotalCount(Map<String, String> parameters, Integer totalCount){
        parameters.put("totalCount", String.valueOf(totalCount));
        parameters.put("pageTotalCount", String.valueOf((int) Math.ceil(totalCount / Double.valueOf(parameters.get("pageRowNumber")))));
    }

    /**
     * 세션에서 로그인한 관리자 정보를 가져온다.
     *
     * @author kst
     * @param request
     * @return
     */
    public static UsersBean getAdminInfo(HttpServletRequest request){
        return (UsersBean)request.getSession().getAttribute(AdminResource.AUTHORIZATION_ADMIN);
    }

    /**
     * 세션에 로그인정보를 등록한다.
     *
     * @author kst
     * @param request
     * @param usersBean
     */
    public static void setAdminInfo(HttpServletRequest request, UsersBean usersBean){
        request.getSession().setAttribute(AdminResource.AUTHORIZATION_ADMIN, usersBean);
    }

    /**
     * 세션에서 로그인정보를 제거한다.
     *
     * @author kst
     * @param request
     */
    public static void removeAdminInfo(HttpServletRequest request){
        request.getSession().removeAttribute(AdminResource.AUTHORIZATION_ADMIN);
    }

    /**
     * 세션에서 로그인한 관리자의 ID를 가져온다.
     *
     * @author kst
     * @param request
     * @return
     */
    public static String getAdminIdFromSession(HttpServletRequest request){
        String adminId = null;
        try{
            UsersBean usersBean = getAdminInfo(request);
            adminId = usersBean.getUserId();
        }catch(Exception e){
            logger.error(e.getMessage());
        }
        return adminId;
    }

    /**
     * 세션에서 로그인한 관리자의 이름을 가져온다.
     *
     * @author kst
     * @param request
     * @return
     */
    public static String getAdminNameFromSession(HttpServletRequest request){
        String adminName = null;
        try{
            UsersBean usersBean = getAdminInfo(request);
            adminName = usersBean.getUserName();
        }catch(Exception e){
            logger.error(e.getMessage());
        }
        return adminName;
    }

    /**
     * 일자별 검색이 필요한 페이지 초기 진입시 날짜 기본값 셋팅</br>
     * - FindBean에 맞춰짐.
     *
     * @Method name : checkSearchDate
     * @author kst
     * @Date 2013. 11. 7.
     * @param parameters
     * @return
     */
    public static Map<String, String> checkSearchDate(Map<String, String> parameters,Integer durationDate){
        return checkSearchDate(parameters, durationDate, Locale.KOREA);
    }

    /**
     * 일자별 검색이 필요한 페이지 초기 진입시 날짜 기본값 셋팅</br>
     * - FindBean에 맞춰짐.
     *
     * @Method name : checkSearchDate
     * @author kst
     * @Date 2013. 11. 7.
     * @param parameters
     * @return
     */
    public static Map<String, String> checkSearchDate(Map<String, String> parameters,Integer durationDate, Locale locale){
        // 일자검색이 둘다 NULL이라면 초기 진입이라 가정
        if(parameters.get("startDatetimeStr") == null && parameters.get("endDatetimeStr") == null){
            SimpleDateFormat sdf = new SimpleDateFormat(CommonResource.PATTERN_DATE,locale);
            Calendar calendar = Calendar.getInstance();
            durationDate = -1 * durationDate;
            calendar.add(calendar.DATE, durationDate);

            Date toDate = new Date();

            parameters.put("startDatetimeStr", sdf.format(calendar.getTime()));
            parameters.put("endDatetimeStr",sdf.format(toDate));

            parameters.put("startDatetimeHour","00");
            parameters.put("endDatetimeHour","23");
        }

        return parameters;
    }

    /**
     * 일자별 검색이 필요한 페이지 초기 진입시 날짜 기본값 셋팅</br> 월~금요일
     * - FindBean에 맞춰짐.
     *
     * @Method name : checkSearchDate
     * @author kst
     * @Date 2013. 11. 7.
     * @param parameters
     * @return
     */
    public static Map<String, String> checkSearchDate(Map<String, String> parameters, Integer startDate, Integer endDate){
        // 일자검색이 둘다 NULL이라면 초기 진입이라 가정
        if(parameters.get("startDatetimeStr") == null && parameters.get("endDatetimeStr") == null){
            SimpleDateFormat sdf = new SimpleDateFormat(CommonResource.PATTERN_DATE,Locale.KOREA);
            Calendar startCalendar = Calendar.getInstance();
            Calendar endCalendar = Calendar.getInstance();
            startCalendar.set(Calendar.DAY_OF_WEEK, startDate); // 주어진 날짜의 요일을 세팅
            endCalendar.set(Calendar.DAY_OF_WEEK, endDate); // 주어진 날짜의 요일을 세팅

            parameters.put("startDatetimeStr", sdf.format(startCalendar.getTime()));
            parameters.put("endDatetimeStr",sdf.format(endCalendar.getTime()));

            parameters.put("startDatetimeHour","00");
            parameters.put("endDatetimeHour","23");
        }

        return parameters;
    }

    public static List<String> findListDateTime(String startDatetimeStr, String endDatetimeStr) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Calendar cal = Calendar.getInstance();
        try {
            cal.setTime(sdf.parse(startDatetimeStr));
        } catch (Exception e) {
            logger.error(e.getMessage());
        }
        int count = 0;
        try {
            count =  (int) ((sdf.parse(endDatetimeStr).getTime() - sdf.parse(startDatetimeStr).getTime()) / 1000 / 60 / 60 / 24);
        } catch (Exception e) {
            count = 0;
        }

        // 시작일부터
        cal.add(Calendar.DATE, -1);
        // 데이터 저장
        List<String> dateLists = new LinkedList<>();
        for (int i = 0; i <= count; i++) {
            cal.add(Calendar.DATE, 1);
            dateLists.add(i,sdf.format(cal.getTime()));
        }

        return dateLists;
    }

    /**
     * 새로고침시 기존 파라미터 유지
     * @param request
     * @param response
     * @param type
     * @param parameters
     * @return
     */
    public static Map<String, String> reloadDashboasrd(HttpServletRequest request, HttpServletResponse response, String type, Map<String, String> parameters){
        try{
            if(StringUtils.notNullCheck(parameters.get("refreshFlag")) && !Boolean.valueOf(parameters.get("refreshFlag"))){
                StringBuilder stringBuilder = new StringBuilder();
                for(String key : parameters.keySet()){
                    stringBuilder.append(key);
                    stringBuilder.append("|");
                    stringBuilder.append(parameters.get(key));
                    stringBuilder.append(CommonResource.COMMA_STRING);
                }
                CookieUtils.addCookie(request, response, type, stringConverter(0, stringBuilder.toString()), 60 * 60);
            }else if(StringUtils.nullCheck(parameters.get("refreshFlag"))){
                String value = stringConverter(1, CookieUtils.getCookieValue(request, type));

                if(StringUtils.nullCheck(value)){
                    return parameters;
                }

                String[] values = value.split(CommonResource.COMMA_STRING);
                for(String temp : values){
                    String[] tempArr = temp.split("\\|");
                    if(tempArr != null && tempArr.length > 1){
                        parameters.put(tempArr[0],tempArr[1]);
                    }
                }
            }
        }catch(Exception e){
            throw new IsaverException("");
        }
        return parameters;
    }

    public static Map<String, String> checkReloadList(HttpServletRequest request, HttpServletResponse response, String type, Map<String, String> parameters){
        if(StringUtils.nullCheck(parameters.get("reloadList"))){
            StringBuilder stringBuilder = new StringBuilder();
            for(String key : parameters.keySet()){
                stringBuilder.append(key);
                stringBuilder.append("|");
                stringBuilder.append(parameters.get(key));
                stringBuilder.append(CommonResource.COMMA_STRING);
            }
            CookieUtils.addCookie(request, response, type, stringConverter(0, stringBuilder.toString()), 60 * 60);
        }else if(StringUtils.notNullCheck(parameters.get("reloadList")) && Boolean.valueOf(parameters.get("reloadList"))){
            String value = stringConverter(1, CookieUtils.getCookieValue(request, type));

            if(StringUtils.nullCheck(value)){
                return parameters;
            }

            String[] values = value.split(CommonResource.COMMA_STRING);
            for(String temp : values){
                String[] tempArr = temp.split("\\|");
                if(tempArr != null && tempArr.length > 1){
                    parameters.put(tempArr[0],tempArr[1]);
                }
            }
        }

        return parameters;
    }

    private static String stringConverter(int type, String value) {
        String result = null;

        try {
            switch (type) {
                case 0:
                    result = URLEncoder.encode(value, CommonResource.CHARSET_UTF8);
                    break;
                case 1:
                    result = URLDecoder.decode(value, CommonResource.CHARSET_UTF8);
                    break;
                default:
                    result = value;
            }
        } catch (UnsupportedEncodingException e) {
            result = CommonResource.EMPTY_STRING;
        }

        return result;
    }

    public static String convertNullToString(Map<String, String> map, String key) {
        String result = null;

        if(StringUtils.notNullCheck(map.get(key))){
            result = map.get(key);
        }else{
            result = "";
        }

        return result;
    }

    public static String convertNullToString(String str) {
        return str != null ? str : "";
    }

    public static List<Date> findListDateTimeForType(String searchDatetime, String type, int addNum) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Calendar cal = Calendar.getInstance();
        try {
            if(searchDatetime!=null){
                cal.setTime(sdf.parse(searchDatetime));
            }
            cal.set( Calendar.HOUR_OF_DAY, 0 );
            cal.set( Calendar.MINUTE, 0 );
            cal.set( Calendar.SECOND, 0 );
            cal.set( Calendar.MILLISECOND, 0 );
        } catch (Exception e) {
            logger.error(e.getMessage());
        }

        List<Date> dateLists = new LinkedList<>();

        switch (type){
            case "day":
                for (int i = 0; i < 24+addNum; i++) {
                    dateLists.add(i,cal.getTime());
                    cal.add(Calendar.HOUR, 1);
                }
                break;
            case "week":
                cal.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
                for (int i = 0; i < 7+addNum; i++) {
                    dateLists.add(i,cal.getTime());
                    cal.add(Calendar.DATE, 1);
                }
                break;
            case "month":
                cal.set(Calendar.DAY_OF_MONTH, 1);
                for (int i = 0; i < cal.getMaximum(Calendar.DAY_OF_MONTH)+addNum; i++) {
                    dateLists.add(i,cal.getTime());
                    cal.add(Calendar.DATE, 1);
                }
                break;
            case "year":
                cal.set(Calendar.DAY_OF_MONTH, 1);
                cal.set(Calendar.MONTH, Calendar.JANUARY);
                for (int i = 0; i < 12+addNum; i++) {
                    dateLists.add(i,cal.getTime());
                    cal.add(Calendar.MONTH, 1);
                }
                break;
        }

        return dateLists;
    }

    public static List<Date> findListDateTimeForType(Date startDatetime, Date endDatetime, String type) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Calendar cal = Calendar.getInstance();
        List<Date> dateLists = new LinkedList<>();

        try {
            cal.setTime(startDatetime);
            switch (type){
                case "day":
                    cal.set( Calendar.MINUTE, 0 );
                    cal.set( Calendar.SECOND, 0 );
                    cal.set( Calendar.MILLISECOND, 0 );
                    while (cal.getTime().getTime()<=endDatetime.getTime()){
                        dateLists.add(cal.getTime());
                        cal.add(Calendar.HOUR, 1);
                    }
                    break;
                case "week":
                case "month":
                    cal.set( Calendar.HOUR_OF_DAY, 0 );
                    cal.set( Calendar.MINUTE, 0 );
                    cal.set( Calendar.SECOND, 0 );
                    cal.set( Calendar.MILLISECOND, 0 );
                    while (cal.getTime().getTime()<=endDatetime.getTime()){
                        dateLists.add(cal.getTime());
                        cal.add(Calendar.DATE, 1);
                    }
                    break;
                case "year":
                    cal.set( Calendar.HOUR_OF_DAY, 0 );
                    cal.set( Calendar.MINUTE, 0 );
                    cal.set( Calendar.SECOND, 0 );
                    cal.set( Calendar.MILLISECOND, 0 );
                    cal.set( Calendar.DAY_OF_MONTH, 1);
                    cal.set( Calendar.MONTH, Calendar.JANUARY);
                    while (cal.getTime().getTime()<=endDatetime.getTime()){
                        dateLists.add(cal.getTime());
                        cal.add(Calendar.MONTH, 1);
                    }
                    break;
            }
        } catch (Exception e) {
            logger.error(e.getMessage());
        }
        return dateLists;
    }
}
