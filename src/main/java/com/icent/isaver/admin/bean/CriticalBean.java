package main.java.com.icent.isaver.admin.bean;

import java.util.List;

/**
 * 임계치 Bean
 *
 * @author : psb
 * @version : 1.0
 * @since : 2018. 9. 21.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2018. 9. 21.     psb           최초 생성
 * </pre>
 */
public class CriticalBean {
    private String criticalId;
    private String eventId;
    private String criticalLevel;
    private Double criticalValue;
    private String dashboardFileId;

    /* ETC*/
    private List<CriticalDetectBean> criticalDetects;
    private String criticalName;
    private String eventName;

    public String getCriticalId() {
        return criticalId;
    }

    public void setCriticalId(String criticalId) {
        this.criticalId = criticalId;
    }

    public String getEventId() {
        return eventId;
    }

    public void setEventId(String eventId) {
        this.eventId = eventId;
    }

    public String getCriticalLevel() {
        return criticalLevel;
    }

    public void setCriticalLevel(String criticalLevel) {
        this.criticalLevel = criticalLevel;
    }

    public Double getCriticalValue() {
        return criticalValue;
    }

    public void setCriticalValue(Double criticalValue) {
        this.criticalValue = criticalValue;
    }

    public String getDashboardFileId() {
        return dashboardFileId;
    }

    public void setDashboardFileId(String dashboardFileId) {
        this.dashboardFileId = dashboardFileId;
    }

    public List<CriticalDetectBean> getCriticalDetects() {
        return criticalDetects;
    }

    public void setCriticalDetects(List<CriticalDetectBean> criticalDetects) {
        this.criticalDetects = criticalDetects;
    }

    public String getCriticalName() {
        return criticalName;
    }

    public void setCriticalName(String criticalName) {
        this.criticalName = criticalName;
    }

    public String getEventName() {
        return eventName;
    }

    public void setEventName(String eventName) {
        this.eventName = eventName;
    }
}
