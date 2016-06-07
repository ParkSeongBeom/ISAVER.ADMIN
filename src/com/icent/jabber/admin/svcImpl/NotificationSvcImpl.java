package com.icent.jabber.admin.svcImpl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.svc.NotificationSvc;
import com.icent.jabber.admin.util.AdminHelper;
import com.icent.jabber.repository.bean.*;
import com.icent.jabber.repository.dao.base.NotificationDao;
import com.kst.common.springutil.TransactionUtil;
import com.kst.common.util.StringUtils;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionStatus;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.inject.Inject;
import java.util.List;
import java.util.Map;

/**
 * 미리알림 관리 Service
 * @author : psb
 * @version : 1.0
 * @since : 2015. 02. 11.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2015. 02. 11.     psb           최초 생성
 * </pre>
 */

@Service
public class NotificationSvcImpl implements NotificationSvc {

    @Inject
    private NotificationDao notificationDao;

    @Resource(name="mybatisBaseTxManager")
    private DataSourceTransactionManager transactionManager;

    @Override
    public ModelAndView findAllNotification(Map<String, String> parameters) {
        List<NotificationBean> Notifications = notificationDao.findAllNotification();

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("notifications",Notifications);
        return modelAndView;
    }

    @Override
    public ModelAndView findByNotification(Map<String, String> parameters) {
        NotificationBean paramBean = AdminHelper.convertMapToBean(parameters, NotificationBean.class);

        NotificationBean notificationBean = null;

        if(StringUtils.notNullCheck(paramBean.getNotiId())) {
            notificationBean = notificationDao.findByNotification(paramBean);
        }

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("notification",notificationBean);
        return modelAndView;
    }

    @Override
    public ModelAndView saveNotification(Map<String, String> parameters) {
        NotificationBean paramBean = AdminHelper.convertMapToBean(parameters, NotificationBean.class, "yyyy-MM-dd HH:mm:ss");

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try {
            notificationDao.saveNotification(paramBean);
            transactionManager.commit(transactionStatus);
        } catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }
}
