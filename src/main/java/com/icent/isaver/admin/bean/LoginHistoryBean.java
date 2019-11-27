package com.icent.isaver.admin.bean;

import java.util.Date;

/**
 * 로그인 이력 Bean
 *
 * @author : psb
 * @version : 1.0
 * @since : 2016. 7. 4.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 7. 4.     psb           최초 생성
 * </pre>
 */
public class LoginHistoryBean extends ISaverCommonBean {

    /* 로그 ID*/
    private String logId;
    /* 사용자 ID*/
    private String userId;
    /* 로그인 구분 */
    private String loginFlag;
    /* 접속IP 주소 */
    private String ipAddress;
    /* 로그 발생 일시 */
    private Date logDatetime;

    /* 사용자명*/
    private String userName;

    /* 로그일시 String */
    private String logDatetimeStr = null;
    /* 로그인 구분 String */
    private String loginFlagStr = null;

    public String getLogId() {
        return logId;
    }

    public void setLogId(String logId) {
        this.logId = logId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getLoginFlag() {
        return loginFlag;
    }

    public void setLoginFlag(String loginFlag) {
        this.loginFlag = loginFlag;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    public Date getLogDatetime() {
        return logDatetime;
    }

    public void setLogDatetime(Date logDatetime) {
        this.logDatetime = logDatetime;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getLogDatetimeStr() {
        return logDatetimeStr;
    }

    public void setLogDatetimeStr(String logDatetimeStr) {
        this.logDatetimeStr = logDatetimeStr;
    }

    public String getLoginFlagStr() {
        return loginFlagStr;
    }

    public void setLoginFlagStr(String loginFlagStr) {
        this.loginFlagStr = loginFlagStr;
    }
}
