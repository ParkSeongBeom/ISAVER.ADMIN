package com.icent.isaver.admin.svcImpl;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.icent.isaver.admin.bean.CriticalBean;
import com.icent.isaver.admin.common.resource.IsaverException;
import com.icent.isaver.admin.dao.CriticalDao;
import com.icent.isaver.admin.dao.DeviceDao;
import com.icent.isaver.admin.dao.EventDao;
import com.icent.isaver.admin.resource.AdminResource;
import com.icent.isaver.admin.svc.CriticalSvc;
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
import java.util.ArrayList;
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

    @Override
    public ModelAndView findListCritical(Map<String, String> parameters) {
        ModelAndView modelAndView = new ModelAndView();

        if(StringUtils.notNullCheck(parameters.get("eventId"))){
            modelAndView.addObject("list",criticalDao.findListCritical(parameters));
        }else{
            modelAndView.addObject("eventList", eventDao.findListEvent(parameters));
            modelAndView.addObject("detectDeviceList", deviceDao.findListDeviceForCriticalDetect(new HashMap<String,String>(){{put("deviceTypeCode",AdminResource.DEVICE_TYPE_CODE.get("target"));}}));
            modelAndView.addObject("targetDeviceList", deviceDao.findListDeviceForCriticalTarget(new HashMap<String,String>(){{put("deviceTypeCode",AdminResource.DEVICE_TYPE_CODE.get("alarm"));}}));
        }
        modelAndView.addObject("paramBean",parameters);
        modelAndView.addObject("alarmFileType", AdminResource.FILE_TYPE.get("alarm"));
        return modelAndView;
    }

    @Override
    public ModelAndView saveCritical(Map<String, String> parameters) {
        List<CriticalBean> criticalBeanList = new ArrayList<>();
        try{
            criticalBeanList = new Gson().fromJson(parameters.get("criticalList"), new TypeToken<List<CriticalBean>>(){}.getType());
        }catch(Exception e){
            throw new IsaverException("");
        }

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try {
            criticalDao.removeCritical(parameters);
            if(ListUtils.notNullCheck(criticalBeanList)) {
                criticalDao.saveCritical(criticalBeanList);
            }
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new IsaverException("");
        }
        return new ModelAndView();
    }
}
