package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.common.resource.IcentException;
import com.icent.isaver.admin.resource.AdminResource;
import com.icent.isaver.admin.svc.AlramSvc;
import com.icent.isaver.admin.util.AdminHelper;
import com.icent.isaver.repository.bean.AlramBean;
import com.icent.isaver.repository.bean.AlramInfoBean;
import com.icent.isaver.repository.bean.DeviceBean;
import com.icent.isaver.repository.bean.FileBean;
import com.icent.isaver.repository.dao.base.AlramDao;
import com.icent.isaver.repository.dao.base.AlramInfoDao;
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
public class AlramSvcImpl implements AlramSvc {

    @Inject
    private AlramDao alramDao;

    @Inject
    private AlramInfoDao alramInfoDao;

    @Inject
    private DeviceDao deviceDao;

    @Inject
    private FileDao fileDao;

    @Resource(name="isaverTxManager")
    private DataSourceTransactionManager transactionManager;

    @Override
    public ModelAndView findListAlram(Map<String, String> parameters) {
        List<AlramBean> alramList = alramDao.findListAlram(parameters);
        Integer totalCount = alramDao.findCountAlram(parameters);

        AdminHelper.setPageTotalCount(parameters, totalCount);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("alramList", alramList);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView findByAlram(Map<String, String> parameters) {
        AlramBean alram = alramDao.findByAlram(parameters);

        Map<String, String> alramInfoParam = new HashMap<>();
        alramInfoParam.put("alramId",parameters.get("alramId"));
        alramInfoParam.put("targetType",AdminResource.ALRAM_TARGET_TYPE[0]);
        List<AlramInfoBean> dashboardAlramInfos = alramInfoDao.findListAlramInfo(alramInfoParam);
        alramInfoParam.put("targetType",AdminResource.ALRAM_TARGET_TYPE[1]);
        List<AlramInfoBean> deviceAlramInfos = alramInfoDao.findListAlramInfo(alramInfoParam);

        List<DeviceBean> devices = deviceDao.findListDevice(null);
        List<FileBean> files = fileDao.findListFile(new HashMap<String,String>(){{put("useYn", AdminResource.YES);}});

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("alram", alram);
        modelAndView.addObject("dashboardAlramInfos", dashboardAlramInfos);
        modelAndView.addObject("deviceAlramInfos", deviceAlramInfos);
        modelAndView.addObject("devices", devices);
        modelAndView.addObject("files", files);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView addAlram(HttpServletRequest request, Map<String, String> parameters) {
        List<Map<String, String>> alramInfoList = new ArrayList<>();
        String alramId = StringUtils.getGUID32();
        String alramInfo = parameters.get("alramInfo");
        parameters.put("alramId",alramId);

        if (!alramInfo.equals("") && alramInfo != null) {
            String[] alramInfos = alramInfo.split(",");

            for (String info : alramInfos) {
                String[] infos = info.split("\\|");
                String alramInfoId = StringUtils.getGUID32();

                for(String item : infos){
                    String[] datas = item.split(":");
                    Map<String, String> alramInfoMap = new HashMap<>();
                    alramInfoMap.put("alramInfoId", alramInfoId);
                    alramInfoMap.put("alramId", alramId);
                    alramInfoMap.put("key", datas[0]);
                    if(datas.length==2){
                        alramInfoMap.put("value", datas[1]);
                    }else{
                        alramInfoMap.put("value", "");
                    }
                    alramInfoList.add(alramInfoMap);
                }
            }
        }else{
            alramInfoList = null;
        }

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            alramDao.addAlram(parameters);
            if(alramInfoList!=null){
                alramInfoDao.addAlramInfo(alramInfoList);
            }
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new IcentException("");
        }
        return new ModelAndView();
    }

    @Override
    public ModelAndView saveAlram(HttpServletRequest request, Map<String, String> parameters) {
        List<Map<String, String>> alramInfoList = new ArrayList<>();
        String alramInfo = parameters.get("alramInfo");

        if (!alramInfo.equals("") && alramInfo != null) {
            String[] alramInfos = alramInfo.split(",");

            for (String info : alramInfos) {
                String[] infos = info.split("\\|");
                String alramInfoId = StringUtils.getGUID32();

                for(String item : infos){
                    String[] datas = item.split(":");

                    Map<String, String> alramInfoMap = new HashMap<>();
                    alramInfoMap.put("alramInfoId", alramInfoId);
                    alramInfoMap.put("alramId", parameters.get("alramId"));
                    alramInfoMap.put("key", datas[0]);
                    if(datas.length==2){
                        alramInfoMap.put("value", datas[1]);
                    }else{
                        alramInfoMap.put("value", "");
                    }
                    alramInfoList.add(alramInfoMap);
                }
            }
        }else{
            alramInfoList = null;
        }

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            alramInfoDao.removeAlramInfo(parameters);
            alramDao.saveAlram(parameters);
            if(alramInfoList!=null){
                alramInfoDao.addAlramInfo(alramInfoList);
            }
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new IcentException("");
        }
        return new ModelAndView();
    }

    @Override
    public ModelAndView removeAlram(HttpServletRequest request, Map<String, String> parameters) {
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            alramInfoDao.removeAlramInfo(parameters);
            alramDao.removeAlram(parameters);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new IcentException("");
        }
        return new ModelAndView();
    }
}
