package main.java.com.icent.isaver.admin.dao;

import com.icent.isaver.admin.bean.RoleBean;

import java.util.List;
import java.util.Map;

/**
 * [Dao] 권한 관련
 *
 * @author dhj
 * @since 2014. 5. 14.
 * @version 1.0
 * @see  <pre>
 * << 개정이력(Modification Information) >>
 *   수정일         수정자            수정내용
 *  ----------   --------  ----------------------
 *  2014.05.14     dhj     최초 생성
 *  2014.06.02     kst     권한목록, 권한갯수 메소드명 및 인자 수정
 * </pre>
 */
public interface RoleDao {
    /**
     * Find all role.
     *
     * @return the list
     * @since 2014.05.14
     * @see dhj
     */
    public List<RoleBean> findListRole(Map<String, String> parameters);

    /**
     * Count Row role.
     *
     * @return the integer
     * @see dhj
     */
    public Integer findCountRole(Map<String, String> parameters);

    /**
     * Find by role.
     *
     * @return the role bean
     * @since 2014.05.14
     * @see dhj
     */
    public RoleBean findByRole(Map<String, String> parameters);

    /**
     * Add role.
     *
     * @since 2014.05.14
     * @see dhj
     */
    public void addRole(Map<String, String> parameters);

    /**
     * Save role.
     *
     * @since 2014.05.14
     * @see dhj
     */
    public void saveRole(Map<String, String> parameters);

    /**
     * Remove role.
     *
     * @since 2014.05.14
     * @see dhj
     */
    public void removeRole(Map<String, String> parameters);
}
