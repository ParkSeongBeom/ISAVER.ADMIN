package com.icent.isaver.admin.bean;

/**
 * [Bean] 메뉴
 *
 * @author dhj
 * @since 2016. 5. 26.
 * @version 1.0
 * @see   <pre>
 * << 개정이력(Modification Information) >>
 *   수정일         수정자            수정내용
 *  ----------   --------  ----------------------
 *  2016.05.26     dhj     최초 생성
 * </pre>
 */
public class MenuBean extends ISaverCommonBean {
    /* 메뉴 ID*/
    private String menuId;
    /* 상위 메뉴 ID*/
    private String parentMenuId;
    /* 메뉴명 */
    private String menuName;
    /* 메뉴 경로 */
    private String menuPath;
    /* 메뉴 구분 */
    private String menuFlag;
    /* 메뉴 사용 여부 */
    private String useYn;
    /* 메뉴 정렬 순서 */
    private String sortOrder;
    /* 메뉴 깊이 */
    private String menuDepth;
    // 메뉴 설명
    private String description = null;

    public String getMenuId() {
        return menuId;
    }

    public void setMenuId(String menuId) {
        this.menuId = menuId;
    }

    public String getParentMenuId() {
        return parentMenuId;
    }

    public void setParentMenuId(String parentMenuId) {
        this.parentMenuId = parentMenuId;
    }

    public String getMenuName() {
        return menuName;
    }

    public void setMenuName(String menuName) {
        this.menuName = menuName;
    }

    public String getMenuPath() {
        return menuPath;
    }

    public void setMenuPath(String menuPath) {
        this.menuPath = menuPath;
    }

    public String getMenuFlag() {
        return menuFlag;
    }

    public void setMenuFlag(String menuFlag) {
        this.menuFlag = menuFlag;
    }

    public String getUseYn() {
        return useYn;
    }

    public void setUseYn(String useYn) {
        this.useYn = useYn;
    }

    public String getSortOrder() {
        return sortOrder;
    }

    public void setSortOrder(String sortOrder) {
        this.sortOrder = sortOrder;
    }

    public String getMenuDepth() {
        return menuDepth;
    }

    public void setMenuDepth(String menuDepth) {
        this.menuDepth = menuDepth;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
