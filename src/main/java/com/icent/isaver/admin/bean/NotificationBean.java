package com.icent.isaver.admin.bean;

import java.util.Date;

/**
 * [Bean] 알림센터
 *
 * @author psb
 * @since 2018. 1. 11.
 * @version 1.0
 * @see   <pre>
 * << 개정이력(Modification Information) >>
 *   수정일         수정자            수정내용
 *  ----------   --------  ----------------------
 *  2018. 1. 11     psb     최초 생성
 * </pre>
 */
public class NotificationBean extends ISaverCommonBean {

    /* 알림 ID */
    private String notificationId;
    /* 이벤트 로그 ID */
    private String eventLogId;
    /* Object ID*/
    private String objectId;
    /* Fence ID*/
    private String fenceId;
    /* 상태 */
    private String status;
    /* 구역 ID*/
    private String areaId;
    /* 장치 ID */
    private String deviceId;
    /* 이벤트 ID*/
    private String eventId;
    /* 이벤트 발생 일시 */
    private Date eventDatetime;
    /* 확인 ID */
    private String confirmUserId;
    /* 확인 일시 */
    private Date confirmDatetime;
    /* 해제 ID */
    private String cancelUserId;
    /* 해제 일시 */
    private Date cancelDatetime;
    /* 해제 내용 */
    private String cancelDesc;
    /* 임계치레벨 */
    private String criticalLevel;
    /* value */
    private Double value;

    /* ETC */
    /* 구역명 */
    private String areaName;
    /* 펜스명 */
    private String fenceName;
    /* 장치명 */
    private String deviceName;
    /* 이벤트명 */
    private String eventName;
    /* 확인자 */
    private String confirmUserName;
    /* 해제자 */
    private String cancelUserName;
    /* 갯수 */
    private Integer notiCnt;
    /* 이벤트 발생일시 String */
    private String eventDatetimeStr;
    /* 확인일시 String */
    private String confirmDatetimeStr;
    /* 해제일시 String */
    private String cancelDatetimeStr;
    /* 임계치레벨명 */
    private String criticalLevelName;

    public String getNotificationId() {
        return notificationId;
    }

    public void setNotificationId(String notificationId) {
        this.notificationId = notificationId;
    }

    public String getEventLogId() {
        return eventLogId;
    }

    public void setEventLogId(String eventLogId) {
        this.eventLogId = eventLogId;
    }

    public String getObjectId() {
        return objectId;
    }

    public void setObjectId(String objectId) {
        this.objectId = objectId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getAreaId() {
        return areaId;
    }

    public void setAreaId(String areaId) {
        this.areaId = areaId;
    }

    public String getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(String deviceId) {
        this.deviceId = deviceId;
    }

    public String getEventId() {
        return eventId;
    }

    public void setEventId(String eventId) {
        this.eventId = eventId;
    }

    public Date getEventDatetime() {
        return eventDatetime;
    }

    public void setEventDatetime(Date eventDatetime) {
        this.eventDatetime = eventDatetime;
    }

    public String getConfirmUserId() {
        return confirmUserId;
    }

    public void setConfirmUserId(String confirmUserId) {
        this.confirmUserId = confirmUserId;
    }

    public Date getConfirmDatetime() {
        return confirmDatetime;
    }

    public void setConfirmDatetime(Date confirmDatetime) {
        this.confirmDatetime = confirmDatetime;
    }

    public String getCancelUserId() {
        return cancelUserId;
    }

    public void setCancelUserId(String cancelUserId) {
        this.cancelUserId = cancelUserId;
    }

    public Date getCancelDatetime() {
        return cancelDatetime;
    }

    public void setCancelDatetime(Date cancelDatetime) {
        this.cancelDatetime = cancelDatetime;
    }

    public String getCancelDesc() {
        return cancelDesc;
    }

    public void setCancelDesc(String cancelDesc) {
        this.cancelDesc = cancelDesc;
    }

    public String getCriticalLevel() {
        return criticalLevel;
    }

    public void setCriticalLevel(String criticalLevel) {
        this.criticalLevel = criticalLevel;
    }

    public String getAreaName() {
        return areaName;
    }

    public void setAreaName(String areaName) {
        this.areaName = areaName;
    }

    public String getDeviceName() {
        return deviceName;
    }

    public void setDeviceName(String deviceName) {
        this.deviceName = deviceName;
    }

    public String getEventName() {
        return eventName;
    }

    public void setEventName(String eventName) {
        this.eventName = eventName;
    }

    public String getConfirmUserName() {
        return confirmUserName;
    }

    public void setConfirmUserName(String confirmUserName) {
        this.confirmUserName = confirmUserName;
    }

    public String getCancelUserName() {
        return cancelUserName;
    }

    public void setCancelUserName(String cancelUserName) {
        this.cancelUserName = cancelUserName;
    }

    public Integer getNotiCnt() {
        return notiCnt;
    }

    public void setNotiCnt(Integer notiCnt) {
        this.notiCnt = notiCnt;
    }

    public String getFenceId() {
        return fenceId;
    }

    public void setFenceId(String fenceId) {
        this.fenceId = fenceId;
    }

    public Double getValue() {
        return value;
    }

    public void setValue(Double value) {
        this.value = value;
    }

    public String getConfirmDatetimeStr() {
        return confirmDatetimeStr;
    }

    public void setConfirmDatetimeStr(String confirmDatetimeStr) {
        this.confirmDatetimeStr = confirmDatetimeStr;
    }

    public String getCancelDatetimeStr() {
        return cancelDatetimeStr;
    }

    public void setCancelDatetimeStr(String cancelDatetimeStr) {
        this.cancelDatetimeStr = cancelDatetimeStr;
    }

    public String getEventDatetimeStr() {
        return eventDatetimeStr;
    }

    public void setEventDatetimeStr(String eventDatetimeStr) {
        this.eventDatetimeStr = eventDatetimeStr;
    }

    public String getCriticalLevelName() {
        return criticalLevelName;
    }

    public void setCriticalLevelName(String criticalLevelName) {
        this.criticalLevelName = criticalLevelName;
    }

    public String getFenceName() {
        return fenceName;
    }

    public void setFenceName(String fenceName) {
        this.fenceName = fenceName;
    }
}
