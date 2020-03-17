package com.icent.isaver.admin.tag;

import com.icent.isaver.admin.bean.CodeBean;
import com.icent.isaver.admin.dao.CodeDao;
import com.icent.isaver.admin.util.AppContextUtil;
import com.meous.common.util.StringUtils;
import org.apache.taglibs.standard.tag.el.core.ParamTag;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * [Spring Custom Tag] 코드용 SELECT BOX HTML TAG
 *
 * @author : dhj
 * @version : 1.0
 * @since : 2014. 6. 11.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 6. 11.     dhj           최초 생성
 * </pre>
 */
public class CodeSelectBoxTagSupport extends ParamTag {
    static Logger logger = LoggerFactory.getLogger(CodeSelectBoxTagSupport.class);

    private static final long serialVersionUID = 2029143573644447215L;

    /* 그룹 코드 ID */
    private String groupCodeId = "";
    /* 코드 ID */
    private String codeId = "";
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

    public void setGroupCodeId(String groupCodeId) {
        this.groupCodeId = groupCodeId;
    }

    public void setCodeId(String codeId) {
        this.codeId = codeId;
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
        CodeDao codeDao = AppContextUtil.getInstance().getBean(CodeDao.class);

        if(StringUtils.notNullCheck(groupCodeId)) {
            Map<String, String> paramBean = new HashMap<>();
            paramBean.put("groupCodeId",groupCodeId);
            paramBean.put("useYn","Y");

            List<CodeBean> codes = codeDao.findListCode(paramBean);

            if (codes != null) {
                if (codes.size() > 0 ) {
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
                        sb.append(String.format(" beforeSelect=\"%s\"", codeId));
                    }

                    if (disabled) {
                        sb.append(" disabled");
                    }

                    sb.append(">");
                    if(allModel) {
                        sb.append(String.format("<option value=\"\">%s</option>", StringUtils.notNullCheck(allText) ? allText : "All") );
                    }
                    for(CodeBean code:codes) {
                        if (codeId.equals(code.getCodeId())) {
                            sb.append(String.format("<option value=\"%s\" selected=\"selected\">%s</option>", code.getCodeId().trim(), code.getCodeName()));
                        } else {
                            sb.append(String.format("<option value=\"%s\">%s</option>", code.getCodeId().trim(), code.getCodeName()));
                        }
                    }
                    sb.append("</select>");
                } else {
                    sb.append("");
                }
            } else {
                sb.append("");
            }

        } else {
            sb.append("");
        }

        try {
            pageContext.getOut().write(sb.toString());
        } catch (IOException e) {
            logger.error(e.getMessage());
        }

        return EVAL_PAGE;
    }
}
