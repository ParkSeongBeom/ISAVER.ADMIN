package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.resource.AdminResource;
import com.icent.isaver.admin.svc.DashBoardSvc;
import com.icent.isaver.repository.bean.AreaBean;
import com.icent.isaver.repository.dao.base.AreaDao;
import com.icent.isaver.repository.dao.base.DeviceDao;
import com.kst.common.resource.CommonResource;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import java.net.InetAddress;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 대쉬보드 Service Implements
 * @author : psb
 * @version : 1.0
 * @since : 2016. 6. 16.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2016. 6. 16.     psb           최초 생성
 * </pre>
 */
@Service
public class DashBoardSvcImpl implements DashBoardSvc {

    @Value("${cnf.fileAddress}")
    private String fileAddress = null;

    @Value("${cnf.fileAttachedUploadPath}")
    private String fileAttachedUploadPath = null;

    @Inject
    private AreaDao areaDao;

    @Inject
    private DeviceDao deviceDao;

    @Override
    public ModelAndView findListDashBoard(Map<String, String> parameters) {
        List<AreaBean> navList = areaDao.findListAreaNav(parameters);

        List<AreaBean> childAreas = areaDao.findListAreaForDashboard(parameters);
        for(AreaBean area : childAreas){
            Map<String, String> deviceParam = new HashMap<>();
            deviceParam.put("areaId",area.getAreaId());
            deviceParam.put("delYn", CommonResource.NO);
            area.setDevices(deviceDao.findListDevice(deviceParam));
            area.setAreas(areaDao.findListAreaForDashboard(deviceParam));
        }
        AreaBean area = areaDao.findByArea(parameters);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("navList", navList);
        modelAndView.addObject("childAreas", childAreas);
        modelAndView.addObject("area", area);
        modelAndView.addObject("deviceCodeCss", AdminResource.DEVICE_CODE_CSS);
        modelAndView.addObject("paramBean",parameters);
        try{
            InetAddress address = InetAddress.getByName(fileAddress);
            modelAndView.addObject("fileUploadPath", "http://" + address.getHostAddress() + fileAttachedUploadPath);
        }catch(Exception e){
            e.printStackTrace();
        }
        return modelAndView;
    }
}
