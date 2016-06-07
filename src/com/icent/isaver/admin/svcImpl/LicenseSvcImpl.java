package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.svc.LicenseSvc;
import com.icent.isaver.repository.bean.LicenseBean;
import com.icent.isaver.repository.dao.base.LicenseDao;
import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.util.AdminHelper;
import com.kst.common.springutil.TransactionUtil;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionStatus;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

/**
 * 라이센스 Service Implements
 *
 * @author : dhj
 * @version : 1.0
 * @since : 2016. 6. 1.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2016. 6. 1.     dhj           최초 생성
 * </pe>
 */
@Service
public class LicenseSvcImpl implements LicenseSvc {

    @Resource(name="mybatisIsaverTxManager")
    private DataSourceTransactionManager transactionManager;

    @Inject
    private LicenseDao licenseDao;

    @Override
    public ModelAndView findListLicense(Map<String, String> parameters) {
        List<LicenseBean> licenses = licenseDao.findListLicense(parameters);
        Integer totalCount = licenseDao.findCountLicense(parameters);

        AdminHelper.setPageTotalCount(parameters, totalCount);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("licenses", licenses);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView findByLicense(Map<String, String> parameters) {

        ModelAndView modelAndView = new ModelAndView();

        LicenseBean license = licenseDao.findByLicense(parameters);
        modelAndView.addObject("license", license);
        return modelAndView;
    }

    @Override
    public ModelAndView addLicense(HttpServletRequest request, Map<String, String> parameters) {

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try {
            licenseDao.addLicense(parameters);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView saveLicense(HttpServletRequest request, Map<String, String> parameters) {

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try {

            licenseDao.saveLicense(parameters);

            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView removeLicense(Map<String, String> parameters) {

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            licenseDao.removeLicense(parameters);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

}
