package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.bean.JabberException;
import com.icent.isaver.admin.svc.MenuSvc;
import com.icent.isaver.admin.util.AdminHelper;
import com.icent.isaver.repository.bean.MenuBean;
import com.icent.isaver.repository.bean.RoleBean;
import com.icent.isaver.repository.dao.base.MenuDao;
import com.icent.isaver.repository.dao.base.RoleMenuDao;
import com.icent.isaver.repository.dao.base.RoleDao;
import com.icent.isaver.repository.bean.RoleMenuBean;
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
import java.util.HashMap;
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

    @Resource(name="mybatisIsaverTxManager")
    private DataSourceTransactionManager transactionManager;

    @Inject
    private MenuDao menuDao;

    @Inject
    private RoleMenuDao roleMenuDao;

    @Inject
    private RoleDao roleDao;

    @Override
    public ModelAndView findAllMenuTree(Map<String, String> parameters) {
        List<MenuBean> menuTreeList = menuDao.findAllMenuTree(parameters);
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("menuTreeList", menuTreeList);
        return modelAndView;
    }

    @Override
    public ModelAndView findAllMenuTopBar(Map<String, String> parameters) {
        List<MenuBean> menuBarList = menuDao.findAllMenuTopBar(parameters);
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("menuBarList", menuBarList);
        return modelAndView;
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
        MenuBean menu = null;
        List<RoleBean> roles = null;
        List<RoleMenuBean> roleMenus = null;
        if(StringUtils.notNullCheck(parameters.get("menuId"))){
            menu = menuDao.findByMenu(parameters);
            roles = roleDao.findListRole(parameters);
            roleMenus = roleMenuDao.findAllRoleMenu(parameters);
        }

        List<RoleBean> roleBeanList = new ArrayList<RoleBean>();
        for(RoleBean roleBean: roles) {
            if (roleMenus.size() == 0) {
                roleBean.setDelYn("Y");
            } else {
                for(RoleMenuBean roleMenuBean: roleMenus) {
                    if (roleBean.getRoleId().equals(roleMenuBean.getRoleId())) {
                        roleBean.setDelYn("N");
                        break;
                    } else {
                        roleBean.setDelYn("Y");
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
        MenuBean searchParentMenuDepthBean = menuDao.findByMenu(parameters);

        Map<String, String> paramBean = new HashMap<>();
        paramBean.put("menuId",StringUtils.getGUID36());
        paramBean.put("menuDepth",searchParentMenuDepthBean.getMenuDepth()+1);

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            menuDao.addMenu(paramBean);
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
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try{
            menuDao.saveMenu(parameters);
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
        List<MenuBean> menus = menuDao.findByMenuTreeChildNodes(parameters);
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try {
            roleMenuDao.removeListRoleMenuForTree(menus);
            menuDao.removeListMenuForTree(menus);
            transactionManager.commit(transactionStatus);
        } catch(DataAccessException e) {
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }
        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }
}
