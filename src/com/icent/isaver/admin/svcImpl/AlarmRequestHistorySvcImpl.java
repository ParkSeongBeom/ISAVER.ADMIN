package com.icent.isaver.admin.svcImpl;

import com.icent.isaver.admin.svc.AlarmRequestHistorySvc;
import com.icent.isaver.admin.util.AdminHelper;
import com.icent.isaver.repository.bean.AlarmRequestHistoryBean;
import com.icent.isaver.repository.bean.AlarmRequestHistoryDetailBean;
import com.icent.isaver.repository.dao.base.AlarmRequestHistoryDao;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import javax.inject.Inject;
import java.util.List;
import java.util.Map;

/**
 * Created by icent on 2016. 11. 24..
 */
@Service
public class AlarmRequestHistorySvcImpl implements AlarmRequestHistorySvc{

    @Inject
    private AlarmRequestHistoryDao alarmRequestHistoryDao;


    @Override
    public ModelAndView findListAlarmRequestHistory(Map<String, String> parameters) {
        List<AlarmRequestHistoryBean> alarmRequestHistoryList = alarmRequestHistoryDao.findListAlarmRequestHistory(parameters);
        Integer totalCount = alarmRequestHistoryDao.findCountAlarmRequestHistory(parameters);

        AdminHelper.setPageTotalCount(parameters, totalCount);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("alarmRequestHistoryList",alarmRequestHistoryList);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView findByAlarmRequestHistoryDetail(Map<String, String> parameters) {

        List<AlarmRequestHistoryDetailBean> alarmRequestHistoryList = alarmRequestHistoryDao.findByAlarmRequestHistoryDetail(parameters);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("alarmRequestHistoryDetail",alarmRequestHistoryList);
        return modelAndView;
    }

}
