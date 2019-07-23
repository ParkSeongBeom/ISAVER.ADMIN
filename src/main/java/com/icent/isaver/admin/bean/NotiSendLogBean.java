package com.icent.isaver.admin.bean;

import java.util.Date;

/**
 * 외부연동용 이벤트 전송 로그 Bean
 *
 * @author : psb
 * @version : 1.0
 * @since : 2019. 7. 23.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2019. 7. 23.     psb           최초 생성
 * </pre>
 */
public class NotiSendLogBean {

    private String notificationId;

    private String sendCode;

    private String sendUrl;

    private Date sendDatetime;

    /**
     * Etc
     */

    private String sendDatetimeStr;

    public String getNotificationId() {
        return notificationId;
    }

    public void setNotificationId(String notificationId) {
        this.notificationId = notificationId;
    }

    public String getSendCode() {
        return sendCode;
    }

    public void setSendCode(String sendCode) {
        this.sendCode = sendCode;
    }

    public String getSendUrl() {
        return sendUrl;
    }

    public void setSendUrl(String sendUrl) {
        this.sendUrl = sendUrl;
    }

    public Date getSendDatetime() {
        return sendDatetime;
    }

    public void setSendDatetime(Date sendDatetime) {
        this.sendDatetime = sendDatetime;
    }

    public String getSendDatetimeStr() {
        return sendDatetimeStr;
    }

    public void setSendDatetimeStr(String sendDatetimeStr) {
        this.sendDatetimeStr = sendDatetimeStr;
    }
}
