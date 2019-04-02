package com.icent.isaver.admin.dao;


import com.icent.isaver.admin.bean.DeviceBean;

import java.util.List;
import java.util.Map;


/**
 * [DAO] 장치
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
public interface DeviceDao {

    /**
     *
     * @param parameters
     * @return
     */
    List<DeviceBean> findListDevice(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @return
     */
    Integer findCountDeviceLicense(Map<String, String> parameters);

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
    DeviceBean findByDevice(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @return
     */
    void addDevice(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @return
     */
    void saveDevice(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @return
     */
    void removeDevice(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @return
     */
    void saveDeviceMainFlag(Map<String, String> parameters);

    /**
     * 조회한 장치에 대한 하위 노드 장치를 가져온다.
     * @param parameters
     * @return
     */
    List<DeviceBean> findByDeviceTreeChildNodes(Map<String, String> parameters);

    /**
     * 구역 삭제 시 하위 구역 노드를 제거한다.
     * @param deviceBeans
     * @see dhj
     */
    void removeListDeviceForTree(List<DeviceBean> deviceBeans);

    /**
     *
     * @param parameters
     * @return
     */
    List<DeviceBean> findListDeviceArea(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @return
     */
    List<DeviceBean> findListDeviceForHistory(Map<String, String> parameters);

    /**
     *
     * @return
     */
    List<DeviceBean> findListDeviceForCriticalDetect(Map<String, String> parameters);

    /**
     *
     * @return
     */
    List<DeviceBean> findListDeviceForCriticalTarget(Map<String, String> parameters);

    /**
     *
     * @param parameters
     * @return
     */
    Integer findCountDeviceArea(Map<String, String> parameters);

    DeviceBean findByParentDevice(Map<String, String> parameters);

    List<DeviceBean> findListDeviceForTest();
}