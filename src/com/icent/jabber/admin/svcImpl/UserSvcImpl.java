package com.icent.jabber.admin.svcImpl;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.svc.OrganizationSvc;
import com.icent.jabber.admin.svc.SettingServerSynchronizeSvc;
import com.icent.jabber.admin.svc.UserSvc;
import com.icent.jabber.admin.util.AdminHelper;
import com.icent.jabber.admin.util.SynchronizeHelper;
import com.icent.jabber.repository.bean.*;
import com.icent.jabber.repository.dao.base.*;
import com.kst.common.bean.CommonResourceBean;
import com.kst.common.helper.FileTransfer;
import com.kst.common.springutil.TransactionUtil;
import com.kst.common.util.FileNioUtil;
import com.kst.common.util.POIExcelUtil;
import com.kst.common.util.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionStatus;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.inject.Inject;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.lang.reflect.Type;
import java.nio.file.Paths;
import java.util.*;

/**
 * 사용자 관리 Service Implements
 *
 * @author : kst
 * @version : 1.0
 * @since : 2014. 6. 2.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 6. 2.     kst           최초 생성
 * </pre>
 */
@Service
public class UserSvcImpl implements UserSvc {

    @Inject
    private UserDao userDao;

    @Inject
    private OrganizationSvc organizationSvc;

    @Inject
    private OrgUserDao orgUserDao;

    @Inject
    private OrganizationDao organizationDao;

    @Inject
    private TargetDao targetDao;

    @Inject
    private UserSettingDao userSettingDao;

    @Inject
    private FunctionDao functionDao;

    @Inject
    private SynchronizeHelper synchronizeHelper;

    @Inject
    private TargetSynchronizeDao targetSynchronizeDao;

    @Inject
    private SettingServerSynchronizeSvc settingServerSynchronizeSvc;

    @Resource(name="mybatisBaseTxManager")
    private DataSourceTransactionManager transactionManager;

    @Value("#{configProperties['cnf.profileUploadPath']}")
    private String profileUploadPath;

    @Value("#{configProperties['cnf.path.photoUrl']}")
    private String photoUrl;

    @Value("#{configProperties['cnf.profilePhotoExtension']}")
    private String profilePhotoFileExtension;

    @Value("#{configProperties['cnf.path.tempUpload']}")
    private String tempUploadPath;

    @Value("#{configProperties['cnf.path.excelSamplePath']}")
    private String sampleExcelPath;

    private String orgRootId = "ORG00000-0000-0000-0000-000000000000";

    @Override
    public ModelAndView findAllUser(Map<String, String> parameters) {
        List<UserBean> users = userDao.findListUser(parameters);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("users",users);
        return modelAndView;
    }

    @Override
    public ModelAndView findListUser(Map<String, String> parameters) {
        List<UserBean> users = userDao.findListUser(parameters);
        Integer totalCount = userDao.findCountUser(parameters);

        AdminHelper.setPageTotalCount(parameters, totalCount);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("users",users);
        modelAndView.addObject("paramBean",parameters);
        return modelAndView;
    }

    @Override
    public ModelAndView findByUser(Map<String, String> parameters) {
        TargetBean target = targetDao.findAllTarget();

        UserBean paramBean = AdminHelper.convertMapToBean(parameters, UserBean.class);
        OrgUserBean orgUserBean = AdminHelper.convertMapToBean(parameters, OrgUserBean.class);
        UserBean user = null;
        List<OrganizationBean> organizations = null;
        List<OrgUserBean> orgUsers = null;
        OrgUserBean orgUser = null;

        ModelAndView modelAndView = new ModelAndView();

        Map<String, String> objectAsMap = new HashMap<>();

        if(StringUtils.notNullCheck(paramBean.getUserId())) {
            user = userDao.findByUser(paramBean);

            organizations = organizationSvc.findAllOrganization();
            modelAndView.addObject("organizations",organizations);

            orgUsers = userDao.findAllUserExistsOrg(paramBean);
            modelAndView.addObject("orgUsers",orgUsers);

            orgUser = orgUserDao.findByOrgUser(orgUserBean);
            modelAndView.addObject("orgUser",orgUser);

            List<UserSettingBean> list = userSettingDao.findListUserSetting(parameters);

            for (UserSettingBean bean : list) {
                objectAsMap.put(bean.getKey(), bean.getValue());
            }
            modelAndView.addObject("userSettings",objectAsMap);
        } else {
//            objectAsMap =  settingServerSynchronizeSvc.getSettingServerSyncFunc();
//            modelAndView.addObject("syncSettings",objectAsMap);

            List<OrganizationBean> organizationTreeList = organizationDao.findAllOrganizationTree(null);
            modelAndView.addObject("organizationList", organizationTreeList);
        }

        FunctionBean funcParam = new FunctionBean();
//        funcParam.setFuncId("uc.sync");
//        FunctionBean ucSync = functionDao.findByFunction(funcParam);

        modelAndView.addObject("photoPath",photoUrl);
        modelAndView.addObject("user",user);
//        modelAndView.addObject("ucSyncYn",ucSync.getUseYn());
        modelAndView.addObject("domain",target.getDomain());
        return modelAndView;
    }

    @Override
    public ModelAndView findByUserCheckExist(Map<String, String> parameters) {
        UserBean paramBean = AdminHelper.convertMapToBean(parameters, UserBean.class);

        Integer count = userDao.findByUserCheckExist(paramBean);
        String existFlag = count > 0 ? CommonResourceBean.YES : CommonResourceBean.NO;

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("exist",existFlag);

        return modelAndView;
    }

    @Override
    public ModelAndView addUser(HttpServletRequest request, Map<String, String> parameters) {
        UserBean paramBean = AdminHelper.convertMapToBean(parameters, UserBean.class);

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        File photoFile = null;
        File oldFile = null;
        try {
            String photoFileName = paramBean.getUserId() + CommonResourceBean.PERIOD_STRING + profilePhotoFileExtension;
            photoFile = FileTransfer.upload(request, "profile_photo",1024,profileUploadPath,null,photoFileName);

            if(photoFile != null){
                //String photoFileName = getPhotoFileNameForExtension(photoFile.getName());
                //FileNioUtil.renameFile(photoFile.getAbsolutePath(), photoFileName, true);
                //oldFile = processForExistProfileImage(photoFile, photoFileName);
                paramBean.setPhotoFilePath(photoFileName);
            }

            userDao.addUser(paramBean);
            UserBean userBean = userDao.findByUser(paramBean);
            if(userBean != null) {
                OrgUserBean orgUserBean = AdminHelper.convertMapToBean(parameters, OrgUserBean.class);

                if (!orgUserBean.getOrgId().equals("-1")) {
                    orgUserBean.setUserId(userBean.getUserId());
                    orgUserBean.setClassification(userBean.getClassification());
                    orgUserDao.addOrgUser(orgUserBean);
                }
            }
            /* 계정관리 주석 처리 : 소장님 지시 사항, @author dhj, @since 2016-02-01 */
            /*
            userSettingDao.upsertUserListSetting(getUserSettingBeanList(parameters));

            if(StringUtils.notNullCheck(parameters.get("synchronizeUserList"))){
                synchronizeHelper.addSynchronize(true, parameters.get("insertUserId"),"0002","0002",parameters.get("synchronizeUserList"));
            }
            */
            transactionManager.commit(transactionStatus);
        }catch(IOException | DataAccessException e){
            transactionManager.rollback(transactionStatus);

            String fileName = null;
            if(photoFile != null){
                fileName = photoFile.getName();
                photoFile.delete();
            }

            if(oldFile != null){
                try {
                    FileNioUtil.renameFile(oldFile.getAbsolutePath(), fileName);
                } catch (IOException e1) {
                    e1.printStackTrace();
                }
            }
            throw new JabberException("");
        }catch(Exception e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        if(oldFile != null){
            oldFile.delete();
        }
        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView saveUser(HttpServletRequest request, Map<String, String> parameters) {
        UserBean paramBean = AdminHelper.convertMapToBean(parameters, UserBean.class);

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        File photoFile = null;
        File oldFile = null;
        try {
            String photoFileName = paramBean.getUserId() + CommonResourceBean.PERIOD_STRING + profilePhotoFileExtension;
            photoFile = FileTransfer.upload(request, "profile_photo",1024,profileUploadPath,null,photoFileName);

            if(photoFile != null){
                //String photoFileName = getPhotoFileNameForExtension(photoFile.getName());
                //FileNioUtil.renameFile(photoFile.getAbsolutePath(), photoFileName, true);
                //oldFile = processForExistProfileImage(photoFile, photoFileName);
                paramBean.setPhotoFilePath(photoFileName);
            }

            userDao.saveUser(paramBean);

            if(StringUtils.notNullCheck(parameters.get("orgId"))){
                OrgUserBean orgUserBean = AdminHelper.convertMapToBean(parameters, OrgUserBean.class);
                orgUserDao.removeOrgUsersFromUser(orgUserBean);

                if (!orgUserBean.getOrgId().equals("-1")) {
                    orgUserDao.addOrgUser(orgUserBean);
                }
            }

            /* 계정관리 주석 처리 : 소장님 지시 사항, @author dhj, @since 2016-02-01 */
            /*
            userSettingDao.upsertUserListSetting(getUserSettingBeanList(parameters));

            if(StringUtils.notNullCheck(parameters.get("synchronizeUserList"))){
                synchronizeHelper.addSynchronize(true, parameters.get("updateUserId"),"0002","0002",parameters.get("synchronizeUserList"));
            }
            */
            transactionManager.commit(transactionStatus);
        }catch(IOException | DataAccessException e){
            transactionManager.rollback(transactionStatus);
            String fileName = null;
            if(photoFile != null){
                fileName = photoFile.getName();
                photoFile.delete();
            }

            if(oldFile != null){
                try {
                    FileNioUtil.renameFile(oldFile.getAbsolutePath(), fileName);
                } catch (IOException e1) {
                    e1.printStackTrace();
                }
            }
            throw new JabberException("");
        }catch(Exception e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        if(oldFile != null){
            oldFile.delete();
        }
        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    private List<UserSettingBean> getUserSettingBeanList(Map<String, String> parameters){
        List<UserSettingBean> userSettingBeanList = new ArrayList<>();

        for (Map.Entry<String, String> entry : parameters.entrySet() ) {
            if(entry.getKey().equals("adLdapUseYn") ||
                    entry.getKey().equals("cucmUseYn") ||
                    entry.getKey().equals("cupUseYn") ||
                    entry.getKey().equals("cucUseYn") ||
                    entry.getKey().equals("webexUseYn")){
                UserSettingBean bean = new UserSettingBean();
                bean.setUserId(parameters.get("userId"));
                bean.setKey(entry.getKey());
                bean.setValue(entry.getValue());
                userSettingBeanList.add(bean);
            }
        }

        return userSettingBeanList;
    }

    @Override
    public ModelAndView removeUser(Map<String, String> parameters) {
        UserBean paramBean = AdminHelper.convertMapToBean(parameters, UserBean.class);
        OrgUserBean orgUserBean = AdminHelper.convertMapToBean(parameters, OrgUserBean.class);

        TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);
        try{
            userDao.removeUser(paramBean);
            if(StringUtils.notNullCheck(parameters.get("synchronizeUserList"))){
                synchronizeHelper.addSynchronize(true, parameters.get("updateUserId"),"0002","0002",parameters.get("synchronizeUserList"));
            }
            transactionManager.commit(transactionStatus);
        }catch(DataAccessException e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }catch(Exception e){
            transactionManager.rollback(transactionStatus);
            throw new JabberException("");
        }

        UserBean targetUserBean = userDao.findByUser(paramBean);
        if(targetUserBean != null && StringUtils.notNullCheck(targetUserBean.getPhotoFilePath())){
            FileNioUtil.deleteFile(Paths.get(profileUploadPath,targetUserBean.getPhotoFilePath()));
        }

        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView findListOrgUser(Map<String, String> parameters) {
        FindBean paramBean = AdminHelper.convertMapToBean(parameters, FindBean.class);

        ArrayList<HashMap<String,Object>> orgUsers = userDao.findAllUserOrgUser(paramBean);
        Integer totalCount = userDao.findCountUserOrgUser(paramBean);

        AdminHelper.setPageTotalCount(paramBean, totalCount);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("users", orgUsers);
        modelAndView.addObject("paramBean",paramBean);
        return modelAndView;
    }

    private String getPhotoFileNameForExtension(String photoFileName){
        if(StringUtils.notNullCheck(photoFileName)){
            return photoFileName.substring(0, photoFileName.lastIndexOf(CommonResourceBean.PERIOD_STRING) + 1) + profilePhotoFileExtension;
        }

        return CommonResourceBean.EMPTY_STRING;
    }

    private File processForExistProfileImage(File uploadFile, String fileNewName) throws IOException {
        File file = new File(uploadFile.getParent() + File.separator + fileNewName);

        if(file.exists()){
            String tempFileName = UUID.randomUUID().toString() + CommonResourceBean.PERIOD_STRING + StringUtils.getExtension(file.getName());
            FileNioUtil.renameFile(file.getAbsolutePath(), tempFileName);
            file = new File(uploadFile.getParent() + File.separator +tempFileName);
            //file.delete();
            //file = null;
        }else{
            file = null;
        }

        FileNioUtil.renameFile(uploadFile.getAbsolutePath(), fileNewName, true);

        return file;
    }

    @Override
    public ModelAndView uploadUserInfoExcel(HttpServletRequest request, Map<String, String> parameters) {
        TargetBean target = targetDao.findAllTarget();
        List<Map<String,String>> resultList = new LinkedList<>();
        List<UserBean> allUserList = userDao.findAllUser();
        List<Map<String, String>> userListMap = null;

        File file = null;

        try {
            file = FileTransfer.upload(request, "excel", 1024, tempUploadPath);
            userListMap = POIExcelUtil.readExcelFile(file, 2, new String[]{"userId", "japplePassword","position","classification","userName","extension","phone","mobile","email"});
        } catch(IOException e) {
            throw new JabberException("");
        } finally {
            if(file != null){
                file.delete();
            }
        }

        // Japple 사용자목록과 비교 후 값이 다르거나 없을경우 List에 추가
        for(Map<String, String> excelUser : userListMap){
            Map<String, String> addUser = new HashMap<>();
            addUser.put("userId",AdminHelper.convertNullToString(excelUser,"userId"));
            addUser.put("japplePassword",AdminHelper.convertNullToString(excelUser,"japplePassword"));
            addUser.put("orgName","");
            addUser.put("position",AdminHelper.convertNullToString(excelUser,"position"));
            addUser.put("phone",AdminHelper.convertNullToString(excelUser,"phone"));
            addUser.put("classification",AdminHelper.convertNullToString(excelUser,"classification"));
            addUser.put("userName",AdminHelper.convertNullToString(excelUser,"userName"));
            addUser.put("extension",AdminHelper.convertNullToString(excelUser,"extension"));
            addUser.put("mobile", AdminHelper.convertNullToString(excelUser,"mobile"));
            addUser.put("email", AdminHelper.convertNullToString(excelUser,"email"));
            addUser.put("mode", "INS");
            addUser.put("domain", target.getDomain());

            /**
             * 0 : 신규
             * 1 : 수정
             * 2 : Japple사용자와 데이터 일치
             */
            int flagValue = 0;

            for(UserBean user : allUserList) {
                if(addUser.get("userId").equals(user.getUserId())){
                    if(  !addUser.get("japplePassword").equals(AdminHelper.convertNullToString(user.getJapplePassword())) ||
                         !addUser.get("position").equals(AdminHelper.convertNullToString(user.getPosition())) ||
                         !addUser.get("classification").equals(AdminHelper.convertNullToString(user.getClassification())) ||
                         !addUser.get("userName").equals(AdminHelper.convertNullToString(user.getUserName())) ||
                         !addUser.get("extension").equals(AdminHelper.convertNullToString(user.getExtension())) ||
                         !addUser.get("phone").equals(AdminHelper.convertNullToString(user.getPhone())) ||
                         !addUser.get("mobile").equals(AdminHelper.convertNullToString(user.getMobile())) ||
                         !addUser.get("email").equals(AdminHelper.convertNullToString(user.getEmail())) ){
                        addUser.put("beforeJapplePassword",AdminHelper.convertNullToString(user.getJapplePassword()));
                        addUser.put("beforePosition",AdminHelper.convertNullToString(user.getPosition()));
                        addUser.put("beforeClassification",AdminHelper.convertNullToString(user.getClassification()));
                        addUser.put("beforeUserName",AdminHelper.convertNullToString(user.getUserName()));
                        addUser.put("beforeExtension",AdminHelper.convertNullToString(user.getExtension()));
                        addUser.put("beforePhone",AdminHelper.convertNullToString(user.getPhone()));
                        addUser.put("beforeMobile",AdminHelper.convertNullToString(user.getMobile()));
                        addUser.put("beforeEmail",AdminHelper.convertNullToString(user.getEmail()));
                        addUser.put("orgName",user.getOrgName());
                        addUser.put("mode","UPD");
                        flagValue = 1;
                    }else{
                        flagValue = 2;
                    }
                    break;
                }
            }

            if(flagValue!=2){
                resultList.add(addUser);
            }
        }

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("userList", resultList);
        return modelAndView;
    }

    @Override
    public void downloadUserInfoExcel(HttpServletRequest request, HttpServletResponse response) {
        File file = new File(sampleExcelPath);
        try {
            FileTransfer.download(request, response, file, "\"" + file.getName() + "\"", 1024);
        } catch (ServletException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Override
    public ModelAndView downloadUserPhotoFile(Map<String, String> parameters, HttpServletRequest request, HttpServletResponse response) {
        UserBean paramBean = AdminHelper.convertMapToBean(parameters, UserBean.class);
        UserBean user = userDao.findByUser(paramBean);

        if(StringUtils.notNullCheck(user.getPhotoFilePath())) {
            try {
                if (new File(profileUploadPath + user.getPhotoFilePath()).exists()) {
                    FileTransfer.download(request, response, profileUploadPath  + user.getPhotoFilePath(), "\"" + user.getPhotoFilePath() + "\"", 1024);
                }
            } catch(IOException | ServletException e) {
                throw new JabberException("");
            }
        }
        ModelAndView modelAndView = new ModelAndView();
        return modelAndView;
    }

    @Override
    public ModelAndView upsertAllUser(Map<String, String> parameters) {
        int resultValue = -1;

        if(userDao.findCountSynchronizeUser()>0){
            resultValue = 100;
        }else{
            String userList = "";
            String orgUserList = "";

            if (StringUtils.notNullCheck(parameters.get("userList"))) {
                userList = parameters.get("userList");
            }
            if (StringUtils.notNullCheck(parameters.get("orgUserList"))) {
                orgUserList = parameters.get("orgUserList");
            }

            Gson gson = new Gson();

            Type userType = new TypeToken<List<UserBean>>() {}.getType();
            Collection<UserBean> userCollection = gson.fromJson(userList, userType);

            Type orgUserType = new TypeToken<List<OrgUserBean>>() {}.getType();
            Collection<OrgUserBean> orgUserCollection = gson.fromJson(orgUserList, orgUserType);

            TransactionStatus transactionStatus = TransactionUtil.getMybatisTransactionStatus(transactionManager);

            try {
                if (userCollection != null && userCollection.size() > 0) {
                    userDao.upsertAllUser(userCollection);
                }
                if (orgUserCollection != null && orgUserCollection.size() > 0) {
                    orgUserDao.removeMainOrgUsers(orgUserCollection);
                    orgUserDao.addAllOrgUser(orgUserCollection);
                }

                if(StringUtils.notNullCheck(parameters.get("synchronizeUserList"))){
                    synchronizeHelper.addSynchronize(true, parameters.get("authUserId"),"0001","0002",parameters.get("synchronizeUserList"));
                }
                transactionManager.commit(transactionStatus);
                resultValue = 200;
            }catch(DataAccessException e){
                transactionManager.rollback(transactionStatus);
                throw new JabberException("");
            }catch(Exception e){
                transactionManager.rollback(transactionStatus);
                throw new JabberException("");
            }
        }

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("resultValue",resultValue);
        return modelAndView;
    }
}
