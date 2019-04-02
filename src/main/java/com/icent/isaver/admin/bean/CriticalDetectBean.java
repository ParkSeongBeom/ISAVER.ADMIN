package com.icent.isaver.admin.bean;

import java.util.List;

/**
 * 임계치별 감지장치 Bean
 *
 * @author : psb
 * @version : 1.0
 * @since : 2018. 9. 21.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2018. 9. 21.     psb           최초 생성
 * </pre>
 */
public class CriticalDetectBean {
    private String criticalDetectId;
    private String criticalId;
    private String detectDeviceId;
    private String fenceId;
    private String useYn;

    /**
     * Etc
     */
    private List<CriticalTargetBean> criticalTargets;
    private List<CriticalDetectConfigBean> criticalDetectConfigs;

    public String getCriticalDetectId() {
        return criticalDetectId;
    }

    public void setCriticalDetectId(String criticalDetectId) {
        this.criticalDetectId = criticalDetectId;
    }

    public String getCriticalId() {
        return criticalId;
    }

    public void setCriticalId(String criticalId) {
        this.criticalId = criticalId;
    }

    public String getDetectDeviceId() {
        return detectDeviceId;
    }

    public void setDetectDeviceId(String detectDeviceId) {
        this.detectDeviceId = detectDeviceId;
    }

    public List<CriticalTargetBean> getCriticalTargets() {
        return criticalTargets;
    }

    public void setCriticalTargets(List<CriticalTargetBean> criticalTargets) {
        this.criticalTargets = criticalTargets;
    }

    public List<CriticalDetectConfigBean> getCriticalDetectConfigs() {
        return criticalDetectConfigs;
    }

    public void setCriticalDetectConfigs(List<CriticalDetectConfigBean> criticalDetectConfigs) {
        this.criticalDetectConfigs = criticalDetectConfigs;
    }

    public String getFenceId() {
        return fenceId;
    }

    public void setFenceId(String fenceId) {
        this.fenceId = fenceId;
    }

    public String getUseYn() {
        return useYn;
    }

    public void setUseYn(String useYn) {
        this.useYn = useYn;
    }
}
