package com.icent.jabber.admin.svcImpl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.resource.AdminResource;
import com.icent.jabber.admin.svc.MonitorProcessSvc;
import com.icent.jabber.admin.util.AdminHelper;
import com.icent.jabber.admin.util.MonitorHelper;
import com.icent.jabber.repository.bean.MonitorBean;
import com.icent.jabber.repository.bean.MonitorProcessBean;
import com.icent.jabber.repository.dao.base.MonitorDao;
import com.icent.jabber.repository.dao.base.MonitorProcessDao;
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
 * 모니터링 프로세스 Service
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
public class MonitorProcessSvcImpl implements MonitorProcessSvc {

    @Inject
    private MonitorProcessDao monitorProcessDao;

    @Inject
    private MonitorDao monitorDao;

    @Inject
    private MonitorHelper monitorHelper;

    @Resource(name="mybatisBaseTxManager")
    private DataSourceTransactionManager transactionManager;

    @Override
    public ModelAndView findAllProcess(Map<String, String> parameters) {
        List<MonitorProcessBean> monitorProcesses = monitorProcessDao.findListMonitorProcess(parameters);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("monitorProcesses",monitorProcesses);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView findByProcess(Map<String, String> parameters) {
        MonitorProcessBean monitorProcessBean = null;

        if(StringUtils.notNullCheck(parameters.get("processId"))) {
            monitorProcessBean = monitorProcessDao.findByMonitorProcess(parameters);
        }

        Map<String, String> monitorParam = new HashMap<>();
        monitorParam.put("useYn", AdminResource.YES);
        List<MonitorBean> monitoringList = monitorDao.findListMonitor(monitorParam);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("monitorProcess",monitorProcessBean);
        modelAndView.addObject("monitoringList",monitoringList);
        return modelAndView;
    }

    @Override
    public ModelAndView addMonitorProcess(Map<String, String> parameters) {
        MonitorProcessBean paramBean = AdminHelper.convertMapToBean(parameters, MonitorProcessBean.class);
        paramBean.setProcessId(StringUtils.getGUID36());

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try {
            monitorProcessDao.addMonitorProcess(paramBean);
            transactionManager.commit(transactionStatus);
        } catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }
        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView saveMonitorProcess(Map<String, String> parameters) {
        MonitorProcessBean paramBean = AdminHelper.convertMapToBean(parameters, MonitorProcessBean.class);

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try {
            monitorProcessDao.saveMonitorProcess(paramBean);
            transactionManager.commit(transactionStatus);
        } catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }
        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView removeMonitorProcess(Map<String, String> parameters) {
        MonitorProcessBean paramBean = AdminHelper.convertMapToBean(parameters, MonitorProcessBean.class);

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try {
            monitorProcessDao.removeMonitorProcess(paramBean);
            transactionManager.commit(transactionStatus);
        } catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView findListMonitorProcess(Map<String, String> parameters) {
        parameters.put("useYn",AdminResource.YES);
        List<MonitorProcessBean> monitorProcesses = monitorProcessDao.findListMonitorProcess(parameters);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("monitorProcesses", monitorProcesses);
        return modelAndView;
    }

    /**
     * 리눅스 프로세스 상태
     * @author psb
     */
    @Override
    public ModelAndView findByMonitorProcess(Map<String, String> parameters){
        parameters.put("useYn",AdminResource.YES);
        MonitorBean monitor = monitorDao.findByMonitor(parameters);

        Map<String, String> resultMap = new HashMap<>();
        resultMap.put("reachable", "failure");

        try{
            boolean reachable = monitorHelper.pingTest(monitor.getIp());

            if(reachable){
                MonitorProcessBean monitoringProcess = monitorProcessDao.findByMonitorProcess(parameters);

//                String statusCommand = "ps -C java -o pcpu,pmem,cmd | grep " + monitoringProcess.getServiceName() + " | awk '{print \"cpu|\"$1\"%,memory|\"$2\"%\"}';";
                String statusCommand = "ps -C java -o pcpu,rss,cmd | grep " + monitoringProcess.getServiceName() + " | awk '{print \"cpu|\"$1\"%,memory|\"int($2/1024)\"M\"}';";

                Map<String, String> monitorMap = monitorHelper.excuteCommand(monitor.getIp(),monitor.getId(),monitor.getPassword(), statusCommand);

                if(StringUtils.notNullCheck(monitorMap.get("result"))){
                    String[] commandResult = monitorMap.get("result").split(",");

                    resultMap.put("reachable", "on");

                    for(int k=0; k<commandResult.length; k++){
                        String[] result = commandResult[k].split("\\|");
                        resultMap.put(result[0], result[1]);
                    }
                }else{
                    resultMap.put("reachable", "off");
                }
            }
        }catch(Exception e){
            e.printStackTrace();
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("processId", parameters.get("processId"));
        modelAndView.addObject("resultMap", resultMap);
        return modelAndView;
    }
}
