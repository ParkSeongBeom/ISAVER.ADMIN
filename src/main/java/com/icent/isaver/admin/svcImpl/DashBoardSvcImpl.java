package main.java.com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.resource.AdminResource;
import com.icent.isaver.admin.svc.DashBoardSvc;
import com.icent.isaver.admin.svc.TemplateSettingSvc;
import com.icent.isaver.admin.bean.AreaBean;
import com.icent.isaver.admin.dao.AreaDao;
import com.icent.isaver.admin.dao.DeviceDao;
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

    @Value("${ws.server.address}")
    private String wsAddress = null;

    @Value("${ws.server.port}")
    private String wsPort = null;

    @Value("${ws.server.projectName}")
    private String wsProjectName = null;

    @Value("${ws.server.mapUrlConnect}")
    private String wsMapUrlConnect = null;

    @Value("${ws.server.toiletRoomUrlConnect}")
    private String wsToiletRoomUrlConnect = null;

    @Inject
    private AreaDao areaDao;

    @Inject
    private DeviceDao deviceDao;

    @Inject
    private TemplateSettingSvc templateSettingSvc;

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
        modelAndView.addObject("templateSetting",templateSettingSvc.findListTemplateSetting());

        try{
            InetAddress address = InetAddress.getByName(fileAddress);
            modelAndView.addObject("fileUploadPath", "http://" + address.getHostAddress() + fileAttachedUploadPath);
        }catch(Exception e){
            e.printStackTrace();
        }

        try{
            InetAddress address = InetAddress.getByName(wsAddress);
            modelAndView.addObject("mapWebSocketUrl", "ws://" + address.getHostAddress() + ":" + wsPort + "/" + wsProjectName + wsMapUrlConnect);
            modelAndView.addObject("toiletRoomWebSocketUrl", "ws://" + address.getHostAddress() + ":" + wsPort + "/" + wsProjectName + wsToiletRoomUrlConnect);
        }catch(Exception e){
            e.printStackTrace();
        }
        return modelAndView;
    }
}
