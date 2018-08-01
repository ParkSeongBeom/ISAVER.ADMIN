package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.common.resource.IcentException;
import com.icent.isaver.admin.resource.AdminResource;
import com.icent.isaver.admin.svc.DeviceSvc;
import com.icent.isaver.admin.svc.DeviceSyncRequestSvc;
import com.icent.isaver.admin.util.AlarmRequestUtil;
import com.icent.isaver.repository.bean.DeviceBean;
import com.icent.isaver.repository.dao.base.AreaDao;
import com.icent.isaver.repository.dao.base.DeviceDao;
import com.icent.isaver.repository.dao.base.EventDao;
import com.icent.isaver.repository.dao.base.LicenseDao;
import com.kst.common.spring.TransactionUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionStatus;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 장치 Service Implements
 *
 * @author : dhj
 * @version : 1.0
 * @since : 2016. 6. 1.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2016. 6. 1.     dhj           최초 생성
 * </pe>
 */
@Service
public class DeviceSvcImpl implements DeviceSvc {

    static Logger logger = LoggerFactory.getLogger(DeviceSvcImpl.class);

    @Resource(name="isaverTxManager")
    private DataSourceTransactionManager transactionManager;

    @Value("${ws.server.domain}")
    private String wsDomain = null;

    @Value("${ws.server.port}")
    private String wsPort = null;

    @Value("${ws.server.projectName}")
    private String wsProjectName = null;

    @Value("${ws.server.urlSync}")
    private String wsUrlSync = null;

    @Inject
    private DeviceDao deviceDao;

    @Inject
    private AreaDao areaDao;

    @Inject
    private EventDao eventDao;

    @Inject
    private LicenseDao licenseDao;

    @Inject
    private DeviceSyncRequestSvc deviceSyncRequestSvc;

    @Override
    public ModelAndView findListDevice(Map<String, String> parameters) {
        List<DeviceBean> deviceTreeList = deviceDao.findListDevice(null);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("devices", deviceTreeList);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView addDevice(HttpServletRequest request, Map<String, String> parameters) {
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try {
            parameters.put("deviceId", generatorFunc());
            deviceDao.addDevice(parameters);

            Map<String, String> addDeviceSyncRequestParam = new HashMap<>();
            addDeviceSyncRequestParam.put("deviceIds", parameters.get("deviceId"));
            addDeviceSyncRequestParam.put("type", AdminResource.SYNC_TYPE.get("add"));
            deviceSyncRequestSvc.addDeviceSyncRequest(request, addDeviceSyncRequestParam);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new IcentException("");
        }
        deviceSync(parameters.get("deviceId"));
        return new ModelAndView();
    }

    @Override
    public ModelAndView saveDevice(HttpServletRequest request, Map<String, String> parameters) {
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try {
            Map<String, String> addDeviceSyncRequestParam = new HashMap<>();
            addDeviceSyncRequestParam.put("deviceIds", parameters.get("deviceId"));
            addDeviceSyncRequestParam.put("type", AdminResource.SYNC_TYPE.get("save"));
            deviceSyncRequestSvc.addDeviceSyncRequest(request, addDeviceSyncRequestParam);
            deviceDao.saveDevice(parameters);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new IcentException("");
        }
        deviceSync(parameters.get("deviceId"));
        return new ModelAndView();
    }

    @Override
    public ModelAndView removeDevice(HttpServletRequest request, Map<String, String> parameters) {
        List<DeviceBean> devices = deviceDao.findByDeviceTreeChildNodes(parameters);
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try {
            Map<String, String> addDeviceSyncRequestParam = new HashMap<>();
            addDeviceSyncRequestParam.put("deviceIds", parameters.get("deviceId"));
            addDeviceSyncRequestParam.put("type", AdminResource.SYNC_TYPE.get("remove"));
            deviceSyncRequestSvc.addDeviceSyncRequest(request, addDeviceSyncRequestParam);
            deviceDao.removeListDeviceForTree(devices);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new IcentException("");
        }
        deviceSync(parameters.get("deviceId"));
        return new ModelAndView();
    }

    private void deviceSync(String deviceId){
        Map parentDeviceParam = new HashMap();
        parentDeviceParam.put("deviceId",deviceId);
        DeviceBean parentDevice = deviceDao.findByParentDevice(parentDeviceParam);

        if(parentDevice != null){
            try {
                Map websocketParam = new HashMap();
                websocketParam.put("deviceId",parentDevice.getDeviceId());
                websocketParam.put("messageType","deviceSync");

                AlarmRequestUtil.sendAlarmRequestFunc(websocketParam, "http://" + wsDomain + ":" + wsPort + "/" + wsProjectName + wsUrlSync, "form", null);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }else{
            logger.error("[deviceSync] error - parent device is null");
        }
        parentDeviceParam = null;
    }

    /**
     *
     * @return
     */
    private String generatorFunc() {
        StringBuilder sb = new StringBuilder();
        Integer totalCount = deviceDao.findCountGenerator();
        String id = "DE";
        String suffix = String.format("%04d", totalCount);
        sb.append(id).append(suffix);
        return sb.toString();
    }
}
