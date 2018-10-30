package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.common.resource.IcentException;
import com.icent.isaver.admin.svc.FileSettingSvc;
import com.icent.isaver.repository.bean.FileSettingBean;
import com.icent.isaver.repository.dao.base.FileSettingDao;
import com.kst.common.spring.TransactionUtil;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionStatus;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.inject.Inject;
import java.util.Map;

/**
 * 파일 환경설정 Service Implements
 *
 * @author : psb
 * @version : 1.0
 * @since : 2018. 10. 29.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2018. 10. 29.     psb           최초 생성
 * </pre>
 */
@Service
public class FileSettingSvcImpl implements FileSettingSvc {

    @Resource(name="isaverTxManager")
    private DataSourceTransactionManager transactionManager;

    @Inject
    private FileSettingDao fileSettingDao;

    @Override
    public ModelAndView findByFileSetting(Map<String, String> parameters) {
        FileSettingBean fileSetting = fileSettingDao.findByFileSetting(parameters);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("fileSetting", fileSetting);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView saveFileSetting(Map<String, String> parameters) {
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try {
            fileSettingDao.saveFileSetting(parameters);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new IcentException("");
        }
        return new ModelAndView();
    }
}
