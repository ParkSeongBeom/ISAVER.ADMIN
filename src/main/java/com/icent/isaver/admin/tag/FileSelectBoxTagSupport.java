package main.java.com.icent.isaver.admin.tag;

import com.icent.isaver.admin.util.AppContextUtil;
import com.icent.isaver.admin.bean.FileBean;
import com.icent.isaver.admin.dao.FileDao;
import com.kst.common.util.StringUtils;
import org.apache.taglibs.standard.tag.el.core.ParamTag;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * [Spring Custom Tag] 파일용 SELECT BOX HTML TAG
 *
 * @author : psb
 * @version : 1.0
 * @since : 2019. 1. 4.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2019. 1. 4.     psb           최초 생성
 * </pre>
 */
public class FileSelectBoxTagSupport extends ParamTag {

    private static final long serialVersionUID = 2029143573644447215L;

    /* 파일 타입 */
    private String fileType = "";
    /* 파일 ID */
    private String fileId = "";
    /* htmlTag(ID) 명 */
    private String htmlTagId = "";
    /* htmlTag(NAME) 명 */
    private String htmlTagName = "";
    /* htmlTag(CLASS) 명 */
    private String htmlTagClass = "";
    /* 전체여부 */
    private Boolean allModel = false;
    /* 비활성여부 */
    private Boolean disabled = false;
    /* 전체 */
    private String allText = "";

    public void setFileType(String fileType) {
        this.fileType = fileType;
    }

    public void setFileId(String fileId) {
        this.fileId = fileId;
    }

    public void setHtmlTagId(String htmlTagId) {
        this.htmlTagId = htmlTagId;
    }

    public void setHtmlTagName(String htmlTagName) {
        this.htmlTagName = htmlTagName;
    }

    public void setHtmlTagClass(String htmlTagClass) {
        this.htmlTagClass = htmlTagClass;
    }

    public void setAllModel(Boolean allModel) {
        this.allModel = allModel;
    }

    public void setDisabled(Boolean disabled) {
        this.disabled = disabled;
    }

    public void setAllText(String allText) {
        this.allText = allText;
    }

    public int doEndTag() {
        StringBuilder sb = new StringBuilder();
        FileDao fileDao = AppContextUtil.getInstance().getBean(FileDao.class);

        Map<String, String> paramBean = new HashMap<>();
        paramBean.put("fileType",fileType);
        paramBean.put("useYn","Y");

        List<FileBean> iconFileList = fileDao.findListFile(paramBean);
        sb.append("<select ");
        if (StringUtils.notNullCheck(htmlTagId)) {
            sb.append(String.format("id=\"%s\"", htmlTagId));
        }

        if (StringUtils.notNullCheck(htmlTagName)) {
            sb.append(String.format(" name=\"%s\"", htmlTagName));
        }

        if (StringUtils.notNullCheck(htmlTagClass)) {
            sb.append(String.format(" class=\"%s\"", htmlTagClass));
        }

        if (StringUtils.notNullCheck(htmlTagClass)) {
            sb.append(String.format(" beforeSelect=\"%s\"", fileId));
        }

        if (disabled) {
            sb.append(" disabled");
        }

        sb.append(">");
        if(allModel) {
            sb.append(String.format("<option value=\"\">%s</option>", StringUtils.notNullCheck(allText) ? allText : "All") );
        }
        if(iconFileList!=null) {
            for (FileBean file : iconFileList) {
                if (fileId.equals(file.getFileId())) {
                    sb.append(String.format("<option value=\"%s\" selected=\"selected\">%s</option>", file.getFileId(), file.getTitle()));
                } else {
                    sb.append(String.format("<option value=\"%s\">%s</option>", file.getFileId(), file.getTitle()));
                }
            }
        }
        sb.append("</select>");

        try {
            pageContext.getOut().write(sb.toString());
        } catch (IOException e) {

        } finally {

        }

        return EVAL_PAGE;
    }
}
