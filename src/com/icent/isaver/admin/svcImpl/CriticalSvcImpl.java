package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.common.resource.IcentException;
import com.icent.isaver.admin.resource.AdminResource;
import com.icent.isaver.admin.svc.CriticalSvc;
import com.icent.isaver.admin.util.AdminHelper;
import com.icent.isaver.repository.bean.AlramBean;
import com.icent.isaver.repository.bean.CriticalBean;
import com.icent.isaver.repository.bean.CriticalInfoBean;
import com.icent.isaver.repository.bean.EventBean;
import com.icent.isaver.repository.dao.base.AlramDao;
import com.icent.isaver.repository.dao.base.CriticalDao;
import com.icent.isaver.repository.dao.base.CriticalInfoDao;
import com.icent.isaver.repository.dao.base.EventDao;
import com.kst.common.spring.TransactionUtil;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionStatus;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.HashMap;
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
public class CriticalSvcImpl implements CriticalSvc {

    @Resource(name="isaverTxManager")
    private DataSourceTransactionManager transactionManager;

    @Inject
    private CriticalDao criticalDao;

    @Inject
    private CriticalInfoDao criticalInfoDao;

    @Inject
    private EventDao eventDao;

    @Inject
    private AlramDao alramDao;

    @Override
    public ModelAndView findListCritical(Map<String, String> parameters) {
        List<CriticalBean> criticals = criticalDao.findListCritical(parameters);
        Integer totalCount = criticalDao.findCountCritical(parameters);

        AdminHelper.setPageTotalCount(parameters, totalCount);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("criticals", criticals);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView findByCritical(Map<String, String> parameters) {
        CriticalBean critical = criticalDao.findByCritical(parameters);
        List<CriticalInfoBean> criticalInfos = criticalInfoDao.findListCriticalInfo(parameters);

        List<EventBean> events = eventDao.findListNotInCriticalList(parameters);
        List<AlramBean> alramList = alramDao.findListAlram(new HashMap<String,String>(){{put("useYn", AdminResource.YES);}});

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("critical", critical);
        modelAndView.addObject("alramList", alramList);
        modelAndView.addObject("criticalInfos", criticalInfos);
        modelAndView.addObject("events", events);

        return modelAndView;
    }

    @Override
    public ModelAndView addCritical(HttpServletRequest request, Map<String, String> parameters) {
        String criticalInfo = parameters.get("criticalInfo");
        String rangeYn = parameters.get("rangeYn");

        List<CriticalInfoBean> criticalInfoList = new ArrayList<>();;

        if (!criticalInfo.equals("") && criticalInfo != null) {
            String[] criticalInfos = criticalInfo.split(",");

            for (String info : criticalInfos) {
                String[] infos = info.split("\\|");
                CriticalInfoBean criticalInfoBean = new CriticalInfoBean();
                criticalInfoBean.setEventId(parameters.get("eventId"));
                criticalInfoBean.setStartValue(Float.parseFloat(infos[0]));
                criticalInfoBean.setEndValue(Float.parseFloat(infos[1]));
                criticalInfoBean.setCriticalLevel(infos[2]);
                if(infos.length == 4){
                    criticalInfoBean.setAlramId(infos[3]);
                }
                criticalInfoList.add(criticalInfoBean);
            }
        }else{
            criticalInfoList = null;
        }

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try {
            criticalDao.addCritical(parameters);
            if(criticalInfoList!=null){
                criticalInfoDao.addCriticalInfo(criticalInfoList);
            }
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new IcentException("");
        }

        return new ModelAndView();
    }

    @Override
    public ModelAndView saveCritical(HttpServletRequest request, Map<String, String> parameters) {
        String criticalInfo = parameters.get("criticalInfo");
        String rangeYn = parameters.get("rangeYn");

        List<CriticalInfoBean> criticalInfoList = new ArrayList<>();

        if (!criticalInfo.equals("") && criticalInfo != null) {
            String[] criticalInfos = criticalInfo.split(",");

            for (String info : criticalInfos) {
                String[] infos = info.split("\\|");
                CriticalInfoBean criticalInfoBean = new CriticalInfoBean();
                criticalInfoBean.setEventId(parameters.get("eventId"));
                criticalInfoBean.setStartValue(Float.parseFloat(infos[0]));
                criticalInfoBean.setEndValue(Float.parseFloat(infos[1]));
                criticalInfoBean.setCriticalLevel(infos[2]);
                if(infos.length == 4){
                    criticalInfoBean.setAlramId(infos[3]);
                }
                criticalInfoList.add(criticalInfoBean);
            }
        }else{
            criticalInfoList = null;
        }

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try {
            criticalInfoDao.removeCriticalInfo(parameters);
            criticalDao.saveCritical(parameters);
            if(criticalInfoList!=null){
                criticalInfoDao.addCriticalInfo(criticalInfoList);
            }
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new IcentException("");
        }

        return new ModelAndView();
    }

    @Override
    public ModelAndView removeCritical(Map<String, String> parameters) {
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            criticalInfoDao.removeCriticalInfo(parameters);
            criticalDao.removeCritical(parameters);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new IcentException("");
        }
        return new ModelAndView();
    }

}
