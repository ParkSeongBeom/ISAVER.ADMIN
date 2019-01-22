package com.icent.isaver.admin.bean;

import java.util.Date;
import java.util.List;

/**
 * [Bean] 이벤트 로그
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
public class EventLogBean extends ISaverCommonBean {

    /* 이벤트 로그 ID */
    private String eventLogId;
    /* 구역 ID*/
    private String areaId;
    /* 장치 ID */
    private String deviceId;
    /* 이벤트 ID*/
    private String eventId;
    /* 이벤트 발생 일시 */
    private Date eventDatetime;

    /* ETC */
    private List<EventLogInfoBean> infos;

    /* 이벤트타입 */
    private String eventType;
    /* 이벤트유형 */
    private String eventFlag;
    /* 구역명 */
    private String areaName;
    /* 장치 유형 */
    private String deviceType;
    /* 장치 종류 */
    private String deviceCode;
    /* 임계치레벨 */
    private String criticalLevel;

    /* 이벤트 갯수 */
    private float value;

    /* 이벤트 갯수 */
    private Integer eventCnt;

    /* 장치명 */
    private String deviceName;

    /* 이벤트 명 */
    private String eventName;

    private String eventDatetimeStr;

    /* 진입자수 */
    private Integer inCount;
    /* 진출자수 */
    private Integer outCount;
    /* 화장실재실상태 */
    private String status;

    /* ETC */
    private Date startDatetime;
    private Date endDatetime;

    public String getEventLogId() {
        return eventLogId;
    }

    public void setEventLogId(String eventLogId) {
        this.eventLogId = eventLogId;
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

    public String getAreaName() {
        return areaName;
    }

    public void setAreaName(String areaName) {
        this.areaName = areaName;
    }

    public String getDeviceType() {
        return deviceType;
    }

    public void setDeviceType(String deviceType) {
        this.deviceType = deviceType;
    }

    public String getDeviceCode() {
        return deviceCode;
    }

    public void setDeviceCode(String deviceCode) {
        this.deviceCode = deviceCode;
    }

    public String getEventName() {
        return eventName;
    }

    public void setEventName(String eventName) {
        this.eventName = eventName;
    }

    public String getEventType() {
        return eventType;
    }

    public void setEventType(String eventType) {
        this.eventType = eventType;
    }

    public List<EventLogInfoBean> getInfos() {
        return infos;
    }

    public void setInfos(List<EventLogInfoBean> infos) {
        this.infos = infos;
    }

    public String getEventDatetimeStr() {
        return eventDatetimeStr;
    }

    public void setEventDatetimeStr(String eventDatetimeStr) {
        this.eventDatetimeStr = eventDatetimeStr;
    }

    public Integer getEventCnt() {
        return eventCnt;
    }

    public void setEventCnt(Integer eventCnt) {
        this.eventCnt = eventCnt;
    }

    public String getEventFlag() {
        return eventFlag;
    }

    public void setEventFlag(String eventFlag) {
        this.eventFlag = eventFlag;
    }

    public String getCriticalLevel() {
        return criticalLevel;
    }

    public void setCriticalLevel(String criticalLevel) {
        this.criticalLevel = criticalLevel;
    }

    public String getDeviceName() {
        return deviceName;
    }

    public void setDeviceName(String deviceName) {
        this.deviceName = deviceName;
    }

    public float getValue() {
        return value;
    }

    public void setValue(float value) {
        this.value = value;
    }

    public Integer getInCount() {
        return inCount;
    }

    public void setInCount(Integer inCount) {
        this.inCount = inCount;
    }

    public Integer getOutCount() {
        return outCount;
    }

    public void setOutCount(Integer outCount) {
        this.outCount = outCount;
    }

    public Date getStartDatetime() {
        return startDatetime;
    }

    public void setStartDatetime(Date startDatetime) {
        this.startDatetime = startDatetime;
    }

    public Date getEndDatetime() {
        return endDatetime;
    }

    public void setEndDatetime(Date endDatetime) {
        this.endDatetime = endDatetime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
