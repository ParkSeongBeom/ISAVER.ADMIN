package main.java.com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.common.resource.IsaverException;
import com.icent.isaver.admin.svc.RoleMenuSvc;
import com.icent.isaver.admin.bean.MenuBean;
import com.icent.isaver.admin.bean.RoleMenuBean;
import com.icent.isaver.admin.dao.MenuDao;
import com.icent.isaver.admin.dao.RoleDao;
import com.icent.isaver.admin.dao.RoleMenuDao;
import com.kst.common.spring.TransactionUtil;
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
 * 메뉴권한 Service Implements
 *
 * @author : psb
 * @version : 1.0
 * @since : 2016. 06. 08.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2016. 06. 08.     psb           최초 생성
 * </pre>
 */
@Service
public class RoleMenuSvcImpl implements RoleMenuSvc {

    @Resource(name="isaverTxManager")
    private DataSourceTransactionManager transactionManager;

    @Inject
    private RoleDao roleDao;

    @Inject
    private RoleMenuDao roleMenuDao;

    @Inject
    private MenuDao menuDao;

    @Override
    public ModelAndView findAllRoleMenu(Map<String, String> parameters) {
        if(StringUtils.nullCheck(parameters.get("roleId"))){
            parameters.put("roleId","ROL000");
        }

        List<RoleMenuBean> unregiMenuList = roleMenuDao.findUnregiRoleMenu(parameters);
        List<RoleMenuBean> regiMenuList = roleMenuDao.findRegiRoleMenu(parameters);
        List<MenuBean> menuTreeList = menuDao.findRoleMenuTree(parameters);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("roles",roleDao.findListRole(null));
        modelAndView.addObject("unregiMenuList",unregiMenuList);
        modelAndView.addObject("regiMenuList",regiMenuList);
        modelAndView.addObject("paramBean",parameters);
        modelAndView.addObject("menuTreeList", menuTreeList);

        return modelAndView;
    }

    @Override
    public ModelAndView saveRoleMenu(Map<String, String> parameters) {
        List<RoleMenuBean> roleMenuBeans = convertToMenuRoleListBean(parameters);

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try{
            roleMenuDao.removeRoleMenu(parameters);
            if(roleMenuBeans.size()>0){
                roleMenuDao.addListRoleMenu(roleMenuBeans);
            }
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
     * @param parameters
     * @return
     */
    private List<RoleMenuBean> convertToMenuRoleListBean(Map<String, String> parameters) {
        List<RoleMenuBean> lists = new ArrayList<RoleMenuBean>();
        String roleId = parameters.get("roleId");
        String userId = parameters.get("insertUserId");

        if (parameters.get("menuIds").trim().length() > 0) {

            String[] arrSplit = parameters.get("menuIds").split(",");

            for(String menuId: arrSplit) {
                RoleMenuBean bean = new RoleMenuBean();
                bean.setRoleId(roleId);
                bean.setMenuId(menuId);
                bean.setInsertUserId(userId);
                lists.add(bean);
            }
        }
        return lists;
    }
}
