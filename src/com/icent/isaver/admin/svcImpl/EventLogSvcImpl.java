package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.bean.JabberException;
import com.icent.isaver.admin.svc.EventLogSvc;
import com.icent.isaver.admin.util.AdminHelper;
import com.icent.isaver.repository.bean.EventLogBean;
import com.icent.isaver.repository.dao.base.ActionDao;
import com.icent.isaver.repository.dao.base.EventLogDao;
import com.kst.common.resource.CommonResource;
import com.kst.common.spring.TransactionUtil;
import com.kst.common.util.POIExcelUtil;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionStatus;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Created by icent on 16. 6. 13..
 */
@Service
public class EventLogSvcImpl implements EventLogSvc {

    @Resource(name="mybatisIsaverTxManager")
    private DataSourceTransactionManager transactionManager;

    @Inject
    private EventLogDao eventLogDao;

    @Inject
    private ActionDao actionDao;

    @Override
    public ModelAndView findListEventLog(Map<String, String> parameters) {
        List<EventLogBean> events = eventLogDao.findListEventLog(parameters);
        Integer totalCount = eventLogDao.findCountEventLog(parameters);

        AdminHelper.setPageTotalCount(parameters, totalCount);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("eventLogs", events);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView findByEventLog(Map<String, String> parameters) {
        ModelAndView modelAndView = new ModelAndView();

        EventLogBean eventLog = eventLogDao.findByEventLog(parameters);
        modelAndView.addObject("eventLog", eventLog);
        return modelAndView;
    }

    @Override
    public ModelAndView findListEventLogForAlram(Map<String, String> parameters) {
        List<EventLogBean> events = eventLogDao.findListEventLogForAlram(parameters);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("eventLogs", events);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView cancelEventLog(Map<String, String> parameters) {
        String[] eventLogIds = parameters.get("eventLogIds").split(CommonResource.COMMA_STRING);

        List<Map<String, String>> parameterList = new ArrayList<>();
        for (String eventLogId : eventLogIds) {
            Map<String, String> eventLogParamMap = new HashMap<>();
            eventLogParamMap.put("eventLogId", eventLogId);
            eventLogParamMap.put("eventCancelUserId", parameters.get("eventCancelUserId"));
            parameterList.add(eventLogParamMap);
        }

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            eventLogDao.cancelEventLog(parameterList);
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView findListEventLogForExcel(HttpServletRequest request, HttpServletResponse response, Map<String, String> parameters) {
        List<EventLogBean> events = eventLogDao.findListEventLogForExcel(parameters);

        String[] heads = new String[]{"구역","이벤트유형","장치유형","이벤트발생일시","이벤트명","이벤트해제자","이벤트해제일시"};
        String[] columns = new String[]{"areaName","eventFlag","deviceCode","eventDatetimeStr","eventName","eventCancelUserName","eventCancelDatetimeStr"};

        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");

        ModelAndView modelAndView = new ModelAndView("excelView");
        POIExcelUtil.downloadExcel(modelAndView, "이벤트이력_"+sdf.format(new Date()), events, columns, heads, "이벤트이력");
        return modelAndView;

//
//        POIExcelView excelView = new POIExcelView();
//        excelView.setFileExtension();
//
//        String fileName = null;
//        if("deptInspList".equals(parameters.get("type"))){ // 부서점검현황
//            InspInfoBean inspInfoBean = new InspInfoBean();
//            inspInfoBean.setSearch_from(parameters.get("search_from"));
//            inspInfoBean.setSearch_to(parameters.get("search_to"));
//            inspInfoBean.setDept_id(parameters.get("dept_id"));
//            //inspInfoBean.setDeptLowSearchFlag("on".equals(parameters.get("deptLowSearchFlag")) ? "Y" : "N");
//
//            List<InspInfoBean> deptInspInfoCountList = deptInspStatusDao.findListDeptInspInfo(inspInfoBean);
//            List<InspInfoBean> deptInspFileCountList = deptInspStatusDao.findListDeptInspFile(inspInfoBean);
//            List<InspInfoBean> deptInspInfoFileCountList = deptInspStatusDao.findListDeptInspForInfoAndFile(inspInfoBean);
//
//            Map<String, Object> inspInfoMap = new HashMap<String, Object>();
//            inspInfoMap.put("deptInspInfoCountList", deptInspInfoCountList);
//            inspInfoMap.put("deptInspFileCountList", deptInspFileCountList);
//            inspInfoMap.put("deptInspInfoFileCountList", deptInspInfoFileCountList);
//
//            Map<String, String[]> columnMap = new HashMap<String, String[]>();
//            columnMap.put("deptInspInfoCountList", new String[]{"dept_name","total_info_cnt","ptrrn_info_cnt","ptfrn_info_cnt","ptdl_info_cnt","ptpp_info_cnt","ptcc_info_cnt","pthi_info_cnt","ptphone_info_cnt","ptemail_info_cnt","ptcp_info_cnt","ptba_info_cnt"});
//            columnMap.put("deptInspFileCountList", new String[]{"dept_name","total_file_cnt","ptrrn_file_cnt","ptfrn_info_cnt","ptdl_info_cnt","ptpp_info_cnt","ptcc_info_cnt","pthi_info_cnt","ptphone_info_cnt","ptemail_info_cnt","ptcp_info_cnt","ptba_info_cnt"});
//            columnMap.put("deptInspInfoFileCountList", new String[]{"dept_name","total_cnt","ptrrn_cnt","ptfrn_cnt","ptdl_cnt","ptpp_cnt","ptcc_cnt","pthi_cnt","ptphone_cnt","ptemail_cnt","ptcp_cnt","ptba_cnt"});
//
//            Map<String, String[]> headMap = new HashMap<String, String[]>();
//            headMap.put("deptInspInfoCountList", new String[]{"부서명","총계","주민번호","외국인번호","운전면허번호","여권번호","신용카드번호","건강보험번호","전화번호","이메일","핸드폰번호","은행계좌번호"});
//            headMap.put("deptInspFileCountList", new String[]{"부서명","총계","주민번호","외국인번호","운전면허번호","여권번호","신용카드번호","건강보험번호","전화번호","이메일","핸드폰번호","은행계좌번호"});
//            headMap.put("deptInspInfoFileCountList", new String[]{"부서명","총계","주민번호","외국인번호","운전면허번호","여권번호","신용카드번호","건강보험번호","전화번호","이메일","핸드폰번호","은행계좌번호"});
//
//            //시트명
//            String[] sheetName = {"부서별_검출파일수(개)","부서별_검출정보수(건)&검출파일수(개)","부서별_검출정보수(건)"};
//            fileName = "PC점검현황_부서점검현황_" + new SimpleDateFormat("yyyyMMdd").format(new Date());
//            multiSheetExcel(modelAndView, fileName, inspInfoMap, columnMap, headMap, sheetName);
//        }else if("userInspList".equals(parameters.get("type"))){ // 개인점검현황
//            InspInfoBean inspInfoBean = new InspInfoBean();
//            inspInfoBean.setSearch_from(parameters.get("search_from"));
//            inspInfoBean.setSearch_to(parameters.get("search_to"));
//            inspInfoBean.setDept_id(parameters.get("dept_id"));
//            inspInfoBean.setClient_user_name(parameters.get("client_user_name"));
////			inspInfoBean.setDeptLowSearchFlag("on".equals(parameters.get("deptLowSearchFlag")) ? "Y" : "N");
//
//            List<InspInfoBean> userInspInfoCountList = userInspStatusDao.findListUserInspInfo(inspInfoBean);
//            List<InspInfoBean> userInspFileCountList = userInspStatusDao.findListUserInspFile(inspInfoBean);
//            List<InspInfoBean> userInspInfoFileCountList = userInspStatusDao.findListUserInspForInfoAndFile(inspInfoBean);
//
//            Map<String, Object> inspInfoMap = new HashMap<String, Object>();
//            inspInfoMap.put("userInspInfoCountList", userInspInfoCountList);
//            inspInfoMap.put("userInspFileCountList", userInspFileCountList);
//            inspInfoMap.put("userInspInfoFileCountList", userInspInfoFileCountList);
//
//            Map<String, String[]> columnMap = new HashMap<String, String[]>();
//            columnMap.put("userInspInfoCountList", new String[]{"dept_name","client_user_name","total_info_cnt","ptrrn_info_cnt","ptfrn_info_cnt","ptdl_info_cnt","ptpp_info_cnt","ptcc_info_cnt","pthi_info_cnt","ptphone_info_cnt","ptemail_info_cnt","ptcp_info_cnt","ptba_info_cnt"});
//            columnMap.put("userInspFileCountList", new String[]{"dept_name","client_user_name","total_file_cnt","ptrrn_file_cnt","ptfrn_info_cnt","ptdl_info_cnt","ptpp_info_cnt","ptcc_info_cnt","pthi_info_cnt","ptphone_info_cnt","ptemail_info_cnt","ptcp_info_cnt","ptba_info_cnt"});
//            columnMap.put("userInspInfoFileCountList", new String[]{"dept_name","client_user_name","total_cnt","ptrrn_cnt","ptfrn_cnt","ptdl_cnt","ptpp_cnt","ptcc_cnt","pthi_cnt","ptphone_cnt","ptemail_cnt","ptcp_cnt","ptba_cnt"});
//
//            Map<String, String[]> headMap = new HashMap<String, String[]>();
//            headMap.put("userInspInfoCountList", new String[]{"부서명","직원명","총계","주민번호","외국인번호","운전면허번호","여권번호","신용카드번호","건강보험번호","전화번호","이메일","핸드폰번호","은행계좌번호"});
//            headMap.put("userInspFileCountList", new String[]{"부서명","직원명","총계","주민번호","외국인번호","운전면허번호","여권번호","신용카드번호","건강보험번호","전화번호","이메일","핸드폰번호","은행계좌번호"});
//            headMap.put("userInspInfoFileCountList", new String[]{"부서명","직원명","총계","주민번호","외국인번호","운전면허번호","여권번호","신용카드번호","건강보험번호","전화번호","이메일","핸드폰번호","은행계좌번호"});
//
//            //시트명
//            String[] sheetName = {"개인별_검출파일수(개)","개인별_검출정보수(건)&검출파일수(개)","개인별_검출정보수(건)"};
//            fileName = "PC점검현황_개인점검현황_" + new SimpleDateFormat("yyyyMMdd").format(new Date());
//            multiSheetExcel(modelAndView, fileName, inspInfoMap, columnMap, headMap,sheetName);
//        }

//        return null;
    }

//    public void multiSheetExcel(ModelAndView modelAndView, String fileName, Map<String,Object> data, Map<String,String[]> columns, Map<String,String[]> heads,String[] sheetName){
//        modelAndView.addObject("dataType",SystemResource.EXCEL_DATATYPE_MAPLIST);
//        modelAndView.addObject("data", data);
//        modelAndView.addObject("columns", columns);
//        modelAndView.addObject("head", heads);
//        modelAndView.addObject("filename", fileName);
//        modelAndView.addObject("sheetName", sheetName);
//    }

}
