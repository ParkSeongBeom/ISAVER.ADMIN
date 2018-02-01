package com.icent.isaver.admin.util;


import com.kst.common.util.StringUtils;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.protocol.HTTP;
import org.codehaus.jackson.map.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 알림 전송 관련 유틸리티
 * @author dhj
 * @date 2016.11.24
 */
public class AlarmRequestUtil {

    private static Logger logger = LoggerFactory.getLogger(AlarmRequestUtil.class);
    private static int timeout = 3;

    /**
     *
     * @param parameters
     * @param requestHttpUrl 알림 전송 URL(ISAVER.API URL)
     * @return
     * @throws IOException
     */
    public static Object sendAlarmRequestFunc(Map<String, String> parameters, String requestHttpUrl, String contentType, String jsonName) throws IOException {

        CloseableHttpClient commonHttpClient = null;
        HttpPost httpPost = null;
        HttpResponse response = null;
        HttpEntity httpEntity =  null;

        commonHttpClient = CommonUtil.getHttpClientFunc(commonHttpClient, timeout* 1000);

        httpPost = new HttpPost(requestHttpUrl);
        final RequestConfig params = RequestConfig.custom().setConnectTimeout(timeout* 1000).setSocketTimeout(timeout* 1000).build();
        httpPost.setConfig(params);
        httpPost.addHeader("charset", "UTF-8");

        switch (contentType) {
            case "json" :
                StringEntity stringEntity = new StringEntity(new ObjectMapper().writeValueAsString(parameters));

                httpPost.addHeader("content-type", "application/json");
                httpPost.setEntity(stringEntity);
                break;
            case "form" :
                List<NameValuePair> nvps = new ArrayList<NameValuePair>();
                if(StringUtils.notNullCheck(jsonName)){
                    nvps.add(new BasicNameValuePair(jsonName, new ObjectMapper().writeValueAsString(parameters)));
                }else{
                    for(String key : parameters.keySet()){
                        nvps.add(new BasicNameValuePair(key, parameters.get(key)));
                    }
                }

                httpPost.addHeader("content-type", "application/x-www-form-urlencoded");
                httpPost.setEntity(new UrlEncodedFormEntity(nvps, HTTP.UTF_8));
                break;
            default:
                return null;
        }

        RequestConfig requestConfig = RequestConfig.custom()
                .setSocketTimeout(timeout * 1000)
                .setConnectTimeout(timeout * 1000)
                .setConnectionRequestTimeout(timeout * 1000)
                .build();

        httpPost.setConfig(requestConfig);

        response = commonHttpClient.execute(httpPost);
        httpEntity = response.getEntity();

        BufferedReader br = new BufferedReader(new InputStreamReader((response.getEntity().getContent())));

        String output;
        StringBuilder stringBuilder = new StringBuilder();

        while ((output = br.readLine()) != null) {
            stringBuilder.append(output);
        }

        logger.info(requestHttpUrl + "/" + contentType + "/" + jsonName);
        logger.info(stringBuilder.toString());

        if (httpEntity != null) {
            httpEntity.getContent().close();
        }
        commonHttpClient.close();

        return null;
    }

}
