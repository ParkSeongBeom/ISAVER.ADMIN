package main.java.com.icent.isaver.admin.bean;

/**
 * 고객사 Bean
 *
 * @author : psb
 * @version : 1.0
 * @since : 2018. 5. 29.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2018. 5. 29.     psb           최초 생성
 * </pre>
 */
public class TargetBean {

    /* 고객사 ID*/
    private String targetId;
    /* 고객사 명*/
    private String targetName;

    /* ETC */

    public String getTargetId() {
        return targetId;
    }

    public void setTargetId(String targetId) {
        this.targetId = targetId;
    }

    public String getTargetName() {
        return targetName;
    }

    public void setTargetName(String targetName) {
        this.targetName = targetName;
    }
}
