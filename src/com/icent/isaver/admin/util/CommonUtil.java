package com.icent.isaver.admin.util;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.HttpVersion;
import org.apache.http.client.HttpClient;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.conn.ClientConnectionManager;
import org.apache.http.conn.scheme.PlainSocketFactory;
import org.apache.http.conn.scheme.Scheme;
import org.apache.http.conn.scheme.SchemeRegistry;
import org.apache.http.conn.ssl.SSLConnectionSocketFactory;
import org.apache.http.conn.ssl.SSLContexts;
import org.apache.http.conn.ssl.SSLSocketFactory;
import org.apache.http.conn.ssl.TrustStrategy;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.impl.conn.tsccm.ThreadSafeClientConnManager;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.HttpConnectionParams;
import org.apache.http.params.HttpParams;
import org.apache.http.params.HttpProtocolParams;
import org.apache.http.protocol.HTTP;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.net.ssl.SSLContext;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.security.*;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;

/**
 * Created by icent on 2016. 11. 25..
 */
public class CommonUtil {

    static Logger logger = LoggerFactory.getLogger(CommonUtil.class);

    public static HttpClient defaultHttpClientSSL(int timeout) {
        try {
            KeyStore trustStore = KeyStore.getInstance(KeyStore.getDefaultType());
            trustStore.load(null, null);

            SSLSocketFactory sf = new SSLSocketFactoryEx(trustStore);
            sf.setHostnameVerifier(SSLSocketFactory.ALLOW_ALL_HOSTNAME_VERIFIER);

            HttpParams params = new BasicHttpParams();
            HttpProtocolParams.setVersion(params, HttpVersion.HTTP_1_1);
            HttpProtocolParams.setContentCharset(params, HTTP.UTF_8);
            HttpConnectionParams.setConnectionTimeout(params, timeout * 1000);
            HttpConnectionParams.setSoTimeout(params, timeout * 1000);

            SchemeRegistry registry = new SchemeRegistry();
            registry.register(new Scheme("http", PlainSocketFactory.getSocketFactory(), 80));
            registry.register(new Scheme("https", sf, 443));

            ClientConnectionManager ccm = new ThreadSafeClientConnManager(params, registry);

            return new DefaultHttpClient(ccm, params);
        } catch (Exception e) {
            return new DefaultHttpClient();
        }
    }

    public static BufferedReader bufferReader(HttpResponse response) {
        if (response != null) {
            HttpEntity ent = response.getEntity();
            try {
                return new BufferedReader(new InputStreamReader(ent.getContent()));
            } catch (IllegalStateException e) {
            } catch (IOException e) {
            }
        }
        return null;
    }

    public static String getHostNameFunc() {
        String hostname = "";

        try {

            InetAddress addr = InetAddress.getLocalHost();
            hostname = addr.getHostName();

        } catch (UnknownHostException e) {
            logger.warn(e.getMessage());
        }
        return hostname;
    }

    public static String getIpAddressFunc() {
        String hostIp = "";

        try {

            InetAddress iAddress = InetAddress.getLocalHost();
            hostIp = iAddress.getHostAddress();

        } catch (UnknownHostException e) {
            logger.warn(e.getMessage());
        }
        return hostIp;
    }

    public static SSLContext buildSSLContext()
            throws NoSuchAlgorithmException, KeyManagementException,
            KeyStoreException {
        SSLContext sslcontext = SSLContexts.custom()
                .setSecureRandom(new SecureRandom())
                .loadTrustMaterial(null, new TrustStrategy() {

                    public boolean isTrusted(X509Certificate[] chain, String authType)
                            throws CertificateException {
                        return true;
                    }
                })
                .build();
        return sslcontext;
    }

    public static CloseableHttpClient getHttpClientFunc(CloseableHttpClient commonHttpClient, int timeout) {
		/* ==================== */
		/* HTTP CLIENT 타임 아웃 설정 */
		/* ==================== */

        RequestConfig config = RequestConfig.custom()
                .setConnectTimeout(timeout * 1000)
                .setConnectionRequestTimeout(timeout * 1000)
                .setSocketTimeout(timeout * 1000).build();

        HttpClients.custom().setDefaultRequestConfig(config);

        SSLContext sslcontext = null;
        try {
            sslcontext = CommonUtil.buildSSLContext();
        } catch (KeyManagementException | NoSuchAlgorithmException | KeyStoreException e1) {
            logger.error(e1.getCause().toString());
        }

        // Allow TLSv1 protocol only
        SSLConnectionSocketFactory sslsf = new SSLConnectionSocketFactory(
                sslcontext,
                new String[]{"TLSv1"},
                null,
                SSLConnectionSocketFactory.ALLOW_ALL_HOSTNAME_VERIFIER);

        commonHttpClient = HttpClientBuilder.create().setDefaultRequestConfig(config).build();
        commonHttpClient = HttpClients.custom().setSSLSocketFactory(sslsf).build();
//		CommonUtil.showMemoryFunc();
        return commonHttpClient;

    }
}
