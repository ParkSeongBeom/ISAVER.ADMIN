package main.java.com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.svc.DeviceStatusHistorySvc;
import com.icent.isaver.admin.util.AdminHelper;
import com.icent.isaver.admin.bean.DeviceStatusHistoryBean;
import com.icent.isaver.admin.dao.DeviceStatusHistoryDao;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
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
}
