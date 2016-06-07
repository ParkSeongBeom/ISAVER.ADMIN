package kst;


import com.icent.jabber.repository.bean.BussinessBoardBean;
import com.icent.jabber.repository.bean.BussinessInfoBean;
import com.icent.jabber.repository.dao.base.BussinessBoardDao;
import com.icent.jabber.repository.dao.base.BussinessInfoDao;
import com.kst.common.springutil.TransactionUtil;
import com.kst.common.util.StringUtils;
import org.apache.ibatis.datasource.DataSourceException;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.TransactionStatus;

import javax.annotation.Resource;
import javax.inject.Inject;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:spring/context-*.xml"})
public class bussinessBoardTest {

    @Inject
    private BussinessBoardDao bussinessBoardDao;

    @Inject
    private BussinessInfoDao bussinessInfoDao;

    @Resource(name="mybatisBaseTxManager")
    private DataSourceTransactionManager transactionManager;

    @Test
    public void addTest(){
        BussinessBoardBean bean = new BussinessBoardBean();
        String id = StringUtils.getGUID36();
        System.out.println(id);

        bean.setBussinessId(id);
        bean.setTitle("사업");
        Calendar startCalendar = Calendar.getInstance();
        startCalendar.set(2015, 7, 26, 9, 10, 0);
        bean.setStartDatetime(startCalendar.getTime());

        Calendar endCalendar = Calendar.getInstance();
        endCalendar.set(2015, 7, 26, 10, 10, 0);
        bean.setEndDatetime(endCalendar.getTime());

        bean.setAlldayYn("N");
        bean.setInsertUserId("dev09");


        List<BussinessInfoBean> infoBeanList = new ArrayList<>();
        for(int index=0; index<5; index++){
            BussinessInfoBean infoBean = new BussinessInfoBean();
            infoBean.setBussinessId(id);
            infoBean.setKey(String.valueOf(index));
            infoBean.setValue(String.valueOf(index));
            infoBeanList.add(infoBean);
        }

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            bussinessBoardDao.addBussinessBoard(bean);
            bussinessInfoDao.addBussinessInfoForList(infoBeanList);
            transactionManager.commit(transactionStatus);
        }catch(DataSourceException e){
            transactionManager.rollback(transactionStatus);
            System.out.println(e);
        }
    }

    @Test
    public void getBussinessBoard(){
        List<BussinessBoardBean> beanList = bussinessBoardDao.findListBussinessBoard(null);
        for(BussinessBoardBean bean : beanList){
            System.out.println(bean);
        }
        //028c912a-827d-4f7c-8b24-cd5084d1cbbd
    }

}
