package com.icent.isaver.admin.svcImpl;

import Aladdin.HaspStatus;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.icent.isaver.admin.bean.DeviceBean;
import com.icent.isaver.admin.bean.EventBean;
import com.icent.isaver.admin.bean.License;
import com.icent.isaver.admin.common.resource.IsaverException;
import com.icent.isaver.admin.dao.AreaDao;
import com.icent.isaver.admin.dao.DeviceDao;
import com.icent.isaver.admin.dao.EventDao;
import com.icent.isaver.admin.dao.FenceDao;
import com.icent.isaver.admin.resource.AdminResource;
import com.icent.isaver.admin.resource.ResultState;
import com.icent.isaver.admin.svc.DeviceSvc;
import com.icent.isaver.admin.svc.DeviceSyncRequestSvc;
import com.icent.isaver.admin.util.AlarmRequestUtil;
import com.icent.isaver.admin.util.HaspLicenseUtil;
import com.icent.isaver.admin.util.MqttUtil;
import com.meous.common.resource.CommonResource;
import com.meous.common.spring.TransactionUtil;
import com.meous.common.util.StringUtils;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Sorts;
import org.bson.Document;
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
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static com.mongodb.client.model.Filters.*;

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
    private static Logger logger = LoggerFactory.getLogger(DeviceSvcImpl.class);

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
    private MqttUtil mqttUtil;

    @Inject
    private DeviceDao deviceDao;

    @Inject
    private AreaDao areaDao;

    @Inject
    private FenceDao fenceDao;

    @Inject
    private EventDao eventDao;

    @Inject
    private DeviceSyncRequestSvc deviceSyncRequestSvc;

    @Inject
    private HaspLicenseUtil haspLicenseUtil;

    @Inject
    private MongoDatabase mongoDatabase;

    @Override
    public ModelAndView findListDevice(Map<String, String> parameters) {
        List<DeviceBean> deviceList = deviceDao.findListDevice(parameters);

        ModelAndView modelAndView = new ModelAndView();
        if(StringUtils.notNullCheck(parameters.get("farmFlag"))){
            DeviceBean parentDevice = deviceDao.findByDevice(parameters);
            modelAndView.addObject("device", parentDevice);
            try{
                MongoCollection<Document> collection = mongoDatabase.getCollection("eventLog");
                Calendar cal = Calendar.getInstance();
                cal.set( Calendar.HOUR_OF_DAY, 0 );
                cal.set( Calendar.MINUTE, 0 );
                cal.set( Calendar.SECOND, 0 );
                cal.set( Calendar.MILLISECOND, 0 );

                for(DeviceBean device : deviceList){
                    Document eventLog = collection.find(
                            and(
                                    eq("deviceId", device.getDeviceId()),
                                    gte("eventDatetime", cal.getTime())
                            )
                    ).sort(Sorts.descending("eventDatetime")).first();

                    if(eventLog!=null){
                        device.setEvtValue(eventLog.get("value").toString());
                        device.setFormat(eventLog.get("format")!=null?eventLog.get("format").toString():null);
                    }
                    device.setDeviceCodeCss(AdminResource.DEVICE_CODE_CSS.get(device.getDeviceCode()));
                }
            }catch(Exception e){
                throw new IsaverException("");
            }
        }
        modelAndView.addObject("devices", deviceList);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView findListDeviceForResource(Map<String, String> parameters) {
        List<DeviceBean> deviceList = deviceDao.findListDevice(parameters);

        Map<String, Object> resourceParam = new HashMap<>();
        resourceParam.put("eventIds",parameters.get("eventIds").split(","));
        List<EventBean> eventList = eventDao.findListEventForResource(resourceParam);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("deviceList", deviceList);
        modelAndView.addObject("eventList", eventList);
        modelAndView.addObject("deviceCodeCss", AdminResource.DEVICE_CODE_CSS);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView addDevice(HttpServletRequest request, Map<String, String> parameters) {
        License license = haspLicenseUtil.read(parameters.get("deviceCode"));

        if (HaspStatus.HASP_STATUS_OK == license.getStatus() || AdminResource.NONE_LICENSE_TARGET == license.getStatus()) {
            int licenseCnt = deviceDao.findCountDeviceLicense(parameters);
            if(AdminResource.NONE_LICENSE_TARGET==license.getStatus() || licenseCnt < Integer.parseInt(license.getMessage())){
                TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
                try {
                    parameters.put("deviceId", generatorFunc());
                    deviceDao.addDevice(parameters);
                    if(parameters.get("mainFlag").equals(CommonResource.YES)){
                        fenceDao.saveFence(parameters);
                        deviceDao.saveDeviceMainFlag(parameters);
                    }

                    Map<String, String> addDeviceSyncRequestParam = new HashMap<>();
                    addDeviceSyncRequestParam.put("deviceIds", parameters.get("deviceId"));
                    addDeviceSyncRequestParam.put("type", AdminResource.SYNC_TYPE.get("add"));
                    deviceSyncRequestSvc.addDeviceSyncRequest(request, addDeviceSyncRequestParam);
                    transactionManager.commit(transactionStatus);
                }catch(DataAccessException e){
                    transactionManager.rollback(transactionStatus);
                    throw new IsaverException("");
                }
                deviceSync(parameters.get("deviceId"));
            }else{
                license.setMessage("licensed quantity exceeded");
                license.setStatus(-4);
            }
        }

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("license",license);
        return modelAndView;
    }

    @Override
    public ModelAndView saveDevice(HttpServletRequest request, Map<String, String> parameters) {
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try {
            Map<String, String> addDeviceSyncRequestParam = new HashMap<>();
            addDeviceSyncRequestParam.put("deviceIds", parameters.get("deviceId"));
            addDeviceSyncRequestParam.put("type", AdminResource.SYNC_TYPE.get("save"));
            deviceSyncRequestSvc.addDeviceSyncRequest(request, addDeviceSyncRequestParam);
            if(parameters.get("mainFlag").equals(CommonResource.YES)){
                fenceDao.saveFence(parameters);
                deviceDao.saveDeviceMainFlag(parameters);
            }
            deviceDao.saveDevice(parameters);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new IsaverException("");
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
            throw new IsaverException("");
        }
        deviceSync(parameters.get("deviceId"));
        return new ModelAndView();
    }

    private void deviceSync(String deviceId){
        Map parentDeviceParam = new HashMap();
        parentDeviceParam.put("deviceId",deviceId);
        DeviceBean parentDevice = deviceDao.findByParentDevice(parentDeviceParam);

        if(parentDevice != null){
            Map websocketParam = new HashMap();
            websocketParam.put("deviceId",parentDevice.getDeviceId());
            websocketParam.put("messageType","deviceSync");
            try {
                if(mqttUtil.getIsMqtt()){
                    ObjectMapper mapper = new ObjectMapper();
                    mqttUtil.publish("sync",mapper.writeValueAsString(websocketParam),0);
                }else {
                    AlarmRequestUtil.sendAlarmRequestFunc(websocketParam, "http://" + wsDomain + ":" + wsPort + "/" + wsProjectName + wsUrlSync, "form", null);
                }
            } catch (Exception e) {
                throw new IsaverException(ResultState.ERROR_SEND_REQUEST,e.getMessage());
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
