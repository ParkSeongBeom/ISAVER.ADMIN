package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.bean.VersionBean;
import com.icent.isaver.admin.common.resource.CommonResource;
import com.icent.isaver.admin.dao.PgsqlMigrationDao;
import com.icent.isaver.admin.dao.VersionDao;
import com.icent.isaver.admin.svc.DatabaseSvc;
import com.meous.common.spring.TransactionUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionStatus;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.inject.Inject;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

/**
 * 데이터베이스 Service Implements
 * @author : psb
 * @version : 1.0
 * @since : 2019. 12. 27.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2019. 12. 27.     psb           최초 생성
 * </pre>
 */
@Service
public class DatabaseSvcImpl implements DatabaseSvc {
    private static Logger logger = LoggerFactory.getLogger(DatabaseSvcImpl.class);

    @Resource(name="isaverTxManager")
    private DataSourceTransactionManager transactionManager;

    @Inject
    private VersionDao versionDao;

    @Inject
    private PgsqlMigrationDao pgsqlMigrationDao;

    String[] migrationHistory = new String[]{
            "1.7.4","1.7.4_1","1.7.4_2","1.7.4_3","1.7.4_4"
            ,"1.7.5_0","1.7.5_1","1.7.5_2","1.7.5_3","1.7.5_4","1.7.5_5"
    };

    @Override
    public ModelAndView postgresqlMigration(Map<String, String> parameters) {
        VersionBean versionBean = versionDao.findByVersion();

        List<Map> resultList = new LinkedList<>();

        if(versionBean.getVersion().equals(migrationHistory[migrationHistory.length-1])){
            resultList.add(setResult(versionBean.getVersion(), CommonResource.SUCCESS, "This is the latest version..."));
        }

        boolean migrationFlag = false;
        for(String version : migrationHistory){
            if(migrationFlag){
                TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
                try {
                    parameters.put("version",version);
                    pgsqlMigrationDao.migration(parameters);
                    versionDao.saveVersion(parameters);
                    transactionManager.commit(transactionStatus);
                    resultList.add(setResult(version, CommonResource.SUCCESS, "Migration... OK"));
                }catch(DataAccessException e){
                    transactionManager.rollback(transactionStatus);
                    resultList.add(setResult(version, CommonResource.FAILURE, e.getMessage()));
                }
            }else if(versionBean.getVersion().equals(version)){
                migrationFlag = true;
            }
        }

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("result",resultList);
        return modelAndView;
    }

    private Map<String,String> setResult(String version, String code, String Message){
        Map<String,String> result = new HashMap<>();
        result.put("version",version);
        result.put("code",CommonResource.SUCCESS);
        result.put("message",Message);
        return result;
    }
}
