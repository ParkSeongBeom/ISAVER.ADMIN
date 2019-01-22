package com.icent.isaver.admin.ctrl;

import com.icent.isaver.admin.resource.AdminResource;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.net.InetAddress;
import java.util.Map;

@Controller
@RequestMapping(value="/resource/*")
public class ResourceCtrl {

    @Value("${ws.server.address}")
    private String wsAddress = null;

    @Value("${ws.server.port}")
    private String wsPort = null;

    @Value("${ws.server.projectName}")
    private String wsProjectName = null;

    @Value("${ws.server.ptzUrlConnect}")
    private String wsPtzUrlConnect = null;

    /**
     * 구역/장치 관리 페이지 요청.
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="/list")
    public ModelAndView findListResource(HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, String> parameters){
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("resourceList");
        modelAndView.addObject("iConFileType", AdminResource.FILE_TYPE.get("icon"));

        try {
            InetAddress address = InetAddress.getByName(wsAddress);
            modelAndView.addObject("ptzWebSocketUrl", "ws://" + address.getHostAddress() + ":" + wsPort + "/" + wsProjectName + wsPtzUrlConnect);
        }catch (Exception e){}
        return modelAndView;
    }
}