package main.java.com.icent.isaver.admin.bean;

import java.util.List;

/**
 * 임계치별 감지장치 Bean
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
public class CriticalDetectBean {
    private String criticalDetectId;
    private String criticalId;
    private String detectDeviceId;
    private String fenceId;

    /**
     * Etc
     */
    private List<CriticalTargetBean> criticalTargets;
    private String eventId;
    private String eventName;
    private String criticalLevel;
    private String detectDeviceName;

    public String getCriticalDetectId() {
        return criticalDetectId;
    }

    public void setCriticalDetectId(String criticalDetectId) {
        this.criticalDetectId = criticalDetectId;
    }

    public String getCriticalId() {
        return criticalId;
    }

    public void setCriticalId(String criticalId) {
        this.criticalId = criticalId;
    }

    public String getDetectDeviceId() {
        return detectDeviceId;
    }

    public void setDetectDeviceId(String detectDeviceId) {
        this.detectDeviceId = detectDeviceId;
    }

    public List<CriticalTargetBean> getCriticalTargets() {
        return criticalTargets;
    }

    public void setCriticalTargets(List<CriticalTargetBean> criticalTargets) {
        this.criticalTargets = criticalTargets;
    }

    public String getDetectDeviceName() {
        return detectDeviceName;
    }

    public void setDetectDeviceName(String detectDeviceName) {
        this.detectDeviceName = detectDeviceName;
    }

    public String getEventId() {
        return eventId;
    }

    public void setEventId(String eventId) {
        this.eventId = eventId;
    }

    public String getEventName() {
        return eventName;
    }

    public void setEventName(String eventName) {
        this.eventName = eventName;
    }

    public String getCriticalLevel() {
        return criticalLevel;
    }

    public void setCriticalLevel(String criticalLevel) {
        this.criticalLevel = criticalLevel;
    }

    public String getFenceId() {
        return fenceId;
    }

    public void setFenceId(String fenceId) {
        this.fenceId = fenceId;
    }
}
