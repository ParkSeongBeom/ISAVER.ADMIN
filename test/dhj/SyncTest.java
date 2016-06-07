package dhj;


import com.icent.jabber.admin.resource.AdminSyncResource;
import com.icent.jabber.admin.svc.SettingServerSynchronizeSvc;
import com.icent.jabber.admin.util.AdminHelper;
import com.icent.jabber.repository.bean.SettingServerSynchronizeBean;
import com.icent.jabber.repository.bean.UserBean;
import com.icent.jabber.repository.bean.UserUploadBean;
import com.icent.jabber.repository.dao.base.SettingServerSynchronizeDao;

import com.icent.jabber.repository.dao.base.UserDao;
import com.kst.common.util.StringUtils;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.inject.Inject;
import java.util.*;

import static com.icent.jabber.admin.util.AdminHelper.*;

/**
 * Created by icent on 16. 1. 13..
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:spring/context-*.xml"})
public class SyncTest {

    protected static Logger logger = LoggerFactory.getLogger(SyncTest.class);

    @Inject
    public SettingServerSynchronizeDao settingServerSynchronizeDao;

    @Inject
    private SettingServerSynchronizeSvc settingServerSynchronizeSvc;

    @Inject
    private UserDao userDao;


    @Test
    public void settingServerSynchronizeDaoTest() {
//        List<SettingServerSynchronizeBean> settings =  settingServerSynchronizeDao.findListSettingServerSynchronize(new HashMap<String, String>(){{put("searchId","UseYn"); put("value","Y");}});
        List<SettingServerSynchronizeBean> settings =  settingServerSynchronizeDao.findListSettingServerSynchronize(new HashMap<String, String>(){{put("searchId","cucTime"); put("searchId","cucPassword");}});

        System.out.println("");
    }

    @Test
    public void settingServerSynchronizeSvcTest() {
        Map<String, String> settingServerSyncMap = settingServerSynchronizeSvc.getSettingServerSyncFunc();

        System.out.println(settingServerSyncMap.size());
    }

    @Test
    public void beanDiffTest() {
        List<UserBean> allUserList = userDao.findAllUser();

        Map<String,String> ldapList = new HashMap<>();

        ldapList.put("userId", "dev05");
        ldapList.put("title", "대리");
        ldapList.put("telephoneNumber", "1111");
        UserUploadBean resultBean =  userBeanDiff("dev05", ldapList, allUserList);

        System.out.println("");
    }

    private UserUploadBean userBeanDiff(String userId, Map<String, String> targetParamMap, List<UserBean> findAllUserList) {

        UserUploadBean userUploadBean = this.findByUserFunc(userId, findAllUserList);

        if (userUploadBean.getUserFindFlag() ) {

            UserBean jappleBean = userUploadBean.getUserBean();

            String title                             = targetParamMap.get(AdminSyncResource.TITLE_NAMESPACE);
            String telephoneNumber = targetParamMap.get(AdminSyncResource.TELEPHONENUMBER_NAMESPACE);
            String mobile                       = targetParamMap.get(AdminSyncResource.MOBILE_NAMESPACE);
            String mail                           = targetParamMap.get(AdminSyncResource.MAIL_NAMESPACE);
            String name                          = targetParamMap.get(AdminSyncResource.NAME_NAMESPACE);

            /* 직책 */
            if (!jappleBean.getClassification().equals(title) && !AdminHelper.convertNullToString(title).equals("")) {
                targetParamMap.put(AdminSyncResource.CLASSIFICATION_NAMEPSPACE, title);
            } else {
                targetParamMap.put(AdminSyncResource.CLASSIFICATION_NAMEPSPACE, jappleBean.getClassification());
            }

            /* 내선 번호 */
            if (!jappleBean.getExtension().equals(telephoneNumber) && !AdminHelper.convertNullToString(telephoneNumber).equals("")) {
                targetParamMap.put(AdminSyncResource.EXTENSION_NAMESPACE, title);
            } else {
                targetParamMap.put(AdminSyncResource.EXTENSION_NAMESPACE, jappleBean.getExtension());
            }

            /* 휴대폰 번호 */
            if (!jappleBean.getMobile().equals(mobile) && !AdminHelper.convertPhoneFormat(mobile, true).equals("")) {
                targetParamMap.put(AdminSyncResource.MOBILE_NAMESPACE, title);
            } else {
                targetParamMap.put(AdminSyncResource.MOBILE_NAMESPACE, jappleBean.getExtension());
            }

            /* 이메일 */
            if (!jappleBean.getEmail().equals(mail) && !AdminHelper.convertNullToString(mail).equals("")) {
                targetParamMap.put(AdminSyncResource.EMAIL_NAMESPACE, mail);
            } else {
                targetParamMap.put(AdminSyncResource.EMAIL_NAMESPACE, jappleBean.getEmail());
            }

            /* 이름 */
            if (!jappleBean.getUserName().equals(name) && !AdminHelper.convertNullToString(name).equals("")) {
                targetParamMap.put(AdminSyncResource.USERNAME_NAMESPACE, name);
            } else {
                targetParamMap.put(AdminSyncResource.USERNAME_NAMESPACE, jappleBean.getUserName());
            }

            targetParamMap.put(AdminSyncResource.MODE, AdminSyncResource.UPDATE);


        } else {
            targetParamMap.put(AdminSyncResource.MODE, AdminSyncResource.INSERT);
        }

        userUploadBean.setResultMap(targetParamMap);

        return userUploadBean;
    }

    private UserUploadBean findByUserFunc(String userId, List<UserBean> findAllUserList) {

        UserUploadBean userUploadBean = new UserUploadBean();

        if (findAllUserList != null) {
            for (int i = 0; i < findAllUserList.size(); i++) {
                try {
                    if (findAllUserList.get(i).getUserId().equals(userId)) {
                        userUploadBean.setUserFindFlag(true);
                        userUploadBean.setUserBean(findAllUserList.get(i));
                        break;
                    }
                } catch(NullPointerException e) {
                    logger.warn(e.getCause().toString());
                } finally {

                }

            }
        }

        return userUploadBean;
    }

}
