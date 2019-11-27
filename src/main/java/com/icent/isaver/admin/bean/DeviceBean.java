package com.icent.isaver.admin.bean;

/**
 * [Bean] 장치
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
public class DeviceBean extends ISaverCommonBean {

    /* 장치 ID */
    private String deviceId;
    /* 장치명 */
    private String deviceName;
    /* 상위 장치 ID*/
    private String parentDeviceId;
    /* 구역 ID*/
    private String areaId;
    /* 장치 분류 코드*/
    private String deviceTypeCode;
    /* 장치 코드*/
    private String deviceCode;
    /* 장치 시리얼명 */
    private String serialNo;
    /* 장치 IP 주소 */
    private String ipAddress;
    /* 포트 */
    private Integer port;
    /* 장치 사용자ID */
    private String deviceUserId;
    /* 장치 비밀번호 */
    private String devicePassword;
    /* 장치 설명*/
    private String deviceDesc;
    /* 프로비저닝여부 */
    private String provisionFlag;
    /* 장치 상태 */
    private String deviceStat;
    /* 제조사 */
    private String vendorCode;
    /* 삭제 여부 */
    private String delYn;
    /* 구역 깊이 */
    private Integer depth;
    /* 카메라 외부 링크 URL */
    private String linkUrl;
    /* 카메라 서브 URL */
    private String subUrl;
    /* 미디어 서버 URL */
    private String streamServerUrl;
    /* M8 메인여부 */
    private String mainFlag;
    /* 버전정보 */
    private String version;
    /* 설정정보 */
    private String config;

    /* ETC */
    private String useFileYn;

    private String vendorCodeName;
    private String deviceTypeCodeName;
    private String deviceCodeName;
    private String deviceCodeCss;
    private String areaName;

    private String path;
    private String parentDeviceName;
    private String evtValue;

    private String fenceId;
    private String fenceName;
    private String format;

    public String getParentDeviceName() {
        return parentDeviceName;
    }

    public void setParentDeviceName(String parentDeviceName) {
        this.parentDeviceName = parentDeviceName;
    }

    public String getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(String deviceId) {
        this.deviceId = deviceId;
    }

    public String getParentDeviceId() {
        return parentDeviceId;
    }

    public void setParentDeviceId(String parentDeviceId) {
        this.parentDeviceId = parentDeviceId;
    }

    public String getAreaId() {
        return areaId;
    }

    public void setAreaId(String areaId) {
        this.areaId = areaId;
    }

    public String getDeviceTypeCode() {
        return deviceTypeCode;
    }

    public void setDeviceTypeCode(String deviceTypeCode) {
        this.deviceTypeCode = deviceTypeCode;
    }

    public String getDeviceCode() {
        return deviceCode;
    }

    public void setDeviceCode(String deviceCode) {
        this.deviceCode = deviceCode;
    }

    public String getSerialNo() {
        return serialNo;
    }

    public void setSerialNo(String serialNo) {
        this.serialNo = serialNo;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    public String getDeviceDesc() {
        return deviceDesc;
    }

    public void setDeviceDesc(String deviceDesc) {
        this.deviceDesc = deviceDesc;
    }

    public String getProvisionFlag() {
        return provisionFlag;
    }

    public void setProvisionFlag(String provisionFlag) {
        this.provisionFlag = provisionFlag;
    }

    public String getDeviceStat() {
        return deviceStat;
    }

    public void setDeviceStat(String deviceStat) {
        this.deviceStat = deviceStat;
    }

    public String getDelYn() {
        return delYn;
    }

    public void setDelYn(String delYn) {
        this.delYn = delYn;
    }

    public Integer getDepth() {
        return depth;
    }

    public void setDepth(Integer depth) {
        this.depth = depth;
    }

    public String getDeviceCodeName() {
        return deviceCodeName;
    }

    public void setDeviceCodeName(String deviceCodeName) {
        this.deviceCodeName = deviceCodeName;
    }

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }

    public String getAreaName() {
        return areaName;
    }

    public void setAreaName(String areaName) {
        this.areaName = areaName;
    }

    public String getUseFileYn() {
        return useFileYn;
    }

    public void setUseFileYn(String useFileYn) {
        this.useFileYn = useFileYn;
    }

    public String getLinkUrl() {
        return linkUrl;
    }

    public void setLinkUrl(String linkUrl) {
        this.linkUrl = linkUrl;
    }

    public String getEvtValue() {
        return evtValue;
    }

    public void setEvtValue(String evtValue) {
        this.evtValue = evtValue;
    }

    public String getDeviceTypeCodeName() {
        return deviceTypeCodeName;
    }

    public void setDeviceTypeCodeName(String deviceTypeCodeName) {
        this.deviceTypeCodeName = deviceTypeCodeName;
    }

    public Integer getPort() {
        return port;
    }

    public void setPort(Integer port) {
        this.port = port;
    }

    public String getDeviceUserId() {
        return deviceUserId;
    }

    public void setDeviceUserId(String deviceUserId) {
        this.deviceUserId = deviceUserId;
    }

    public String getDevicePassword() {
        return devicePassword;
    }

    public void setDevicePassword(String devicePassword) {
        this.devicePassword = devicePassword;
    }

    public String getVendorCode() {
        return vendorCode;
    }

    public void setVendorCode(String vendorCode) {
        this.vendorCode = vendorCode;
    }

    public String getVendorCodeName() {
        return vendorCodeName;
    }

    public void setVendorCodeName(String vendorCodeName) {
        this.vendorCodeName = vendorCodeName;
    }

    public String getSubUrl() {
        return subUrl;
    }

    public void setSubUrl(String subUrl) {
        this.subUrl = subUrl;
    }

    public String getStreamServerUrl() {
        return streamServerUrl;
    }

    public void setStreamServerUrl(String streamServerUrl) {
        this.streamServerUrl = streamServerUrl;
    }

    public String getDeviceName() {
        return deviceName;
    }

    public void setDeviceName(String deviceName) {
        this.deviceName = deviceName;
    }

    public String getMainFlag() {
        return mainFlag;
    }

    public void setMainFlag(String mainFlag) {
        this.mainFlag = mainFlag;
    }

    public String getVersion() {
        return version;
    }

    public void setVersion(String version) {
        this.version = version;
    }

    public String getConfig() {
        return config;
    }

    public void setConfig(String config) {
        this.config = config;
    }

    public String getFenceId() {
        return fenceId;
    }

    public void setFenceId(String fenceId) {
        this.fenceId = fenceId;
    }

    public String getFenceName() {
        return fenceName;
    }

    public void setFenceName(String fenceName) {
        this.fenceName = fenceName;
    }

    public String getFormat() {
        return format;
    }

    public void setFormat(String format) {
        this.format = format;
    }

    public String getDeviceCodeCss() {
        return deviceCodeCss;
    }

    public void setDeviceCodeCss(String deviceCodeCss) {
        this.deviceCodeCss = deviceCodeCss;
    }
}
