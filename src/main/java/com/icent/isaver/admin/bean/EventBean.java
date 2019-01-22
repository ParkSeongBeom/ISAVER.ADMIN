package main.java.com.icent.isaver.admin.bean;

import java.util.List;

/**
 * [Bean] 이벤트
 *
 * @author dhj
 * @since 2016. 5. 26.
 * @version 1.0
 * @see   <pre>
 * << 개정이력(Modification Information) >>
 *   수정일         수정자            수정내용
 *  ----------   --------  ----------------------
 *  2016.05.26     dhj     최초 생성
 * </pre>
 */
public class EventBean extends ISaverCommonBean {
    /* 이벤트 ID*/
    private String eventId;
    /* 이벤트구분_감지,경보 */
    private String eventFlag;
    /* 이벤트명 */
    private String eventName;
    /* 이벤트 설명 */
    private String eventDesc;
    /* 삭제 여부 */
    private String delYn;
    /* 통계 코드 */
    private String statisticsCode;

    /* etc */
    private List<CriticalBean> criticals;

    private String actionId;
    private String actionCode;
    private String actionDesc;

    private String actionCodeName;
    private String eventFlagName;
    private String criticalUseYn;
    private String statisticsName;

    public String getEventId() {
        return eventId;
    }

    public void setEventId(String eventId) {
        this.eventId = eventId;
    }

    public String getEventFlag() {
        return eventFlag;
    }

    public void setEventFlag(String eventFlag) {
        this.eventFlag = eventFlag;
    }

    public String getEventName() {
        return eventName;
    }

    public void setEventName(String eventName) {
        this.eventName = eventName;
    }

    public String getEventDesc() {
        return eventDesc;
    }

    public void setEventDesc(String eventDesc) {
        this.eventDesc = eventDesc;
    }

    public String getDelYn() {
        return delYn;
    }

    public void setDelYn(String delYn) {
        this.delYn = delYn;
    }

    public String getActionId() {
        return actionId;
    }

    public void setActionId(String actionId) {
        this.actionId = actionId;
    }

    public String getActionCode() {
        return actionCode;
    }

    public void setActionCode(String actionCode) {
        this.actionCode = actionCode;
    }

    public String getActionDesc() {
        return actionDesc;
    }

    public void setActionDesc(String actionDesc) {
        this.actionDesc = actionDesc;
    }

    public String getActionCodeName() {
        return actionCodeName;
    }

    public void setActionCodeName(String actionCodeName) {
        this.actionCodeName = actionCodeName;
    }

    public String getEventFlagName() {
        return eventFlagName;
    }

    public void setEventFlagName(String eventFlagName) {
        this.eventFlagName = eventFlagName;
    }

    public String getCriticalUseYn() {
        return criticalUseYn;
    }

    public void setCriticalUseYn(String criticalUseYn) {
        this.criticalUseYn = criticalUseYn;
    }

    public String getStatisticsCode() {
        return statisticsCode;
    }

    public void setStatisticsCode(String statisticsCode) {
        this.statisticsCode = statisticsCode;
    }

    public String getStatisticsName() {
        return statisticsName;
    }

    public void setStatisticsName(String statisticsName) {
        this.statisticsName = statisticsName;
    }

    public List<CriticalBean> getCriticals() {
        return criticals;
    }

    public void setCriticals(List<CriticalBean> criticals) {
        this.criticals = criticals;
    }
}
