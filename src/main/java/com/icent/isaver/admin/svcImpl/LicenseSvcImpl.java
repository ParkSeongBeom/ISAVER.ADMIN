package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.svc.LicenseSvc;
import com.icent.isaver.admin.util.HaspLicenseUtil;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.inject.Inject;
import java.util.Map;

/**
 * 라이센스 Service Implements
 *
 * @author : psb
 * @version : 1.0
 * @since : 2016. 6. 1.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2016. 6. 1.     psb           최초 생성
 * </pe>
 */
@Service
public class LicenseSvcImpl implements LicenseSvc {

    @Resource(name="isaverTxManager")
    private DataSourceTransactionManager transactionManager;

    @Inject
    private HaspLicenseUtil haspLicenseUtil;

    @Override
    public ModelAndView findListLicense(Map<String, String> parameters) {
        ModelAndView modelAndView = haspLicenseUtil.getLicenseList();
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }
}
