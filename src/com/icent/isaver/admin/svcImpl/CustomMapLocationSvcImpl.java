package com.icent.isaver.admin.svcImpl;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.icent.isaver.admin.common.resource.IsaverException;
import com.icent.isaver.admin.svc.CustomMapLocationSvc;
import com.icent.isaver.repository.bean.AreaBean;
import com.icent.isaver.repository.bean.CustomMapLocationBean;
import com.icent.isaver.repository.bean.FenceBean;
import com.icent.isaver.repository.bean.FenceDeviceBean;
import com.icent.isaver.repository.dao.base.AreaDao;
import com.icent.isaver.repository.dao.base.CustomMapLocationDao;
import com.icent.isaver.repository.dao.base.FenceDao;
import com.icent.isaver.repository.dao.base.FenceDeviceDao;
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

    static Logger logger = LoggerFactory.getLogger(CustomMapLocationSvcImpl.class);

    @Resource(name="isaverTxManager")
    private DataSourceTransactionManager transactionManager;

    @Value("${cnf.fileAddress}")
    private String fileAddress = null;

    @Value("${cnf.fileAttachedUploadPath}")
    private String fileAttachedUploadPath = null;

    @Inject
    private CustomMapLocationDao customMapLocationDao;

    @Inject
    private FenceDeviceDao fenceDeviceDao;

    @Inject
    private FenceDao fenceDao;

    @Inject
    private AreaDao areaDao;

    @Override
    public ModelAndView findListCustomMapLocation(Map<String, String> parameters) {
        List<CustomMapLocationBean> childList = customMapLocationDao.findListCustomMapLocation(parameters);
        AreaBean area = areaDao.findByArea(parameters);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("childList", childList);
        modelAndView.addObject("area", area);
        try{
            InetAddress address = InetAddress.getByName(fileAddress);
            modelAndView.addObject("fileUploadPath", "http://" + address.getHostAddress() + fileAttachedUploadPath);
        }catch(Exception e){
            e.printStackTrace();
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

        // Custom Map Insert Param
        List<CustomMapLocationBean> customList = new Gson().fromJson(parameters.get("customList"), new TypeToken<List<CustomMapLocationBean>>(){}.getType());
        List<FenceBean> fenceList = new Gson().fromJson(parameters.get("fenceList"), new TypeToken<List<FenceBean>>(){}.getType());
        List<FenceDeviceBean> fenceDeviceList = new Gson().fromJson(parameters.get("fenceDeviceList"), new TypeToken<List<FenceDeviceBean>>(){}.getType());

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try {
            areaDao.saveAreaFileId(saveAreaParam);
            customMapLocationDao.removeCustomMapLocation(removeCustomParam);
            fenceDeviceDao.removeFenceDevice(removeCustomParam);
            if(customList.size()>0){
                customMapLocationDao.insertCustomMapLocation(customList);
            }
            if(fenceList.size()>0){
                fenceDao.saveFence(fenceList);
            }
            if(fenceDeviceList.size()>0){
                fenceDeviceDao.addFenceDevice(fenceDeviceList);
            }
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new IsaverException("");
        }
        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }
}
