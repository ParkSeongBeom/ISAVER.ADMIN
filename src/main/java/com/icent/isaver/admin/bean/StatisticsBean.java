package com.icent.isaver.admin.bean;

/**
 * 통계 Bean
 *
 * @author : psb
 * @version : 1.0
 * @since : 2019. 10. 24.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2019. 10. 24.     psb           최초 생성
 * </pre>
 */
public class StatisticsBean extends ISaverCommonBean {

    /* 통계 ID*/
    private String statisticsId;
    /* 통계 명*/
    private String statisticsName;
    /* 차트타입*/
    private String chartType;
    /* 조회조건*/
    private String jsonData;

    /**
     * Etc
     */

    public String getStatisticsId() {
        return statisticsId;
    }

    public void setStatisticsId(String statisticsId) {
        this.statisticsId = statisticsId;
    }

    public String getStatisticsName() {
        return statisticsName;
    }

    public void setStatisticsName(String statisticsName) {
        this.statisticsName = statisticsName;
    }

    public String getChartType() {
        return chartType;
    }

    public void setChartType(String chartType) {
        this.chartType = chartType;
    }

    public String getJsonData() {
        return jsonData;
    }

    public void setJsonData(String jsonData) {
        this.jsonData = jsonData;
    }
}