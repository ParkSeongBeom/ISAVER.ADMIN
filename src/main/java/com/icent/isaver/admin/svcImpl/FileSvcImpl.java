package main.java.com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.common.resource.CommonResource;
import com.icent.isaver.admin.common.resource.IsaverException;
import com.icent.isaver.admin.resource.ResultState;
import com.icent.isaver.admin.svc.DeviceSyncRequestSvc;
import com.icent.isaver.admin.svc.FileSvc;
import com.icent.isaver.admin.util.AdminHelper;
import com.icent.isaver.admin.util.AlarmRequestUtil;
import com.icent.isaver.admin.util.FileUtil;
import com.icent.isaver.admin.bean.FileBean;
import com.icent.isaver.admin.dao.DeviceDao;
import com.icent.isaver.admin.dao.FileDao;
import com.kst.common.helper.FileTransfer;
import com.kst.common.spring.TransactionUtil;
import com.kst.common.util.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionStatus;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
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

    @Value("${cnf.fileUploadPath}")
    private String fileUploadPath = null;

    @Value("${ws.server.domain}")
    private String wsDomain = null;

    @Value("${ws.server.port}")
    private String wsPort = null;

    @Value("${ws.server.projectName}")
    private String wsProjectName = null;

    @Value("${ws.server.urlSync}")
    private String wsUrlSync = null;

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
        modelAndView.addObject("paramBean",parameters);
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
            throw new IsaverException("");
        }

        if(file != null){
            parameters.put("physicalFileName", file.getName());
            parameters.put("fileSize", String.valueOf(file.length()));
            parameters.put("filePath", file.getAbsolutePath());
        }else{
            throw new IsaverException("");
        }

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try {
            parameters.put("fileId",fileId);
            fileDao.addFile(parameters);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new IsaverException("");
        }

        deviceSync();
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
            throw new IsaverException("");
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
            throw new IsaverException("");
        }

        deviceSync();
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
            throw new IsaverException("");
        }

        deviceSync();
        return new ModelAndView();
    }

    private void deviceSync(){
        try {
            Map websocketParam = new HashMap();
            websocketParam.put("allFlag", CommonResource.YES);
            websocketParam.put("messageType","alarmFileSync");

            AlarmRequestUtil.sendAlarmRequestFunc(websocketParam, "http://" + wsDomain + ":" + wsPort + "/" + wsProjectName + wsUrlSync, "form", null);
        } catch (Exception e) {
            throw new IsaverException(ResultState.ERROR_SEND_REQUEST,e.getMessage());
        }
    }

//    @Override
//    public ModelAndView downloadFile(Map<String, String> parameters, HttpServletRequest request, HttpServletResponse response) {
//        FileBean file = fileDao.findByFile(parameters);
//
//        if(StringUtils.notNullCheck(file.getPhysicalFileName())) {
//            try {
//                if (new File(fileUploadPath + file.getPhysicalFileName()).exists()) {
//                    CommonUtil.download(request, response, fileUploadPath + file.getPhysicalFileName(), "\"" + file.getLogicalFileName() + "\"", 1024);
//                }
//            } catch(IOException | ServletException e) {
//                throw new IsaverException("");
//            }
//        }
//        ModelAndView modelAndView = new ModelAndView();
//        return modelAndView;
//    }

    @Override
    public ModelAndView downloadFile(Map<String, String> parameters, HttpServletRequest request, HttpServletResponse response) {
        FileBean file = fileDao.findByFile(parameters);

        if(StringUtils.notNullCheck(file.getPhysicalFileName())) {
            try {
                FileUtil.fileDown(request, response, fileUploadPath, file.getPhysicalFileName(), file.getLogicalFileName());
            } catch(IOException e) {
                throw new IsaverException("");
            }
        }
        return new ModelAndView();
    }
}
