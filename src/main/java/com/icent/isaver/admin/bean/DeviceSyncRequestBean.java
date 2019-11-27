package com.icent.isaver.admin.bean;

import java.util.Date;

/**
 * 장치 동기화 요청 Bean
 *
 * @author : psb
 * @version : 1.0
 * @since : 2016. 10. 24.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 10. 24.     psb           최초 생성
 * </pre>
 */
public class DeviceSyncRequestBean extends ISaverCommonBean {

    /* 장치동기화요청 ID*/
    private String deviceSyncRequestId;
    /* 장치 ID*/
    private String deviceId;
    /* 요청구분 */
    private String type;
    /* 처리상태 */
    private String status;
    /* 요청시작일시 */
    private Date startDatetime = null;
    /* 요청종료일시 */
    private Date endDatetime = null;

    /* etc */
    private String deviceName = null;

    public String getDeviceSyncRequestId() {
        return deviceSyncRequestId;
    }

    public void setDeviceSyncRequestId(String deviceSyncRequestId) {
        this.deviceSyncRequestId = deviceSyncRequestId;
    }

    public String getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(String deviceId) {
        this.deviceId = deviceId;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
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

    public String getDeviceName() {
        return deviceName;
    }

    public void setDeviceName(String deviceName) {
        this.deviceName = deviceName;
    }
}
