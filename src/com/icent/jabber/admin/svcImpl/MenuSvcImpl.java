package com.icent.jabber.admin.svcImpl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.svc.MenuSvc;
import com.icent.jabber.admin.util.AdminHelper;
import com.icent.jabber.repository.bean.FindBean;
import com.icent.jabber.repository.bean.MenuBean;
import com.icent.jabber.repository.bean.MenuRoleBean;
import com.icent.jabber.repository.bean.RoleBean;
import com.icent.jabber.repository.dao.base.MenuDao;
import com.icent.jabber.repository.dao.base.MenuRoleDao;
import com.icent.jabber.repository.dao.base.RoleDao;
import com.kst.common.springutil.TransactionUtil;
import com.kst.common.util.StringUtils;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionStatus;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.inject.Inject;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 메뉴관리 Service Interface
 *
 * @author : dhj
 * @version : 1.0
 * @since : 2014. 5. 20.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 5. 20.     dhj           최초 생성
 *  2014. 6. 02.     kst           GUID 생성 변경
 * </pre>
 */
@Service("menuSvc")
public class MenuSvcImpl implements MenuSvc {

    @Resource(name="mybatisBaseTxManager")
    private DataSourceTransactionManager transactionManager;

    @Inject
    private MenuDao menuDao;

    @Inject
    private MenuRoleDao menuRoleDao;

    @Inject
    private RoleDao roleDao;

    @Override
    public ModelAndView findAllMenuTree(Map<String, String> parameters) {

        MenuBean paramBean = AdminHelper.convertMapToBean(parameters, MenuBean.class);

        List<MenuBean> menuTreeList = menuDao.findAllMenuTree(paramBean);
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("menuTreeList", menuTreeList);
        return modelAndView;
    }

    @Override
    public ModelAndView findAllMenuTopBar(Map<String, String> parameters) {

        FindBean paramBean = AdminHelper.convertMapToBean(parameters, FindBean.class);
        List<MenuBean> menuBarList = menuDao.findAllMenuTopBar(paramBean);
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("menuBarList", menuBarList);
        return modelAndView;
    }

    @Override
    public List<MenuBean> findAllMenuTreePath(MenuBean menuBean) {

        List<MenuBean> menuTreeList = null;

        if(StringUtils.notNullCheck(menuBean.getMenuId())){
            menuTreeList = menuDao.findAllMenuTree(menuBean);
        }
        return menuTreeList;
    }

    @Override
    public MenuBean findByMenuTree(MenuBean menuBean) {

        MenuBean resultBean = null;
        if(StringUtils.notNullCheck(menuBean.getMenuId())){
            resultBean = menuDao.findByMenuTree(menuBean);
        }
        return resultBean;
    }

    @Override
    public ModelAndView findByMenu(Map<String, String> parameters) {
        MenuBean paramBean = AdminHelper.convertMapToBean(parameters, MenuBean.class);

        MenuBean menu = null;
        List<RoleBean> roles = null;
        List<MenuRoleBean> menuRoles = null;
        FindBean findBean = new FindBean();
        findBean.setId(paramBean.getMenuId());
        if(StringUtils.notNullCheck(paramBean.getMenuId())){
            menu = menuDao.findByMenu(paramBean);
            roles = roleDao.findListRole(null);
            menuRoles = menuRoleDao.findAllMenuRole(findBean);
        }

        List<RoleBean> roleBeanList = new ArrayList<RoleBean>();
        for(RoleBean roleBean: roles) {
            if (menuRoles.size() == 0) {
                roleBean.setUseFlag("N");
            } else {
                for(MenuRoleBean menuRoleBean: menuRoles) {
                    if (roleBean.getRoleId().equals(menuRoleBean.getRoleId())) {
                        roleBean.setUseFlag("Y");
                        break;
                    } else {
                        roleBean.setUseFlag("N");
                    }
                }
            }
            roleBeanList.add(roleBean);
        }
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("menu",menu);
        modelAndView.addObject("roles",roleBeanList);
        //modelAndView.addObject("paramBean",paramBean);
        return modelAndView;
    }

    @Override
    public ModelAndView addMenu(Map<String, String> parameters) {

        MenuBean paramBean = AdminHelper.convertMapToBean(parameters, MenuBean.class);

        MenuBean searchParentMenuDepthBean = new MenuBean();

        searchParentMenuDepthBean.setMenuId(paramBean.getParentMenuId());
        searchParentMenuDepthBean = menuDao.findByMenu(searchParentMenuDepthBean);

        paramBean.setMenuId(StringUtils.getGUID36());
        paramBean.setMenuDepth(searchParentMenuDepthBean.getMenuDepth()+1);

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            menuDao.addMenu(paramBean);
            parameters.put("menuId", paramBean.getMenuId());
            List<MenuRoleBean> menuRoleBeans = convertToMenuRoleListBean(parameters);
            menuRoleDao.addListMenuRole(menuRoleBeans);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView saveMenu(Map<String, String> parameters) {
        MenuBean paramBean = AdminHelper.convertMapToBean(parameters, MenuBean.class);

        List<MenuRoleBean> menuRoleBeans = convertToMenuRoleListBean(parameters);

        FindBean findBean = new FindBean();
        findBean.setId(parameters.get("menuId"));

        List<MenuRoleBean> deleteRoleBeans = menuRoleDao.findAllMenuRole(findBean);
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try{

            menuDao.saveMenu(paramBean);
            menuRoleDao.removeListMenuRole(deleteRoleBeans);
            menuRoleDao.addListMenuRole(menuRoleBeans);

            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView removeMenu(Map<String, String> parameters) {
        MenuBean paramBean = AdminHelper.convertMapToBean(parameters, MenuBean.class);

        List<MenuBean> menus = menuDao.findByMenuTreeChildNodes(paramBean);
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try {
            menuRoleDao.removeListMenuRoleForTree(menus);
            menuDao.removeListMenuForTree(menus);
            transactionManager.commit(transactionStatus);
        } catch(DataAccessException e) {
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }
        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    /**
     *
     * @param parameters
     * @return
     */
    private List<MenuRoleBean> convertToMenuRoleListBean(Map<String, String> parameters) {
        List<MenuRoleBean> lists = new ArrayList<MenuRoleBean>();
        String menuId = parameters.get("menuId");

        String adminId = parameters.get("updateUserId");
        if (parameters.get("roleIds").trim().length() > 0) {

            String[] arrSplit = parameters.get("roleIds").split(",");

            for(String roleId: arrSplit) {
                MenuRoleBean bean = new MenuRoleBean();
                bean.setMenuRoleId(StringUtils.getGUID36());
                bean.setMenuId(menuId);
                bean.setRoleId(roleId);
                bean.setInsertUserId(adminId);
                lists.add(bean);
            }
        }

        return lists;
    }
}
