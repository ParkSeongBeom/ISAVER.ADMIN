package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.common.resource.IcentException;
import com.icent.isaver.admin.resource.AdminResource;
import com.icent.isaver.admin.svc.CriticalSvc;
import com.icent.isaver.repository.bean.CriticalBean;
import com.icent.isaver.repository.bean.DeviceBean;
import com.icent.isaver.repository.bean.EventBean;
import com.icent.isaver.repository.bean.FileBean;
import com.icent.isaver.repository.dao.base.CriticalDao;
import com.icent.isaver.repository.dao.base.DeviceDao;
import com.icent.isaver.repository.dao.base.EventDao;
import com.icent.isaver.repository.dao.base.FileDao;
import com.kst.common.spring.TransactionUtil;
import com.kst.common.util.StringUtils;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionStatus;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.inject.Inject;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 임계치 Service Implements
 * @author : psb
 * @version : 1.0
 * @since : 2018. 9. 21.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2018. 9. 21.     psb           최초 생성
 * </pre>
 */
@Service
public class CriticalSvcImpl implements CriticalSvc {

    @Resource(name="isaverTxManager")
    private DataSourceTransactionManager transactionManager;

    @Inject
    private CriticalDao criticalDao;

    @Inject
    private EventDao eventDao;

    @Inject
    private DeviceDao deviceDao;

    @Inject
    private FileDao fileDao;

    @Override
    public ModelAndView findListCritical(Map<String, String> parameters) {
        List<EventBean> eventList = criticalDao.findListCritical(parameters);
        List<DeviceBean> deviceList = deviceDao.findListDeviceForCritical(null);
        List<FileBean> alarmFileList = fileDao.findListFile(new HashMap<String, String>(){{put("fileType",AdminResource.FILE_TYPE.get("alarm"));}});

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("eventList", eventList);
        modelAndView.addObject("detectDeviceTypeCode", AdminResource.DEVICE_TYPE_CODE.get("target"));
        modelAndView.addObject("targetDeviceTypeCode", AdminResource.DEVICE_TYPE_CODE.get("alarm"));
        modelAndView.addObject("alarmFileList", alarmFileList);
        modelAndView.addObject("deviceList", deviceList);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView findByCritical(Map<String, String> parameters) {
        CriticalBean critical = criticalDao.findByCritical(parameters);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("critical", critical);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView addCritical(Map<String, String> parameters) {
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        parameters.put("criticalId", StringUtils.getGUID32());
        try {
            criticalDao.addCritical(parameters);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new IcentException("");
        }
        return new ModelAndView();
    }

    @Override
    public ModelAndView saveCritical(Map<String, String> parameters) {
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try {
            criticalDao.saveCritical(parameters);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new IcentException("");
        }
        return new ModelAndView();
    }

    @Override
    public ModelAndView removeCritical(Map<String, String> parameters) {
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try{
            criticalDao.removeCritical(parameters);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new IcentException("");
        }
        return new ModelAndView();
    }

}
