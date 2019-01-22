package com.icent.isaver.admin.bean;

/**
 * 펜스 좌표 Bean
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
public class FenceLocationBean {

    private String uuid;

    private Double lat;

    private Double lng;

    public FenceLocationBean() {}

    public FenceLocationBean(String uuid) {
        this.uuid = uuid;
    }

    public FenceLocationBean(String uuid, Double lat, Double lng) {
        this.uuid = uuid;
        this.lat = lat;
        this.lng = lng;
    }

    public String getUuid() {
        return uuid;
    }

    public void setUuid(String uuid) {
        this.uuid = uuid;
    }

    public Double getLat() {
        return lat;
    }

    public void setLat(Double lat) {
        this.lat = lat;
    }

    public Double getLng() {
        return lng;
    }

    public void setLng(Double lng) {
        this.lng = lng;
    }
}
