package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.common.resource.IcentException;
import com.icent.isaver.admin.common.util.TransactionUtil;
import com.icent.isaver.admin.resource.AdminResource;
import com.icent.isaver.admin.svc.TemplateSettingSvc;
import com.icent.isaver.repository.bean.TemplateSettingBean;
import com.icent.isaver.repository.dao.base.TemplateSettingDao;
import com.kst.common.util.StringUtils;
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

        for (String data : paramData) {
            Map<String, String> addParam = new HashMap<>();
            addParam.put("settingId", data.split("\\|")[0]);
            addParam.put("value", data.split("\\|")[1]);
            addParamList.add(addParam);
        }

        try {
            templateSettingDao.saveTemplateSetting(addParamList);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new IcentException("");
        }
        setTemplateSetting();
        return new ModelAndView();
    }

    private void setTemplateSetting(){
        Hashtable<String, String> templateSettingMap = new Hashtable<>();
        for(TemplateSettingBean templateSetting : templateSettingDao.findListTemplateSetting()){
            templateSettingMap.put(templateSetting.getSettingId(), templateSetting.getValue());
        }
        AdminResource.TEMPLATE_SETTING = templateSettingMap;
    }
}
