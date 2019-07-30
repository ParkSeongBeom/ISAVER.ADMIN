package com.icent.isaver.admin.tag;

import com.icent.isaver.admin.bean.MenuBean;
import com.icent.isaver.admin.svc.MenuSvc;
import com.icent.isaver.admin.svcImpl.MenuSvcImpl;
import com.icent.isaver.admin.util.AppContextUtil;
import com.meous.common.util.StringUtils;
import org.apache.taglibs.standard.tag.el.core.ParamTag;

import java.io.IOException;

/**
 * [Spring Custom Tag] 메뉴 전체 경로 반환 태크
 * @author : dhj
 * @version : 1.0
 * @since : 2014. 6. 3.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 6. 3.     dhj           최초 생성
 * </pre>
 */
public class MenuTagSupport extends ParamTag {

    private static final long serialVersionUID = -8275235968021249758L;

    //조회 하고자 할 대상 : 메뉴 ID
    private String menuId = "";

    public void setMenuId(String menuId) {
        this.menuId = menuId;
    }

    public int doEndTag() {
        StringBuilder sb = new StringBuilder();
        MenuSvc menuSvc = AppContextUtil.getInstance().getBean(MenuSvcImpl.class);

        if(StringUtils.notNullCheck(menuId)) {
            MenuBean menuBean = new MenuBean();
            menuBean.setMenuId(menuId);
            MenuBean resultBean = menuSvc.findByMenuTree(menuBean);

            if (resultBean != null) {
                sb.append(resultBean.getDescription());
            } else {
                sb.append("");
            }
            sb.append("");
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
