package com.icent.isaver.admin.bean;

/**
 * Critical Block Bean
 *
 * @author : psb
 * @version : 1.0
 * @since : 2020. 06. 04.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2020. 06. 04.     psb           최초 생성
 * </pre>
 */
public class CriticalBlockBean {
    private String criticalBlockId;
    private String areaId;

    /**
     * Etc
     */

    public String getCriticalBlockId() {
        return criticalBlockId;
    }

    public void setCriticalBlockId(String criticalBlockId) {
        this.criticalBlockId = criticalBlockId;
    }

    public String getAreaId() {
        return areaId;
    }

    public void setAreaId(String areaId) {
        this.areaId = areaId;
    }
}
