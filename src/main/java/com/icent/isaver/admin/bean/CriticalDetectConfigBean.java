package com.icent.isaver.admin.bean;

/**
 * 임계치별 감지장치 설정 Bean
 *
 * @author : ljh
 * @version : 1.0
 * @since : 2019. 3. 25.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2019. 3. 25.     ljh           최초 생성
 * </pre>
 */
public class CriticalDetectConfigBean {
    private String criticalDetectConfigId;
    private String criticalDetectId;
    private String startDatetime;
    private String endDatetime;
    private String useYn;

    public String getCriticalDetectConfigId() {
        return criticalDetectConfigId;
    }

    public void setCriticalDetectConfigId(String criticalDetectConfigId) {
        this.criticalDetectConfigId = criticalDetectConfigId;
    }

    public String getCriticalDetectId() {
        return criticalDetectId;
    }

    public void setCriticalDetectId(String criticalDetectId) {
        this.criticalDetectId = criticalDetectId;
    }

    public String getStartDatetime() {
        return startDatetime;
    }

    public void setStartDatetime(String startDatetime) {
        this.startDatetime = startDatetime;
    }

    public String getEndDatetime() {
        return endDatetime;
    }

    public void setEndDatetime(String endDatetime) {
        this.endDatetime = endDatetime;
    }

    public String getUseYn() {
        return useYn;
    }

    public void setUseYn(String useYn) {
        this.useYn = useYn;
    }
}
