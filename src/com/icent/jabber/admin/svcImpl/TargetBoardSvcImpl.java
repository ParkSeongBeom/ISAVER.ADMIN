package com.icent.jabber.admin.svcImpl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.resource.AdminResource;
import com.icent.jabber.admin.svc.TargetBoardSvc;
import com.icent.jabber.admin.util.AdminHelper;
import com.icent.jabber.repository.bean.CodeBean;
import com.icent.jabber.repository.bean.FindBean;
import com.icent.jabber.repository.bean.TargetBoardBean;
import com.icent.jabber.repository.dao.base.CodeDao;
import com.icent.jabber.repository.dao.base.TargetBoardDao;
import com.kst.common.helper.FileTransfer;
import com.kst.common.springutil.TransactionUtil;
import com.kst.common.util.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionStatus;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * 고객사 게시판 관리 Service
 * @author : psb
 * @version : 1.0
 * @since : 2014. 11. 26.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 11. 26.     psb           최초 생성
 * </pre>
 */
@Service
public class TargetBoardSvcImpl implements TargetBoardSvc {

    @Inject
    private TargetBoardDao targetBoardDao;

    @Inject
    private CodeDao codeDao;

    @Resource(name="mybatisBaseTxManager")
    private DataSourceTransactionManager transactionManager;

    @Value("#{configProperties['cnf.boardFileAttachedUploadPath']}")
    private String boardUploadPath;

    @Value("#{configProperties['cnf.defaultPageSize']}")
    private String defaultPageSize;

    @Override
    public ModelAndView findAllTargetBoard(Map<String, String> parameters) {
        List<TargetBoardBean> pinTargetBoards = targetBoardDao.findListPINTargetBoard();

        String _defaultPageSize = String.valueOf(Integer.parseInt(defaultPageSize) - pinTargetBoards.size());
        AdminHelper.setPageParam(parameters, _defaultPageSize);

        FindBean paramBean = AdminHelper.convertMapToBean(parameters, FindBean.class);

        List<TargetBoardBean> targetBoards = targetBoardDao.findAllTargetBoard(paramBean);
        Integer totalCount = targetBoardDao.findCountTargetBoard(paramBean);
        AdminHelper.setPageTotalCount(paramBean, totalCount);

        for (int i=0; i<targetBoards.size(); i++){
            pinTargetBoards.add(targetBoards.get(i));
        }

        FindBean codeParamBean = new FindBean();
        codeParamBean.setId("T001");
        codeParamBean.setUseYn(AdminResource.YES);
        List<CodeBean> headers = codeDao.findListCode(codeParamBean);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("targetBoards",pinTargetBoards);
        modelAndView.addObject("paramBean",paramBean);
        modelAndView.addObject("headers",headers);
        return modelAndView;
    }

    @Override
    public ModelAndView findByTargetBoard(Map<String, String> parameters) {
        TargetBoardBean paramBean = AdminHelper.convertMapToBean(parameters, TargetBoardBean.class);

        TargetBoardBean targetBoardBean = new TargetBoardBean();

        if(StringUtils.notNullCheck(paramBean.getBoardId())) {
            targetBoardBean = targetBoardDao.findByTargetBoard(paramBean);
        }else{
            targetBoardBean.setStartDatetime(new Date());
            targetBoardBean.setEndDatetime(new Date());
        }

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("targetBoard",targetBoardBean);
        return modelAndView;
    }

    @Override
    public ModelAndView addTargetBoard(HttpServletRequest request, Map<String, String> parameters) {

        TargetBoardBean paramBean = AdminHelper.convertMapToBean(parameters, TargetBoardBean.class, "yyyy-MM-dd HH:mm:ss");
        paramBean.setBoardId(StringUtils.getGUID36());

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        File targetBoardFile = null;

        try {
            targetBoardFile = FileTransfer.upload(request, "targetBoardFile", 1024, boardUploadPath, null, paramBean.getBoardId());
            if(targetBoardFile != null){
                paramBean.setPhysicalFileName(targetBoardFile.getName());

            }
        } catch(IOException e){
            if(targetBoardFile != null){
                targetBoardFile.delete();
            }
            throw new JabberException("");
        }

        try {
            paramBean.setDelYn("N");
            targetBoardDao.addTargetBoard(paramBean);
            transactionManager.commit(transactionStatus);
        } catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }
        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView saveTargetBoard(HttpServletRequest request, Map<String, String> parameters) {
        TargetBoardBean paramBean = AdminHelper.convertMapToBean(parameters, TargetBoardBean.class, "yyyy-MM-dd HH:mm:ss");
        File targetBoardFile = null;
        try {
            targetBoardFile = FileTransfer.upload(request, "targetBoardFile", 1024, boardUploadPath, null, paramBean.getBoardId());
            if(targetBoardFile != null){
                paramBean.setPhysicalFileName(targetBoardFile.getName());

            }
        } catch(IOException e) {
            if(targetBoardFile != null){
                targetBoardFile.delete();
            }
            throw new JabberException("");
        }

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try {

            targetBoardDao.saveTargetBoard(paramBean);
            transactionManager.commit(transactionStatus);
        } catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);

            throw new JabberException("");
        }
        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView removeTargetBoard(Map<String, String> parameters) {

        TargetBoardBean paramBean = AdminHelper.convertMapToBean(parameters, TargetBoardBean.class, "yyyy-MM-dd HH:mm:ss");
        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

        try {
            targetBoardDao.removeTargetBoard(paramBean);
            transactionManager.commit(transactionStatus);
        } catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView downloadTargetBoard(Map<String, String> parameters, HttpServletRequest request, HttpServletResponse response) {
        TargetBoardBean paramBean = AdminHelper.convertMapToBean(parameters, TargetBoardBean.class);
        TargetBoardBean targetBoard = targetBoardDao.findByTargetBoard(paramBean);

        if(StringUtils.notNullCheck(targetBoard.getPhysicalFileName())) {
            try {
                if (new File(boardUploadPath + targetBoard.getPhysicalFileName()).exists()) {
                    FileTransfer.download(request, response, boardUploadPath + targetBoard.getPhysicalFileName(), "\"" + targetBoard.getLogicalFileName() + "\"", 1024);
                }
            } catch(IOException | ServletException e) {
                throw new JabberException("");
            }
        }
        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;

    }
}
