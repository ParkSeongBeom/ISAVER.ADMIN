package com.icent.isaver.admin.dao;


import com.icent.isaver.admin.bean.GroupCodeBean;

import java.util.List;
import java.util.Map;

/**
 * 그룹코드 관리 Dao Interface
 *
 * @author : kst
 * @version : 1.0
 * @since : 2014. 5. 30.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 5. 30.     kst           최초 생성
 * </pre>
 */
public interface GroupCodeDao {

    /**
     * 그룹코드 목록을 가져온다.
     *
     * @author kst
     * @return
     */
    public List<GroupCodeBean> findListGroupCode();

    /**
     * 그룹코드 정보를 가져온다.
     *
     * @author kst
     * @return
     */
    public GroupCodeBean findByGroupCode(Map<String, String> parameters);

    /**
     * 그룹코드를 등록한다.
     *
     * @author kst
     */
    public void addGroupCode(Map<String, String> parameters);

    /**
     * 그룹코드를 수정한다.
     *
     * @author kst
     */
    public void saveGroupCode(Map<String, String> parameters);

    /**
     * 그룹코드를 제거한다.
     *
     * @author kst
     */
    public void removeGroupCode(Map<String, String> parameters);
}
