package com.icent.isaver.admin.tag;

import com.icent.isaver.admin.bean.RoleMenuBean;
import com.icent.isaver.admin.bean.UsersBean;
import com.icent.isaver.admin.dao.RoleMenuDao;
import com.icent.isaver.admin.resource.AdminResource;
import com.icent.isaver.admin.util.AppContextUtil;
import com.meous.common.util.StringUtils;
import org.apache.taglibs.standard.tag.el.core.ParamTag;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

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
    private static Logger logger = LoggerFactory.getLogger(RoleCheckTagSupport.class);

    private static final long serialVersionUID = -2283578630333735163L;

    // 메뉴 ID
    private String menuId = "";

    private String locale = "";

    public void setMenuId(String menuId) {
        this.menuId = menuId;
    }

    public void setLocale(String locale) {
        this.locale = locale;
    }

    public int doEndTag() {
        StringBuilder sb = new StringBuilder();
        RoleMenuDao roleMenuDao = AppContextUtil.getInstance().getBean(RoleMenuDao.class);
        UsersBean usersBean = null;
        try{
            usersBean = (UsersBean) pageContext.getSession().getAttribute(AdminResource.AUTHORIZATION_ADMIN);
        }catch(Exception e){}

        Boolean pagePermissionFlag = false;
        if (usersBean != null && StringUtils.notNullCheck(menuId) && StringUtils.notNullCheck(usersBean.getUserId())) {
            RoleMenuBean menuRoleBean = roleMenuDao.findByRoleIdPageTag(usersBean.getUserId(), menuId);
            if (menuRoleBean != null) {
                pagePermissionFlag = true;
            }
        }

        if (pagePermissionFlag) {
            sb.append("");
        } else {
            sb.append("<script type=\"text/javascript\">");
            if(locale.equals("en_US")){
                sb.append("alert(\"permission denied.\");");
            }else{
                sb.append("alert(\"권한이 없습니다.\");");
            }
            sb.append("history.back()");
            sb.append("</script>");
        }

        try {
            pageContext.getOut().write(sb.toString());
        } catch (IOException e) {
            logger.error(e.getMessage());
        }

        return EVAL_PAGE;
    }
}
