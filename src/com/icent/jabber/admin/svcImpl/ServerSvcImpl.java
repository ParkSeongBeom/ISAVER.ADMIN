package com.icent.jabber.admin.svcImpl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.resource.AdminResource;
import com.icent.jabber.admin.svc.ServerSvc;
import com.icent.jabber.admin.util.AdminHelper;
import com.icent.jabber.admin.util.MonitorHelper;
import com.icent.jabber.admin.util.ServerConfigHelper;
import com.icent.jabber.repository.bean.ServerBean;
import com.icent.jabber.repository.dao.base.ServerDao;
import com.icent.jabber.repository.dao.base.TargetDao;
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
import java.util.Hashtable;
import java.util.List;
import java.util.Map;

/**
 * 서버 관리 Service
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
public class ServerSvcImpl implements ServerSvc {

    @Inject
    private ServerDao serverDao;

    @Inject
    private TargetDao targetDao;

    @Resource(name="mybatisBaseTxManager")
    private DataSourceTransactionManager transactionManager;

    @Inject
    private ServerConfigHelper serverConfigHelper;

    @Inject
    private MonitorHelper monitorHelper;

    @Override
    public ModelAndView findAllServer(Map<String, String> parameters) {
        List<ServerBean> server = serverDao.findAllServer();

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("servers",server);
        return modelAndView;
    }

    @Override
    public ModelAndView findByServer(Map<String, String> parameters) {
        ServerBean paramBean = AdminHelper.convertMapToBean(parameters, ServerBean.class);

        ServerBean serverBean = null;

        if(StringUtils.notNullCheck(paramBean.getServerId())) {
            serverBean = serverDao.findByServer(paramBean);
        }

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("server",serverBean);
        return modelAndView;
    }

    @Override
    public ModelAndView addServer(Map<String, String> parameters) {
        ServerBean paramBean = AdminHelper.convertMapToBean(parameters, ServerBean.class, "yyyy-MM-dd HH:mm:ss");
        paramBean.setServerId(StringUtils.getGUID36());

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try {
            serverDao.addServer(paramBean);
            transactionManager.commit(transactionStatus);
        } catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView saveServer(Map<String, String> parameters) {
        ServerBean paramBean = AdminHelper.convertMapToBean(parameters, ServerBean.class, "yyyy-MM-dd HH:mm:ss");

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try {
            serverDao.saveServer(paramBean);
            transactionManager.commit(transactionStatus);
        } catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView removeServer(Map<String, String> parameters) {
        ServerBean paramBean = AdminHelper.convertMapToBean(parameters, ServerBean.class);

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try {
            serverDao.removeServer(paramBean);
            transactionManager.commit(transactionStatus);
        } catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView resetServer() {
        boolean resFlag = false;

        AdminResource.SERVER_CONFIG = new Hashtable<>();

        List<ServerBean> wasList = serverConfigHelper.findListServer("was");
        List<ServerBean> apiList = serverConfigHelper.findListServer("api");

        if(wasList == null){ return null; }
        if(apiList == null){ return null; }

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
                HttpPost wasHttpPost = new HttpPost(wasUrlBuilder.toString()+"/resetServer.json");
                HttpResponse wasResponse = wasHttpclient.execute(wasHttpPost);
            }
            resFlag = true;
        }catch(Exception e){
            throw new JabberException("");
        }

        try {
            for (int i=0; i<apiList.size(); i++){
                ServerBean api = apiList.get(i);

                StringBuilder apiUrlBuilder = new StringBuilder();
                apiUrlBuilder.append(api.getProtocol());
                apiUrlBuilder.append(AdminResource.PROTOCOL_SUBPIX);
                apiUrlBuilder.append(api.getIp());
                apiUrlBuilder.append(CommonResourceBean.COLON_STRING);
                apiUrlBuilder.append(api.getPort());
                apiUrlBuilder.append(api.getUrl());

                HttpClient apiHttpclient = AdminHelper.defaultHttpClientSSL(3000);
                HttpPost apiHttpPost = new HttpPost(apiUrlBuilder.toString()+"/management/resetServer.json");
                HttpResponse apiResponse = apiHttpclient.execute(apiHttpPost);
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
