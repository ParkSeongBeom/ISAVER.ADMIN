package com.icent.isaver.admin.resource;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
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
     * worker eventIds
     * @author psb
     */
    public final static String[] WORKER_EVENT_ID_ALL = new String[]{"EVT009", "EVT015","EVT016","EVT013","EVT014"};
    public final static String[] WORKER_EVENT_ID_DETAIL = new String[]{"EVT009", "EVT015","EVT016","EVT013"};

    /**
     * crane eventIds
     * @author psb
     */
    public final static String[] CRANE_EVENT_ID_ALL = new String[]{"EVT100", "EVT101", "EVT102", "EVT210", "EVT211"};
    public final static String[] CRANE_EVENT_ID_DETAIL = new String[]{"EVT100", "EVT101", "EVT210"};

    /**
     * alram eventIds
     * @author psb
     */
    public final static List<String> ALRAM_EVENT = new ArrayList(){{
        add("EVT009");
        add("EVT013");
        add("EVT015");
        add("EVT016");
        add("EVT100");
        add("EVT101");
        add("EVT210");
    }};

    /**
     * in, out eventIds
     * @author psb
     */
    public final static String[] INOUT_EVENT_ID = new String[]{"EVT002", "EVT221", "EVT300", "EVT003", "EVT222", "EVT301"};

    /**
     * in eventIds
     * @author psb
     */
    public final static String[] IN_EVENT_ID = new String[]{"EVT002", "EVT221", "EVT300"};

    /**
     * out eventIds
     * @author psb
     */
    public final static String[] OUT_EVENT_ID = new String[]{"EVT003", "EVT222", "EVT301"};

    public final static String PEOPLE_COUNT_DEVICE_ID = "DEV009";

    public final static String API_PATH_URL_SENDEVENT = "/alarm/eventSend.json";

    public final static String WS_PATH_URL_SENDEVENT = "/eventAlarm/eventSend.json";

    public final static String WS_PATH_URL_CONNECT = "/eventAlarm";
}
