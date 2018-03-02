package com.icent.isaver.admin.resource;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * 관리자 리소스
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
 * </pre>
 */
public class AdminResource {

    /**
     * deploy datetime
     * @author psb
     */
    public final static String DEPLOY_DATETIME = String.valueOf(new Date().getTime());

    /**
     * 콤마
     * @author psb
     */
    public final static String COMMA_STRING = ",";

    /**
     * 빈문자
     * @author kst
     */
    public final static String EMPTY_STRING = "";

    /**
     * JSON VIEW EXTENTION
     * @author kst
     */
    public final static String JSON_VIEW = "json";

    /**
     * XML VIEW EXTENTION
     * @author kst
     */
    public final static String XML_VIEW = "xml";

    /**
     * useable || delete flag</br>
     * - Y
     * @author kst
     */
    public final static String YES = "Y";

    /**
     * useable || delete flag</br>
     * - N
     * @author kst
     */
    public final static String NO = "N";

    /**
     * DB Link Success Flag</br>
     * - OK
     * @author psb
     */
    public final static String OK = "OK";

    /**
     * session attribute key
     * @author kst
     */
    public final static String AUTHORIZATION_ADMIN = "authAdminInfo";

    /**
     * admin log type</br>
     * - login : 1</br>
     * - logout : 0</br>
     *
     * @author psb
     */
    public final static String[] ADMIN_LOG_TYPE = new String[]{"1","0"};

    /**
     * admin log type</br>
     * - login : 1</br>
     * - logout : 0</br>
     *
     * @author psb
     */
    public final static String ALARM_TARGET_ID = "DASHBOARD";

    /**
     * 그룹코드 타입 정의
     * - S : SYSTEM
     * - C : CUSTOM
     */
    public final static Map<String, String> GROUP_CODE_TYPE = new HashMap<String, String>(){
        {
            put("SYSTEM", "SYSTEM");// 시스템코드
            put("CUSTOM", "CUSTOM");// 커스텀코드
        }
    };

    public final static String PROTOCOL_SUBPIX = "://";

    /**
     * 서버유형 코드정의
     * @author kst
     */
    public final static Map<String, String> SERVER_TYPE = new HashMap<String, String>(){
        {
            put("was","0001");
            put("api","0002");
            put("file","0003");
            put("mail","0004");
            put("cup","1000");
            put("cucm","2000");
            put("cuc","3000");
            put("ad","4000");
            put("tms","5000");
            put("webex","6000");
            put("ldap","7000");
        }
    };

    /**
     * 장치유형 코드정의
     * @author psb
     */
    public final static Map<String, String> DEVICE_TYPE_CODE = new HashMap<String, String>(){
        {
            put("alarm","D00001"); // 경보장치
            put("target","D00002"); // 감지장치
        }
    };

    /**
     * 장치동기화 요청구분 코드정의
     * @author psb
     */
    public final static Map<String, String> SYNC_TYPE = new HashMap<String, String>(){
        {
            put("add","T01001"); // 등록
            put("save","T01002"); // 수정
            put("remove","T01003"); // 삭제
        }
    };

    /**
     * 장치동기화 처리상태 코드정의
     * @author psb
     */
    public final static Map<String, String> SYNC_STATUS = new HashMap<String, String>(){
        {
            put("wait","S01001"); // 대기
            put("progress","S01002"); // 처리중
            put("success","S01003"); // 성공
            put("fail","S01004"); // 실패
        }
    };

    /**
     * 임계치 레벨별 css정의
     * @author psb
     */
    public final static Map<String, String> CRITICAL_LEVEL_CSS = new HashMap<String, String>(){
        {
            put("LEV001","caution"); // 주의
            put("LEV002","warning"); // 경고
            put("LEV003","danger"); // 위험
        }
    };

    /**
     * 통계메뉴 상위 ID
     * @author psb
     */
    public final static String[] STATISTICS_PARENT_MENU_ID = new String[]{"200000", "2A0000","2B0000"};


    public final static String PEOPLE_COUNT_DEVICE_ID = "DEV009";
}
