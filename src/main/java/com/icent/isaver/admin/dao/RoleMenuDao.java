package com.icent.isaver.admin.dao;

import com.icent.isaver.admin.bean.MenuBean;
import com.icent.isaver.admin.bean.RoleMenuBean;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * [Dao] 메뉴 권한
 *
 * @author dhj
 * @since 2014. 5. 14.
 * @version 1.0
 * @see  <pre>
 * << 개정이력(Modification Information) >>
 *   수정일         수정자            수정내용
 *  ----------   --------  ----------------------
 *  2014.05.14     dhj     최초 생성
 * </pre>
 */
public interface RoleMenuDao {

    /**
     * Find all menu role.
     *
     * @return the list
     * @since 2014.05.14
     * @see
     */
    public List<RoleMenuBean> findUnregiRoleMenu(Map<String, String> parameters);

    /**
     * Find all menu role.
     *
     * @return the list
     * @since 2014.05.14
     * @see
     */
    public List<RoleMenuBean> findRegiRoleMenu(Map<String, String> parameters);

    /**
     * Add list menu role.
     *
     * @param roleMenuBeans the menu role beans
     */
    public void addListRoleMenu(List<RoleMenuBean> roleMenuBeans);

    /**
     * 권한에 매핑 정보를 제거한다.
     *
     * @since 2014.05.14
     * @see
     */
    public void removeRoleMenu(Map<String, String> parameters);

    /**
     * 권한 삭제기 관련 매핑정보를 제거한다.
     *
     * @author kst
     */
    public void removeRoleMenuForRole(Map<String, String> parameters);

    /**
     * 메뉴 삭제 시 하위 메뉴 노드를 제거한다.
     * @param menuBeans
     * @author dhj
     */
    public void removeListRoleMenuForTree(List<MenuBean> menuBeans);

    /**
     * 조회 대상 사용자 별 권한에 매핑된 권한 메뉴를 가져온다.(Spring custom Tag용)
     * @param userId
     * @param menuId
     * @return
     */
    public RoleMenuBean findByRoleIdPageTag(@Param("userId") String userId, @Param("menuId") String menuId);
}
