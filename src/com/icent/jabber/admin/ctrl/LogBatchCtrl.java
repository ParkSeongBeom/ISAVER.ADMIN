package com.icent.jabber.admin.ctrl;

import com.icent.jabber.admin.svc.LogBatchSvc;
import com.icent.jabber.admin.util.AdminHelper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import java.util.Map;

/**
 * 배치로그 관리 Controller
 *
 * @author : kst
 * @version : 1.0
 * @since : 2014. 6. 11.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 6. 11.     kst           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value="/logbatch/*")
public class LogBatchCtrl {

    @Value("#{configProperties['cnf.defaultPageSize']}")
    private String defaultPageSize;

    @Inject
    private LogBatchSvc logBatchSvc;

    /**
     * 배치로그 목록을 가져온다.
     *
     * @author kst
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET}, value="/list")
    public ModelAndView findListLogBatch(@RequestParam Map<String, String> parameters){
        parameters = AdminHelper.setPageParam(parameters, defaultPageSize);
        parameters = AdminHelper.checkSearchDate(parameters,7);

        ModelAndView modelAndView = logBatchSvc.findListLogBatch(parameters);
        modelAndView.setViewName("logBatchList");
        return modelAndView;
    }

    /**
     * 메인 - 배치로그 목록을 가져온다.
     *
     * @author kst
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET}, value="/mainList")
    public ModelAndView findListLogBatchByMain(@RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = logBatchSvc.findListLogBatchByMain(parameters);
        modelAndView.setViewName("mainLogBatchList");
        return modelAndView;
    }
}
