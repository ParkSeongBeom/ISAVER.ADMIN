package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.bean.DeviceBean;
import com.icent.isaver.admin.bean.VideoHistoryBean;
import com.icent.isaver.admin.dao.DeviceDao;
import com.icent.isaver.admin.dao.VideoHistoryDao;
import com.icent.isaver.admin.resource.AdminResource;
import com.icent.isaver.admin.svc.VideoHistorySvc;
import com.kst.common.util.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import java.net.InetAddress;
import java.util.List;
import java.util.Map;

/**
 * 영상이력 Service Interface
 * @author : psb
 * @version : 1.0
 * @since : 2018. 8. 16.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2018. 8. 16.     psb           최초 생성
 * </pre>
 */
@Service
public class VideoHistorySvcImpl implements VideoHistorySvc {

    @Value("${cnf.fileAddress}")
    private String fileAddress = null;

    @Value("${cnf.videoAttachedUploadPath}")
    private String videoAttachedUploadPath = null;

    @Inject
    private VideoHistoryDao videoHistoryDao;

    @Inject
    private DeviceDao deviceDao;

    @Override
    public ModelAndView findListVideoHistory(Map<String, String> parameters) {
        List<DeviceBean> deviceList = deviceDao.findListDeviceForHistory(parameters);
        ModelAndView modelAndView = new ModelAndView();

        if(StringUtils.notNullCheck(parameters.get("mode")) && parameters.get("mode").equals(AdminResource.SEARCH_MODE)){
            List<VideoHistoryBean> videoHistoryList = videoHistoryDao.findListVideoHistory(parameters);
            Integer totalCount = videoHistoryDao.findCountVideoHistory(parameters);
            modelAndView.addObject("videoHistoryList", videoHistoryList);
            modelAndView.addObject("totalCount",totalCount);
        }

        modelAndView.addObject("deviceList", deviceList);
        modelAndView.addObject("paramBean",parameters);
        try{
            InetAddress address = InetAddress.getByName(fileAddress);
            modelAndView.addObject("videoUrl", "http://" + address.getHostAddress() + videoAttachedUploadPath);
        }catch(Exception e){
            e.printStackTrace();
        }
        return modelAndView;
    }
}
