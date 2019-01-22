package com.icent.isaver.admin.bean;

import java.util.Date;

/**
 * 사용자 Bean
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
public class UsersBean extends ISaverCommonBean {

    /* 사용자  ID*/
    private String userId;
    /* 권한 ID*/
    private String roleId;
    /* 사용자 비밀번호 */
    private String userPassword;
    /* 사용자 명 */
    private String userName;
    /* 사용자 이메일 */
    private String email;
    /* 사용자 삭제 여부 */
    private String delYn;
    /* 연락처 */
    private String telephone;

    /* 등록자 */
    private String insertUserId = null;

    /* 등록일자 */
    private Date insertDatetime = null;

    /* 수정자 */
    private String updateUserId = null;

    /* 수정일자 */
    private Date updateDatetime = null;

    /* 등록자명 */
    private String insertUserName = null;

    /* 수정자명 */
    private String updateUserName = null;

    /* etc */
    private String roleName = null;

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getRoleId() {
        return roleId;
    }

    public void setRoleId(String roleId) {
        this.roleId = roleId;
    }

    public String getUserPassword() {
        return userPassword;
    }

    public void setUserPassword(String userPassword) {
        this.userPassword = userPassword;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getDelYn() {
        return delYn;
    }

    public void setDelYn(String delYn) {
        this.delYn = delYn;
    }

    public String getTelephone() {
        return telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    public String getInsertUserId() {
        return insertUserId;
    }

    public void setInsertUserId(String insertUserId) {
        this.insertUserId = insertUserId;
    }

    public Date getInsertDatetime() {
        return insertDatetime;
    }

    public void setInsertDatetime(Date insertDatetime) {
        this.insertDatetime = insertDatetime;
    }

    public String getUpdateUserId() {
        return updateUserId;
    }

    public void setUpdateUserId(String updateUserId) {
        this.updateUserId = updateUserId;
    }

    public Date getUpdateDatetime() {
        return updateDatetime;
    }

    public void setUpdateDatetime(Date updateDatetime) {
        this.updateDatetime = updateDatetime;
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

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }
}
