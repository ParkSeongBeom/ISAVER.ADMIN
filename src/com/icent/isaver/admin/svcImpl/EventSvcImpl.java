package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.svc.EventSvc;
import com.icent.isaver.repository.bean.EventBean;
import com.icent.isaver.repository.dao.base.EventActionDao;
import com.icent.isaver.repository.dao.base.EventDao;
import com.icent.isaver.admin.bean.JabberException;
import com.icent.isaver.admin.util.AdminHelper;
import com.kst.common.springutil.TransactionUtil;
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
 * 이벤트 Service Implements
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
public class EventSvcImpl implements EventSvc {

    @Resource(name="mybatisIsaverTxManager")
    private DataSourceTransactionManager transactionManager;

    @Inject
    private EventDao eventDao;

    @Inject
    private EventActionDao eventActionDao;

    @Override
    public ModelAndView findListEvent(Map<String, String> parameters) {
        List<EventBean> events = eventDao.findListEvent(parameters);
        Integer totalCount = eventDao.findCountEvent(parameters);

        AdminHelper.setPageTotalCount(parameters, totalCount);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("events", events);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView findByEvent(Map<String, String> parameters) {

        ModelAndView modelAndView = new ModelAndView();

        EventBean event = eventDao.findByEvent(parameters);
        modelAndView.addObject("event", event);
        return modelAndView;
    }

    @Override
    public ModelAndView addEvent(HttpServletRequest request, Map<String, String> parameters) {

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try {
            eventDao.addEvent(parameters);
            if (parameters.get("actionId") != null) {
                eventActionDao.removeEventAction(parameters);
                eventActionDao.addEventAction(parameters);
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
    public ModelAndView saveEvent(HttpServletRequest request, Map<String, String> parameters) {

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try {

            eventDao.saveEvent(parameters);
            if (parameters.get("actionId") != null) {
                eventActionDao.removeEventAction(parameters);
                eventActionDao.addEventAction(parameters);
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
    public ModelAndView removeEvent(Map<String, String> parameters) {

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{

            if (parameters.get("actionId") != null) {
                eventActionDao.removeEventAction(parameters);
            }
            eventDao.removeEvent(parameters);

            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }


}
