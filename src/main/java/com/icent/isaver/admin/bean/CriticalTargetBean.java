package com.icent.isaver.admin.bean;

/**
 * 임계치별 대상장치 Bean
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
public class CriticalTargetBean {
    private String criticalDetectId;
    private String targetDeviceId;
    private String alarmType;
    private String alarmMessage;
    private String alarmFileId;
    private String useYn;

    public String getCriticalDetectId() {
        return criticalDetectId;
    }

    public void setCriticalDetectId(String criticalDetectId) {
        this.criticalDetectId = criticalDetectId;
    }

    public String getTargetDeviceId() {
        return targetDeviceId;
    }

    public void setTargetDeviceId(String targetDeviceId) {
        this.targetDeviceId = targetDeviceId;
    }

    public String getAlarmType() {
        return alarmType;
    }

    public void setAlarmType(String alarmType) {
        this.alarmType = alarmType;
    }

    public String getAlarmMessage() {
        return alarmMessage;
    }

    public void setAlarmMessage(String alarmMessage) {
        this.alarmMessage = alarmMessage;
    }

    public String getAlarmFileId() {
        return alarmFileId;
    }

    public void setAlarmFileId(String alarmFileId) {
        this.alarmFileId = alarmFileId;
    }

    public String getUseYn() {
        return useYn;
    }

    public void setUseYn(String useYn) {
        this.useYn = useYn;
    }
}