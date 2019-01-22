package com.icent.isaver.admin.bean;

/**
 * [Bean] 그룹 코드
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
public class GroupCodeBean extends ISaverCommonBean {
    /* 그룹 코드 ID*/
    private String groupCodeId;
    /* 그룹 명 */
    private String groupName;

    /* 등록자명 */
    private String insertUserName = null;

    /* 수정자명 */
    private String updateUserName = null;

    public String getGroupCodeId() {
        return groupCodeId;
    }

    public void setGroupCodeId(String groupCodeId) {
        this.groupCodeId = groupCodeId;
    }

    public String getGroupName() {
        return groupName;
    }

    public void setGroupName(String groupName) {
        this.groupName = groupName;
    }

    public String getInsertUserName() {
        return insertUserName;
    }

    public void setInsertUserName(String insertUserName) {
        this.insertUserName = insertUserName;
    }

    public String getUpdateUserName() {
        return updateUserName;
    }

    public void setUpdateUserName(String updateUserName) {
        this.updateUserName = updateUserName;
    }
}
