package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.bean.ActionBean;
import com.icent.isaver.admin.bean.DeviceBean;
import com.icent.isaver.admin.common.resource.IsaverException;
import com.icent.isaver.admin.dao.ActionDao;
import com.icent.isaver.admin.dao.DeviceDao;
import com.icent.isaver.admin.svc.ActionSvc;
import com.icent.isaver.admin.util.AdminHelper;
import com.kst.common.spring.TransactionUtil;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionStatus;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
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
 * </pe>
 */
@Service
public class ActionSvcImpl implements ActionSvc {

    @Resource(name="isaverTxManager")
    private DataSourceTransactionManager transactionManager;

    @Inject
    private ActionDao actionDao;

    @Inject
    private DeviceDao deviceDao;

    @Override
    public ModelAndView findListAction(Map<String, String> parameters) {
        List<ActionBean> areas = actionDao.findListAction(parameters);
        Integer totalCount = actionDao.findCountAction(parameters);

        AdminHelper.setPageTotalCount(parameters, totalCount);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("actions", areas);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView findByAction(Map<String, String> parameters) {

        ModelAndView modelAndView = new ModelAndView();

        ActionBean action = actionDao.findByAction(parameters);
        modelAndView.addObject("action", action);
        return modelAndView;
    }

    @Override
    public ModelAndView findByActionFromEventId(Map<String, String> parameters) {
        ActionBean action = actionDao.findByActionFromEventId(parameters);
        DeviceBean device = deviceDao.findByDevice(parameters);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("action", action);
        modelAndView.addObject("device", device);
        modelAndView.addObject("paramBean", parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView addAction(HttpServletRequest request, Map<String, String> parameters) {

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        Integer eventExistCount = actionDao.findByActionCheckExist(parameters);

        ModelAndView modelAndView = new ModelAndView();

        if (eventExistCount == 0) {
            try {
                parameters.put("actionId", generatorFunc());
                actionDao.addAction(parameters);
                transactionManager.commit(transactionStatus);
            }catch(DataAccessException e){
                transactionManager.rollback(transactionStatus);
                throw new IsaverException("");
            }
        } else {
            modelAndView.addObject("existFlag", "true");
        }


        return modelAndView;
    }

    @Override
    public ModelAndView saveAction(HttpServletRequest request, Map<String, String> parameters) {

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try {

            actionDao.saveAction(parameters);

            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new IsaverException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView removeAction(Map<String, String> parameters) {

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            actionDao.removeAction(parameters);
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

        Integer totalCount = actionDao.findCountGenerator();

        String id = "ACT";

        String suffix = String.format("%03d", totalCount);
        sb.append(id).append(suffix);
        return sb.toString();
    }

}
