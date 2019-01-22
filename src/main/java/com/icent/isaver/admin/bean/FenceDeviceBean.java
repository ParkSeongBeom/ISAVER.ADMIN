package main.java.com.icent.isaver.admin.bean;

/**
 * 펜스 카메라 맵핑 Bean
 *
 * @author : psb
 * @version : 1.0
 * @since : 2018. 7. 10.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2018. 7. 10.     psb           최초 생성
 * </pre>
 */
public class FenceDeviceBean {

    /* UUID*/
    private String uuid;
    /* 장치 ID*/
    private String deviceId;

    /**
     * Etc
     */
    /* 펜스 ID*/
    private String fenceId;

    public String getUuid() {
        return uuid;
    }

    public void setUuid(String uuid) {
        this.uuid = uuid;
    }

    public String getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(String deviceId) {
        this.deviceId = deviceId;
    }

    public String getFenceId() {
        return fenceId;
    }

    public void setFenceId(String fenceId) {
        this.fenceId = fenceId;
    }
}
