package com.icent.isaver.admin.svcImpl;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.icent.isaver.admin.bean.*;
import com.icent.isaver.admin.common.resource.IsaverException;
import com.icent.isaver.admin.dao.*;
import com.icent.isaver.admin.resource.AdminResource;
import com.icent.isaver.admin.resource.ResultState;
import com.icent.isaver.admin.svc.CustomMapLocationSvc;
import com.icent.isaver.admin.svc.TemplateSettingSvc;
import com.icent.isaver.admin.util.AlarmRequestUtil;
import com.icent.isaver.admin.util.MqttUtil;
import com.meous.common.spring.TransactionUtil;
import com.meous.common.util.StringUtils;
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
import java.net.InetAddress;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Custom Map Service Implements
 *
 * @author : psb
 * @version : 1.0
 * @since : 2018. 6. 14.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2018. 6. 14.     psb           최초 생성
 * </pre>
 */
@Service
public class CustomMapLocationSvcImpl implements CustomMapLocationSvc {
    private static Logger logger = LoggerFactory.getLogger(CustomMapLocationSvcImpl.class);

    @Resource(name="isaverTxManager")
    private DataSourceTransactionManager transactionManager;

    @Value("${cnf.fileAddress}")
    private String fileAddress = null;

    @Value("${cnf.fileAttachedUploadPath}")
    private String fileAttachedUploadPath = null;

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
    private CustomMapLocationDao customMapLocationDao;

    @Inject
    private FenceDeviceDao fenceDeviceDao;

    @Inject
    private FenceLocationDao fenceLocationDao;

    @Inject
    private FenceDao fenceDao;

    @Inject
    private AreaDao areaDao;

    @Inject
    private DeviceDao deviceDao;

    @Inject
    private FileDao fileDao;

    @Inject
    private TemplateSettingSvc templateSettingSvc;

    @Override
    public ModelAndView findListCustomMapLocation(Map<String, String> parameters) {
        Map paramBean = new HashMap();
        paramBean.put("areaId",parameters.get("areaId"));
        if(StringUtils.notNullCheck(parameters.get("deviceCodes"))){
            paramBean.put("deviceCodes",parameters.get("deviceCodes").split(","));
        }
        List<CustomMapLocationBean> childList = customMapLocationDao.findListCustomMapLocation(paramBean);
        for(CustomMapLocationBean customMapLocationBean : childList){
            if(!customMapLocationBean.getDeviceCode().equals("area")){
                Map param = new HashMap();
                param.put("parentDeviceId",customMapLocationBean.getTargetId());
                customMapLocationBean.setChildDeviceList(deviceDao.findListDevice(param));
            }
        }
        AreaBean area = areaDao.findByArea(parameters);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("childList", childList);
        modelAndView.addObject("area", area);

        modelAndView.addObject("templateSetting",templateSettingSvc.findListTemplateSetting());

        List<FileBean> iconFileList = fileDao.findListFile(new HashMap<String, String>(){{put("fileType", AdminResource.FILE_TYPE.get("icon")); put("useYn", com.meous.common.resource.CommonResource.YES);}});
        modelAndView.addObject("iconFileList", iconFileList);

        try{
            InetAddress address = InetAddress.getByName(fileAddress);
            modelAndView.addObject("fileUploadPath", "http://" + address.getHostAddress() + fileAttachedUploadPath);
        }catch(Exception e){
            logger.error(e.getMessage());
        }
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView saveCustomMapLocation(Map<String, String> parameters) {
        // Custom Map remove Param
        Map<String, String> removeCustomParam = new HashMap<>();
        removeCustomParam.put("areaId",parameters.get("areaId"));

        // Area FileId Save Param
        Map<String, String> saveAreaParam = new HashMap<>();
        saveAreaParam.put("areaId",parameters.get("areaId"));
        saveAreaParam.put("fileId",parameters.get("fileId"));
        saveAreaParam.put("rotate",parameters.get("rotate"));
        saveAreaParam.put("skewX",parameters.get("skewX"));
        saveAreaParam.put("skewY",parameters.get("skewY"));
        saveAreaParam.put("angleClass",parameters.get("angleClass"));

        // Custom Map Insert Param
        List<CustomMapLocationBean> customList = new Gson().fromJson(parameters.get("customList"), new TypeToken<List<CustomMapLocationBean>>(){}.getType());
        List<FenceBean> fenceList = new Gson().fromJson(parameters.get("fenceList"), new TypeToken<List<FenceBean>>(){}.getType());
        List<FenceDeviceBean> fenceDeviceList = new Gson().fromJson(parameters.get("fenceDeviceList"), new TypeToken<List<FenceDeviceBean>>(){}.getType());

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try {
            // 구역 Bg File 업데이트
            areaDao.saveAreaByCustomMapLocation(saveAreaParam);

            // 장치 위치 Update
            customMapLocationDao.removeCustomMapLocation(removeCustomParam);
            if(customList.size()>0){
                customMapLocationDao.addCustomMapLocation(customList);
            }

            // 펜스 Update
            fenceDeviceDao.removeFenceDevice(removeCustomParam);
            fenceLocationDao.removeFenceLocation(removeCustomParam);
            fenceDao.removeFence(removeCustomParam);
            if(fenceList.size()>0){
                fenceDao.addFence(fenceList);
                for(FenceBean fenceBean : fenceList){
                    fenceLocationDao.addFenceLocation(fenceBean.getLocation());
                }
                if(fenceDeviceList.size()>0){
                    fenceDeviceDao.addFenceDevice(fenceDeviceList);
                }
            }
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new IsaverException("");
        }

        locationSync(parameters);
        vmsSync(parameters);
        return new ModelAndView();
    }

    @Override
    public ModelAndView syncCustomMapLocation(Map<String, String> parameters) {
        ModelAndView modelAndView = new ModelAndView();
        locationSync(parameters);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    private void locationSync(Map<String, String> parameters){
        List<DeviceBean> deviceList = deviceDao.findListDeviceForLocationSync(parameters);

        if(deviceList!=null && deviceList.size() > 0){
            for(DeviceBean device : deviceList){
                Map websocketParam = new HashMap();
                websocketParam.put("deviceId", device.getDeviceId());
                websocketParam.put("messageType","locationSync");

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
            }
        }
    }

    private void vmsSync(Map<String, String> parameters){
        List<Map> deviceList = deviceDao.findListDeviceForVMSSync(parameters);

        if(deviceList!=null && deviceList.size() > 0){
            try {
                if(mqttUtil.getIsMqtt()) {
                    ObjectMapper mapper = new ObjectMapper();
                    mqttUtil.publish("vmsSync", mapper.writeValueAsString(deviceList), 0);
                }
            } catch (Exception e) {
                throw new IsaverException(ResultState.ERROR_SEND_REQUEST,e.getMessage());
            }
        }
    }
}
