package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.bean.AreaBean;
import com.icent.isaver.admin.bean.DeviceBean;
import com.icent.isaver.admin.common.resource.IsaverException;
import com.icent.isaver.admin.dao.AreaDao;
import com.icent.isaver.admin.dao.DeviceDao;
import com.icent.isaver.admin.dao.FileDao;
import com.icent.isaver.admin.resource.AdminResource;
import com.icent.isaver.admin.svc.DashBoardSvc;
import com.icent.isaver.admin.svc.TemplateSettingSvc;
import com.meous.common.resource.CommonResource;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Sorts;
import org.bson.Document;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import java.net.InetAddress;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static com.mongodb.client.model.Filters.*;

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
    private static Logger logger = LoggerFactory.getLogger(DashBoardSvcImpl.class);

    @Value("${cnf.fileAddress}")
    private String fileAddress = null;

    @Value("${cnf.fileAttachedUploadPath}")
    private String fileAttachedUploadPath = null;

    @Inject
    private AreaDao areaDao;

    @Inject
    private DeviceDao deviceDao;

    @Inject
    private FileDao fileDao;

    @Inject
    private TemplateSettingSvc templateSettingSvc;

    @Inject
    private MongoDatabase mongoDatabase;

    @Override
    public ModelAndView findListDashBoard(Map<String, String> parameters) {
        List<AreaBean> navList = areaDao.findListAreaNav(parameters);

        List<AreaBean> childAreas = areaDao.findListAreaForDashboard(parameters);
        for(AreaBean area : childAreas){
            Map<String, String> deviceParam = new HashMap<>();
            deviceParam.put("areaId",area.getAreaId());
            deviceParam.put("delYn", CommonResource.NO);
            List<DeviceBean> deviceList = deviceDao.findListDevice(deviceParam);

            if(area.getTemplateCode().equals("TMP004")){
                try{
                    MongoCollection<Document> collection = mongoDatabase.getCollection("eventLog");
                    Calendar cal = Calendar.getInstance();
                    cal.set( Calendar.HOUR_OF_DAY, 0 );
                    cal.set( Calendar.MINUTE, 0 );
                    cal.set( Calendar.SECOND, 0 );
                    cal.set(Calendar.MILLISECOND, 0 );

                    for(DeviceBean device : deviceList){
                        Document eventLog = collection.find(
                                and(
                                        eq("deviceId", device.getDeviceId()),
                                        gte("eventDatetime", cal.getTime())
                                )
                        ).sort(Sorts.descending("eventDatetime")).first();

                        if(eventLog!=null){
                            if(eventLog.get("value")!=null){
                                device.setEvtValue(eventLog.get("value").toString());
                            }
                            if(eventLog.get("format")!=null){
                                device.setFormat(eventLog.get("format").toString());
                            }
                        }
                    }
                }catch(Exception e){
                    logger.error(e.getMessage());
                    throw new IsaverException("");
                }
            }
            area.setDevices(deviceList);
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
        modelAndView.addObject("logoFile",fileDao.findByFileByLogo());

        try{
            InetAddress address = InetAddress.getByName(fileAddress);
            modelAndView.addObject("fileUploadPath", "http://" + address.getHostAddress() + fileAttachedUploadPath);
        }catch(Exception e){
            logger.error(e.getMessage());
        }
        return modelAndView;
    }
}
