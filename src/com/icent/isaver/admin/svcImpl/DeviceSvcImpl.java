package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.common.resource.IcentException;
import com.icent.isaver.admin.resource.AdminResource;
import com.icent.isaver.admin.svc.DeviceSvc;
import com.icent.isaver.admin.svc.DeviceSyncRequestSvc;
import com.icent.isaver.admin.util.AlarmRequestUtil;
import com.icent.isaver.repository.bean.*;
import com.icent.isaver.repository.dao.base.*;
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
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

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

    @Value("${ws.server.address}")
    private String wsAddress = null;

    @Value("${ws.server.port}")
    private String wsPort = null;

    @Value("${ws.server.projectName}")
    private String wsProjectName = null;

    @Value("${ws.server.urlDeviceSync}")
    private String wsUrlDeviceSync = null;

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

    @Inject
    private AlarmTargetDeviceConfigDao alarmTargetDeviceConfigDao;

    @Override
    public ModelAndView findListDevice(Map<String, String> parameters) {
        List<DeviceBean> deviceTreeList = deviceDao.findListDevice(null);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("devices", deviceTreeList);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView findTbListDevice(Map<String, String> parameters) {
        List<DeviceBean> deviceList = deviceDao.findTbListDevice(parameters);
        List<AreaBean> areaList = areaDao.findListArea(null);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("devices", deviceList);
        modelAndView.addObject("areas", areaList);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView findByDevice(Map<String, String> parameters) {

        ModelAndView modelAndView = new ModelAndView();

        DeviceBean device = deviceDao.findByDevice(parameters);
        modelAndView.addObject("device", device);
        return modelAndView;
    }

    private DeviceLicenceBean getVerificationDeviceLicense(Map<String, String> parameters) {

        DeviceLicenceBean deviceLicenceBean = new DeviceLicenceBean();

        LicenseBean licenseBean = null;
        Boolean resultFlag = false;
        Boolean dateDiff = false;
        Integer deviceCount = 0;

        if (parameters.get("deviceCode").equals(AdminResource.PEOPLE_COUNT_DEVICE_ID)) {
            licenseBean = licenseDao.findByLicense(parameters);

            deviceCount = deviceDao.findCountDeviceLicense(parameters);

            Date deviceLicenseDate = null;

            if (  licenseBean != null && licenseBean.getLicenseCount() > 0 ) {

                SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");

                try {
                    deviceLicenseDate = format.parse(licenseBean.getExpireDate());
                    Calendar calendar = Calendar.getInstance();
                    calendar.setTime(deviceLicenseDate);
                    calendar.set(Calendar.HOUR_OF_DAY, 23);
                    calendar.set(Calendar.MINUTE, 59);
                    calendar.set(Calendar.SECOND, 59);
                    calendar.set(Calendar.MILLISECOND, 999);
                    deviceLicenseDate = calendar.getTime();

                } catch (ParseException e) {
                    throw new IcentException("");
                }

                if (  licenseBean.getLicenseCount() > deviceCount ) {
                    resultFlag = true;

                }

                if (deviceLicenseDate.getTime() >= new Date().getTime()) {
                    dateDiff = true;
                }
            }
        } else {
            resultFlag = true;
        }

        deviceLicenceBean.setLicenseBean(licenseBean);
        deviceLicenceBean.setResultFlag(resultFlag);
        deviceLicenceBean.setDateDiff(dateDiff);
        deviceLicenceBean.setDeviceCount(deviceCount);
        return deviceLicenceBean;
    }

    @Override
    public ModelAndView addDevice(HttpServletRequest request, Map<String, String> parameters) {

        DeviceLicenceBean deviceLicenceBean = getVerificationDeviceLicense(parameters);

        // 라이선스 사용안함 (2018.02.01 psb)
        deviceLicenceBean.setResultFlag(true);

        if (deviceLicenceBean.getResultFlag()) {
            TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

            try {
                parameters.put("deviceId", generatorFunc());
                deviceDao.addDevice(parameters);
                transactionManager.commit(transactionStatus);
            }catch(DataAccessException e){
                transactionManager.rollback(transactionStatus);
                throw new IcentException("");
            }

            transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
            try {
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
        }

        ModelAndView modelAndView = new ModelAndView();

        modelAndView.addObject("resultFlag", deviceLicenceBean.getResultFlag());

        if (deviceLicenceBean.getResultFlag() == false && parameters.get("deviceCode").equals(AdminResource.PEOPLE_COUNT_DEVICE_ID)) {

            if (deviceLicenceBean.getLicenseBean() == null ) {
                modelAndView.addObject("licenseMsg", "NOT_EXIST");
            } else if(deviceLicenceBean.getLicenseBean() != null && deviceLicenceBean.getDateDiff()  == false) {
                modelAndView.addObject("licenseMsg", "DAY_OVER");
            } else if (deviceLicenceBean.getLicenseBean() != null  && deviceLicenceBean.getLicenseBean().getLicenseCount() <= deviceLicenceBean.deviceCount) {
                modelAndView.addObject("licenseMsg", "QUANTITY_SHORTAGE");
            }

        }

        return modelAndView;
    }

    @Override
    public ModelAndView saveDevice(HttpServletRequest request, Map<String, String> parameters) {
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

//        DeviceBean device = deviceDao.findByDevice(parameters);
        try {
//            if(!parameters.get("areaId").equals(device.getAreaId()) || !parameters.get("deviceCode").equals(device.getDeviceCode())
//                    || (StringUtils.notNullCheck(parameters.get("ipAddress")) && !parameters.get("ipAddress").equals(device.getIpAddress()))){
                Map<String, String> addDeviceSyncRequestParam = new HashMap<>();
                addDeviceSyncRequestParam.put("deviceIds", parameters.get("deviceId"));
                addDeviceSyncRequestParam.put("type", AdminResource.SYNC_TYPE.get("save"));
                deviceSyncRequestSvc.addDeviceSyncRequest(request, addDeviceSyncRequestParam);
//            }
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new IcentException("");
        }

        transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try {
            deviceDao.saveDevice(parameters);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new IcentException("");
        }

        deviceSync(parameters.get("deviceId"));

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView removeDevice(HttpServletRequest request, Map<String, String> parameters) {

        List<DeviceBean> devices = deviceDao.findByDeviceTreeChildNodes(parameters);

        Boolean provisionExist = false;
        String provisionDeviceId = "";

        /*
        for (Integer i =0; i <devices.size(); i ++) {
            if (devices.get(i).getProvisionFlag().equals(CommonResource.YES)) {
                provisionExist = true;
                provisionDeviceId = devices.get(i).getDeviceId();
                break;
            }
            devices.get(i).setUpdateUserId(parameters.get("updateUserId"));
        }
        */

        if (!provisionExist) {
            TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

            try {
                Map<String, String> addDeviceSyncRequestParam = new HashMap<>();
                addDeviceSyncRequestParam.put("deviceIds", parameters.get("deviceId"));
                addDeviceSyncRequestParam.put("type", AdminResource.SYNC_TYPE.get("remove"));
                deviceSyncRequestSvc.addDeviceSyncRequest(request, addDeviceSyncRequestParam);
                transactionManager.commit(transactionStatus);
            }catch(DataAccessException e){
                transactionManager.rollback(transactionStatus);
                throw new IcentException("");
            }

            transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

            try{
                deviceDao.removeListDeviceForTree(devices);
                transactionManager.commit(transactionStatus);
            }catch(DataAccessException e){
                transactionManager.rollback(transactionStatus);
                throw new IcentException("");
            }

            deviceSync(parameters.get("deviceId"));
        }


        ModelAndView modelAndView = new ModelAndView();
        if (provisionExist) {
            modelAndView.addObject("provisionExist", "Y");
            modelAndView.addObject("provisionDeviceId", provisionDeviceId);
        }
        return modelAndView;
    }

    @Override
    public ModelAndView findListAlarmMappingDetail(Map<String, String> parameters) {

        ModelAndView modelAndView = new ModelAndView();
        List<AlarmTargetDeviceConfigBean> alarmTargetDeviceConfigList = alarmTargetDeviceConfigDao.findListAlarmTargetDeviceConfig(parameters);

        String deviceId = parameters.get("deviceId");

        DeviceParamBean deviceParamBean = new DeviceParamBean();

        deviceParamBean.setDeviceId(deviceId);
        if (parameters.get("findDeviceId") != "" && parameters.get("findDeviceId") != null) {
            deviceParamBean.setFindDeviceId(parameters.get("findDeviceId"));
        }

        if (parameters.get("findDeviceTypeCode") != "" && parameters.get("findDeviceTypeCode") != null) {
            deviceParamBean.setFindDeviceTypeCode(parameters.get("findDeviceTypeCode"));
        }

        if (alarmTargetDeviceConfigList.size() > 0) {
            deviceParamBean.setDeviceBeanList(alarmTargetDeviceConfigList);
        }

        List<DeviceBean> deviceBeanList = deviceDao.findListAlarmMapping(deviceParamBean);

        modelAndView.addObject("alarmTargetDeviceConfigList", alarmTargetDeviceConfigList);
        modelAndView.addObject("deviceBeanList", deviceBeanList);

        return modelAndView;
    }

    private void deviceSync(String deviceId){
        Map parentDeviceParam = new HashMap();
        parentDeviceParam.put("deviceId",deviceId);
        DeviceBean parentDevice = deviceDao.findByParentDevice(parentDeviceParam);

        if(parentDevice != null){
            try {
                Map websocketParam = new HashMap();
                websocketParam.put("deviceId",parentDevice.getDeviceId());

                AlarmRequestUtil.sendAlarmRequestFunc(websocketParam, "http://" + wsAddress + ":" + wsPort + "/" + wsProjectName + wsUrlDeviceSync, "form", null);
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

    class DeviceLicenceBean {
        LicenseBean licenseBean = null;
        Boolean resultFlag = false;
        Boolean dateDiff = false;
        Integer deviceCount = 0;

        public LicenseBean getLicenseBean() {
            return licenseBean;
        }

        public void setLicenseBean(LicenseBean licenseBean) {
            this.licenseBean = licenseBean;
        }

        public Boolean getResultFlag() {
            return resultFlag;
        }

        public void setResultFlag(Boolean resultFlag) {
            this.resultFlag = resultFlag;
        }

        public Boolean getDateDiff() {
            return dateDiff;
        }

        public void setDateDiff(Boolean dateDiff) {
            this.dateDiff = dateDiff;
        }

        public Integer getDeviceCount() {
            return deviceCount;
        }

        public void setDeviceCount(Integer deviceCount) {
            this.deviceCount = deviceCount;
        }
    }
}
