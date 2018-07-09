package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.svc.FenceSvc;
import com.icent.isaver.repository.bean.FenceBean;
import com.icent.isaver.repository.dao.base.FenceDao;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import java.util.List;
import java.util.Map;

/**
 * 펜스 Service Implements
 * @author : psb
 * @version : 1.0
 * @since : 2018. 7. 9.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2018. 7. 9.     psb           최초 생성
 * </pre>
 */
@Service
public class FenceSvcImpl implements FenceSvc {

    @Inject
    private FenceDao fenceDao;

    @Override
    public ModelAndView findListFence(Map<String, String> parameters) {
        List<FenceBean> fenceList = fenceDao.findListFence(parameters);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("fenceList", fenceList);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }
}
