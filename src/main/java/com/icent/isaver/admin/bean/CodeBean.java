package main.java.com.icent.isaver.admin.bean;

/**
 * [Bean] 코드
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
public class CodeBean extends ISaverCommonBean {

    /* 코드ID */
    private String codeId;
    /* 그룹 코드ID*/
    private String groupCodeId;
    /* 코드명 */
    private String codeName;
    /* 코드 설명 */
    private String codeDesc;
    /* 사용 여부*/
    private String useYn;
    /* 정렬 순서 */
    private Integer sortOrder;

    /* 등록자명 */
    private String insertUserName = null;

    /* 수정자명 */
    private String updateUserName = null;

    /* ETC */
    /* 장치수량 */
    private int deviceCnt;

    public String getCodeId() {
        return codeId;
    }

    public void setCodeId(String codeId) {
        this.codeId = codeId;
    }

    public String getGroupCodeId() {
        return groupCodeId;
    }

    public void setGroupCodeId(String groupCodeId) {
        this.groupCodeId = groupCodeId;
    }

    public String getCodeName() {
        return codeName;
    }

    public void setCodeName(String codeName) {
        this.codeName = codeName;
    }

    public String getCodeDesc() {
        return codeDesc;
    }

    public void setCodeDesc(String codeDesc) {
        this.codeDesc = codeDesc;
    }

    public String getUseYn() {
        return useYn;
    }

    public void setUseYn(String useYn) {
        this.useYn = useYn;
    }

    public Integer getSortOrder() {
        return sortOrder;
    }

    public void setSortOrder(Integer sortOrder) {
        this.sortOrder = sortOrder;
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

    public int getDeviceCnt() {
        return deviceCnt;
    }

    public void setDeviceCnt(int deviceCnt) {
        this.deviceCnt = deviceCnt;
    }
}
