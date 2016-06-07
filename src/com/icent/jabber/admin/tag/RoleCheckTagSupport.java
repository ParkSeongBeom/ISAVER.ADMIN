package com.icent.jabber.admin.tag;

import com.icent.jabber.admin.resource.AdminResource;
import com.icent.jabber.admin.util.AppContextUtil;
import com.icent.jabber.repository.bean.AdminBean;
import com.icent.jabber.repository.bean.MenuRoleBean;
import com.icent.jabber.repository.dao.base.MenuRoleDao;
import com.kst.common.util.StringUtils;
import org.apache.taglibs.standard.tag.el.core.ParamTag;

import java.io.IOException;

/**
 * [Spring Custom Tag] 페이지 별 권한 체크
 *
 * @author : dhj
 * @version : 1.0
 * @since : 2014. 6. 6.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 6. 6.     dhj           최초 생성
 * </pre>
 */
public class RoleCheckTagSupport extends ParamTag {

    private static final long serialVersionUID = -2283578630333735163L;

    // 메뉴 ID
    private String menuId = "";

    public void setMenuId(String menuId) {
        this.menuId = menuId;
    }

    public int doEndTag() {
        StringBuilder sb = new StringBuilder();
        MenuRoleDao menuRoleDao = AppContextUtil.getInstance().getBean(MenuRoleDao.class);

        AdminBean adminBean = null;
        try{
            adminBean = (AdminBean) pageContext.getSession().getAttribute(AdminResource.AUTHORIZATION_ADMIN);
        }catch(Exception e){

        }

        Boolean pagePermissionFlag = false;
        if (adminBean != null && StringUtils.notNullCheck(menuId) && StringUtils.notNullCheck(adminBean.getAdminId())) {

            MenuRoleBean menuRoleBean = menuRoleDao.findByRoleIdPageTag(adminBean.getAdminId(), menuId);
            if (menuRoleBean != null) {
                pagePermissionFlag = true;
            }
        }

        if (pagePermissionFlag) {
            sb.append("");
        } else {
            sb.append("<script type=\"text/javascript\">");
            sb.append("alert(\"권한이 없습니다.\");");
            sb.append("history.back()");
            sb.append("</script>");
        }

        try {
            pageContext.getOut().write(sb.toString());
        } catch (IOException e) {

        } finally {

        }

        return EVAL_PAGE;
    }
}
