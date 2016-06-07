package com.icent.jabber.admin.svcImpl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.svc.ClientProductSvc;
import com.icent.jabber.admin.util.AdminHelper;
import com.icent.jabber.repository.bean.ClientProductBean;
import com.icent.jabber.repository.bean.FindBean;
import com.icent.jabber.repository.dao.base.ClientProductDao;
import com.kst.common.helper.FileTransfer;
import com.kst.common.springutil.TransactionUtil;
import com.kst.common.util.FileNioUtil;
import com.kst.common.util.StringUtils;
import org.omg.CORBA.StringHolder;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionStatus;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.nio.file.Paths;
import java.util.List;
import java.util.Map;

/**
 * 클라이언트 제품정보 Service Implements
 *
 * @author : kst
 * @version : 1.0
 * @since : 2014. 8. 20.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 8. 20.     kst           최초 생성
 * </pre>
 */
@Service
public class ClientProductSvcImpl implements ClientProductSvc {

    @Value("#{configProperties['cnf.path.client']}")
    private String clientPath;

    @Inject
    private ClientProductDao clientProductDao;

    @Resource(name="mybatisBaseTxManager")
    private DataSourceTransactionManager transactionManager;

    @Override
    public ModelAndView findListClientProduct(Map<String, String> parameters) {
        FindBean paramBean = AdminHelper.convertMapToBean(parameters, FindBean.class);

        List<ClientProductBean> clientProducts = clientProductDao.findListClientProduct(paramBean);
        Integer totalCount = clientProductDao.findCountClientProduct(paramBean);

        AdminHelper.setPageTotalCount(paramBean,totalCount);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("clientProducts",clientProducts);
        modelAndView.addObject("paramBean",paramBean);

        return modelAndView;
    }

    @Override
    public ModelAndView findByClientProduct(Map<String, String> parameters) {
        ClientProductBean paramBean = AdminHelper.convertMapToBean(parameters, ClientProductBean.class);

        ClientProductBean clientProduct = null;
        if(StringUtils.notNullCheck(paramBean.getClientProductId())){
            clientProduct = clientProductDao.findByClientProduct(paramBean);
        }

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("clientProduct",clientProduct);
        return modelAndView;
    }

    @Override
    public ModelAndView addClientProduct(HttpServletRequest request, Map<String, String> parameters) {
        ClientProductBean paramBean = AdminHelper.convertMapToBean(parameters, ClientProductBean.class);

        File clientFile = null;

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            StringHolder originalFileName = new StringHolder();
            clientFile = FileTransfer.upload(request, "file", 1024, clientPath, originalFileName);

            if(clientFile != null){
                paramBean.setPhysicalFileName(clientFile.getName());
                paramBean.setLogicalFileName(originalFileName.value);
                paramBean.setFileSize(Integer.valueOf(String.valueOf(clientFile.length())));
            }

            clientProductDao.addClientProduct(paramBean);
            transactionManager.commit(transactionStatus);
        }catch(Exception e){
            transactionManager.rollback(transactionStatus);

            if(clientFile != null){
                FileNioUtil.deleteFile(Paths.get(clientFile.getAbsolutePath()));
            }

            throw new JabberException("");
        }finally{
            clientFile = null;
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView saveClientProduct(HttpServletRequest request, Map<String, String> parameters) {
        ClientProductBean paramBean = AdminHelper.convertMapToBean(parameters, ClientProductBean.class);

        File clientFile = null;

        ClientProductBean oldClientProduct = clientProductDao.findByClientProduct(paramBean);

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            StringHolder originalFileName = new StringHolder();
            clientFile = FileTransfer.upload(request, "file", 1024, clientPath, originalFileName);

            if(clientFile != null){
                paramBean.setPhysicalFileName(clientFile.getName());
                paramBean.setLogicalFileName(originalFileName.value);
                paramBean.setFileSize(Integer.valueOf(String.valueOf(clientFile.length())));
            }

            clientProductDao.saveClientProduct(paramBean);
            transactionManager.commit(transactionStatus);
        }catch(Exception e){
            transactionManager.rollback(transactionStatus);

            if(clientFile != null){
                FileNioUtil.deleteFile(Paths.get(clientFile.getAbsolutePath()));
            }

            clientFile = null;
            throw new JabberException("");
        }

        if(clientFile != null && StringUtils.notNullCheck(oldClientProduct.getPhysicalFileName())){
            FileNioUtil.deleteFile(Paths.get(clientPath,oldClientProduct.getPhysicalFileName()));
        }

        clientFile = null;

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView removeClientProduct(Map<String, String> parameters) {
        ClientProductBean paramBean = AdminHelper.convertMapToBean(parameters, ClientProductBean.class);

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        ClientProductBean oldClientProduct = clientProductDao.findByClientProduct(paramBean);

        try{
            clientProductDao.removeClientProduct(paramBean);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        if(StringUtils.notNullCheck(oldClientProduct.getPhysicalFileName())){
            FileNioUtil.deleteFile(Paths.get(clientPath,oldClientProduct.getPhysicalFileName()));
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }
}
