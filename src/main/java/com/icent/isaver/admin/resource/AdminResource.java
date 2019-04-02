package com.icent.isaver.admin.resource;

import java.util.Date;
import java.util.HashMap;
import java.util.Hashtable;
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

    public final static String SEARCH_MODE = "search";

    public final static String RESULT_NODE_NAME = "result";

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

    public final static String HTML_VIEW = "html";

    /**
     * XML VIEW EXTENTION
     * @author kst
     */
    public final static String XML_VIEW = "xml";

    public final static String PERIOD_STRING = ".";

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

    public final static int NONE_LICENSE_TARGET = -99;

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
     * 화장실재실 상태 코드정의
     * - 비어있음 : empty
     * - 정상 : normal
     * - 쓰러짐 : fall
     * @author psb
     */
    public final static String[] TOILET_ROOM_STATUS = new String[]{"empty","normal","fall","sign"};

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
     * 장치코드별 css정의
     * @author psb
     */
    public final static Map<String, String> DEVICE_CODE_CSS = new HashMap<String, String>(){
        {
            put("DEV001",""); // IVAS
            put("DEV002","ico-ptz"); // IP카메라
            put("DEV003","ico-sioc"); // SIOC
            put("DEV004",""); // IR센서 제어기
            put("DEV005",""); // 레이저스캐너
            put("DEV006","ico-led"); // LED
            put("DEV007","ico-speaker"); // 사운드
            put("DEV008","ico-wlight"); // 경광등
            put("DEV009","ico-tof"); // 피플카운트
            put("DEV010",""); // CCTV
            put("DEV011",""); // 세탁기
            put("DEV012",""); // 건조기
            put("DEV013","ico-m8"); // M8
            put("DEV014","ico-hlds"); // 감지구역침입 감지기
            put("DEV015","ico-qguard"); // Quanergy Server
            put("DEV016","ico-server"); // 압전서버
            put("DEV017","ico-shock"); // 압전센서
            put("DEV018",""); // 원격 I/O 제어기
            put("DEV900","ico-gate"); // 게이트웨이
            put("DEV901","ico-temp"); // 온도 감지기
            put("DEV902","ico-co2"); // CO2(이산화탄소) 감지기
            put("DEV903","ico-gas"); // 가스 감지기
            put("DEV904","ico-smok"); // 연기 감지기
            put("DEV905","ico-co"); // CO(일산화탄소) 감지기
            put("DEV906","ico-plug"); // S/P(스마트 플러그)
            put("DEV907","ico-humi"); // 습도 감지기
        }
    };

    /**
     * 장치코드별 css정의
     * @author psb
     */
    public final static Map<String, Integer> DEVICE_CODE_LICENSE = new HashMap<String, Integer>(){
        {
            put("DEV001",0); // IVAS
            put("DEV002",2); // IP카메라
            put("DEV003",4); // SIOC
            put("DEV004",6); // IR센서 제어기
            put("DEV005",8); // 레이저스캐너
            put("DEV006",10); // LED
            put("DEV007",12); // 사운드
            put("DEV008",14); // 경광등
            put("DEV009",16); // 피플카운트
            put("DEV010",18); // CCTV
            put("DEV011",20); // 세탁기
            put("DEV012",22); // 건조기
            put("DEV013",24); // M8
            put("DEV014",26); // 감지구역침입 감지기
            put("DEV015",28); // Quanergy Server
            put("DEV900",30); // 게이트웨이
            put("DEV901",32); // 온도 감지기
            put("DEV902",34); // CO2(이산화탄소) 감지기
            put("DEV903",36); // 가스 감지기
            put("DEV904",38); // 연기 감지기
            put("DEV905",40); // CO(일산화탄소) 감지기
            put("DEV906",42); // S/P(스마트 플러그)
            put("DEV907",44); // 습도 감지기
            put("DEV016",46); // 압전서버
            put("DEV017",48); // 압전센서
            put("DEV018",50); // 원격 I/O 제어기
        }
    };

    /**
     * 파일 타입 코드 정의
     * @author psb
     */
    public final static Map<String, String> FILE_TYPE = new HashMap<String, String>(){
        {
            put("alarm","FTA001"); // 알람파일
            put("map","FTA002"); // Map파일
            put("video","FTA003"); // Video파일
            put("icon","FTA004"); // Icon파일
        }
    };

    /**
     * 통계메뉴 상위 ID
     * @author psb
     */
    public final static String[] STATISTICS_PARENT_MENU_ID = new String[]{"200000","2A0000","2B0000"};

    /**
     * Dashboard Template 환경설정
     * @author psb
     */
    public static Hashtable<String, String> TEMPLATE_SETTING;
}
