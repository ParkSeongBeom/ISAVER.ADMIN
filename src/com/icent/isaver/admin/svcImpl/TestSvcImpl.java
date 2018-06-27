package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.svc.TestSvc;
import com.icent.isaver.admin.util.AlarmRequestUtil;
import com.icent.isaver.repository.bean.AreaBean;
import com.icent.isaver.repository.bean.DeviceBean;
import com.icent.isaver.repository.dao.base.AreaDao;
import com.icent.isaver.repository.dao.base.DeviceDao;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.text.SimpleDateFormat;
import java.util.Date;
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

    @Override
    public ModelAndView testList(HttpServletRequest request, Map<String, String> parameters) {
        List<AreaBean> areaList = areaDao.findListAreaForTest();
        List<DeviceBean> deviceList = deviceDao.findListDeviceForTest();
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("areaList",areaList);
        modelAndView.addObject("deviceList",deviceList);
        return modelAndView;
    }

    @Override
    public ModelAndView eventSend(HttpServletRequest request, Map<String, String> parameters) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
        parameters.put("type","D");
        parameters.put("time",sdf.format(new Date()));

        try {
            AlarmRequestUtil.sendAlarmRequestFunc(parameters, "http://" + ipAddress + ":" + port + "/" + projectName + eventAddUrl, "form", null);
        } catch (IOException e) {
            e.printStackTrace();
        }

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("paramBean",parameters);
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
