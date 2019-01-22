package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.common.resource.IsaverException;
import com.icent.isaver.admin.resource.AdminResource;
import com.icent.isaver.admin.svc.AreaSvc;
import com.icent.isaver.admin.svc.DeviceSyncRequestSvc;
import com.icent.isaver.admin.bean.AreaBean;
import com.icent.isaver.admin.bean.DeviceBean;
import com.icent.isaver.admin.dao.AreaDao;
import com.icent.isaver.admin.dao.DeviceDao;
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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 구역 Service Implements
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
 *  2018. 6. 12.     psb           트리 제거 및 소스정리
 * </pe>
 */
@Service
public class AreaSvcImpl implements AreaSvc {

    @Resource(name="isaverTxManager")
    private DataSourceTransactionManager transactionManager;

    @Inject
    private AreaDao areaDao;

    @Inject
    private DeviceDao deviceDao;

    @Inject
    private DeviceSyncRequestSvc deviceSyncRequestSvc;

    @Override
    public ModelAndView findListArea(Map<String, String> parameters) {
        List<AreaBean> areas = areaDao.findListArea(parameters);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("areas", areas);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView findByArea(Map<String, String> parameters) {

        ModelAndView modelAndView = new ModelAndView();

        AreaBean area = areaDao.findByArea(parameters);

        List<DeviceBean> deviceBeanList = deviceDao.findListDeviceArea(parameters);
        Integer deviceTotalCount = deviceDao.findCountDeviceArea(parameters);

        modelAndView.addObject("area", area);
        modelAndView.addObject("devices", deviceBeanList);
        modelAndView.addObject("totalCount", deviceTotalCount);

        return modelAndView;
    }

    @Override
    public ModelAndView addArea(HttpServletRequest request, Map<String, String> parameters) {
        ModelAndView modelAndView = new ModelAndView();

        Map<String, String> areaCheckParam = new HashMap<>();
        areaCheckParam.put("delYn","N");
        areaCheckParam.put("parentAreaId",parameters.get("parentAreaId"));

        if(areaDao.findCountArea(areaCheckParam)>=9){
            modelAndView.addObject("resultCode", "ERR200");
        }else{
            TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
            try {
                parameters.put("areaId", generatorFunc());
                areaDao.addArea(parameters);
                transactionManager.commit(transactionStatus);
            }catch(DataAccessException e){
                transactionManager.rollback(transactionStatus);
                throw new IsaverException("");
            }
        }
        return modelAndView;
    }

    @Override
    public ModelAndView saveArea(HttpServletRequest request, Map<String, String> parameters) {
        ModelAndView modelAndView = new ModelAndView();

        Map<String, String> areaCheckParam = new HashMap<>();
        areaCheckParam.put("delYn","N");
        areaCheckParam.put("areaId",parameters.get("areaId"));
        areaCheckParam.put("parentAreaId",parameters.get("parentAreaId"));

        if(areaDao.findCountArea(areaCheckParam)>=9){
            modelAndView.addObject("resultCode", "ERR200");
        }else{
            TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
            AreaBean area = areaDao.findByArea(parameters);
            try {
                areaDao.saveArea(parameters);
                if(StringUtils.notNullCheck(parameters.get("allTemplate"))){
                    areaDao.saveAreaTemplate(parameters);
                }
                transactionManager.commit(transactionStatus);
            }catch(DataAccessException e){
                transactionManager.rollback(transactionStatus);
                throw new IsaverException("");
            }

            transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
            try {
                if(!parameters.get("areaName").equals(area.getAreaName())){
                    Map<String, String> addDeviceSyncRequestParam = new HashMap<>();
                    String deviceIds = "";

                    List<DeviceBean> deviceBeanList = deviceDao.findListDeviceArea(parameters);
                    for(DeviceBean deviceBean : deviceBeanList){
                        deviceIds += deviceBean.getDeviceId() + ",";
                    }

                    if(StringUtils.notNullCheck(deviceIds)){
                        deviceIds = deviceIds.substring(0, deviceIds.length()-1);
                        addDeviceSyncRequestParam.put("deviceIds",deviceIds);
                        addDeviceSyncRequestParam.put("type", AdminResource.SYNC_TYPE.get("save"));
                        deviceSyncRequestSvc.addDeviceSyncRequest(request, addDeviceSyncRequestParam);
                    }
                }
                transactionManager.commit(transactionStatus);
            }catch(DataAccessException e){
                transactionManager.rollback(transactionStatus);
                throw new IsaverException("");
            }
        }
        return modelAndView;
    }

    @Override
    public ModelAndView removeArea(HttpServletRequest request, Map<String, String> parameters) {

        List<AreaBean> areas = areaDao.findByAreaTreeChildNodes(parameters);

        for (Integer i =0; i <areas.size(); i ++) {
            areas.get(i).setUpdateUserId(parameters.get("updateUserId"));
        }

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try {
            Map<String, String> addDeviceSyncRequestParam = new HashMap<>();
            String deviceIds = "";

            List<DeviceBean> deviceBeanList = deviceDao.findListDeviceArea(parameters);
            for(DeviceBean deviceBean : deviceBeanList){
                deviceIds += deviceBean.getDeviceId() + ",";
            }

            if(StringUtils.notNullCheck(deviceIds)){
                deviceIds = deviceIds.substring(0, deviceIds.length()-1);
                addDeviceSyncRequestParam.put("deviceIds",deviceIds);
                addDeviceSyncRequestParam.put("type", AdminResource.SYNC_TYPE.get("remove"));
                deviceSyncRequestSvc.addDeviceSyncRequest(request, addDeviceSyncRequestParam);
            }
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new IsaverException("");
        }

        transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try{
            areaDao.removeListAreaForTree(areas);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new IsaverException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    /**
     *
     * @return
     */
    private String generatorFunc() {
        StringBuilder sb = new StringBuilder();

        Integer totalCount = areaDao.findCountGenerator();

        String id = "AR";

        String suffix = String.format("%04d", totalCount);
        sb.append(id).append(suffix);
        return sb.toString();
    }
}
