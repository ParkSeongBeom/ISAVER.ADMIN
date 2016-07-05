package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.bean.JabberException;
import com.icent.isaver.admin.svc.InoutConfigurationSvc;
import com.icent.isaver.repository.bean.InoutConfigurationBean;
import com.icent.isaver.repository.dao.base.InoutConfigurationDao;
import com.kst.common.resource.CommonResource;
import com.kst.common.spring.TransactionUtil;
import com.kst.common.util.ListUtils;
import com.kst.common.util.MapUtils;
import com.kst.common.util.StringUtils;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionStatus;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.inject.Inject;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 접속 로그 관리 Service Implements
 *
 * @author : psb
 * @version : 1.0
 * @since : 2016. 06. 14.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2016. 06. 14.     psb           최초 생성
 * </pre>
 */
@Service
public class InoutConfigurationSvcImpl implements InoutConfigurationSvc {
    @Resource(name="mybatisIsaverTxManager")
    private DataSourceTransactionManager transactionManager;

    @Inject
    private InoutConfigurationDao inoutConfigurationDao;

    @Override
    public ModelAndView findListInoutConfiguration(Map<String, String> parameters) {
        List<InoutConfigurationBean> inoutConfigurationList = inoutConfigurationDao.findListInoutConfiguration(parameters);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("inoutConfigurationList",inoutConfigurationList);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView saveInoutConfiguration(Map<String, String> parameters) {
        String[] inoutDatetimes = parameters.get("inoutDatetimes").split(CommonResource.COMMA_STRING);
        List<Map<String, String>> parameterList = new ArrayList<>();
        for (String inoutDatetime : inoutDatetimes) {
            String[] datetime = inoutDatetime.split("\\|");
            Map<String, String> inoutConfigurationMap = new HashMap<>();
            inoutConfigurationMap.put("configId", StringUtils.getGUID32().substring(0,18));
            inoutConfigurationMap.put("userId", parameters.get("userId"));
            inoutConfigurationMap.put("areaId", parameters.get("areaId"));
            inoutConfigurationMap.put("inoutStarttime", datetime[0]);
            inoutConfigurationMap.put("inoutEndtime", datetime[1]);
            inoutConfigurationMap.put("insertUserId", parameters.get("userId"));
            parameterList.add(inoutConfigurationMap);
        }

        if(ListUtils.notNullCheck(parameterList)){
            TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
            try {
                inoutConfigurationDao.removeInoutConfigurationFromArea(parameters);
                inoutConfigurationDao.addInoutConfiguration(parameterList);
                transactionManager.commit(transactionStatus);
            }catch(DataAccessException e){
                transactionManager.rollback(transactionStatus);
                throw new JabberException("");
            }
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }
}
