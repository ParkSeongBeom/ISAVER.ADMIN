package com.icent.jabber.admin.svcImpl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.svc.FileSvc;
import com.icent.jabber.admin.util.AdminHelper;
import com.icent.jabber.repository.bean.FileBean;
import com.icent.jabber.repository.bean.FindBean;
import com.icent.jabber.repository.dao.base.FileDao;
import com.kst.common.bean.CommonResourceBean;
import com.kst.common.springutil.TransactionUtil;
import com.kst.common.util.FileNioUtil;
import com.kst.common.util.StringUtils;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionStatus;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.inject.Inject;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 파일 Service Implement
 *
 * @author : kst
 * @version : 1.0
 * @since : 2015. 2. 5.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2015. 2. 5.     kst           최초 생성
 * </pre>
 */
@Service
public class FileSvcImpl implements FileSvc{

    @Inject
    private FileDao fileDao;

    @Resource(name="mybatisBaseTxManager")
    private DataSourceTransactionManager transactionManager;

    @Override
    public ModelAndView findListFile(Map<String, String> parameters) {
        FindBean paramBean = AdminHelper.convertMapToBean(parameters, FindBean.class);

        List<FileBean> files = fileDao.findListFile(paramBean);
        Integer totalCount = fileDao.findCountFile(paramBean);

        AdminHelper.setPageTotalCount(paramBean, totalCount);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("files",files);
        modelAndView.addObject("paramBean",paramBean);
        return modelAndView;
    }

    @Override
    public ModelAndView deleteFile(Map<String, String> parameters) {
        FindBean paramBean = AdminHelper.convertMapToBean(parameters, FindBean.class);

        if(StringUtils.nullCheck(paramBean.getId())){
            throw new JabberException("");
        }

        List<String> notDeleteFiles = new ArrayList<>();
        for(String id : paramBean.getId().split(CommonResourceBean.COMMA_STRING)){
            FileBean fileParam = new FileBean(id);
            fileParam.setUpdateUserId(paramBean.getUserId());

            TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
            try{
                fileDao.deleteFile(fileParam);

                FindBean findParam = new FindBean();
                findParam.setId(id);
                fileParam = fileDao.findByFile(findParam);
                boolean flag = FileNioUtil.deleteFile(Paths.get(fileParam.getFilePath()));
                if(!flag){
                    notDeleteFiles.add(fileParam.getLogicalFileName());
                    transactionManager.rollback(transactionStatus);
                }else{
                    transactionManager.commit(transactionStatus);
                }
            }catch(Exception e){
                transactionManager.rollback(transactionStatus);
                throw new JabberException("");
            }
        }

        ModelAndView modelAndView = new ModelAndView();
        if(notDeleteFiles.size() > 0){
            modelAndView.addObject("notDeleteFiles",notDeleteFiles);
        }
        return modelAndView;
    }
}
