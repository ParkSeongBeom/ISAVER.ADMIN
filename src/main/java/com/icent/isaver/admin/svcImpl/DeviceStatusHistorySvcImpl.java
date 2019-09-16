package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.bean.DeviceStatusHistoryBean;
import com.icent.isaver.admin.dao.DeviceStatusHistoryDao;
import com.icent.isaver.admin.svc.DeviceStatusHistorySvc;
import com.icent.isaver.admin.util.AdminHelper;
import com.meous.common.util.POIExcelUtil;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * 장치 상태 Service Implements
 * @author : psb
 * @version : 1.0
 * @since : 2018. 7. 12.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2018. 7. 12.     psb           최초 생성
 * </pre>
 */
@Service
public class DeviceStatusHistorySvcImpl implements DeviceStatusHistorySvc {

    @Inject
    private DeviceStatusHistoryDao deviceStatusHistoryDao;

    @Override
    public ModelAndView findListDeviceStatusHistory(Map<String, String> parameters) {
        List<DeviceStatusHistoryBean> deviceStatusHistoryList = deviceStatusHistoryDao.findListDeviceStatusHistory(parameters);
        Integer totalCount = deviceStatusHistoryDao.findCountDeviceStatusHistory(parameters);

        AdminHelper.setPageTotalCount(parameters, totalCount);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("deviceStatusHistoryList", deviceStatusHistoryList);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView findListDeviceStatusHistoryForExcel(HttpServletRequest request, HttpServletResponse response, Map<String, String> parameters) {
        List<DeviceStatusHistoryBean> deviceStatusHistoryList = deviceStatusHistoryDao.findListDeviceStatusHistoryForExcel(parameters);

        String[] heads = new String[]{"Device Id","Device Name","Device Code Name","Area Name","Device Status","Log Datetime","Description"};
        String[] columns = new String[]{"deviceId","deviceName","deviceCodeName","areaName","deviceStat","logDatetimeStr","description"};

        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");

        ModelAndView modelAndView = new ModelAndView();
        POIExcelUtil.downloadExcel(modelAndView, "isaver_device_status_history_" + sdf.format(new Date()), deviceStatusHistoryList, columns, heads, "DeviceStatusHistory");
        return modelAndView;
    }
}
