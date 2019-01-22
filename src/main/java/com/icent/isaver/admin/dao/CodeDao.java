package main.java.com.icent.isaver.admin.dao;

import com.icent.isaver.admin.bean.CodeBean;

import java.util.List;
import java.util.Map;

/**
 * 코드관리 Dao Interface
 *
 * @author : kst
 * @version : 1.0
 * @since : 2014. 5. 19.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 5. 19.     kst           최초 생성
 * </pre>
 */
public interface CodeDao {

    /**
     * 코드 목록을 가져온다.
     *
     * @author kst
     * @return
     */
    public List<CodeBean> findListCode(Map<String, String> parameters);

    /**
     * 코드 목록을 가져온다. 라이센스용
     *
     * @author psb
     * @return
     */
    public List<CodeBean> findListCodeDevice();

    /**
     * 코드 상세정보를 가져온다.
     *
     * @author kst
     * @return
     */
    public CodeBean findByCode(Map<String, String> parameters);

    /**
     * 코드를 등록한다.
     *
     * @author kst
     */
    public void addCode(Map<String, String> parameters);

    /**
     * 코드를 수정한다.
     *
     * @author kst
     */
    public void saveCode(Map<String, String> parameters);

    /**
     * 코드를 제거한다.
     *
     * @author kst
     */
    public void removeCode(Map<String, String> parameters);

}
