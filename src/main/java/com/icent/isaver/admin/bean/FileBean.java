package com.icent.isaver.admin.bean;

/**
 * [Bean] 파일
 *
 * @author psb
 * @since 2016. 12. 20.
 * @version 1.0
 * @see   <pre>
 * << 개정이력(Modification Information) >>
 *   수정일         수정자            수정내용
 *  ----------   --------  ----------------------
 *  2016.12.20     psb     최초 생성
 * </pre>
 */
public class FileBean extends ISaverCommonBean {
    /* 파일ID */
    private String fileId;

    /* 파일타입 */
    private String fileType;

    /* 제목 */
    private String title;

    /* 비고 */
    private String description;

    /* 논리파일명 */
    private String logicalFileName;

    /* 물리파일명 */
    private String physicalFileName;

    /* 파일크기 */
    private Integer fileSize;

    /* 파일경로 */
    private String filePath;

    /* 사용여부 */
    private String useYn;

    /**
     * Etc
     */
    /* 해당파일 다른테이블 사용여부 */
    private String fkUseYn;

    private String fileTypeName;

    public String getFileId() {
        return fileId;
    }

    public void setFileId(String fileId) {
        this.fileId = fileId;
    }

    public String getFileType() {
        return fileType;
    }

    public void setFileType(String fileType) {
        this.fileType = fileType;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getLogicalFileName() {
        return logicalFileName;
    }

    public void setLogicalFileName(String logicalFileName) {
        this.logicalFileName = logicalFileName;
    }

    public String getPhysicalFileName() {
        return physicalFileName;
    }

    public void setPhysicalFileName(String physicalFileName) {
        this.physicalFileName = physicalFileName;
    }

    public Integer getFileSize() {
        return fileSize;
    }

    public void setFileSize(Integer fileSize) {
        this.fileSize = fileSize;
    }

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public String getUseYn() {
        return useYn;
    }

    public void setUseYn(String useYn) {
        this.useYn = useYn;
    }

    public String getFkUseYn() {
        return fkUseYn;
    }

    public void setFkUseYn(String fkUseYn) {
        this.fkUseYn = fkUseYn;
    }

    public String getFileTypeName() {
        return fileTypeName;
    }

    public void setFileTypeName(String fileTypeName) {
        this.fileTypeName = fileTypeName;
    }
}
