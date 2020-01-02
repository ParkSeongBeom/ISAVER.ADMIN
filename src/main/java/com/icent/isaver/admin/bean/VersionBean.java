package com.icent.isaver.admin.bean;

import java.util.Date;

/**
 * Version Bean
 * @author : psb
 * @version : 1.0
 * @since : 2019. 12. 27.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2019. 12. 27.     psb           최초 생성
 * </pre>
 */

public class VersionBean {
    private String version;
    private Date insertDatetime;
    private Date updateDatetime;

    public String getVersion() {
        return version;
    }

    public void setVersion(String version) {
        this.version = version;
    }

    public Date getInsertDatetime() {
        return insertDatetime;
    }

    public void setInsertDatetime(Date insertDatetime) {
        this.insertDatetime = insertDatetime;
    }

    public Date getUpdateDatetime() {
        return updateDatetime;
    }

    public void setUpdateDatetime(Date updateDatetime) {
        this.updateDatetime = updateDatetime;
    }
}
