package com.icent.jabber.admin.tag;

import com.icent.jabber.admin.util.AppContextUtil;
import com.icent.jabber.repository.bean.CodeBean;
import com.icent.jabber.repository.bean.FindBean;
import com.icent.jabber.repository.dao.base.CodeDao;
import com.kst.common.util.StringUtils;
import org.apache.taglibs.standard.tag.el.core.ParamTag;

import java.io.IOException;
import java.util.List;

/**
 * User: dhj
 * Date: 2014. 6. 11.
 * Time: 오후 10:12
 */
public class CodeTextTagSupport extends ParamTag {

    private static final long serialVersionUID = 3977336077673211703L;

    /* 그룹 코드 ID */
    private String groupCodeId = "";
    /* 코드 ID */
    private String codeId = "";

    public void setGroupCodeId(String groupCodeId) {
        this.groupCodeId = groupCodeId;
    }

    public void setCodeId(String codeId) {
        this.codeId = codeId;
    }

    public int doEndTag() {
        StringBuilder sb = new StringBuilder();
        sb.append("");
        CodeDao codeDao = AppContextUtil.getInstance().getBean(CodeDao.class);

        if(StringUtils.notNullCheck(groupCodeId) && StringUtils.notNullCheck(codeId)) {
            FindBean paramBean = new FindBean();
            paramBean.setId(groupCodeId);
            paramBean.setUseYn("Y");

            List<CodeBean> codes = codeDao.findListCode(paramBean);


            if (codes != null) {
                if (codes.size() > 0 ) {
                    for(CodeBean code:codes) {
                        if (codeId.equals(code.getCodeId())) {
                            sb.append(code.getCodeName());
                        }
                    }
                }
            }

        }
        try {
            pageContext.getOut().write(sb.toString());
        } catch (IOException e) {

        } finally {

        }

        return EVAL_PAGE;
    }
}