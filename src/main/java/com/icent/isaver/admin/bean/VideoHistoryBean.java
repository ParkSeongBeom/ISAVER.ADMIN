package main.java.com.icent.isaver.admin.bean;

import java.util.Date;

/**
 * [Bean] 영상이력
 * @author : psb
 * @version : 1.0
 * @since : 2018. 8. 16.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2018. 8. 16.     psb           최초 생성
 * </pre>
 */
public class VideoHistoryBean {

    /* 영상이력 ID*/
    private String videoHistoryId;
    /* 장치 ID*/
    private String deviceId;
    /* 알림 ID*/
    private String notificationId;
    /* 비디오파일명*/
    private String videoFileName;
    /* 썸네일파일명*/
    private String thumbnailFileName;
    /* 비디오타입*/
    private String videoType;
    /* 이력저장시간*/
    private Date videoDatetime;
    /* 비디오파일크기*/
    private Integer videoSize;

    /**
     * Etc
     */
    /* 구역명 */
    private String areaName;
    /* 장치명 */
    private String deviceName;
    /* 이벤트명 */
    private String eventName;
    /* 펜스명 */
    private String fenceName;

    public String getVideoHistoryId() {
        return videoHistoryId;
    }

    public void setVideoHistoryId(String videoHistoryId) {
        this.videoHistoryId = videoHistoryId;
    }

    public String getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(String deviceId) {
        this.deviceId = deviceId;
    }

    public String getNotificationId() {
        return notificationId;
    }

    public void setNotificationId(String notificationId) {
        this.notificationId = notificationId;
    }

    public String getVideoFileName() {
        return videoFileName;
    }

    public void setVideoFileName(String videoFileName) {
        this.videoFileName = videoFileName;
    }

    public String getThumbnailFileName() {
        return thumbnailFileName;
    }

    public void setThumbnailFileName(String thumbnailFileName) {
        this.thumbnailFileName = thumbnailFileName;
    }

    public String getVideoType() {
        return videoType;
    }

    public void setVideoType(String videoType) {
        this.videoType = videoType;
    }

    public Date getVideoDatetime() {
        return videoDatetime;
    }

    public void setVideoDatetime(Date videoDatetime) {
        this.videoDatetime = videoDatetime;
    }

    public Integer getVideoSize() {
        return videoSize;
    }

    public void setVideoSize(Integer videoSize) {
        this.videoSize = videoSize;
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

    public String getFenceName() {
        return fenceName;
    }

    public void setFenceName(String fenceName) {
        this.fenceName = fenceName;
    }
}
