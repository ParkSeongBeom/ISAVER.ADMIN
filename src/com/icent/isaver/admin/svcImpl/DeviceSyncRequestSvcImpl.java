package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.common.resource.IcentException;
import com.icent.isaver.admin.resource.AdminResource;
import com.icent.isaver.admin.svc.DeviceSyncRequestSvc;
import com.icent.isaver.admin.util.AdminHelper;
import com.icent.isaver.repository.bean.DeviceSyncRequestBean;
import com.icent.isaver.repository.dao.base.DeviceSyncRequestDao;
import com.kst.common.spring.TransactionUtil;
import com.kst.common.util.StringUtils;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionStatus;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 장치 동기화 요청 Service implements
 * @author : psb
 * @version : 1.0
 * @since : 2016. 10. 24.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2016. 10. 24.     psb           최초 생성
 * </pre>
 */
@Service
public class DeviceSyncRequestSvcImpl implements DeviceSyncRequestSvc {

    @Inject
    private DeviceSyncRequestDao deviceSyncRequestDao;

    @Resource(name="isaverTxManager")
    private DataSourceTransactionManager transactionManager;

    @Override
    public ModelAndView findListDeviceSyncRequest(Map<String, String> parameters) {
        List<DeviceSyncRequestBean> deviceSyncRequestList = deviceSyncRequestDao.findListDeviceSyncRequest(parameters);
        Integer totalCount = deviceSyncRequestDao.findCountDeviceSyncRequest(parameters);

        AdminHelper.setPageTotalCount(parameters, totalCount);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("deviceSyncRequestList", deviceSyncRequestList);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView addDeviceSyncRequest(HttpServletRequest request, Map<String, String> parameters) {
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        List<Map<String, String>> addParamList = new ArrayList<>();
        String[] deviceIds = parameters.get("deviceIds").split(AdminResource.COMMA_STRING);

        for (String deviceId : deviceIds) {
            Map<String, String> addParam = new HashMap<>();
            addParam.put("deviceSyncRequestId", StringUtils.getGUID32());
            addParam.put("deviceId", deviceId);
            addParam.put("type", parameters.get("type"));
            addParam.put("status", AdminResource.SYNC_STATUS.get("wait"));
            addParam.put("insertUserId", AdminHelper.getAdminIdFromSession(request));
            addParamList.add(addParam);
        }

        try{
            deviceSyncRequestDao.addDeviceSyncRequest(addParamList);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new IcentException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView saveDeviceSyncRequest(HttpServletRequest request, Map<String, String> parameters) {
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        List<Map<String, String>> saveParamList = new ArrayList<>();
        String[] deviceSyncRequestIds = parameters.get("deviceSyncRequestIds").split(",");

        for (String deviceSyncRequestId : deviceSyncRequestIds) {
            Map<String, String> saveParam = new HashMap<>();
            saveParam.put("deviceSyncRequestId", deviceSyncRequestId);
            saveParam.put("status", AdminResource.SYNC_STATUS.get("wait"));
            saveParam.put("updateUserId", AdminHelper.getAdminIdFromSession(request));
            saveParamList.add(saveParam);
        }

        try{
            deviceSyncRequestDao.saveDeviceSyncRequest(saveParamList);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new IcentException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }
}
