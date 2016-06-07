package com.icent.jabber.admin.svcImpl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.resource.AdminResource;
import com.icent.jabber.admin.svc.MonitorSvc;
import com.icent.jabber.admin.util.AdminHelper;
import com.icent.jabber.admin.util.MonitorHelper;
import com.icent.jabber.repository.bean.MonitorBean;
import com.icent.jabber.repository.dao.base.MonitorDao;
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
 * 모니터링 Service
 * @author : psb
 * @version : 1.0
 * @since : 2015. 04. 07.
 * <pre>
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2015. 04. 07.     psb           최초 생성
 * </pre>
 */
@Service
public class MonitorSvcImpl implements MonitorSvc {

    @Inject
    private MonitorDao monitorDao;

    @Inject
    private MonitorHelper monitorHelper;

    @Resource(name="mybatisBaseTxManager")
    private DataSourceTransactionManager transactionManager;

    @Override
    public ModelAndView findAllMonitor(Map<String, String> parameters) {
        List<MonitorBean> monitors = monitorDao.findListMonitor(parameters);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("monitors",monitors);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView findByMonitor(Map<String, String> parameters) {
        MonitorBean monitorBean = null;

        if(StringUtils.notNullCheck(parameters.get("monitorId"))) {
            monitorBean = monitorDao.findByMonitor(parameters);
        }

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("monitor",monitorBean);
        return modelAndView;
    }

    @Override
    public ModelAndView addMonitor(Map<String, String> parameters) {
        MonitorBean paramBean = AdminHelper.convertMapToBean(parameters, MonitorBean.class);
        paramBean.setMonitorId(StringUtils.getGUID36());

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try {
            monitorDao.addMonitor(paramBean);
            transactionManager.commit(transactionStatus);
        } catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }
        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView saveMonitor(Map<String, String> parameters) {
        MonitorBean paramBean = AdminHelper.convertMapToBean(parameters, MonitorBean.class);

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try {
            monitorDao.saveMonitor(paramBean);
            transactionManager.commit(transactionStatus);
        } catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }
        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView removeMonitor(Map<String, String> parameters) {
        MonitorBean paramBean = AdminHelper.convertMapToBean(parameters, MonitorBean.class);

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try {
            monitorDao.removeMonitor(paramBean);
            transactionManager.commit(transactionStatus);
        } catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView findListMonitorServer(Map<String, String> parameters) {
        parameters.put("useYn", AdminResource.YES);
        List<MonitorBean> monitors = monitorDao.findListMonitor(parameters);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("monitors", monitors);
        return modelAndView;
    }

    /**
     * 리눅스 서버 사용률
     * @author psb
     */
    @Override
    public ModelAndView findByMonitorServer(Map<String, String> parameters){
        parameters.put("useYn", AdminResource.YES);
        MonitorBean monitor = monitorDao.findByMonitor(parameters);
        Map<String, String> resultMap = new HashMap<>();

        try{
            boolean reachable = monitorHelper.pingTest(monitor.getIp());
            resultMap.put("reachable", reachable?"on":"off");

            if(reachable){
                String command = "mpstat | tail -1 | awk '{if ($12>0) cpu=$12; else cpu=$11} END {print \"cpu|\"100-cpu\"%\"}';"
                        + "free -m | grep -i ^Mem | awk '{print \"memory|\" $3 \"m / \" $2 \"m\"}';"
                        + "df -hP | sed -n '2p' | awk '{print \"storage|\" $3 \" / \" $2}';";

                Map<String, String> monitorMap = monitorHelper.excuteCommand(monitor.getIp(),monitor.getId(),monitor.getPassword(), command);

                if(StringUtils.notNullCheck(monitorMap.get("resultFlag")) && monitorMap.get("resultFlag").equals("false")){
                    resultMap.put("reachable", "failure");
                }

                if(StringUtils.notNullCheck(monitorMap.get("result"))){
                    String[] commandResult = monitorMap.get("result").split(",");

                    for(int k=0; k<commandResult.length; k++){
                        String[] result = commandResult[k].split("\\|");
                        resultMap.put(result[0], result[1]);
                    }
                }
            }
        }catch(Exception e){
            e.printStackTrace();
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("monitorId", parameters.get("monitorId"));
        modelAndView.addObject("resultMap", resultMap);
        return modelAndView;
    }
}
