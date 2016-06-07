package com.icent.jabber.admin.svcImpl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.resource.AdminResource;
import com.icent.jabber.admin.svc.FunctionSvc;
import com.icent.jabber.admin.util.AdminHelper;
import com.icent.jabber.admin.util.ServerConfigHelper;
import com.icent.jabber.repository.bean.FunctionBean;
import com.icent.jabber.repository.bean.ServerBean;
import com.icent.jabber.repository.dao.base.FunctionDao;
import com.kst.common.bean.CommonResourceBean;
import com.kst.common.springutil.TransactionUtil;
import com.kst.common.util.StringUtils;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionStatus;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.inject.Inject;
import java.util.List;
import java.util.Map;

/**
 * 기능제한 관리 Service
 * @author : psb
 * @version : 1.0
 * @since : 2014. 10. 29.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 10. 29.     psb           최초 생성
 * </pre>
 */
@Service
public class FunctionSvcImpl implements FunctionSvc {

    @Inject
    private FunctionDao functionDao;

    @Resource(name="mybatisBaseTxManager")
    private DataSourceTransactionManager transactionManager;

    @Inject
    private ServerConfigHelper serverConfigHelper;

    @Override
    public ModelAndView findAllFunction(Map<String, String> parameters) {
        List<FunctionBean> function = functionDao.findAllFunction();

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("functions",function);
        return modelAndView;
    }

    @Override
    public ModelAndView findByFunction(Map<String, String> parameters) {
        FunctionBean paramBean = AdminHelper.convertMapToBean(parameters, FunctionBean.class);

        FunctionBean functionBean = null;

        if(StringUtils.notNullCheck(paramBean.getFuncId())) {
            functionBean = functionDao.findByFunction(paramBean);
        }

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("function",functionBean);
        return modelAndView;
    }

    @Override
    public ModelAndView saveFunction(Map<String, String> parameters) {
        FunctionBean paramBean = AdminHelper.convertMapToBean(parameters, FunctionBean.class, "yyyy-MM-dd HH:mm:ss");

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try {

            functionDao.saveFunction(paramBean);
            transactionManager.commit(transactionStatus);
        } catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);

            throw new JabberException("");
        }
        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView resetFunction() {
        boolean resFlag = false;

        List<ServerBean> wasList = serverConfigHelper.findListServer("was");

        if(wasList == null){ return null; }

        try {
            for (int i=0; i<wasList.size(); i++){
                ServerBean was = wasList.get(i);

                StringBuilder wasUrlBuilder = new StringBuilder();
                wasUrlBuilder.append(was.getProtocol());
                wasUrlBuilder.append(AdminResource.PROTOCOL_SUBPIX);
                wasUrlBuilder.append(was.getIp());
                wasUrlBuilder.append(CommonResourceBean.COLON_STRING);
                wasUrlBuilder.append(was.getPort());
                wasUrlBuilder.append(was.getUrl());

                HttpClient wasHttpclient = AdminHelper.defaultHttpClientSSL(3000);
                HttpPost wasHttpPost = new HttpPost(wasUrlBuilder.toString()+"/resetFunction.json");
                HttpResponse wasResponse = wasHttpclient.execute(wasHttpPost);
            }
            resFlag = true;
        }catch(Exception e){
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("resFlag",resFlag);
        return modelAndView;
    }
}
