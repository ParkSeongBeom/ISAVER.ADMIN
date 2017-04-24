package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.common.resource.IcentException;
import com.icent.isaver.admin.resource.AdminResource;
import com.icent.isaver.admin.svc.DeviceSyncRequestSvc;
import com.icent.isaver.admin.svc.FileSvc;
import com.icent.isaver.admin.util.AdminHelper;
import com.icent.isaver.admin.util.CommonUtil;
import com.icent.isaver.repository.bean.FileBean;
import com.icent.isaver.repository.dao.base.DeviceDao;
import com.icent.isaver.repository.dao.base.FileDao;
import com.kst.common.helper.FileTransfer;
import com.kst.common.spring.TransactionUtil;
import com.kst.common.util.ListUtils;
import com.kst.common.util.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionStatus;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 파일 Service Implements
 * @author : psb
 * @version : 1.0
 * @since : 2016. 12. 20.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2016. 12. 20.     psb           최초 생성
 * </pre>
 */
@Service
public class FileSvcImpl implements FileSvc {

    @Resource(name="isaverTxManager")
    private DataSourceTransactionManager transactionManager;

    @Value("${cnf.fileAttachedUploadPath}")
    private String fileUploadPath = null;

    @Inject
    private FileDao fileDao;

    @Inject
    private DeviceDao deviceDao;

    @Inject
    private DeviceSyncRequestSvc deviceSyncRequestSvc;

    @Override
    public ModelAndView findListFile(Map<String, String> parameters) {
        List<FileBean> files = fileDao.findListFile(parameters);
        Integer totalCount = fileDao.findCountFile(parameters);

        AdminHelper.setPageTotalCount(parameters, totalCount);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("files", files);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView findListFileForDevice(Map<String, String> parameters) {
        List<FileBean> files = fileDao.findListFile(parameters);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("files", files);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView findByFile(Map<String, String> parameters) {
        ModelAndView modelAndView = new ModelAndView();

        FileBean file = fileDao.findByFile(parameters);
        modelAndView.addObject("file", file);
        return modelAndView;
    }

    @Override
    public ModelAndView addFile(HttpServletRequest request, Map<String, String> parameters) {
        String fileId = StringUtils.getGUID32();
        File file = null;

        try {
            file = FileTransfer.upload(request, "file", 1024, fileUploadPath, null, fileId);
        } catch(IOException e){
            if(file != null){
                file.delete();
            }
            throw new IcentException("");
        }

        if(file != null){
            parameters.put("physicalFileName", file.getName());
            parameters.put("fileSize", String.valueOf(file.length()));
            parameters.put("filePath", file.getAbsolutePath());
        }else{
            throw new IcentException("");
        }

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try {
            parameters.put("fileId",fileId);
            fileDao.addFile(parameters);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new IcentException("");
        }

        saveFileDevice(request, fileId, parameters.get("updateUserId"), parameters.get("addDevices"), parameters.get("removeDevices"), parameters.get("addDeviceSyncRequests"));
        return new ModelAndView();
    }

    @Override
    public ModelAndView saveFile(HttpServletRequest request, Map<String, String> parameters) {
        File file = null;

        try {
            file = FileTransfer.upload(request, "file", 1024, fileUploadPath, null, parameters.get("fileId"));
        } catch(IOException e){
            if(file != null){
                file.delete();
            }
            throw new IcentException("");
        }

        if(file != null){
            parameters.put("physicalFileName", file.getName());

            if(StringUtils.notNullCheck(parameters.get("selDevices"))){
                if(StringUtils.nullCheck(parameters.get("addDeviceSyncRequests"))){
                    parameters.put("addDeviceSyncRequests", parameters.get("selDevices"));
                }else{
                    parameters.put("addDeviceSyncRequests", parameters.get("addDeviceSyncRequests") + "," + parameters.get("selDevices"));
                }
            }
        }

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try {
            fileDao.saveFile(parameters);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new IcentException("");
        }

        saveFileDevice(request, parameters.get("fileId"), parameters.get("updateUserId"), parameters.get("addDevices"), parameters.get("removeDevices"), parameters.get("addDeviceSyncRequests"));
        return new ModelAndView();
    }

    @Override
    public ModelAndView removeFile(HttpServletRequest request, Map<String, String> parameters) {
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try{
            fileDao.removeFile(parameters);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new IcentException("");
        }

        saveFileDevice(request, parameters.get("fileId"), parameters.get("updateUserId"), parameters.get("addDevices"), parameters.get("removeDevices"), parameters.get("addDeviceSyncRequests"));
        return new ModelAndView();
    }

    @Override
    public ModelAndView downloadFile(Map<String, String> parameters, HttpServletRequest request, HttpServletResponse response) {
        FileBean file = fileDao.findByFile(parameters);

        if(StringUtils.notNullCheck(file.getPhysicalFileName())) {
            try {
                if (new File(fileUploadPath + file.getPhysicalFileName()).exists()) {
                    CommonUtil.download(request, response, fileUploadPath + file.getPhysicalFileName(), "\"" + file.getLogicalFileName() + "\"", 1024);
                }
            } catch(IOException | ServletException e) {
                throw new IcentException("");
            }
        }
        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }
    private void saveFileDevice(HttpServletRequest request, String fileId, String updateUserId, String addDevices, String removeDevices, String addDeviceSyncRequests) {
        List<Map<String, String>> parameterList = new ArrayList<>();
        if(StringUtils.notNullCheck(addDevices)){
            String[] addDeviceIds = addDevices.split(AdminResource.COMMA_STRING);

            for (String deviceId : addDeviceIds) {
                Map<String, String> addDeviceParamMap = new HashMap<>();
                addDeviceParamMap.put("fileId", fileId);
                addDeviceParamMap.put("deviceId", deviceId);
                addDeviceParamMap.put("updateUserId", updateUserId);
                parameterList.add(addDeviceParamMap);
            }
        }
        if(StringUtils.notNullCheck(removeDevices)){
            String[] removeDeviceIds = removeDevices.split(AdminResource.COMMA_STRING);

            for (String deviceId : removeDeviceIds) {
                Map<String, String> removeDeviceParamMap = new HashMap<>();
                removeDeviceParamMap.put("fileId", null);
                removeDeviceParamMap.put("deviceId", deviceId);
                removeDeviceParamMap.put("updateUserId", updateUserId);
                parameterList.add(removeDeviceParamMap);
            }
        }

        if(ListUtils.notNullCheck(parameterList)){
            deviceDao.saveListDeviceForFile(parameterList);
        }

        if(StringUtils.notNullCheck(addDeviceSyncRequests)){
            Map<String, String> addDeviceSyncRequestParam = new HashMap<>();
            addDeviceSyncRequestParam.put("deviceIds", addDeviceSyncRequests);
            addDeviceSyncRequestParam.put("type", AdminResource.SYNC_TYPE.get("save"));
            deviceSyncRequestSvc.addDeviceSyncRequest(request, addDeviceSyncRequestParam);
        }
    }
}
