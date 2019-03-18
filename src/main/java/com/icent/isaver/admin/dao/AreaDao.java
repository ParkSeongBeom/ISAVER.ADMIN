package com.icent.isaver.admin.dao;


import com.icent.isaver.admin.bean.AreaBean;

import java.util.List;
import java.util.Map;


/**
 * [DAO] 구역
 * @author dhj
 * @since 2016. 06. 02.
 * @version 1.0
 * @see   <pre>
 * << 개정이력(Modification Information) >>
 *   수정일         수정자            수정내용
 *  ----------   --------  ----------------------
 *  2016.06.02  dhj    최초 생성
 * </pre>
 */
public interface AreaDao {
    /**
     *
     * @param parameters
     * @return
     */
    List<AreaBean> findListArea(Map<String, String> parameters);

    /**
     * 조회한 구역에 대한 하위 노드 메뉴를 가져온다.
     * @param parameters
     * @return
     */
    List<AreaBean> findByAreaTreeChildNodes(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @return
     */
    Integer findCountArea(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @return
     */
    AreaBean findByArea(Map<String, String> parameters);

    /**
     *
     * @return
     */
    Integer findCountGenerator();

    /**
     *
     * @param parameters
     * @return
     */
    void addArea(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @return
     */
    void saveArea(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @return
     */
    void saveAreaTemplate(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @return
     */
    void removeArea(Map<String, String> parameters);

    /**
     * 구역 삭제 시 하위 구역 노드를 제거한다.
     * @param areaBeans
     * @see dhj
     */
    void removeListAreaForTree(List<AreaBean> areaBeans);

    /**
     *
     * @return
     */
    List<AreaBean> findListAreaForMenuTopBar();

    /**
     *
     * @param parameters
     * @return
     */
    List<AreaBean> findListAreaForDashboard(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @return
     */
    List<AreaBean> findListAreaNav(Map<String, String> parameters);

    /**
     * @return
     */
    List<AreaBean> findListAreaForTest();

    /**
     *
     * @param parameters
     * @return
     */
    List<AreaBean> findListAreaForCustomMap(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @return
     */
    void saveAreaByCustomMapLocation(Map<String, String> parameters);
}