package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.bean.JabberException;
import com.icent.isaver.admin.svc.FileSvc;
import com.icent.isaver.admin.util.AdminHelper;
import com.icent.isaver.repository.bean.*;
import com.icent.isaver.repository.dao.base.FileDao;
import com.kst.common.spring.TransactionUtil;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionStatus;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import java.util.*;

/**
 * 파일 Service Implements
 * @author : psb
 * @version : 1.0
 * @since : 2016. 12. 20.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2016. 12. 20.     psb           최초 생성
 * </pre>
 */
@Service
public class FileSvcImpl implements FileSvc {

    @Resource(name="mybatisIsaverTxManager")
    private DataSourceTransactionManager transactionManager;

    @Inject
    private FileDao fileDao;

    @Override
    public ModelAndView findListFile(Map<String, String> parameters) {
        List<FileBean> files = fileDao.findListFile(parameters);
        Integer totalCount = fileDao.findCountFile(parameters);

        AdminHelper.setPageTotalCount(parameters, totalCount);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("files", files);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView findByFile(Map<String, String> parameters) {
        ModelAndView modelAndView = new ModelAndView();

        FileBean file = fileDao.findByFile(parameters);
        modelAndView.addObject("file", file);
        return modelAndView;
    }

    @Override
    public ModelAndView addFile(HttpServletRequest request, Map<String, String> parameters) {
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try {
            fileDao.addFile(parameters);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        return new ModelAndView();
    }

    @Override
    public ModelAndView saveFile(HttpServletRequest request, Map<String, String> parameters) {
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try {
            fileDao.saveFile(parameters);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        return new ModelAndView();
    }

    @Override
    public ModelAndView removeFile(Map<String, String> parameters) {
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try{
            fileDao.removeFile(parameters);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        return new ModelAndView();
    }
}
