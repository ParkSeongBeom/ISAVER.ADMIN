package main.java.com.icent.isaver.admin.bean;

/**
 * [Bean] 진출입 환경설정
 *
 * @author dhj
 * @since 2016. 6. 20.
 * @version 1.0
 * @see   <pre>
 * << 개정이력(Modification Information) >>
 *   수정일         수정자            수정내용
 *  ----------   --------  ----------------------
 *  2016.06.20     dhj     최초 생성
 * </pre>
 */
public class InoutConfigurationBean extends ISaverCommonBean {

    /* 환경 설정 ID*/
    private String configId;

    /* 사용자 ID*/
    private String userId;

    /* 구역 ID */
    private String areaId;

    /* 초기화 시작 시간 */
    private String inoutStarttime;

    /* 초기화 종료 시간 */
    private String inoutEndtime;

    /* ETC */
    /* 현재 시작시간 */
    private String nowInoutStarttime;
    /* 현재 종료시간 */
    private String nowInoutEndtime;
    /* 이전 시작시간 */
    private String beforeInoutStarttime;
    /* 이전 종료시간 */
    private String beforeInoutEndtime;

    public String getConfigId() {
        return configId;
    }

    public void setConfigId(String configId) {
        this.configId = configId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getAreaId() {
        return areaId;
    }

    public void setAreaId(String areaId) {
        this.areaId = areaId;
    }

    public String getInoutStarttime() {
        return inoutStarttime;
    }

    public void setInoutStarttime(String inoutStarttime) {
        this.inoutStarttime = inoutStarttime;
    }

    public String getInoutEndtime() {
        return inoutEndtime;
    }

    public void setInoutEndtime(String inoutEndtime) {
        this.inoutEndtime = inoutEndtime;
    }

    public String getNowInoutStarttime() {
        return nowInoutStarttime;
    }

    public void setNowInoutStarttime(String nowInoutStarttime) {
        this.nowInoutStarttime = nowInoutStarttime;
    }

    public String getNowInoutEndtime() {
        return nowInoutEndtime;
    }

    public void setNowInoutEndtime(String nowInoutEndtime) {
        this.nowInoutEndtime = nowInoutEndtime;
    }

    public String getBeforeInoutStarttime() {
        return beforeInoutStarttime;
    }

    public void setBeforeInoutStarttime(String beforeInoutStarttime) {
        this.beforeInoutStarttime = beforeInoutStarttime;
    }

    public String getBeforeInoutEndtime() {
        return beforeInoutEndtime;
    }

    public void setBeforeInoutEndtime(String beforeInoutEndtime) {
        this.beforeInoutEndtime = beforeInoutEndtime;
    }
}