package com.icent.isaver.admin.util;

import com.icent.isaver.admin.resource.AdminResource;
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
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.InetAddress;
import java.net.URLEncoder;
import java.net.UnknownHostException;
import java.security.*;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.util.ArrayList;
import java.util.List;

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

    public static void download(HttpServletRequest request, HttpServletResponse response, String filePath, String fileName, int bufferSize) throws IOException, ServletException {
        download(request, response, new FileInputStream(new File(filePath)), fileName, 0L, (String)null, bufferSize);
    }

    public static void download(HttpServletRequest request, HttpServletResponse response, File file, String fileName, long fileSize, int bufferSize) throws ServletException, IOException {
        download(request, response, new FileInputStream(file), fileName, fileSize, (String)null, bufferSize);
    }

    public static void download(HttpServletRequest request, HttpServletResponse response, File file, String fileName, int bufferSize) throws ServletException, IOException {
        download(request, response, new FileInputStream(file), fileName, 0L, (String)null, bufferSize);
    }

    public static void download(HttpServletRequest request, HttpServletResponse response, InputStream is, String filename, long filesize, String mimetype, int bufferSize) throws ServletException, IOException {
        String mime = mimetype;
        if(mimetype == null || mimetype.length() == 0) {
            mime = "application/octet-stream;";
        }

        byte[] buffer = new byte[bufferSize];
        response.setContentType(mime + "; charset=utf-8");
        String userAgent = request.getHeader("User-Agent");
        if(userAgent != null && userAgent.indexOf("MSIE 5.5") > -1) {
            response.setHeader("Content-Disposition", "filename=" + URLEncoder.encode(filename, "UTF-8") + ";");
        } else if(userAgent != null && userAgent.indexOf("MSIE") > -1) {
            response.setHeader("Content-Disposition", "attachment; filename=" + URLEncoder.encode(filename, "UTF-8") + ";");
        } else if(userAgent != null && userAgent.indexOf("Chrome") > -1) {
            StringBuffer sb = new StringBuffer();
            for (int i = 0; i < filename.length(); i++) {
                char c = filename.charAt(i);
                if (c > '~') {
                    sb.append(URLEncoder.encode("" + c, "UTF-8"));
                } else {
                    sb.append(c);
                }
            }
            response.setHeader("Content-Disposition", "attachment; filename=" + sb.toString() + ";");
        } else {
            response.setHeader("Content-Disposition", "attachment; filename=" + new String(filename.getBytes("EUC-KR"), "latin1") + ";");
        }
        response.setHeader("Content-Transfer-Encoding", "binary");

        if(filesize > 0L) {
            response.setHeader("Content-Length", "" + filesize);
        }

        BufferedInputStream fin = null;
        BufferedOutputStream outs = null;

        try {
            fin = new BufferedInputStream(is);
            outs = new BufferedOutputStream(response.getOutputStream());
            boolean e = false;

            int e1;
            while((e1 = fin.read(buffer)) != -1) {
                outs.write(buffer, 0, e1);
            }
        } catch (IOException var21) {
            throw var21;
        } finally {
            try {
                if(outs != null) {
                    outs.close();
                }

                if(fin != null) {
                    fin.close();
                }

                if(is != null) {
                    is.close();
                }
            } catch (Exception var20) {
                ;
            }
        }
    }

    public static <T> List<List<T>> splitList(List<T> resList, int count) {
        if (resList == null || count <1)
            return null;
        List<List<T>> ret = new ArrayList<List<T>>();
        int size = resList.size();
        if (size <= count) {
            // 데이터 부족 count 지정 크기
            ret.add(resList);
        } else {
            int pre = size / count;
            int last = size % count;
            // 앞 pre 개 집합, 모든 크기 다 count 가지 요소
            for (int i = 0; i <pre; i++) {
                List<T> itemList = new ArrayList<T>();
                for (int j = 0; j <count; j++) {
                    itemList.add(resList.get(i * count + j));
                }
                ret.add(itemList);
            }
            // last 진행이 처리
            if (last > 0) {
                List<T> itemList = new ArrayList<T>();
                for (int i = 0; i <last; i++) {
                    itemList.add(resList.get(pre * count + i));
                }
                ret.add(itemList);
            }
        }
        return ret;
    }


    /**
     * request에 따른 View Type을 가져온다.
     *
     * @author psb
     * @since 2018. 12. 18.
     * @return View
     */
    public static String getViewFromRequest(HttpServletRequest request){
        String requestPath = request.getServletPath();
        return requestPath.substring(requestPath.lastIndexOf(AdminResource.PERIOD_STRING) + 1, requestPath.length());
    }
}
