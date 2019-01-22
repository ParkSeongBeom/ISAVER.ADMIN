package main.java.com.icent.isaver.admin.common.util;

import com.icent.isaver.admin.common.resource.ConvertType;
import org.apache.commons.io.IOUtils;

import java.io.*;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.text.Normalizer;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by icent on 2017. 2. 1..
 */
public class StringUtils {
    public StringUtils() {
    }

    public static String getGUID32() {
        return UUID.randomUUID().toString().replaceAll("-", "");
    }

    public static String getGUID36() {
        return UUID.randomUUID().toString();
    }

    public static String convertStreamToString(InputStream is) throws IOException {
        if(is != null) {
            char[] buffer = new char[1024];
            BufferedReader reader = new BufferedReader(new InputStreamReader(is, "UTF-8"));
            Throwable var4 = null;

            String resultString;
            try {
                StringWriter x2 = new StringWriter();
                Throwable var6 = null;

                try {
                    int x21;
                    while((x21 = reader.read(buffer)) != -1) {
                        x2.write(buffer, 0, x21);
                    }

                    resultString = x2.toString();
                } catch (Throwable var29) {
                    var6 = var29;
                    throw var29;
                } finally {
                    if(x2 != null) {
                        if(var6 != null) {
                            try {
                                x2.close();
                            } catch (Throwable var28) {
                                var6.addSuppressed(var28);
                            }
                        } else {
                            x2.close();
                        }
                    }

                }
            } catch (Throwable var31) {
                var4 = var31;
                throw var31;
            } finally {
                if(reader != null) {
                    if(var4 != null) {
                        try {
                            reader.close();
                        } catch (Throwable var27) {
                            var4.addSuppressed(var27);
                        }
                    } else {
                        reader.close();
                    }
                }

            }

            return resultString;
        } else {
            return "";
        }
    }

    public static String convertToCharsetString(String input, String inputCharset, String outputCharset) {
        try {
            input = new String(inputCharset == null?input.getBytes():input.getBytes(inputCharset), outputCharset);
        } catch (UnsupportedEncodingException var4) {
            input = "";
        }

        return input;
    }

    public static String convertToCharsetString(String input, String outputCharset) {
        return convertToCharsetString(input, (String)null, outputCharset);
    }

    public static String convertToCharsetString(String input) {
        return convertToCharsetString(input, (String)null, "UTF-8");
    }

    public static boolean nullCheck(String value) {
        return !notNullCheck(value);
    }

    public static boolean notNullCheck(String data) {
        return data != null && !data.equals("");
    }

    public static String addCDATA(String text) {
        if(text != null && !"".equals(text)) {
            StringBuilder sb = new StringBuilder();
            sb.append("<![CDATA[ ");
            sb.append(text);
            sb.append(" ]]>");
            return sb.toString();
        } else {
            return text;
        }
    }

    public static String getExtension(String text) {
        String extension = "";
        if(!"".equals(text) && text.lastIndexOf(".") > -1) {
            extension = text.substring(text.lastIndexOf(".") + 1, text.length());
        }

        return extension;
    }

    public static String getFileNameRemoveExtension(String text) {
        String resultStr = text.substring(0, text.lastIndexOf("."));
        return resultStr;
    }

    public static String convertLongToStringTime(Long longTime) {
        return convertLongToStringTime(longTime, (String)null);
    }

    public static String convertLongToStringTime(Long longTime, String divisionStr) {
        String division = ":";
        if(divisionStr != null) {
            division = divisionStr;
        }

        String second = "" + longTime.longValue() / 1000L % 60L;
        String minute = "" + longTime.longValue() / 60000L % 60L;
        String hour = "" + longTime.longValue() / 3600000L % 24L;
        String time = convertTwoCipher(hour) + division + convertTwoCipher(minute) + division + convertTwoCipher(second);
        return time;
    }

    public static String convertTwoCipher(String str) {
        return convertTwoCipher(str, 2);
    }

    public static String convertTwoCipher(String str, int length) {
        if(str.length() <= length - 1) {
            str = "0" + str;
            return convertTwoCipher(str, length);
        } else {
            return str;
        }
    }

    public static boolean isNumber(String arg) {
        return Pattern.matches("[0-9]*", arg);
    }

    public static boolean checkResult(String[] resultArr) {
        return resultArr != null && resultArr.length != 0?"SUCCESS".equalsIgnoreCase(resultArr[0]):false;
    }

    public static String urlConverter(ConvertType type, String value, String charset) {
        String result = null;

        try {
            switch(type) {
                case ENCODE:
                    result = URLEncoder.encode(value, charset);
                    break;
                case DECODE:
                    result = URLDecoder.decode(value, charset);
                    break;
                default:
                    result = value;
            }
        } catch (UnsupportedEncodingException var5) {
            result = "";
        }

        return result;
    }

    public static String urlConverter(ConvertType type, String value) {
        return urlConverter(type, value, "UTF-8");
    }

    public static String inputStreamToString(InputStream inputStream, String chatset) {
        StringWriter writer = new StringWriter();
        String result = null;

        try {
            IOUtils.copy(inputStream, writer, "UTF-8");
            result = writer.toString();
            writer.close();
        } catch (IOException var5) {
            var5.printStackTrace();
        }

        return result;
    }

    public static String normalizing(String value, Normalizer.Form form) {
        return form != null && !Normalizer.isNormalized(value, form)?Normalizer.normalize(value, form):value;
    }

    public static String normalizing(String value) {
        return normalizing(value, Normalizer.Form.NFC);
    }

    public static boolean isEmail(String email) {
        String mail = "^[_a-zA-Z0-9-\\.]+@[\\.a-zA-Z0-9-]+\\.[a-zA-Z]+$";
        Pattern p = Pattern.compile(mail);
        Matcher m = p.matcher(email);
        return m.matches();
    }

    public static String strJoin(String[] aArr, String sSep) {
        StringBuilder sbStr = new StringBuilder();
        for (int i = 0, il = aArr.length; i < il; i++) {
            if (i > 0)
                sbStr.append(sSep);
            sbStr.append(aArr[i]);
        }
        return sbStr.toString();
    }
}
