package main.java.com.icent.isaver.admin.bean;

import java.util.List;

/**
 * [Bean] 구역
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
public class AreaBean extends ISaverCommonBean {

    /* 구역 ID*/
    private String areaId;
    /* 상위 구역 ID*/
    private String parentAreaId;
    /* 구역명*/
    private String areaName;
    /* 구역설명 */
    private String areaDesc;
    /* 삭제 여부 */
    private String delYn;
    /* 정렬 순서 */
    private Integer sortOrder;
    /* 구역 깊이 */
    private Integer depth;
    /* 템플릿 코드 */
    private String templateCode;
    /* 파일ID */
    private String fileId;

    /* ETC */
    private List<DeviceBean> devices;
    private List<AreaBean> areas;

    private String areaPath;
    private String path;

    private String childAreaIds;

    private Integer eventCnt;

    private String physicalFileName;

    public String getAreaId() {
        return areaId;
    }

    public void setAreaId(String areaId) {
        this.areaId = areaId;
    }

    public String getParentAreaId() {
        return parentAreaId;
    }

    public void setParentAreaId(String parentAreaId) {
        this.parentAreaId = parentAreaId;
    }

    public String getAreaName() {
        return areaName;
    }

    public void setAreaName(String areaName) {
        this.areaName = areaName;
    }

    public String getAreaDesc() {
        return areaDesc;
    }

    public void setAreaDesc(String areaDesc) {
        this.areaDesc = areaDesc;
    }

    public String getDelYn() {
        return delYn;
    }

    public void setDelYn(String delYn) {
        this.delYn = delYn;
    }

    public Integer getSortOrder() {
        return sortOrder;
    }

    public void setSortOrder(Integer sortOrder) {
        this.sortOrder = sortOrder;
    }

    public Integer getDepth() {
        return depth;
    }

    public void setDepth(Integer depth) {
        this.depth = depth;
    }

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }

    public Integer getEventCnt() {
        return eventCnt;
    }

    public void setEventCnt(Integer eventCnt) {
        this.eventCnt = eventCnt;
    }

    public String getChildAreaIds() {
        return childAreaIds;
    }

    public void setChildAreaIds(String childAreaIds) {
        this.childAreaIds = childAreaIds;
    }

    public List<DeviceBean> getDevices() {
        return devices;
    }

    public void setDevices(List<DeviceBean> devices) {
        this.devices = devices;
    }

    public String getTemplateCode() {
        return templateCode;
    }

    public void setTemplateCode(String templateCode) {
        this.templateCode = templateCode;
    }

    public List<AreaBean> getAreas() {
        return areas;
    }

    public void setAreas(List<AreaBean> areas) {
        this.areas = areas;
    }

    public String getFileId() {
        return fileId;
    }

    public void setFileId(String fileId) {
        this.fileId = fileId;
    }

    public String getPhysicalFileName() {
        return physicalFileName;
    }

    public void setPhysicalFileName(String physicalFileName) {
        this.physicalFileName = physicalFileName;
    }

    public String getAreaPath() {
        return areaPath;
    }

    public void setAreaPath(String areaPath) {
        this.areaPath = areaPath;
    }
}
