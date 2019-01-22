package main.java.com.icent.isaver.admin.bean;

/**
 * 이벤트로그 상세 Bean
 *
 * @author : psb
 * @version : 1.0
 * @since : 2016. 10. 28.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2016. 10. 28.     psb           최초 생성
 * </pre>
 */
public class EventLogInfoBean {

    private String eventLogId;

    private String key;

    private String value;

    public EventLogInfoBean() {}

    public EventLogInfoBean(String eventLogId) {
        this.eventLogId = eventLogId;
    }

    public EventLogInfoBean(String eventLogId, String key, String value) {
        this.eventLogId = eventLogId;
        this.key = key;
        this.value = value;
    }

    public EventLogInfoBean(String key, String value) {
        this.key = key;
        this.value = value;
    }

    public String getEventLogId() {
        return eventLogId;
    }

    public void setEventLogId(String eventLogId) {
        this.eventLogId = eventLogId;
    }

    public String getKey() {
        return key;
    }

    public void setKey(String key) {
        this.key = key;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }
}
