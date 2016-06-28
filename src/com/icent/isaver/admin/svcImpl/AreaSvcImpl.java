package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.bean.JabberException;
import com.icent.isaver.admin.svc.AreaSvc;
import com.icent.isaver.admin.util.AdminHelper;
import com.icent.isaver.repository.bean.AreaBean;
import com.icent.isaver.repository.bean.DeviceBean;
import com.icent.isaver.repository.dao.base.AreaDao;
import com.icent.isaver.repository.dao.base.DeviceDao;
import com.kst.common.springutil.TransactionUtil;
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
 * </pe>
 */
@Service
public class AreaSvcImpl implements AreaSvc {

    @Resource(name="mybatisIsaverTxManager")
    private DataSourceTransactionManager transactionManager;

    @Inject
    private AreaDao areaDao;

    @Inject
    private DeviceDao deviceDao;

    @Override
    public ModelAndView findAllAreaTree(Map<String, String> parameters) {

        List<AreaBean> areaTreeList = this.areaTreeDataStructure(null);
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("areaList", areaTreeList);
        return modelAndView;
    }

    @Override
    public ModelAndView findListArea(Map<String, String> parameters) {
//        List<AreaBean> areas = areaDao.findListArea(parameters);
//        Integer totalCount = areaDao.findCountArea(parameters);

//        AdminHelper.setPageTotalCount(parameters, totalCount);

        List<AreaBean> areaTreeList = this.areaTreeDataStructure(null);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("areas", areaTreeList);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView findByArea(Map<String, String> parameters) {

        ModelAndView modelAndView = new ModelAndView();

        AreaBean area = areaDao.findByArea(parameters);

        List<DeviceBean> deviceBeanList = deviceDao.findListDevice(parameters);
        Integer deviceTotalCount = deviceDao.findCountDevice(parameters);

        modelAndView.addObject("area", area);
        modelAndView.addObject("devices", deviceBeanList);
        modelAndView.addObject("totalCount", deviceTotalCount);

        return modelAndView;
    }

    @Override
    public ModelAndView addArea(HttpServletRequest request, Map<String, String> parameters) {

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try {
            parameters.put("areaId", generatorFunc());
            areaDao.addArea(parameters);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView saveArea(HttpServletRequest request, Map<String, String> parameters) {

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try {

            areaDao.saveArea(parameters);

            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView removeArea(Map<String, String> parameters) {

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            areaDao.removeArea(parameters);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public List<AreaBean> areaTreeDataStructure(Map<String, String> parameters) {

        //String orgRootId = this.orgRootId;

        List<AreaBean> areaTreeList = areaDao.findAllAreaTree(null);

        Integer loopLength = 0;

        AreaTreeModel areaTreeModel = new AreaTreeModel();

        //bean.setOrgId(orgRootId);
        //bean.setDepth(0);
        //organizationTreeModel.setOrgBean(bean);
        //organizationTreeList.add(0, bean);
        areaTreeModel.setAreaList(areaTreeList);

        /* 구역 깊이 별 정렬 순서에 의한 정렬 시도*/
        while (areaTreeModel.getTreeLength() != areaTreeModel.getAreaList().size() && areaTreeModel.getAreaList().size() != loopLength) {

            List<AreaBean> syncOrgList = copyAreaListFunc(areaTreeModel.getAreaList());
            for(AreaBean areaBean:syncOrgList) {

                //if (orgBean.getOrgId().equals(orgRootId)) {
                if (areaBean.getDepth() == 1) {
                    Integer treeLength = areaTreeModel.getTreeLength();
                    treeLength++;
                    areaTreeModel.setTreeLength(treeLength);

                    if (areaTreeModel.getAreaModelList() == null) {
                        areaTreeModel.setAreaModelList(new ArrayList<AreaBean>());
                    }

                    areaTreeModel.getAreaModelList().add(areaBean);
                    areaTreeModel.getAreaList().remove(areaBean);

                } else {
                    areaTreeModel.setAreaBean(areaBean);
                    this.getParentNode(areaTreeModel);
                }

            }
        }

        /* 구역  모델에서 루트 ROOT KEY 삭제 */
        //organizationTreeModel.getOrgModelList().remove(bean);
        /* 초기화 */
        areaTreeModel.setAreaBean(null);

        return areaTreeModel.getAreaModelList();
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


    public AreaTreeModel getParentNode(AreaTreeModel areaTreeModel) {

        Integer treeLength = areaTreeModel.getTreeLength();

        List<AreaBean> syncAreaList = null;
        if (areaTreeModel.getAreaModelList() != null) {
            syncAreaList = copyAreaListFunc(areaTreeModel.getAreaModelList());
        } else {
            areaTreeModel.setAreaModelList(new ArrayList<AreaBean>());
            syncAreaList = new ArrayList<>();
        }

        for (AreaBean areaBean : syncAreaList) {

            if (areaBean.getAreaId().equals(areaTreeModel.getAreaBean().getParentAreaId())) {

                areaTreeModel.getAreaModelList().add(areaTreeModel.getAreaBean());
                areaTreeModel.getAreaList().remove(areaTreeModel.getAreaBean());
                Collections.sort(syncAreaList, new NoAscCompare());

                treeLength++;
            }

        }

        areaTreeModel.setTreeLength(treeLength);
        return areaTreeModel;
    }

    /**
     * 숫자 오름차순 정렬 : 구역 SortOrder 기준 사용
     * @author dhj
     */
    public static class NoAscCompare implements Comparator<AreaBean> {

        /**
         * 오름차순(ASC)
         */
        @Override
        public int compare(AreaBean arg0, AreaBean arg1) {
            return arg0.getDepth() < arg1.getDepth() ? -1 : arg0.getDepth() > arg1.getDepth() ? 1:0;
        }

    }

    public static List<AreaBean> copyAreaListFunc(List<AreaBean> orgList) {

        List<AreaBean> list = new ArrayList<>();

        for(AreaBean bean : orgList) {
            list.add(bean);
        }
        return list;
    }

    class AreaTreeModel {

        List<AreaBean> areaModelList;
        List<AreaBean> areaList;
        AreaBean areaBean;

        Integer treeLength = 0;
        Integer loopLength = 0;

        public List<AreaBean> getAreaModelList() {
            return areaModelList;
        }

        public void setAreaModelList(List<AreaBean> areaModelList) {
            this.areaModelList = areaModelList;
        }

        public List<AreaBean> getAreaList() {
            return areaList;
        }

        public void setAreaList(List<AreaBean> areaList) {
            this.areaList = areaList;
        }

        public AreaBean getAreaBean() {
            return areaBean;
        }

        public void setAreaBean(AreaBean areaBean) {
            this.areaBean = areaBean;
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
