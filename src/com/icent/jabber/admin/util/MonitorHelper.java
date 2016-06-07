package com.icent.jabber.admin.util;

import ch.ethz.ssh2.Connection;
import ch.ethz.ssh2.Session;
import ch.ethz.ssh2.StreamGobbler;
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by psb on 15. 04. 08..
 */
public class MonitorHelper {

    /**
     * 핑테스트
     * @author psb
     */
    public boolean pingTest(String ip){
        boolean reachable = false;
        Process proc = null;

        try {
            boolean isWindows = System.getProperty("os.name").toLowerCase().contains("win");
            ProcessBuilder processBuilder = new ProcessBuilder("ping", isWindows? "-n" : "-c", "1", ip);
            proc = processBuilder.start();

            int returnVal = proc.waitFor();
            reachable = (returnVal==0);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (proc!=null) proc.destroy();
        }

        return reachable;
    }

    /**
     * 리눅스 명령
     * @author psb
     */
    public Map<String, String> excuteCommand(String ip, String id, String password, String command){
        Map<String, String> resultMap = new HashMap<>();

        /* Create a connection instance */
        Connection conn = null;
        try{
            /* Now connect */
            conn = new Connection(ip);
            conn.connect();

			/* Authenticate.
			 * If you get an IOException saying something like
			 * "Authentication method password not supported by the server at this stage."
			 * then please check the FAQ.
			 */
            boolean isAuthenticated = conn.authenticateWithPassword(id, password);
            resultMap.put("resultFlag",Boolean.toString(isAuthenticated));
            if (isAuthenticated == false){
                return resultMap;
            }

            resultMap.put("result",excuteCommand(conn, command));
        }catch (Exception e){
            e.printStackTrace();
        }finally {
			/* Close the connection */
            if (conn!=null) conn.close();
        }

        return resultMap;
    }

    private String excuteCommand(Connection conn, String command){
        /* Create a session */
        Session sess = null;
        StringBuilder sb = new StringBuilder();

        try{
            sess = conn.openSession();
            sess.execCommand(command);

            /*
             * This basic example does not handle stderr, which is sometimes dangerous
             * (please read the FAQ).
             */
            InputStream stdout = new StreamGobbler(sess.getStdout());
            BufferedReader br = new BufferedReader(new InputStreamReader(stdout));

            String line = br.readLine();
            while( line != null )
            {
                sb.append(line + ",");
                line = br.readLine();
            }
        }catch (Exception e){
            return null;
        }finally {
			/* Close this session */
            if (sess!=null) sess.close();
        }

        return sb.toString();
    }
}
