package main.java.com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.common.resource.IsaverException;
import com.icent.isaver.admin.resource.AdminResource;
import com.icent.isaver.admin.svc.CriticalSvc;
import com.icent.isaver.admin.bean.CriticalBean;
import com.icent.isaver.admin.bean.DeviceBean;
import com.icent.isaver.admin.bean.EventBean;
import com.icent.isaver.admin.dao.CriticalDao;
import com.icent.isaver.admin.dao.DeviceDao;
import com.icent.isaver.admin.dao.EventDao;
import com.kst.common.spring.TransactionUtil;
import com.kst.common.util.ListUtils;
import com.kst.common.util.StringUtils;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionStatus;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.inject.Inject;
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

    @Override
    public ModelAndView findListCritical(Map<String, String> parameters) {
        List<EventBean> eventList = criticalDao.findListCritical(parameters);
        List<DeviceBean> deviceList = deviceDao.findListDeviceForCritical(null);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("eventList", eventList);
        modelAndView.addObject("detectDeviceTypeCode", AdminResource.DEVICE_TYPE_CODE.get("target"));
        modelAndView.addObject("targetDeviceTypeCode", AdminResource.DEVICE_TYPE_CODE.get("alarm"));
        modelAndView.addObject("deviceList", deviceList);
        modelAndView.addObject("paramBean",parameters);
        modelAndView.addObject("alarmFileType", AdminResource.FILE_TYPE.get("alarm"));
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
        ModelAndView modelAndView = new ModelAndView();
        if(ListUtils.notNullCheck(criticalDao.findExistCritical(parameters))){
            modelAndView.addObject("resultCode", "ERR100");
        }else{
            TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
            parameters.put("criticalId", StringUtils.getGUID32());
            try {
                criticalDao.addCritical(parameters);
                transactionManager.commit(transactionStatus);
            }catch(DataAccessException e){
                transactionManager.rollback(transactionStatus);
                throw new IsaverException("");
            }
        }
        return modelAndView;
    }

    @Override
    public ModelAndView saveCritical(Map<String, String> parameters) {
        ModelAndView modelAndView = new ModelAndView();
        if(ListUtils.notNullCheck(criticalDao.findExistCritical(parameters))){
            modelAndView.addObject("resultCode", "ERR100");
        }else{
            TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
            try {
                criticalDao.saveCritical(parameters);
                transactionManager.commit(transactionStatus);
            }catch(DataAccessException e){
                transactionManager.rollback(transactionStatus);
                throw new IsaverException("");
            }
        }
        return modelAndView;
    }

    @Override
    public ModelAndView removeCritical(Map<String, String> parameters) {
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            criticalDao.removeCritical(parameters);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new IsaverException("");
        }
        return new ModelAndView();
    }

}
