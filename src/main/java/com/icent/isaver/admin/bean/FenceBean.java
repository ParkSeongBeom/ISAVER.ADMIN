package main.java.com.icent.isaver.admin.bean;

import java.util.List;

/**
 * 펜스 Bean
 *
 * @author : psb
 * @version : 1.0
 * @since : 2018. 7. 9.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2018. 7. 9.     psb           최초 생성
 * </pre>
 */
public class FenceBean {

    /* UUID*/
    private String uuid;
    /* 펜스 ID*/
    private String fenceId;
    /* 펜스타입*/
    private String fenceType;
    /* 장치 ID*/
    private String deviceId;

    /* 펜스명*/
    private String fenceName;

    /**
     * Etc
     */
    /* 구역 ID*/
    private String areaId;

    private List<FenceLocationBean> location;

    public String getUuid() {
        return uuid;
    }

    public void setUuid(String uuid) {
        this.uuid = uuid;
    }

    public String getFenceId() {
        return fenceId;
    }

    public void setFenceId(String fenceId) {
        this.fenceId = fenceId;
    }

    public String getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(String deviceId) {
        this.deviceId = deviceId;
    }

    public String getFenceName() {
        return fenceName;
    }

    public void setFenceName(String fenceName) {
        this.fenceName = fenceName;
    }

    public List<FenceLocationBean> getLocation() {
        return location;
    }

    public void setLocation(List<FenceLocationBean> location) {
        this.location = location;
    }

    public String getAreaId() {
        return areaId;
    }

    public void setAreaId(String areaId) {
        this.areaId = areaId;
    }

    public String getFenceType() {
        return fenceType;
    }

    public void setFenceType(String fenceType) {
        this.fenceType = fenceType;
    }
}
