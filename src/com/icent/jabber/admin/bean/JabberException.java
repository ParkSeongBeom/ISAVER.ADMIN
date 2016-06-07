package com.icent.jabber.admin.bean;

/**
 * Jabber 공통 Custom Exception
 *
 * @author kst
 * @since 2014. 4. 7.
 * @version 1.0
 * @see
 *
 *      <pre>
 * << 개정이력(Modification Information) >>
 *
 *   수정일            수정자           수정내용
 *  --------------    -------------    ----------------------
 *   2014. 4. 7.     kst              최초 생성
 *
 * </pre>
 */
public class JabberException extends RuntimeException {

    private static final long serialVersionUID = 1L;

    // 에러코드
    private String code = null;

    // 에러메시지
    private String message = null;

    // 에러상세 메시지
    private String detailMessage = null;

    public JabberException(String code){
        this.code = code;
    }

    public JabberException(String code, String detailMessage){
        this.code = code;
        this.detailMessage = detailMessage;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getDetailMessage() {
        return detailMessage;
    }

    public void setDetailMessage(String detailMessage) {
        this.detailMessage = detailMessage;
    }



}
