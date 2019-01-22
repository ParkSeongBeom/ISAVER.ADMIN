package main.java.com.icent.isaver.admin.bean;

/**
 * [Bean] 대응
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
public class ActionBean extends ISaverCommonBean {

    /* 대응ID */
    private String actionId;
    /* 대응구분코드ID */
    private String actionCode;
    /* 대응방법 */
    private String actionDesc;
    /* 삭제여부*/
    private String delYn;

    /*
     * Etc
     */
    /* 이벤트 명 */
    private String eventName;
    /* 미포함 대응 ID*/
    private String notInActionId;

    public String getActionId() {
        return actionId;
    }

    public void setActionId(String actionId) {
        this.actionId = actionId;
    }

    public String getActionCode() {
        return actionCode;
    }

    public void setActionCode(String actionCode) {
        this.actionCode = actionCode;
    }

    public String getActionDesc() {
        return actionDesc;
    }

    public void setActionDesc(String actionDesc) {
        this.actionDesc = actionDesc;
    }

    public String getDelYn() {
        return delYn;
    }

    public void setDelYn(String delYn) {
        this.delYn = delYn;
    }

    public String getEventName() {
        return eventName;
    }

    public void setEventName(String eventName) {
        this.eventName = eventName;
    }

    public String getNotInActionId() {
        return notInActionId;
    }

    public void setNotInActionId(String notInActionId) {
        this.notInActionId = notInActionId;
    }
}
