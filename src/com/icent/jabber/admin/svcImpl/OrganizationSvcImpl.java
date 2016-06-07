package com.icent.jabber.admin.svcImpl;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.svc.OrganizationSvc;
import com.icent.jabber.admin.util.AdminHelper;
import com.icent.jabber.repository.bean.*;
import com.icent.jabber.repository.dao.base.OrgUserDao;
import com.icent.jabber.repository.dao.base.OrganizationDao;
import com.kst.common.springutil.TransactionUtil;
import com.kst.common.util.StringUtils;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionStatus;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.inject.Inject;
import java.lang.reflect.Type;
import java.util.*;

@Service
public class OrganizationSvcImpl implements OrganizationSvc {

    @Resource(name="mybatisBaseTxManager")
    private DataSourceTransactionManager transactionManager;

    @Inject
    private OrganizationDao organizationDao;

    @Inject
    private OrgUserDao orgUserDao;

    /* 부서 루트 ID */
    //private static String orgRootId = "ORG00000-0000-0000-0000-000000000000";

    @Override
    public ModelAndView findAllOrganizationTree(Map<String, String> parameters) {
        OrganizationBean paramBean = AdminHelper.convertMapToBean(parameters, OrganizationBean.class);
        List<OrganizationBean> organizationTreeList = this.orgTreeDataStructure(null);
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("organizationList", organizationTreeList);
        return modelAndView;
    }

    @Override
    public List<OrganizationBean> findAllOrganization() {
        List<OrganizationBean> organizationTreeList = organizationDao.findAllOrganizationTree(null);
        return organizationTreeList;
    }

    @Override
    public ModelAndView findByOrganization(Map<String, String> parameters) {
        FindBean paramBean = AdminHelper.convertMapToBean(parameters, FindBean.class);

        OrganizationBean organizationBean = null;
        ArrayList<HashMap<String,Object>> orgUsers = null;
        Integer totalCount = 0;

        if(paramBean.getId() != null){
            organizationBean = organizationDao.findByOrganization(paramBean);

            if(paramBean.getId().equals("0")){
                orgUsers = orgUserDao.findNotExistOrgUserMap(paramBean);
                totalCount = orgUserDao.findNotExistOrgUserCount(paramBean);
            }else{
                orgUsers = orgUserDao.findAllOrgUserMap(paramBean);
                totalCount = orgUserDao.findAllOrgUserCount(paramBean);
            }
        }

        ModelAndView modelAndView = new ModelAndView();

        modelAndView.addObject("organization", organizationBean);
        modelAndView.addObject("orgUsers", orgUsers);
        modelAndView.addObject("totalCount", totalCount);
        return modelAndView;
    }

    @Override
    public ModelAndView addOrganization(Map<String, String> parameters) {

        OrganizationBean paramBean = AdminHelper.convertMapToBean(parameters, OrganizationBean.class);

        paramBean.setOrgId(StringUtils.getGUID36());
        paramBean.setDepth(paramBean.getDepth()+1);
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try {
            organizationDao.addOrganization(paramBean);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView saveOrganization(Map<String, String> parameters) {
        OrganizationBean paramBean = AdminHelper.convertMapToBean(parameters, OrganizationBean.class);

        String roleIds = "";
        if (!parameters.get("roleIds").isEmpty()) {
            roleIds = parameters.get("roleIds");
        }

        FindBean findBean = new FindBean();
        findBean.setId(paramBean.getUpOrgId());
        OrganizationBean resultBean = organizationDao.findByOrganization(findBean);

        Gson gson = new Gson();

        Type typeOfObjectsList = new TypeToken<List<OrgUserBean>>() {}.getType();
        Collection<OrgUserBean> collection = gson.fromJson(roleIds, typeOfObjectsList);

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try {
            organizationDao.saveOrganization(paramBean);

            if (collection != null && collection.size() > 0) {
                orgUserDao.saveAllOrgUser(collection);
            }

            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView removeOrganization(Map<String, String> parameters) {

        OrganizationBean paramBean = AdminHelper.convertMapToBean(parameters, OrganizationBean.class);

        List<OrganizationBean> organizationRemoveList = organizationDao.findAllRemoveTargetOrgSeq(paramBean);

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try {
            for(OrganizationBean bean : organizationRemoveList) {
                OrgUserBean orgUserBean = new OrgUserBean();
                orgUserBean.setOrgId(bean.getOrgId());
                orgUserDao.removeOrgUser(orgUserBean);
            }
            for(OrganizationBean bean : organizationRemoveList) {
                organizationDao.removeOrganization(bean);
            }
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }
        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView findAllOrganizationConvertJson(Map<String, String> parameters) {
        return null;
    }

    @Override
    public List<OrganizationBean> orgTreeDataStructure(Map<String, String> parameters) {

        //String orgRootId = this.orgRootId;

        List<OrganizationBean> organizationTreeList = organizationDao.findAllOrganizationTree(null);

        Integer loopLength = 0;

        OrganizationTreeModel organizationTreeModel = new OrganizationTreeModel();

        OrganizationBean bean = new OrganizationBean();
        //bean.setOrgId(orgRootId);
        //bean.setDepth(0);
        //organizationTreeModel.setOrgBean(bean);
        //organizationTreeList.add(0, bean);
        organizationTreeModel.setOrgList(organizationTreeList);

        /* 부서 깊이 별 정렬 순서에 의한 정렬 시도*/
        while (organizationTreeModel.getTreeLength() != organizationTreeModel.getOrgList().size() && organizationTreeModel.getOrgList().size() != loopLength) {

            List<OrganizationBean> syncOrgList = copyOrgListFunc(organizationTreeModel.getOrgList());
            for(OrganizationBean orgBean:syncOrgList) {

                //if (orgBean.getOrgId().equals(orgRootId)) {
                if (orgBean.getDepth() == 1) {
                    Integer treeLength = organizationTreeModel.getTreeLength();
                    treeLength++;
                    organizationTreeModel.setTreeLength(treeLength);

                    if (organizationTreeModel.getOrgModelList() == null) {
                        organizationTreeModel.setOrgModelList(new ArrayList<OrganizationBean>());
                    }

                    organizationTreeModel.getOrgModelList().add(orgBean);
                    organizationTreeModel.getOrgList().remove(orgBean);

                } else {
                    organizationTreeModel.setOrgBean(orgBean);
                    this.getParentNode(organizationTreeModel);
                }

            }
        }

        /* 부서 모델에서 루트 ROOT KEY 삭제 */
        //organizationTreeModel.getOrgModelList().remove(bean);
        /* 초기화 */
        organizationTreeModel.setOrgBean(null);

        return organizationTreeModel.getOrgModelList();
    }

    public OrganizationTreeModel getParentNode(OrganizationTreeModel organizationTreeModel) {

        Integer treeLength = organizationTreeModel.getTreeLength();

        List<OrganizationBean> syncOrgList = null;
        if (organizationTreeModel.getOrgModelList() != null) {
            syncOrgList = copyOrgListFunc(organizationTreeModel.getOrgModelList());
        } else {
            organizationTreeModel.setOrgModelList(new ArrayList<OrganizationBean>());
            syncOrgList = new ArrayList<>();
        }

        for (OrganizationBean orgBean : syncOrgList) {

            if (orgBean.getOrgId().equals(organizationTreeModel.getOrgBean().getUpOrgId())) {

                organizationTreeModel.getOrgModelList().add(organizationTreeModel.getOrgBean());
                organizationTreeModel.getOrgList().remove(organizationTreeModel.getOrgBean());
                Collections.sort(syncOrgList, new NoAscCompare());

                treeLength++;
            }

        }

        organizationTreeModel.setTreeLength(treeLength);
        return organizationTreeModel;
    }

    public static List<OrganizationBean> copyOrgListFunc(List<OrganizationBean> orgList) {

        List<OrganizationBean> list = new ArrayList<>();

        for(OrganizationBean bean : orgList) {
            list.add(bean);
        }
        return list;
    }

    @Override
    public ModelAndView findListOrganizationTree(Map<String, String> parameters) {
        List<OrganizationBean> organizationTreeList = organizationDao.findAllOrganizationTree(null);
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("organizationList", organizationTreeList);
        return modelAndView;
    }

    /**
     * 숫자 오름차순 정렬 : 부서 SortOrder 기준 사용
     * @author dhj
     */
    public static class NoAscCompare implements Comparator<OrganizationBean> {

        /**
         * 오름차순(ASC)
         */
        @Override
        public int compare(OrganizationBean arg0, OrganizationBean arg1) {
            return arg0.getDepth() < arg1.getDepth() ? -1 : arg0.getDepth() > arg1.getDepth() ? 1:0;
        }

    }

    class OrganizationTreeModel {

        List<OrganizationBean> orgModelList;
        List<OrganizationBean> orgList;
        OrganizationBean orgBean;

        Integer treeLength = 0;
        Integer loopLength = 0;

        public List<OrganizationBean> getOrgModelList() {
            return orgModelList;
        }

        public void setOrgModelList(List<OrganizationBean> orgModelList) {
            this.orgModelList = orgModelList;
        }

        public List<OrganizationBean> getOrgList() {
            return orgList;
        }

        public void setOrgList(List<OrganizationBean> orgList) {
            this.orgList = orgList;
        }

        public OrganizationBean getOrgBean() {
            return orgBean;
        }

        public void setOrgBean(OrganizationBean orgBean) {
            this.orgBean = orgBean;
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
