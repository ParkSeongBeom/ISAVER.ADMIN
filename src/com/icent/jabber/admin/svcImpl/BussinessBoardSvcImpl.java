package com.icent.jabber.admin.svcImpl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.svc.BussinessBoardSvc;
import com.icent.jabber.admin.util.AdminHelper;
import com.icent.jabber.repository.bean.*;
import com.icent.jabber.repository.dao.base.BussinessBoardDao;
import com.icent.jabber.repository.dao.base.BussinessInfoDao;
import com.icent.jabber.repository.dao.base.CalendarDao;
import com.kst.common.bean.CommonResourceBean;
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
@Service
public class BussinessBoardSvcImpl implements BussinessBoardSvc {

    @Resource(name = "mybatisBaseTxManager")
    private DataSourceTransactionManager transactionManager;

    @Inject
    private BussinessBoardDao bussinessBoardDao;

    @Inject
    private BussinessInfoDao bussinessInfoDao;

    @Inject
    private CalendarDao calendarDao;

    @Override
    public ModelAndView findListBussinessBoard(Map<String, String> parameters) {
        FindBean paramBean = AdminHelper.convertMapToBean(parameters, FindBean.class);

        List<BussinessBoardBean> bussinessBoardList = bussinessBoardDao.findListBussinessBoard(paramBean);
        List<CalendarBean> calendars = calendarDao.findAllCalendar(paramBean);

        if(parameters.get("viewType").equals("listView")){
            Integer totalCount = bussinessBoardDao.findCountBussinessBoard(paramBean);
            AdminHelper.setPageTotalCount(parameters, totalCount);
        }

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("bussinessBoardList", bussinessBoardList);
        modelAndView.addObject("calendars", calendars);
        modelAndView.addObject("paramBean", parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView findByBussinessBoard(Map<String, String> parameters) {
        FindBean paramBean = AdminHelper.convertMapToBean(parameters, FindBean.class);

        BussinessBoardBean bussinessBoard = bussinessBoardDao.findByBussinessBoard(paramBean);
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("bussinessBoard", bussinessBoard);
        return modelAndView;
    }

    @Override
    public ModelAndView addBussinessBoard(Map<String, String> parameters) {
        BussinessBoardBean bussinessBoard = AdminHelper.convertMapToBean(parameters, BussinessBoardBean.class, CommonResourceBean.PATTERN_DATETIME);

        String id = StringUtils.getGUID36();
        bussinessBoard.setBussinessId(id);
        List<BussinessInfoBean> infoBeans = makeBussinessInfoList(id, parameters);

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try {
            bussinessBoardDao.addBussinessBoard(bussinessBoard);
            bussinessInfoDao.addBussinessInfoForList(infoBeans);
            transactionManager.commit(transactionStatus);
        } catch (DataAccessException e) {
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView saveBussinessBoard(Map<String, String> parameters) {
        BussinessBoardBean bussinessBoard = AdminHelper.convertMapToBean(parameters, BussinessBoardBean.class, CommonResourceBean.PATTERN_DATETIME);

        List<BussinessInfoBean> infoBeans = makeBussinessInfoList(parameters.get("bussinessId"), parameters);

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try {
            bussinessInfoDao.removeBussinessInfoForAll(new BussinessInfoBean(parameters.get("bussinessId")));
            bussinessBoardDao.saveBussinessBoard(bussinessBoard);
            bussinessInfoDao.addBussinessInfoForList(infoBeans);
            transactionManager.commit(transactionStatus);
        } catch (DataAccessException e) {
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView removeBussinessBoard(Map<String, String> parameters) {
        BussinessBoardBean bussinessBoard = AdminHelper.convertMapToBean(parameters, BussinessBoardBean.class, CommonResourceBean.PATTERN_DATETIME);

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try {
            bussinessBoardDao.removeBussinessBoard(bussinessBoard);
            transactionManager.commit(transactionStatus);
        } catch (DataAccessException e) {
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    private List<BussinessInfoBean> makeBussinessInfoList(String id, Map<String, String> parameters) {
        List<BussinessInfoBean> infoBeans = new ArrayList<>();
        if (StringUtils.notNullCheck(parameters.get("keys")) && StringUtils.notNullCheck(parameters.get("values"))
                && parameters.get("keys").split(CommonResourceBean.SPLIT_STRING).length == parameters.get("values").split(CommonResourceBean.SPLIT_STRING).length) {
            String[] keys = parameters.get("keys").split(CommonResourceBean.SPLIT_STRING);
            String[] values = parameters.get("values").split(CommonResourceBean.SPLIT_STRING);

            for (int index = 0; index < keys.length; index++) {
                infoBeans.add(new BussinessInfoBean(id, keys[index], values[index]));
            }
        }
        return infoBeans;
    }
}
