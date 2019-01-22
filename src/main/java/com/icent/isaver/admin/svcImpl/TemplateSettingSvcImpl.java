package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.common.resource.IsaverException;
import com.icent.isaver.admin.common.util.TransactionUtil;
import com.icent.isaver.admin.resource.AdminResource;
import com.icent.isaver.admin.resource.ResultState;
import com.icent.isaver.admin.svc.TemplateSettingSvc;
import com.icent.isaver.admin.util.AlarmRequestUtil;
import com.icent.isaver.admin.bean.TemplateSettingBean;
import com.icent.isaver.admin.dao.TemplateSettingDao;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionStatus;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.inject.Inject;
import java.util.*;

/**
 * Dashboard Template 환경설정 Service Implements
 *
 * @author : psb
 * @version : 1.0
 * @since : 2018. 6. 12.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2018. 6. 12.     psb           최초 생성
 * </pre>
 */
@Service
public class TemplateSettingSvcImpl implements TemplateSettingSvc {

    @Resource(name="isaverTxManager")
    private DataSourceTransactionManager transactionManager;

    @Value("${ws.server.domain}")
    private String wsDomain = null;

    @Value("${ws.server.port}")
    private String wsPort = null;

    @Value("${ws.server.projectName}")
    private String wsProjectName = null;

    @Value("${ws.server.urlSendMap}")
    private String wsUrlSendMap = null;

    @Inject
    private TemplateSettingDao templateSettingDao;

    @Override
    public Map<String, String> findListTemplateSetting() {
        if(AdminResource.TEMPLATE_SETTING == null){
            setTemplateSetting();
        }
        return AdminResource.TEMPLATE_SETTING;
    }

    @Override
    public String findByTemplateSetting(String key) {
        if(AdminResource.TEMPLATE_SETTING == null){
            setTemplateSetting();
        }
        return AdminResource.TEMPLATE_SETTING.get(key);
    }

    @Override
    public ModelAndView saveTemplateSetting(Map<String, String> parameters) {
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        List<Map<String, String>> addParamList = new ArrayList<>();
        String[] paramData = parameters.get("paramData").split(AdminResource.COMMA_STRING);
        boolean guardViewModifyFlag = false;

        for (String data : paramData) {
            Map<String, String> addParam = new HashMap<>();
            String[] addData = data.split("\\|");
            addParam.put("settingId", addData[0]);
            if(addData.length > 1){
                addParam.put("value", addData[1]);
                if(addData[0].equals("safeGuardMapView") && !addData[1].equals(findByTemplateSetting("safeGuardMapView"))){
                    guardViewModifyFlag = true;
                }
            }
            addParamList.add(addParam);
        }

        try {
            templateSettingDao.upsertTemplateSetting(addParamList);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new IsaverException("");
        }
        setTemplateSetting();
        if(guardViewModifyFlag){
            sendGuardViewSetting();
        }
        return new ModelAndView();
    }

    private void setTemplateSetting(){
        Hashtable<String, String> templateSettingMap = new Hashtable<>();
        for(TemplateSettingBean templateSetting : templateSettingDao.findListTemplateSetting()){
            templateSettingMap.put(templateSetting.getSettingId(), templateSetting.getValue()!=null?templateSetting.getValue():"");
        }
        AdminResource.TEMPLATE_SETTING = templateSettingMap;
    }

    private void sendGuardViewSetting(){
        /**
         * = 웹소켓 서버로 설정 전송
         * @author psb
         * @date 2018.06.27
         */
        try {
            Map websocketParam = new HashMap();
            websocketParam.put("messageType","setMode");
            websocketParam.put("settingId","safeGuardMapView");
            websocketParam.put("value",findByTemplateSetting("safeGuardMapView"));
            AlarmRequestUtil.sendAlarmRequestFunc(websocketParam, "http://" + wsDomain + ":" + wsPort + "/" + wsProjectName + wsUrlSendMap, "form", null);
        } catch (Exception e) {
            throw new IsaverException(ResultState.ERROR_SEND_REQUEST,e.getMessage());
        }
    }
}
