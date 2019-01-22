package main.java.com.icent.isaver.admin.dao;

import com.icent.isaver.admin.bean.MenuBean;

import java.util.List;
import java.util.Map;

/**
 * [Dao] 메뉴
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
public interface MenuDao {

    /**
     * 전체 메뉴 트리를 반환 한다.
     * @return the list
     */
    public List<MenuBean> findAllMenuTree(Map<String, String> parameters);

    /**
     * 전체 메뉴 트리를 반환 한다. 메뉴권한용
     * @return the list
     */
    public List<MenuBean> findRoleMenuTree(Map<String, String> parameters);

    /**
     * 전체 메뉴 바를 반환 한다.
     * @return the list
     */
    public List<MenuBean> findAllMenuTopBar(Map parameters);

    /**
     * 조회한 메뉴에 대한 하위 노드 메뉴를 가져온다.
     * @return
     */
    public List<MenuBean> findByMenuTreeChildNodes(Map<String, String> parameters);

    /**
     * 단건에 대한 메뉴를 가져온다.
     * @return
     */
    public MenuBean findByMenuTree(MenuBean menuBean);

    /**
     * 단일 메뉴를 가져온다.
     *
     * @return the menu bean
     * @since 2014.05.14
     * @see
     */
    public MenuBean findByMenu(Map<String, String> parameters);

    /**
     * 단일 메뉴를 추가한다.
     *
     * @since 2014.05.14
     * @see
     */
    public void addMenu(Map<String, String> parameters);

    /**
     * 단일 메뉴를 저장한다.
     *
     * @since 2014.05.14
     * @see
     */
    public void saveMenu(Map<String, String> parameters);

    /**
     * 메뉴 삭제 시 하위 메뉴 노드를 제거한다.
     * @param menuBeans
     * @see dhj
     */
    public void removeListMenuForTree(List<MenuBean> menuBeans);
}
