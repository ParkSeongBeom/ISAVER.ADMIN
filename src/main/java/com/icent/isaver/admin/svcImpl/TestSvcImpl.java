package com.icent.isaver.admin.svcImpl;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import com.icent.isaver.admin.bean.*;
import com.icent.isaver.admin.common.resource.IsaverException;
import com.icent.isaver.admin.dao.AreaDao;
import com.icent.isaver.admin.dao.DeviceDao;
import com.icent.isaver.admin.dao.EventDao;
import com.icent.isaver.admin.dao.FenceDao;
import com.icent.isaver.admin.resource.ResultState;
import com.icent.isaver.admin.svc.TestSvc;
import com.icent.isaver.admin.util.AlarmRequestUtil;
import org.apache.http.entity.StringEntity;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.List;
import java.util.Map;

/**
 * 테스트 시뮬레이터 Service Implements
 *
 * @author : psb
 * @version : 1.0
 * @since : 2018. 3. 20.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2018. 3. 20.     psb           최초 생성
 * </pre>
 */

@Service
public class TestSvcImpl implements TestSvc {

    private static Logger logger = LoggerFactory.getLogger(TestSvcImpl.class);

    @Value("${api.server.address}")
    private String ipAddress = null;

    @Value("${api.server.port}")
    private String port = null;

    @Value("${api.server.projectName}")
    private String projectName = null;

    @Value("${api.server.eventAddUrl}")
    private String eventAddUrl = null;

    @Value("${test.proc.id}")
    private String testId = null;

    @Value("${test.proc.start}")
    private String startProc = null;

    @Value("${test.proc.stop}")
    private String stopProc = null;

    @Inject
    private DeviceDao deviceDao;

    @Inject
    private AreaDao areaDao;

    @Inject
    private FenceDao fenceDao;

    @Inject
    private EventDao eventDao;

    @Override
    public ModelAndView testList(HttpServletRequest request, Map<String, String> parameters) {
        List<AreaBean> areaList = areaDao.findListAreaForTest();
        List<DeviceBean> deviceList = deviceDao.findListDeviceForTest();
        List<FenceBean> fenceList = fenceDao.findListFenceForTest();
        List<EventBean> eventList = eventDao.findListEvent(null);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("areaList",areaList);
        modelAndView.addObject("deviceList",deviceList);
        modelAndView.addObject("fenceList",fenceList);
        modelAndView.addObject("eventList",eventList);
        return modelAndView;
    }

    @Override
    public ModelAndView eventSend(HttpServletRequest request, Map<String, String> parameters) {
        Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss.SSS").create();
        EventLogBean eventLogBean = gson.fromJson(parameters.get("eventData"), new TypeToken<EventLogBean>(){}.getType());
        ResultBean result = new ResultBean();
        try {
            result = AlarmRequestUtil.sendRequestFuncJson(new StringEntity(parameters.get("eventData")), "http://" + ipAddress + ":" + port + "/" + projectName + eventAddUrl);
        } catch (Exception e) {
            throw new IsaverException(ResultState.ERROR_SEND_REQUEST,e.getMessage());
        }

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("result",result);
        modelAndView.addObject("paramBean",eventLogBean);
        return modelAndView;
    }

    @Override
    public ModelAndView guard(HttpServletRequest request, Map<String, String> parameters) {
        String osName = System.getProperty("os.name");
        if(osName.toLowerCase().indexOf("windows") == -1) {
            StringBuilder sb = new StringBuilder();
            Process p = null;
            BufferedReader br;
            String s;

            String command;
            if(parameters.get("type").equals("start")) {
                command = startProc;
            }else{
                command = stopProc;
            }

            try{
                String[] cmd = new String[]{"su", "-c", command, testId};
                p = Runtime.getRuntime().exec(cmd);
                br = new BufferedReader(new InputStreamReader(p.getInputStream()));
                if((s = br.readLine()) != null) {
                    sb.append(s);
                }
                p.waitFor();
                logger.info(sb.toString());
            }catch(Exception e){
                e.printStackTrace();
            }finally {
                p.destroy();
            }
        }

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }
}
