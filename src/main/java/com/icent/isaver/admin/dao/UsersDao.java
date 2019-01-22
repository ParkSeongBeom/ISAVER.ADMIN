package main.java.com.icent.isaver.admin.dao;

import com.icent.isaver.admin.bean.UsersBean;

import java.util.List;
import java.util.Map;

/**
 * [DAO] 사용자
 * @author dhj
 * @since 2016. 06. 01.
 * @version 1.0
 * @see   <pre>
 * << 개정이력(Modification Information) >>
 *   수정일         수정자            수정내용
 *  ----------   --------  ----------------------
 *  2016.06.01  dhj     최초 생성
 * </pre>
 */
public interface UsersDao {

    /**
     *
     * @param parameters
     * @author dhj
     * @return
     */
    public List<UsersBean> findListUsers(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @author dhj
     * @return
     */
    public UsersBean findByUsers(Map<String, String> parameters);

    /**
     * 사용자ID의 존재여부를 확인한다.
     *
     * @author kst
     * @return
     */
    public Integer findByUserCheckExist(Map<String, String> parameters);

    /**
     *
     * @author psb
     * @return
     */
    public Integer findByUserRoleCount(Map<String, String> parameters);

    /**
     * 정보를 가져온다. (for Login)
     * @param parameters
     * @author psb
     * @return
     */
    public UsersBean findByUsersForLogin(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @author dhj
     * @return
     */
    public Integer findCountUsers(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @author dhj
     * @return
     */
    public void addUsers(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @author dhj
     * @return
     */
    public void saveUsers(Map<String, String> parameters);

    /**
     * 권한삭제시 관리자의 권한정보를 제거한다.
     *
     * @author kst
     */
    public void saveUsersForRole(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @author dhj
     * @return
     */
    public void removeUsers(Map<String, String> parameters);
}