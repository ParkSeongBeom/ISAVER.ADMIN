package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.common.resource.IcentException;
import com.icent.isaver.admin.resource.AdminResource;
import com.icent.isaver.admin.svc.AlarmSvc;
import com.icent.isaver.admin.util.AdminHelper;
import com.icent.isaver.repository.bean.AlarmBean;
import com.icent.isaver.repository.bean.AlarmInfoBean;
import com.icent.isaver.repository.bean.DeviceBean;
import com.icent.isaver.repository.bean.FileBean;
import com.icent.isaver.repository.dao.base.AlarmDao;
import com.icent.isaver.repository.dao.base.AlarmInfoDao;
import com.icent.isaver.repository.dao.base.DeviceDao;
import com.icent.isaver.repository.dao.base.FileDao;
import com.kst.common.spring.TransactionUtil;
import com.kst.common.util.StringUtils;
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
 * 장치 동기화 요청 Service implements
 * @author : psb
 * @version : 1.0
 * @since : 2016. 10. 24.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2016. 10. 24.     psb           최초 생성
 * </pre>
 */
@Service
public class AlarmSvcImpl implements AlarmSvc {

    @Inject
    private AlarmDao alarmDao;

    @Inject
    private AlarmInfoDao alarmInfoDao;

    @Inject
    private DeviceDao deviceDao;

    @Inject
    private FileDao fileDao;

    @Resource(name="isaverTxManager")
    private DataSourceTransactionManager transactionManager;

    @Override
    public ModelAndView findListAlarm(Map<String, String> parameters) {
        List<AlarmBean> alarmList = alarmDao.findListAlarm(parameters);
        Integer totalCount = alarmDao.findCountAlarm(parameters);

        AdminHelper.setPageTotalCount(parameters, totalCount);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("alarmList", alarmList);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView findByAlarm(Map<String, String> parameters) {
        AlarmBean alarm = alarmDao.findByAlarm(parameters);

        Map<String, String> alarmInfoParam = new HashMap<>();
        alarmInfoParam.put("alarmId",parameters.get("alarmId"));
        alarmInfoParam.put("dashboardTargetId",AdminResource.ALARM_TARGET_ID);
        List<AlarmInfoBean> deviceAlarmInfos = alarmInfoDao.findListAlarmInfo(alarmInfoParam);

        List<DeviceBean> targetDevices = deviceDao.findListDevice(new HashMap<String,String>(){{put("deviceTypeCode", AdminResource.DEVICE_TYPE_CODE.get("target"));}});
        List<DeviceBean> alarmDevices = deviceDao.findListDevice(new HashMap<String,String>(){{put("deviceTypeCode", AdminResource.DEVICE_TYPE_CODE.get("alarm"));}});
        List<FileBean> files = fileDao.findListFile(new HashMap<String,String>(){{put("useYn", AdminResource.YES); put("fileType", AdminResource.FILE_TYPE.get("alarm"));}});

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("alarm", alarm);
        modelAndView.addObject("deviceAlarmInfos", deviceAlarmInfos);
        modelAndView.addObject("targetDevices", targetDevices);
        modelAndView.addObject("alarmDevices", alarmDevices);
        modelAndView.addObject("files", files);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView addAlarm(HttpServletRequest request, Map<String, String> parameters) {
        List<Map<String, String>> alarmInfoList = new ArrayList<>();
        String alarmId = StringUtils.getGUID32();
        String alarmInfo = parameters.get("alarmInfo");
        parameters.put("alarmId",alarmId);

        if (!alarmInfo.equals("") && alarmInfo != null) {
            String[] alarmInfos = alarmInfo.split(",");

            for (String info : alarmInfos) {
                String[] infos = info.split("\\|");
                String alarmInfoId = StringUtils.getGUID32();
                String targetId = infos[0];

                for(int i=1; i<infos.length; i++){
                    String[] datas = infos[i].split(":");
                    Map<String, String> alarmInfoMap = new HashMap<>();
                    alarmInfoMap.put("alarmInfoId", alarmInfoId);
                    alarmInfoMap.put("alarmId", alarmId);
                    alarmInfoMap.put("targetId", targetId);
                    alarmInfoMap.put("key", datas[0]);
                    if(datas.length==2){
                        alarmInfoMap.put("value", datas[1]);
                    }else{
                        alarmInfoMap.put("value", "");
                    }
                    alarmInfoList.add(alarmInfoMap);
                }
            }
        }else{
            alarmInfoList = null;
        }

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            alarmDao.addAlarm(parameters);
            if(alarmInfoList!=null){
                alarmInfoDao.addAlarmInfo(alarmInfoList);
            }
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new IcentException("");
        }
        return new ModelAndView();
    }

    @Override
    public ModelAndView saveAlarm(HttpServletRequest request, Map<String, String> parameters) {
        List<Map<String, String>> alarmInfoList = new ArrayList<>();
        String alarmInfo = parameters.get("alarmInfo");

        if (!alarmInfo.equals("") && alarmInfo != null) {
            String[] alarmInfos = alarmInfo.split(",");

            for (String info : alarmInfos) {
                String[] infos = info.split("\\|");
                String alarmInfoId = StringUtils.getGUID32();
                String targetId = infos[0];

                for(int i=1; i<infos.length; i++){
                    String[] datas = infos[i].split(":");
                    Map<String, String> alarmInfoMap = new HashMap<>();
                    alarmInfoMap.put("alarmInfoId", alarmInfoId);
                    alarmInfoMap.put("alarmId", parameters.get("alarmId"));
                    alarmInfoMap.put("targetId", targetId);
                    alarmInfoMap.put("key", datas[0]);
                    if(datas.length==2){
                        alarmInfoMap.put("value", datas[1]);
                    }else{
                        alarmInfoMap.put("value", "");
                    }
                    alarmInfoList.add(alarmInfoMap);
                }
            }
        }else{
            alarmInfoList = null;
        }

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            alarmInfoDao.removeAlarmInfo(parameters);
            alarmDao.saveAlarm(parameters);
            if(alarmInfoList!=null){
                alarmInfoDao.addAlarmInfo(alarmInfoList);
            }
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new IcentException("");
        }
        return new ModelAndView();
    }

    @Override
    public ModelAndView removeAlarm(HttpServletRequest request, Map<String, String> parameters) {
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            alarmInfoDao.removeAlarmInfo(parameters);
            alarmDao.removeAlarm(parameters);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new IcentException("");
        }
        return new ModelAndView();
    }
}
