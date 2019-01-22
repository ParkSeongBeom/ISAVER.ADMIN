package main.java.com.icent.isaver.admin.bean;

import java.util.Date;
import java.util.List;

/**
 * 통계 Bean
 *
 * @author : psb
 * @version : 1.0
 * @since : 2016. 8. 4.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2016. 8. 4.     psb           최초 생성
 *  2018. 2. 23.     psb           통계 테이블 변경으로 인한 수정
 * </pre>
 */
public class EventStatisticsBean {
    /* 날짜 */
    private Date stDt;
    /* 날짜 String */
    private String stDtStr;

    /* 구역 ID */
    private String areaId;
    /* 장치 ID */
    private String deviceId;
    /* 이벤트 ㅑㅇ */
    private String eventId;
    /* 값 */
    private Double value;
    /* 요일 */
    private Integer dow;
    /* 주 */
    private Integer week;

    /* ETC */
    private List<EventStatisticsBean> infos;

    /* etc */
    private String areaName;
    private String deviceName;
    private String eventName;

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

    public Double getValue() {
        return value;
    }

    public void setValue(Double value) {
        this.value = value;
    }

    public Integer getDow() {
        return dow;
    }

    public void setDow(Integer dow) {
        this.dow = dow;
    }

    public Integer getWeek() {
        return week;
    }

    public void setWeek(Integer week) {
        this.week = week;
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

    public Date getStDt() {
        return stDt;
    }

    public void setStDt(Date stDt) {
        this.stDt = stDt;
    }

    public String getStDtStr() {
        return stDtStr;
    }

    public void setStDtStr(String stDtStr) {
        this.stDtStr = stDtStr;
    }

    public List<EventStatisticsBean> getInfos() {
        return infos;
    }

    public void setInfos(List<EventStatisticsBean> infos) {
        this.infos = infos;
    }
}
