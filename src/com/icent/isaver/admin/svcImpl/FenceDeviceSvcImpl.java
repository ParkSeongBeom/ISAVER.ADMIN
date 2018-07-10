package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.svc.FenceDeviceSvc;
import com.icent.isaver.repository.bean.FenceDeviceBean;
import com.icent.isaver.repository.dao.base.FenceDeviceDao;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import java.util.List;
import java.util.Map;

/**
 * 펜스 카메라 맵핑 Service Implements
 * @author : psb
 * @version : 1.0
 * @since : 2018. 7. 10.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2018. 7. 10.     psb           최초 생성
 * </pre>
 */
@Service
public class FenceDeviceSvcImpl implements FenceDeviceSvc {

    @Inject
    private FenceDeviceDao fenceDeviceDao;

    @Override
    public ModelAndView findListFenceDevice(Map<String, String> parameters) {
        List<FenceDeviceBean> fenceDeviceList = fenceDeviceDao.findListFenceDevice(parameters);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("fenceDeviceList", fenceDeviceList);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }
}
