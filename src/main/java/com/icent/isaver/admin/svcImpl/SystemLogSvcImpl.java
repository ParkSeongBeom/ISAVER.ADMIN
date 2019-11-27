package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.bean.DeviceBean;
import com.icent.isaver.admin.bean.SystemLogBean;
import com.icent.isaver.admin.bean.VideoHistoryBean;
import com.icent.isaver.admin.common.resource.IsaverException;
import com.icent.isaver.admin.dao.DeviceDao;
import com.icent.isaver.admin.dao.SystemLogDao;
import com.icent.isaver.admin.dao.VideoHistoryDao;
import com.icent.isaver.admin.resource.AdminResource;
import com.icent.isaver.admin.svc.SystemLogSvc;
import com.icent.isaver.admin.svc.VideoHistorySvc;
import com.icent.isaver.admin.util.AdminHelper;
import com.icent.isaver.admin.util.CommonUtil;
import com.icent.isaver.admin.util.ExcuteHelper;
import com.icent.isaver.admin.util.FileUtil;
import com.meous.common.util.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.InetAddress;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 시스템로그 Service Interface
 * @author : psb
 * @version : 1.0
 * @since : 2019. 10. 21.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2019. 10. 21.     psb           최초 생성
 * </pre>
 */
@Service
public class SystemLogSvcImpl implements SystemLogSvc {

    @Value("${cnf.systemLogAttachedUploadPath}")
    private String systemLogAttachedUploadPath = null;

    @Value("${cnf.hostIp}")
    private String hostIp = null;

    @Value("${cnf.hostId}")
    private String hostId = null;

    @Value("${cnf.hostPassword}")
    private String hostPassword = null;

    @Inject
    private SystemLogDao systemLogDao;

    @Inject
    private ExcuteHelper excuteHelper;

    @Override
    public ModelAndView findListSystemLog(Map<String, String> parameters) {
        List<SystemLogBean> systemLogList = systemLogDao.findListSystemLog(parameters);
        Integer totalCount = systemLogDao.findCountSystemLog(parameters);
        AdminHelper.setPageTotalCount(parameters, totalCount);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("systemLogList", systemLogList);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView excuteSystemLog(Map<String, String> parameters, HttpServletRequest request, HttpServletResponse response) {
        String status;

        ModelAndView modelAndView = new ModelAndView();
        try{
            boolean reachable = excuteHelper.pingTest(hostIp);
            if(reachable){
                String command = "python3 /isaver/script/log_extract.py " + parameters.get("logDatetime");
                boolean resultFlag = excuteHelper.excuteCommand(hostIp,hostId,hostPassword,command);

                if(resultFlag){
                    status="commandSuccess";
                }else{
                    status="commandFailure";
                }
            }else{
                status="pingFailure";
            }
        }catch(Exception e){
            throw new IsaverException("");
        }

        modelAndView.addObject("status", status);
        return modelAndView;
    }

    @Override
    public ModelAndView downloadFile(Map<String, String> parameters, HttpServletRequest request, HttpServletResponse response) {
        SystemLogBean systemLog = systemLogDao.findBySystemLog(parameters);

        if(StringUtils.notNullCheck(systemLog.getFileName())) {
            try {
                FileUtil.fileDown(request, response, systemLogAttachedUploadPath, systemLog.getFileName(), systemLog.getFileName());
            } catch(IOException e) {
                throw new IsaverException("");
            }
        }
        return new ModelAndView();
    }
}
