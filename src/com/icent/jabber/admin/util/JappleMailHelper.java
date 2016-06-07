package com.icent.jabber.admin.util;

import com.icent.jabber.repository.bean.*;
import com.icent.jabber.repository.dao.base.FunctionDao;
import com.icent.jabber.repository.dao.base.MailDao;
import com.icent.jabber.repository.dao.base.UserDao;
import com.kst.common.bean.CommonResourceBean;
import com.kst.common.helper.MailHelper;
import com.kst.common.helper.mail.CONTENT_TYPE;
import com.kst.common.helper.mail.MAIL_TYPE;
import com.kst.common.util.StringUtils;

import javax.inject.Inject;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by sungtae on 14. 11. 28..
 */
public class JappleMailHelper {

    public enum Type {
        MAINTANENCE_COMPLETE("MAINTANENCE.COMPLETE"), // 의뢰하기-완료
        NOTICE_REGISTE("NOTICE.REGIST"); // 공지

        private String value;

        Type(String value){
            this.value = value;
        }

        public String getValue(){
            return this.value;
        }
    }

    private final String FUNCTION_KEY = "mail.send";

    @Inject
    private MailDao mailDao;

    @Inject
    private UserDao userDao;

    @Inject
    private FunctionDao functionDao;

    @Inject
    private ServerConfigHelper serverConfigHelper;

    /**
     * 메일코드
     * 0 : 0001 (시스템자동선택)
     * 1 : 0002 (직접입력)
     */
    private final String[] MAIL_CODE = new String[]{"0001","0002"};

    public  String[] sendNotifyMail(Type type, String sender, String receivers, String title, String content){
        if(StringUtils.nullCheck(receivers)){
            return new String[]{CommonResourceBean.FAILURE, "parameter validate error"};
        }

        return sendNotifyMail(type, sender, receivers.split(CommonResourceBean.COMMA_STRING), title, content);
    }

    public String[] sendNotifyMail(Type type, String sender, String[] receivers, String title, String content){
        return sendNotifyMail(type, sender, getReceiverEmail(receivers), title, content);
    }

    private String[] sendNotifyMail(Type type, String sender, List<String> receivers, String title, String content){

        FunctionBean functionParam = new FunctionBean();
        functionParam.setFuncId(FUNCTION_KEY);
        FunctionBean functionBean = functionDao.findByFunction(functionParam);

        if(functionBean == null || !CommonResourceBean.YES.equalsIgnoreCase(functionBean.getUseYn())){
            return new String[]{CommonResourceBean.SUCCESS,"send mail disabled"};
        }

        ServerBean mailServer = serverConfigHelper.findByServer("mail");
        if(mailServer == null){
            return new String[]{CommonResourceBean.FAILURE,"mailserver is null"};
        }else if(StringUtils.nullCheck(mailServer.getProtocol())){
            return new String[]{CommonResourceBean.FAILURE,"mailserver protocol is null"};
        }

        Map<String, String> parameters = new HashMap<>();
        parameters.put("mailType",type.getValue());
        parameters.put("useYn",CommonResourceBean.YES);
        MailBean mailBean = mailDao.findByMail(parameters);
        if(mailBean == null || StringUtils.nullCheck(mailBean.getSendType())){
            return new String[]{CommonResourceBean.FAILURE,"mailinfo is null"};
        }

        MailHelper mailHelper = new MailHelper();

        mailHelper.setConnectInfo(mailServer.getIp(), mailServer.getPort() == null ? -1 : mailServer.getPort());
        mailHelper.setAuthorizeInfo(mailServer.getId(),mailServer.getPassword());

        MAIL_TYPE mailType = MAIL_TYPE.SEND_MAIL;

        if(MAIL_TYPE.SEND_MAIL.getValue().equalsIgnoreCase(mailServer.getProtocol())){
            mailType = MAIL_TYPE.SEND_MAIL;
        }else if(MAIL_TYPE.JAVA_MAIL.getValue().equalsIgnoreCase(mailServer.getProtocol())){
            mailType = MAIL_TYPE.JAVA_MAIL;
        }

        mailHelper.setType(mailType);

        if(MAIL_CODE[0].equals(mailBean.getSendType())){ // 자동
            mailHelper.setFrom(sender);
        }else if(MAIL_CODE[1].equals(mailBean.getSendType())){ // 직접입력
            mailHelper.setFrom(mailBean.getSendValue());
        }

        if(MAIL_CODE[0].equals(mailBean.getReceiveType())){ // 자동
            for(String receiver : receivers){
                mailHelper.addTo(receiver);
            }
        }else if(MAIL_CODE[1].equals(mailBean.getReceiveType())){ // 직접입력
            String receiverStr = mailBean.getReceiveValue();
            for(String receiverTemp : receiverStr.split(CommonResourceBean.COMMA_STRING)){
                mailHelper.addTo(receiverTemp);
            }
        }

        mailHelper.setContentType(CONTENT_TYPE.HTML);
        String[] result = mailHelper.send(title, content);

        return result;
    }

    /**
     * 수신자들의 메일정보를 가져온다.
     *
     * @author kst
     * @param receivers
     * @return
     */
    private List<String> getReceiverEmail(String[] receivers){
        List<String> receiverEmails = new ArrayList<>();
        for(String receiver : receivers){
            if(StringUtils.nullCheck(receiver)){
                // is null
            }else if(receiver.indexOf("@") < 0){
                UserBean user = getUserInfo(receiver);
                if(user != null){
                    receiverEmails.add(user.getEmail());
                }
            }else{
                receiverEmails.add(receiver);
            }
        }

        return receiverEmails;
    }

    private UserBean getUserInfo(String userId){
        //Map<String, String> parameters = new HashMap<>();
        UserBean userParam = new UserBean();
        userParam.setUserId(userId);
        return userDao.findByUser(userParam);
    }
}
