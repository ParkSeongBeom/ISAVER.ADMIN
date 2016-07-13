package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.bean.JabberException;
import com.icent.isaver.admin.svc.AreaSvc;
import com.icent.isaver.admin.svc.DeviceSvc;
import com.icent.isaver.repository.bean.AreaBean;
import com.icent.isaver.admin.util.AdminHelper;
import com.icent.isaver.repository.bean.DeviceBean;
import com.icent.isaver.repository.dao.base.AreaDao;
import com.icent.isaver.repository.dao.base.DeviceDao;
import com.kst.common.resource.CommonResource;
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

    @Resource(name="mybatisIsaverTxManager")
    private DataSourceTransactionManager transactionManager;

    @Inject
    private DeviceDao deviceDao;

    @Inject
    private AreaSvc areaSvc;

    @Override
    public ModelAndView findAllDeviceTree(Map<String, String> parameters) {

        List<DeviceBean> deviceTreeList = this.deviceTreeDataStructure(null);
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("deviceList", deviceTreeList);
        return modelAndView;
    }

    @Override
    public ModelAndView findListDeviceArea(Map<String, String> parameters) {
        return null;
    }

    @Override
    public ModelAndView findListDevice(Map<String, String> parameters) {

        List<DeviceBean> deviceTreeList = this.deviceTreeDataStructure(null);
        ModelAndView areaModelAndView = areaSvc.findAllAreaTree(parameters);

        List<AreaBean> areaTreeList = (List<AreaBean>) areaModelAndView.getModel().get("areaList");
//        Integer totalCount = deviceDao.findCountDevice(parameters);
//        AdminHelper.setPageTotalCount(parameters, totalCount);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("devices", deviceTreeList);
        modelAndView.addObject("areas", areaTreeList);
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

    @Override
    public ModelAndView addDevice(HttpServletRequest request, Map<String, String> parameters) {

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try {
            parameters.put("deviceId", generatorFunc());
            deviceDao.addDevice(parameters);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView saveDevice(HttpServletRequest request, Map<String, String> parameters) {

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try {
            deviceDao.saveDevice(parameters);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView removeDevice(Map<String, String> parameters) {

        List<DeviceBean> devices = deviceDao.findByDeviceTreeChildNodes(parameters);

        Boolean provisionExist = false;
        String provisionDeviceId = "";

        for (Integer i =0; i <devices.size(); i ++) {
            if (devices.get(i).getProvisionFlag().equals(CommonResource.YES)) {
                provisionExist = true;
                provisionDeviceId = devices.get(i).getDeviceId();
                break;
            }
            devices.get(i).setUpdateUserId(parameters.get("updateUserId"));
        }

        if (!provisionExist) {
            TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

            try{
                deviceDao.removeListDeviceForTree(devices);
                transactionManager.commit(transactionStatus);
            }catch(DataAccessException e){
                transactionManager.rollback(transactionStatus);
                throw new JabberException("");
            }
        }


        ModelAndView modelAndView = new ModelAndView();
        if (provisionExist) {
            modelAndView.addObject("provisionExist", "Y");
            modelAndView.addObject("provisionDeviceId", provisionDeviceId);
        }
        return modelAndView;
    }

    @Override
    public List<DeviceBean> deviceTreeDataStructure(Map<String, String> parameters) {

        //String orgRootId = this.orgRootId;

        List<DeviceBean> deviceTreeList = deviceDao.findAllDeviceTree(null);

        Integer loopLength = 0;

        DeviceTreeModel deviceTreeModel = new DeviceTreeModel();

        //bean.setOrgId(orgRootId);
        //bean.setDepth(0);
        //organizationTreeModel.setOrgBean(bean);
        //organizationTreeList.add(0, bean);
        deviceTreeModel.setDeviceList(deviceTreeList);

        /* 구역 깊이 별 정렬 순서에 의한 정렬 시도*/
        while (deviceTreeModel.getTreeLength() != deviceTreeModel.getDeviceList().size() && deviceTreeModel.getDeviceList().size() != loopLength) {

            List<DeviceBean> syncOrgList = copyDeviceListFunc(deviceTreeModel.getDeviceList());
            for(DeviceBean deviceBean:syncOrgList) {

                //if (orgBean.getOrgId().equals(orgRootId)) {
                if (deviceBean.getDepth() == 1) {
                    Integer treeLength = deviceTreeModel.getTreeLength();
                    treeLength++;
                    deviceTreeModel.setTreeLength(treeLength);

                    if (deviceTreeModel.getDeviceModelList() == null) {
                        deviceTreeModel.setDeviceModelList(new ArrayList<DeviceBean>());
                    }

                    deviceTreeModel.getDeviceModelList().add(deviceBean);
                    deviceTreeModel.getDeviceList().remove(deviceBean);

                } else {
                    deviceTreeModel.setDeviceBean(deviceBean);
                    this.getParentNode(deviceTreeModel);
                }

            }
        }

        /* 구역  모델에서 루트 ROOT KEY 삭제 */
        //organizationTreeModel.getOrgModelList().remove(bean);
        /* 초기화 */
        deviceTreeModel.setDeviceBean(null);

        return deviceTreeModel.getDeviceModelList();
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

    public DeviceTreeModel getParentNode(DeviceTreeModel deviceTreeModel) {

        Integer treeLength = deviceTreeModel.getTreeLength();

        List<DeviceBean> syncDeviceList = null;
        if (deviceTreeModel.getDeviceModelList() != null) {
            syncDeviceList = copyDeviceListFunc(deviceTreeModel.getDeviceModelList());
        } else {
            deviceTreeModel.setDeviceModelList(new ArrayList<DeviceBean>());
            syncDeviceList = new ArrayList<>();
        }

        for (DeviceBean deviceBean : syncDeviceList) {

            if (deviceBean.getDeviceId().equals(deviceTreeModel.getDeviceBean().getParentDeviceId())) {

                deviceTreeModel.getDeviceModelList().add(deviceTreeModel.getDeviceBean());
                deviceTreeModel.getDeviceList().remove(deviceTreeModel.getDeviceBean());
                Collections.sort(syncDeviceList, new NoAscCompare());

                treeLength++;
            }

        }

        deviceTreeModel.setTreeLength(treeLength);
        return deviceTreeModel;
    }

    /**
     * 숫자 오름차순 정렬 : 구역 SortOrder 기준 사용
     * @author dhj
     */
    public static class NoAscCompare implements Comparator<DeviceBean> {

        /**
         * 오름차순(ASC)
         */
        @Override
        public int compare(DeviceBean arg0, DeviceBean arg1) {
            return arg0.getDepth() < arg1.getDepth() ? -1 : arg0.getDepth() > arg1.getDepth() ? 1:0;
        }

    }

    public static List<DeviceBean> copyDeviceListFunc(List<DeviceBean> orgList) {

        List<DeviceBean> list = new ArrayList<>();

        for(DeviceBean bean : orgList) {
            list.add(bean);
        }
        return list;
    }

    class DeviceTreeModel {

        List<DeviceBean> deviceModelList;
        List<DeviceBean> deviceList;
        DeviceBean deviceBean;

        Integer treeLength = 0;
        Integer loopLength = 0;

        public List<DeviceBean> getDeviceModelList() {
            return deviceModelList;
        }

        public void setDeviceModelList(List<DeviceBean> deviceModelList) {
            this.deviceModelList = deviceModelList;
        }

        public List<DeviceBean> getDeviceList() {
            return deviceList;
        }

        public void setDeviceList(List<DeviceBean> deviceList) {
            this.deviceList = deviceList;
        }

        public DeviceBean getDeviceBean() {
            return deviceBean;
        }

        public void setDeviceBean(DeviceBean deviceBean) {
            this.deviceBean = deviceBean;
        }

        public Integer getTreeLength() {
            return treeLength;
        }

        public void setTreeLength(Integer treeLength) {
            this.treeLength = treeLength;
        }

        public Integer getLoopLength() {
            return loopLength;
        }

        public void setLoopLength(Integer loopLength) {
            this.loopLength = loopLength;
        }
    }
}
