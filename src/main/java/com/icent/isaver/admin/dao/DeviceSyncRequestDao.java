package com.icent.isaver.admin.dao;

import com.icent.isaver.admin.bean.DeviceSyncRequestBean;

import java.util.List;
import java.util.Map;

/**
 * 장치 동기화 요청 Dao Interface
 *
 * @author : psb
 * @version : 1.0
 * @since : 2016. 10. 24.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2016. 10. 24.     psb           최초 생성
 * </pre>
 */
public interface DeviceSyncRequestDao {

    /**
     * 장치 동기화 요청 목록을 가져온다.
     * @author psb
     */
    public List<DeviceSyncRequestBean> findListDeviceSyncRequest(Map<String, String> parameters);

    /**
     * 장치 동기화 요청 목록 갯수를 가져온다.
     * @author psb
     */
    public Integer findCountDeviceSyncRequest(Map<String, String> parameters);

    /**
     * 장치 동기화 요청을 등록한다.
     * @author psb
     */
    public void addDeviceSyncRequest(List<Map<String, String>> parameterList);

    /**
     * 장치 동기화 요청을 저장한다.
     * @author psb
     */
    public void saveDeviceSyncRequest(List<Map<String, String>> parameterList);
}