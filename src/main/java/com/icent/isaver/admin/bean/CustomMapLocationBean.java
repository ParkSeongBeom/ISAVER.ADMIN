package com.icent.isaver.admin.bean;

/**
 * Custom Map Bean
 *
 * @author : psb
 * @version : 1.0
 * @since : 2018. 6. 14.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2018. 6. 14.     psb           최초 생성
 * </pre>
 */
public class CustomMapLocationBean {

    /* 구역 ID*/
    private String areaId;
    /* 대상 ID*/
    private String targetId;
    /* 사용여부*/
    private String useYn;
    /* X1*/
    private Double x1;
    /* X2*/
    private Double x2;
    /* Y1*/
    private Double y1;
    /* Y2*/
    private Double y2;

    /* ETC */
    /* 구역/장치명*/
    private String targetName;
    /* 장치코드*/
    private String deviceCode;
    /* 장치상태*/
    private String deviceStat;
    /* 링크URL*/
    private String linkUrl;
    /* 메인Flag*/
    private String mainFlag;

    public String getAreaId() {
        return areaId;
    }

    public void setAreaId(String areaId) {
        this.areaId = areaId;
    }

    public String getTargetId() {
        return targetId;
    }

    public void setTargetId(String targetId) {
        this.targetId = targetId;
    }

    public String getUseYn() {
        return useYn;
    }

    public void setUseYn(String useYn) {
        this.useYn = useYn;
    }

    public Double getX1() {
        return x1;
    }

    public void setX1(Double x1) {
        this.x1 = x1;
    }

    public Double getX2() {
        return x2;
    }

    public void setX2(Double x2) {
        this.x2 = x2;
    }

    public Double getY1() {
        return y1;
    }

    public void setY1(Double y1) {
        this.y1 = y1;
    }

    public Double getY2() {
        return y2;
    }

    public void setY2(Double y2) {
        this.y2 = y2;
    }

    public String getDeviceCode() {
        return deviceCode;
    }

    public void setDeviceCode(String deviceCode) {
        this.deviceCode = deviceCode;
    }

    public String getTargetName() {
        return targetName;
    }

    public void setTargetName(String targetName) {
        this.targetName = targetName;
    }

    public String getDeviceStat() {
        return deviceStat;
    }

    public void setDeviceStat(String deviceStat) {
        this.deviceStat = deviceStat;
    }

    public String getLinkUrl() {
        return linkUrl;
    }

    public void setLinkUrl(String linkUrl) {
        this.linkUrl = linkUrl;
    }

    public String getMainFlag() {
        return mainFlag;
    }

    public void setMainFlag(String mainFlag) {
        this.mainFlag = mainFlag;
    }
}