package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.bean.NotiSendLogBean;
import com.icent.isaver.admin.dao.NotiSendLogDao;
import com.icent.isaver.admin.svc.NotiSendLogSvc;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.inject.Inject;
import java.util.List;
import java.util.Map;

/**
 * 외부연동용 이벤트 전송 이력 Service Interface
 * @author : psb
 * @version : 1.0
 * @since : 2019. 7. 23.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2019. 7. 23.     psb           최초 생성
 * </pre>
 */
@Service
public class NotiSendLogSvcImpl implements NotiSendLogSvc {

    @Resource(name="isaverTxManager")
    private DataSourceTransactionManager transactionManager;

    @Inject
    private NotiSendLogDao notiSendLogDao;

    @Override
    public ModelAndView findListNotiSendLog(Map<String, String> parameters) {
        List<NotiSendLogBean> notiSendLogList = notiSendLogDao.findListNotiSendLog(parameters);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("notiSendLogList",notiSendLogList);
        return modelAndView;
    }
}
