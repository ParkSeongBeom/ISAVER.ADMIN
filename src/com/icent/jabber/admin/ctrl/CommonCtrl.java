package com.icent.jabber.admin.ctrl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.svc.CommonSvc;
import com.kst.common.util.MapUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import java.util.Map;

/**
 * 공통 관련 Controller
 * @author : dhj
 * @version : 1.0
 * @since : 2014. 6. 13.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 6. 13.     dhj           최초 생성
 * </pre>
 */
@Controller
@RequestMapping(value="/common/*")
public class CommonCtrl {

    @Inject
    private CommonSvc commonSvc;

    /**
     * 다음 텍스트 편집기 호출
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET}, value="/editor")
    public ModelAndView editor(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("editor");
        return modelAndView;
    }

    /**
     * 다음 텍스트 사진팝업 호출
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST, RequestMethod.GET}, value="/popImage")
    public ModelAndView popImage(HttpServletRequest request, @RequestParam Map<String, String> parameters) {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("popImage");
        return modelAndView;
    }

    private final static String[] uploadImageParam = new String[]{"path"};

    /**
     * 다음 텍스트 사진업로드
     *
     * @author psb
     * @param request
     * @param parameters
     * @return
     */
    @RequestMapping(method={RequestMethod.POST,RequestMethod.GET}, value="uploadImage")
    public ModelAndView uploadImage(HttpServletRequest request, @RequestParam Map<String, String> parameters){
        if(MapUtils.nullCheckMap(parameters, uploadImageParam)){
            throw new JabberException("");
        }

        ModelAndView modelAndView = commonSvc.uploadImage(request, parameters);

        return modelAndView;
    }
}
