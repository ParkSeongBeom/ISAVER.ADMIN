package com.icent.jabber.admin.svcImpl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.resource.AdminResource;
import com.icent.jabber.admin.svc.CalendarSvc;
import com.icent.jabber.admin.util.AdminHelper;
import com.icent.jabber.repository.bean.*;
import com.icent.jabber.repository.dao.base.AssetsDao;
import com.icent.jabber.repository.dao.base.CodeDao;
import com.icent.jabber.repository.dao.base.CalendarDao;
import com.icent.jabber.repository.dao.base.ReservationDao;
import com.kst.common.springutil.TransactionUtil;
import com.kst.common.util.StringUtils;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionStatus;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.inject.Inject;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 일정 관리 Service
 * @author : psb
 * @version : 1.0
 * @since : 2014. 11. 27.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 11. 27.     psb           최초 생성
 * </pre>
 */
@Service
public class CalendarSvcImpl implements CalendarSvc {

    @Inject
    private CalendarDao calendarDao;

    @Inject
    private ReservationDao reservationDao;

    @Inject
    private CodeDao codeDao;

    @Inject
    private AssetsDao assetsDao;

    @Resource(name="mybatisBaseTxManager")
    private DataSourceTransactionManager transactionManager;

    @Override
    public ModelAndView findCalendarView(Map<String, String> parameters) {
        FindBean paramBean = AdminHelper.convertMapToBean(parameters, FindBean.class);

        List<ReservationBean> reservations = reservationDao.findListReservation(paramBean);
        List<CalendarBean> calendars = calendarDao.findAllCalendar(paramBean);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("reservations", reservations);
        modelAndView.addObject("calendars", calendars);
        modelAndView.addObject("paramBean", parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView findListView(Map<String, String> parameters) {
        FindBean codeParam = new FindBean();
        codeParam.setId("0001");
        List<AssetsBean> assetses = assetsDao.findListAssets(codeParam);

        List<CalendarBean> Calendars = calendarDao.findListCalendar(parameters);
        Integer totalCount = calendarDao.findCountCalendar(parameters);

        AdminHelper.setPageTotalCount(parameters, totalCount);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("assetses",assetses);
        modelAndView.addObject("calendars",Calendars);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView findByCalendar(Map<String, String> parameters) {
        CalendarBean paramBean = AdminHelper.convertMapToBean(parameters, CalendarBean.class);

        CalendarBean calendarBean = null;

        if(StringUtils.notNullCheck(paramBean.getCalendarId())) {
            calendarBean = calendarDao.findByCalendar(paramBean);
        }

        FindBean codeParamBean = new FindBean();
        codeParamBean.setId("CAL001");
        codeParamBean.setUseYn(AdminResource.YES);
        List<CodeBean> headers = codeDao.findListCode(codeParamBean);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("calendar",calendarBean);
        modelAndView.addObject("headers",headers);
        return modelAndView;
    }

    @Override
    public ModelAndView addCalendar(Map<String, String> parameters) {
        CalendarBean paramBean = AdminHelper.convertMapToBean(parameters, CalendarBean.class, "yyyy-MM-dd");
        paramBean.setCalendarId(StringUtils.getGUID36());

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try {
            calendarDao.addCalendar(paramBean);
            transactionManager.commit(transactionStatus);
        } catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }
        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView saveCalendar(Map<String, String> parameters) {
        CalendarBean paramBean = AdminHelper.convertMapToBean(parameters, CalendarBean.class, "yyyy-MM-dd");
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try {

            calendarDao.saveCalendar(paramBean);
            transactionManager.commit(transactionStatus);
        } catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);

            throw new JabberException("");
        }
        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView removeCalendar(Map<String, String> parameters) {

        CalendarBean paramBean = AdminHelper.convertMapToBean(parameters, CalendarBean.class, "yyyy-MM-dd HH:mm:ss");
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try {
            calendarDao.removeCalendar(paramBean);
            transactionManager.commit(transactionStatus);
        } catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }
}
