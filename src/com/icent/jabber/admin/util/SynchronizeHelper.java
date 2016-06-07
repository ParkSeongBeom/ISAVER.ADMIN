package com.icent.jabber.admin.util;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.repository.bean.*;
import com.icent.jabber.repository.dao.base.*;
import com.kst.common.bean.CommonResourceBean;
import com.kst.common.util.StringUtils;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;

import javax.inject.Inject;
import java.lang.reflect.Type;
import java.util.*;

/**
 * 동기화 요청 biz helper
 *
 * @author : psb
 * @version : 1.0
 * @since : 2015. 12. 23.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2015. 12. 23.     psb           최초 생성
 * </pre>
 */
public class SynchronizeHelper {
    @Inject
    public RequestSynchronizeDao requestSynchronizeDao;

    @Inject
    public SynchronizeUserDao synchronizeUserDao;

    @Inject
    public SynchronizeUserInfoDao synchronizeUserInfoDao;

    @Inject
    public SynchronizeUserDetailDao synchronizeUserDetailDao;

    @Inject
    public SettingServerSynchronizeDao settingServerSynchronizeDao;

    @Inject
    public FunctionDao functionDao;

    private final String FUNC_ID = "uc.sync";

    /**
     * [요청이력] 요청구성 코드
     * 0 : 0001 (사용자 업로드)
     * 1 : 0002 (사용자 직접입력)
     * 2 : 0003 (인사연동 에이전트)
     * 3 : 0004 (전체동기화)
     * 4 : 0005 (재요청)
     */
    private final String[] REQUEST_METHOD_CODE = new String[]{"0001","0002","0003","0004","0005"};

    /**
     * [요청이력] 요청구분 코드
     * 0 : 0001 (전체)
     * 1 : 0002 (개별)
     */
    private final String[] REQUEST_TYPE_CODE = new String[]{"0001","0002"};

    /**
     * [요청이력] 처리상태 코드
     * 0 : 0001 (대기)
     * 1 : 0002 (처리중)
     * 2 : 0003 (종료)
     */
    private final String[] REQUEST_STATE_CODE = new String[]{"0001","0002","0003"};

    /**
     * [요청작업] 동기화 작업 코드
     * 0 : 0001 (등록)
     * 1 : 0002 (수정)
     * 2 : 0003 (삭제)
     */
    private final Map<String, String> SYNC_TYPE_CODE = new HashMap(){{
        put("INS", "0001");
        put("UPD", "0002");
        put("DEL", "0003");
    }};

    /**
     * [요청작업] 동기화 처리상태 코드
     * 0 : 0001 (대기)
     * 1 : 0002 (성공)
     * 2 : 0003 (실패)
     */
    private final String[] SYNC_STATE_CODE = new String[]{"0001","0002","0003"};

    private final Map<String, String> SETTING_ID_CODE = new HashMap(){{
        put("adLdapUseYn", "adLdap");
        put("cucmUseYn", "cucm");
        put("cupUseYn", "cup");
        put("cucUseYn", "cuc");
        put("webexUseYn", "webex");
    }};

    public String[] addSynchronize(boolean ucSyncCheckYn, String requestUserId, String reqMethod, String reqType){
        return addSynchronize(ucSyncCheckYn, requestUserId, reqMethod, reqType, new LinkedList<SynchronizeUserBean>());
    }

    public String[] addSynchronize(boolean ucSyncCheckYn, String requestUserId, String reqMethod, String reqType, String synchronizeUserList){
        return addSynchronize(ucSyncCheckYn, requestUserId, reqMethod, reqType, getSynchronizeUserList(synchronizeUserList));
    }

    public String[] addSynchronize(boolean ucSyncCheckYn, String requestUserId, String reqMethod, String reqType, SynchronizeUserBean synchronizeUser){
        return addSynchronize(ucSyncCheckYn, requestUserId, reqMethod, reqType, getSynchronizeUserList(synchronizeUser));
    }

    private String[] addSynchronize(boolean ucSyncCheckYn, String requestUserId, String reqMethod, String reqType, List<SynchronizeUserBean> synchronizeUserList){
        /* uc 동기화 사용여부 validation */
        if(ucSyncCheckYn){
            FunctionBean function = functionDao.findByFunction(new FunctionBean(){{setFuncId(FUNC_ID);}});
            if(function==null){
                throw new JabberException("",FUNC_ID+" is null");
            }
            if(function.getUseYn().equals("N")){
                throw new JabberException("",FUNC_ID+" not in use");
            }
        }

        RequestSynchronizeBean requestSynchronizeBean = new RequestSynchronizeBean();
        requestSynchronizeBean.setRequestId(StringUtils.getGUID36());
        requestSynchronizeBean.setMethod(reqMethod);
        requestSynchronizeBean.setType(reqType);
        requestSynchronizeBean.setState(REQUEST_STATE_CODE[0]);
        requestSynchronizeBean.setRequestUserId(requestUserId);
        /* 요청이력 등록 */
        requestSynchronizeDao.addRequestSynchronize(requestSynchronizeBean);

        if(!REQUEST_METHOD_CODE[3].equals(reqMethod)){ // 전체동기화가 아닐경우만 실행
            for (SynchronizeUserBean synchronizeUser : synchronizeUserList){
                synchronizeUser.setSyncUserId(StringUtils.getGUID36());
                synchronizeUser.setRequestId(requestSynchronizeBean.getRequestId());
            /* 요청계정 등록 */
                synchronizeUserDao.addSynchronizeUser(synchronizeUser);

                if(REQUEST_TYPE_CODE[1].equals(reqType)) { // 개별
                    for (SynchronizeUserInfoBean synchronizeUserInfo : synchronizeUser.getInfoBeans()){
                        synchronizeUserInfo.setSyncUserId(synchronizeUser.getSyncUserId());
                    /* 요청계정정보 등록 */
                        synchronizeUserInfoDao.addSynchronizeUserInfo(synchronizeUserInfo);
                    }

                    for (SynchronizeUserDetailBean synchronizeUserDetail : synchronizeUser.getDetailBeans()){
                        synchronizeUserDetail.setSyncUserId(synchronizeUser.getSyncUserId());
                        synchronizeUserDetail.setState(SYNC_STATE_CODE[0]);

                        if(StringUtils.notNullCheck(SYNC_TYPE_CODE.get(synchronizeUserDetail.getType()))){
                            synchronizeUserDetail.setType(SYNC_TYPE_CODE.get(synchronizeUserDetail.getType()));
                        }else{
                            throw new JabberException("",FUNC_ID+" not in use");
                        }

                        if(StringUtils.nullCheck(synchronizeUserDetail.getTarget())){
                            List<SettingServerSynchronizeBean> settings =  settingServerSynchronizeDao.findListSettingServerSynchronize(new HashMap<String, String>(){{put("searchId","UseYn"); put("value","Y");}});
                            for(SettingServerSynchronizeBean setting : settings){
                                if(StringUtils.notNullCheck(SETTING_ID_CODE.get(setting.getSettingId()))){
                                    synchronizeUserDetail.setDetailId(StringUtils.getGUID36());
                                    synchronizeUserDetail.setTarget(SETTING_ID_CODE.get(setting.getSettingId()));
                                /* 요청작업 등록 */
                                    synchronizeUserDetailDao.addSynchronizeDetail(synchronizeUserDetail);
                                }
                            }
                        }else{
                        /* 요청작업 등록 */
                            synchronizeUserDetail.setDetailId(StringUtils.getGUID36());
                            synchronizeUserDetail.setTarget(SETTING_ID_CODE.get(synchronizeUserDetail.getTarget()));
                            synchronizeUserDetailDao.addSynchronizeDetail(synchronizeUserDetail);
                        }
                    }
                }
            }
        }
        return new String[]{CommonResourceBean.SUCCESS,""};
    }

    private List<SynchronizeUserBean> getSynchronizeUserList(String synchronizeUsers){
        List<SynchronizeUserBean> synchronizeUserList = null;
        try{
            ObjectMapper mapper = new ObjectMapper();
            synchronizeUserList = Arrays.asList(mapper.readValue(synchronizeUsers, SynchronizeUserBean[].class));
        }catch(Exception e){
            throw new JabberException("","getSynchronizeUserList parse error");
        }
        return synchronizeUserList;
    }

    private List<SynchronizeUserBean> getSynchronizeUserList(SynchronizeUserBean synchronizeUsers){
        List<SynchronizeUserBean> synchronizeUserList = new LinkedList<>();
        synchronizeUserList.add(synchronizeUsers);
        return synchronizeUserList;
    }
}
