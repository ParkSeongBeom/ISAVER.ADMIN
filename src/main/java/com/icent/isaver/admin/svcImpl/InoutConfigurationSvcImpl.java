package com.icent.isaver.admin.svcImpl;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.icent.isaver.admin.bean.InoutConfigurationBean;
import com.icent.isaver.admin.common.resource.IsaverException;
import com.icent.isaver.admin.dao.InoutConfigurationDao;
import com.icent.isaver.admin.resource.ResultState;
import com.icent.isaver.admin.svc.InoutConfigurationSvc;
import com.icent.isaver.admin.util.AlarmRequestUtil;
import com.icent.isaver.admin.util.MqttUtil;
import com.meous.common.resource.CommonResource;
import com.meous.common.spring.TransactionUtil;
import com.meous.common.util.ListUtils;
import com.meous.common.util.StringUtils;
import org.springframework.beans.factory.annotation.Value;
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
    @Resource(name="isaverTxManager")
    private DataSourceTransactionManager transactionManager;

    @Value("${ws.server.domain}")
    private String wsDomain = null;

    @Value("${ws.server.port}")
    private String wsPort = null;

    @Value("${ws.server.projectName}")
    private String wsProjectName = null;

    @Value("${ws.server.urlSendEvent}")
    private String wsUrlSendEvent = null;

    @Value("${socketMode}")
    private String socketMode = null;

    @Inject
    private MqttUtil mqttUtil;

    @Inject
    private InoutConfigurationDao inoutConfigurationDao;

    @Override
    public ModelAndView findListInoutConfiguration(Map<String, String> parameters) {
        List<InoutConfigurationBean> inoutConfigurationBeanList = inoutConfigurationDao.findListInoutConfiguration(parameters);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("inoutConfigList", inoutConfigurationBeanList);
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
                throw new IsaverException("");
            }
        }

        Map websocketParam = new HashMap();
        websocketParam.put("messageType","refreshBlinker");
        websocketParam.put("areaId", parameters.get("areaId"));

        /**
         * = 웹소켓 서버로 알림 전송
         * @author psb
         * @date 2016.12.15
         */
        try {
            if(socketMode.equals("mqtt")){
                ObjectMapper mapper = new ObjectMapper();
                mqttUtil.publish("eventAlarm",mapper.writeValueAsString(websocketParam),0);
            }else {
                AlarmRequestUtil.sendAlarmRequestFunc(websocketParam, "http://" + wsDomain + ":" + wsPort + "/" + wsProjectName + wsUrlSendEvent, "form", "jsonData");
            }
        } catch (Exception e) {
            throw new IsaverException(ResultState.ERROR_SEND_REQUEST,e.getMessage());
        }
        return new ModelAndView();
    }
}
