package com.icent.isaver.admin.svcImpl;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonParser;
import com.google.gson.reflect.TypeToken;
import com.icent.isaver.admin.common.resource.IcentException;
import com.icent.isaver.admin.svc.CustomMapLocationSvc;
import com.icent.isaver.repository.bean.CustomMapLocationBean;
import com.icent.isaver.repository.dao.base.AreaDao;
import com.icent.isaver.repository.dao.base.CustomMapLocationDao;
import com.kst.common.spring.TransactionUtil;
import com.kst.common.util.StringUtils;
import org.codehaus.jackson.map.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionStatus;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Custom Map Service Implements
 *
 * @author : psb
 * @version : 1.0
 * @since : 2018. 6. 14.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2018. 6. 14.     psb           최초 생성
 * </pre>
 */
@Service
public class CustomMapLocationSvcImpl implements CustomMapLocationSvc {

    static Logger logger = LoggerFactory.getLogger(CustomMapLocationSvcImpl.class);

    @Resource(name="isaverTxManager")
    private DataSourceTransactionManager transactionManager;

    @Inject
    private CustomMapLocationDao customMapLocationDao;

    @Inject
    private AreaDao areaDao;

    @Override
    public ModelAndView findListCustomMapLocation(Map<String, String> parameters) {
        List<CustomMapLocationBean> childList = customMapLocationDao.findListCustomMapLocation(parameters);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("childList", childList);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView saveCustomMapLocation(Map<String, String> parameters) {
        // Custom Map remove Param
        Map<String, String> removeCustomParam = new HashMap<>();
        removeCustomParam.put("areaId",parameters.get("areaId"));

        // Area FileId Save Param
        Map<String, String> saveAreaParam = new HashMap<>();
        saveAreaParam.put("areaId",parameters.get("areaId"));
        saveAreaParam.put("fileId",parameters.get("fileId"));

        // Custom Map Insert Param
        List<CustomMapLocationBean> customList = new Gson().fromJson(parameters.get("paramData"), new TypeToken<List<CustomMapLocationBean>>(){}.getType());

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try {
            areaDao.saveAreaFileId(saveAreaParam);
            customMapLocationDao.removeCustomMapLocation(removeCustomParam);
            customMapLocationDao.insertCustomMapLocation(customList);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new IcentException("");
        }
        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }
}
