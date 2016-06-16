package com.icent.isaver.admin.tag;

import com.icent.isaver.admin.util.AppContextUtil;
import com.icent.isaver.repository.bean.AreaBean;
import com.icent.isaver.repository.bean.CodeBean;
import com.icent.isaver.repository.dao.base.AreaDao;
import com.kst.common.util.StringUtils;
import org.apache.taglibs.standard.tag.el.core.ParamTag;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * [Spring Custom Tag] 구역용 SELECT BOX HTML TAG
 *
 * @author : psb
 * @version : 1.0
 * @since : 2016. 6. 16.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2016. 6. 16.     psb           최초 생성
 * </pre>
 */
public class AreaSelectBoxTagSupport extends ParamTag {

    private static final long serialVersionUID = 2029143573644447215L;

    /* 구역 ID */
    private String areaId = "";
    /* 상위구역 ID */
    private String parentAreaId = "";
    /* htmlTag(ID) 명 */
    private String htmlTagId = "";
    /* htmlTag(NAME) 명 */
    private String htmlTagName = "";
    /* htmlTag(CLASS) 명 */
    private String htmlTagClass = "";
    /* 전체여부 */
    private Boolean allModel = false;
    /* 전체 */
    private String allText = "";

    public void setAreaId(String areaId) {
        this.areaId = areaId;
    }

    public void setParentAreaId(String parentAreaId) {
        this.parentAreaId = parentAreaId;
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

    public void setAllText(String allText) {
        this.allText = allText;
    }

    public int doEndTag() {
        StringBuilder sb = new StringBuilder();
        AreaDao areaDao = AppContextUtil.getInstance().getBean(AreaDao.class);

        Map<String, String> paramBean = new HashMap<>();
        paramBean.put("areaId",areaId);
        paramBean.put("parentAreaId",parentAreaId);
        paramBean.put("delYn","N");

        List<AreaBean> areas = areaDao.findListArea(paramBean);

        if (areas != null) {
            if (areas.size() > 0 ) {
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
                    sb.append(String.format(" beforeSelect=\"%s\"", areaId));
                }

                sb.append(">");
                if(allModel) {
                    sb.append(String.format("<option value=\"\">%s</option>", StringUtils.notNullCheck(allText) ? allText : "전체") );
                }
                for(AreaBean area:areas) {
                    if (areaId.equals(area.getAreaId())) {
                        sb.append(String.format("<option value=\"%s\" selected=\"selected\">%s</option>", area.getAreaId(), area.getAreaDesc()));
                    } else {
                        sb.append(String.format("<option value=\"%s\">%s</option>", area.getAreaId(), area.getAreaDesc()));
                    }

                }
                sb.append("</select>");
            } else {
                sb.append("");
            }
        } else {
            sb.append("");
        }

        try {
            pageContext.getOut().write(sb.toString());
        } catch (IOException e) {

        } finally {

        }

        return EVAL_PAGE;
    }
}
