package com.icent.isaver.admin.bean;

import java.util.Date;

/**
 * 시스템로그 Bean
 *
 * @author : psb
 * @version : 1.0
 * @since : 2019. 10. 21.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2019. 10. 21.     psb           최초 생성
 * </pre>
 */
public class SystemLogBean {

    /* 시스템로그 ID*/
    private String systemLogId;
    /* 파일명*/
    private String fileName;
    /* 이력저장시간*/
    private Date logDatetime;

    /**
     * Etc
     */

    public String getSystemLogId() {
        return systemLogId;
    }

    public void setSystemLogId(String systemLogId) {
        this.systemLogId = systemLogId;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public Date getLogDatetime() {
        return logDatetime;
    }

    public void setLogDatetime(Date logDatetime) {
        this.logDatetime = logDatetime;
    }
}