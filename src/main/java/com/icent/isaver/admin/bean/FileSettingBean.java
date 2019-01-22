package main.java.com.icent.isaver.admin.bean;

/**
 * [Bean] 파일 환경설정
 *
 * @author psb
 * @since 2018. 10. 29.
 * @version 1.0
 * @see   <pre>
 * << 개정이력(Modification Information) >>
 *   수정일         수정자            수정내용
 *  ----------   --------  ----------------------
 *  2018.10.29     psb     최초 생성
 * </pre>
 */
public class FileSettingBean extends ISaverCommonBean {
    /* 파일 구분 */
    private String fileType;
    /* 제한타입 */
    private String limitKeepType;
    /* 파일보관기간 */
    private Integer limitKeepTime;

    /**
     * Etc
     */

    public String getFileType() {
        return fileType;
    }

    public void setFileType(String fileType) {
        this.fileType = fileType;
    }

    public String getLimitKeepType() {
        return limitKeepType;
    }

    public void setLimitKeepType(String limitKeepType) {
        this.limitKeepType = limitKeepType;
    }

    public Integer getLimitKeepTime() {
        return limitKeepTime;
    }

    public void setLimitKeepTime(Integer limitKeepTime) {
        this.limitKeepTime = limitKeepTime;
    }
}
