package com.icent.jabber.admin.svcImpl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.resource.AdminResource;
import com.icent.jabber.admin.svc.ReservationSvc;
import com.icent.jabber.admin.util.AdminHelper;
import com.icent.jabber.repository.bean.*;
import com.icent.jabber.repository.dao.base.*;
import com.kst.common.springutil.TransactionUtil;
import com.kst.common.util.StringUtils;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionStatus;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 회의실예약 Service
 *
 * @author : psb
 * @version : 1.0
 * @since : 2015. 07. 07.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2015. 07. 07.     psb           최초 생성
 * </pre>
 */
@Service
public class ReservationSvcImpl implements ReservationSvc {

    @Inject
    private ReservationDao reservationDao;

    @Inject
    private EntryReservationDao entryReservationDao;

    @Inject
    private RepeatReservationDao repeatReservationDao;

    @Resource(name="mybatisBaseTxManager")
    private DataSourceTransactionManager transactionManager;

    @Override
    public ModelAndView findByReservation(Map<String, String> parameters) {
        ReservationBean reservation = reservationDao.findByReservation(parameters);
        List<EntryReservationBean> entryReservations = entryReservationDao.findListEntryReservation(parameters);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("reservation",reservation);
        modelAndView.addObject("entryReservations",entryReservations);
        return modelAndView;
    }

    @Override
    public ModelAndView removeReservation(Map<String, String> parameters) {
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        Integer resultFlag = 0;
//        Map<String, String> sendNoteParameters = new HashMap<>();

        try {
            parameters.put("cmd","DEL");
//            sendNoteParameters = sendNoteReservation(parameters);
            entryReservationDao.removeEntryReservation(parameters);
            repeatReservationDao.removeRepeatReservation(parameters);
            reservationDao.removeReservation(parameters);
            resultFlag = 200;
            transactionManager.commit(transactionStatus);
        } catch(DataAccessException e) {
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

//        transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
//        try{
//            if (resultFlag==200){
//                noteSvc.addNote(sendNoteParameters);
//                sendMailNotify(sendNoteParameters);
//            }
//            transactionManager.commit(transactionStatus);
//        } catch(Exception e) {
//            transactionManager.rollback(transactionStatus);
//            resultFlag=300;
//        }
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("resultFlag", resultFlag);
        return modelAndView;
    }
}
