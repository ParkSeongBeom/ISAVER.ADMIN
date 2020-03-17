package com.icent.isaver.admin.tag;

import org.apache.taglibs.standard.tag.el.core.ParamTag;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.text.DecimalFormat;

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
public class CustomSupport extends ParamTag {
    private static Logger logger = LoggerFactory.getLogger(CustomSupport.class);

    private static final long serialVersionUID = 2029143573644447215L;

    private String bytes = "";

    public void setBytes(String bytes) {
        this.bytes = bytes;
    }

    public int doEndTag() {
        String retFormat = "0";
        Double size = Double.parseDouble(bytes);
        String[] s = { "bytes", "KB", "MB", "GB", "TB", "PB" };

        if (bytes != "0") {
            int idx = (int) Math.floor(Math.log(size) / Math.log(1024));
            DecimalFormat df = new DecimalFormat("#,###.##");
            double ret = ((size / Math.pow(1024, Math.floor(idx))));
            retFormat = df.format(ret) + " " + s[idx];
        } else {
            retFormat += " " + s[0];
        }

        StringBuilder sb = new StringBuilder();
        sb.append(retFormat);

        try {
            pageContext.getOut().write(sb.toString());
        } catch (IOException e) {
            logger.error(e.getMessage());
        }

        return EVAL_PAGE;
    }
}
