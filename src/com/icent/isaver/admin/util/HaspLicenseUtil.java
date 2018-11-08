package com.icent.isaver.admin.util;

import Aladdin.Hasp;
import Aladdin.HaspStatus;
import com.icent.isaver.admin.bean.License;
import com.icent.isaver.admin.resource.AdminResource;
import com.icent.isaver.repository.bean.CodeBean;
import com.icent.isaver.repository.dao.base.CodeDao;
import com.kst.common.util.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.ModelAndView;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import javax.inject.Inject;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import java.io.StringReader;
import java.net.InetAddress;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Hasp USB Lock License Util
 *
 * @author : psb
 * @version : 1.0
 * @since : 2018. 10. 05.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2018. 10. 05.     psb           최초 생성
 * </pre>
 */
public class HaspLicenseUtil {
    static Logger logger = LoggerFactory.getLogger(HaspLicenseUtil.class);

    private long[] featureArr = {5,6};
    private long feature;
    private boolean authorLicenseFlag = true;
    private String scope =
            "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>" +
                    "<haspscope/>";

    private String format =
            "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>" +
                    "<haspformat root=\"hasp_info\">" +
                    "    <feature>" +
                    "        <attribute name=\"id\" />" +
                    "        <element name=\"license\" />" +
                    "        <hasp>" +
                    "          <attribute name=\"id\" />" +
                    "          <attribute name=\"type\" />" +
                    "        </hasp>" +
                    "    </feature>" +
                    "</haspformat>" +
                    "";
    private String vendorCode =
            "AzIceaqfA1hX5wS+M8cGnYh5ceevUnOZIzJBbXFD6dgf3tBkb9cvUF/Tkd/iKu2fsg9wAysYKw7RMAsV" +
            "vIp4KcXle/v1RaXrLVnNBJ2H2DmrbUMOZbQUFXe698qmJsqNpLXRA367xpZ54i8kC5DTXwDhfxWTOZrB" +
            "rh5sRKHcoVLumztIQjgWh37AzmSd1bLOfUGI0xjAL9zJWO3fRaeB0NS2KlmoKaVT5Y04zZEc06waU2r6" +
            "AU2Dc4uipJqJmObqKM+tfNKAS0rZr5IudRiC7pUwnmtaHRe5fgSI8M7yvypvm+13Wm4Gwd4VnYiZvSxf" +
            "8ImN3ZOG9wEzfyMIlH2+rKPUVHI+igsqla0Wd9m7ZUR9vFotj1uYV0OzG7hX0+huN2E/IdgLDjbiapj1" +
            "e2fKHrMmGFaIvI6xzzJIQJF9GiRZ7+0jNFLKSyzX/K3JAyFrIPObfwM+y+zAgE1sWcZ1YnuBhICyRHBh" +
            "aJDKIZL8MywrEfB2yF+R3k9wFG1oN48gSLyfrfEKuB/qgNp+BeTruWUk0AwRE9XVMUuRbjpxa4YA67SK" +
            "unFEgFGgUfHBeHJTivvUl0u4Dki1UKAT973P+nXy2O0u239If/kRpNUVhMg8kpk7s8i6Arp7l/705/bL" +
            "Cx4kN5hHHSXIqkiG9tHdeNV8VYo5+72hgaCx3/uVoVLmtvxbOIvo120uTJbuLVTvT8KtsOlb3DxwUrwL" +
            "zaEMoAQAFk6Q9bNipHxfkRQER4kR7IYTMzSoW5mxh3H9O8Ge5BqVeYMEW36q9wnOYfxOLNw6yQMf8f9s" +
            "JN4KhZty02xm707S7VEfJJ1KNq7b5pP/3RjE0IKtB2gE6vAPRvRLzEohu0m7q1aUp8wAvSiqjZy7FLaT" +
            "tLEApXYvLvz6PEJdj4TegCZugj7c8bIOEqLXmloZ6EgVnjQ7/ttys7VFITB3mazzFiyQuKf4J6+b/a/Y";

    public static final int BASE_LENGTH = 2;
    private Hasp hasp;

    @Inject
    private CodeDao codeDao;

    public void setHasp(String hostAddress, String noneLicenseTargets){
        String hostIp = null;
        if(hostAddress != null && hostAddress.length() > 1){
            try{
                InetAddress address = InetAddress.getByName(hostAddress);
                hostIp = address.getHostAddress();
            }catch (Exception e){
                logger.error(e.getMessage());
            }
        }
        if(noneLicenseTargets != null && noneLicenseTargets.length() > 0){
            for(String target : noneLicenseTargets.split(",")){
                if(StringUtils.notNullCheck(hostIp) && (target.equals(hostIp) || target.equals(CommonUtil.getIpAddressFunc()))){ // 라이센스 체크 대상이 아님.
                    authorLicenseFlag = false;
                    break;
                }else{ // 라이센스 유효성 체크 대상.
                    authorLicenseFlag = true;
                }
            }
        }
        if(authorLicenseFlag){
            for(long ft : featureArr){
                hasp = new Hasp(ft);
                hasp.login(vendorCode);

                if(hasp.getLastError()==HaspStatus.HASP_STATUS_OK){
                    feature = ft;
                    break;
                }
            }
        }
    }

    public License login() {
        License license = new License();
        if(authorLicenseFlag){
            hasp.login(vendorCode);

            int status = hasp.getLastError();
            license.setStatus(status);

            switch (status) {
                case HaspStatus.HASP_STATUS_OK:
                    break;
                case HaspStatus.HASP_FEATURE_NOT_FOUND:
                    license.setMessage("no Sentinel DEMOMA key found");
                    break;
                case HaspStatus.HASP_HASP_NOT_FOUND:
                    license.setMessage("Sentinel key not found");
                    break;
                case HaspStatus.HASP_OLD_DRIVER:
                    license.setMessage("outdated driver version or no driver installed");
                    break;
                case HaspStatus.HASP_NO_DRIVER:
                    license.setMessage("Sentinel key not found");
                    break;
                case HaspStatus.HASP_INV_VCODE:
                    license.setMessage("invalid vendor code");
                    break;
                case HaspStatus.HASP_FEATURE_EXPIRED:
                    license.setMessage("Sentinel key is expired");
                    license.setStatus(-1);
                    break;
                default:
                    license.setMessage("login to default feature failed");
                    license.setStatus(-2);
            }
        }else{
            license.setMessage("none authorize license");
            license.setStatus(AdminResource.NONE_LICENSE_TARGET);
        }
        return license;
    }

    public License read(String deviceCode) {
        License license = new License();
        if(authorLicenseFlag){
            license = login();
            if (HaspStatus.HASP_STATUS_OK == license.getStatus()) {
                if(AdminResource.DEVICE_CODE_LICENSE.get(deviceCode)!=null){
                    byte[] membuffer = new byte[BASE_LENGTH];
                    hasp.read(Hasp.HASP_FILEID_RO, AdminResource.DEVICE_CODE_LICENSE.get(deviceCode), membuffer);
                    int status = hasp.getLastError();
                    license.setStatus(status);

                    switch (status) {
                        case HaspStatus.HASP_STATUS_OK:
                            license.setMessage(new String(membuffer));
                            break;
                        case HaspStatus.HASP_INV_HND:
                            license.setMessage("handle not active");
                            break;
                        case HaspStatus.HASP_INV_FILEID:
                            license.setMessage("invalid file id");
                            break;
                        case HaspStatus.HASP_MEM_RANGE:
                            license.setMessage("beyond memory range of attached Sentinel key");
                            break;
                        case HaspStatus.HASP_HASP_NOT_FOUND:
                            license.setMessage("hasp not found");
                            break;
                        default:
                            license.setMessage("read memory failed");
                            license.setStatus(-2);
                    }
                }else{
                    license.setMessage("Undefined device code");
                    license.setStatus(-3);
                }
            }else{
                logger.info(license.getMessage());
            }
        }else{
            license.setMessage("none authorize license");
            license.setStatus(AdminResource.NONE_LICENSE_TARGET);
        }

        return license;
    }

    public ModelAndView getLicenseList(){
        ModelAndView modelAndView = new ModelAndView();

        License license = new License();
        List<Map<String,String>> resultList = new LinkedList<>();
        String result = "";

        if(authorLicenseFlag) {
            license = login();
            if (HaspStatus.HASP_STATUS_OK == license.getStatus()) {
                resultList = readDeviceList();
                result = getExpireDate();
            }
        }else{
            license.setMessage("none authorize license");
            license.setStatus(AdminResource.NONE_LICENSE_TARGET);
        }
        modelAndView.addObject("licenseList", resultList);
        modelAndView.addObject("licenseExpireDate", result);
        modelAndView.addObject("license", license);
        return modelAndView;
    }

    private List<Map<String,String>> readDeviceList() {
        List<Map<String,String>> resultList = new LinkedList<>();
        List<CodeBean> codeList = codeDao.findListCodeDevice();
        for(CodeBean code : codeList){
            if(AdminResource.DEVICE_CODE_LICENSE.get(code.getCodeId())!=null){
                byte[] membuffer = new byte[BASE_LENGTH];
                hasp.read(Hasp.HASP_FILEID_RO, AdminResource.DEVICE_CODE_LICENSE.get(code.getCodeId()), membuffer);
                if(hasp.getLastError()==HaspStatus.HASP_STATUS_OK){
                    Map<String,String> resultMap = new HashMap<>();
                    resultMap.put("deviceCodeName",code.getCodeName());
                    resultMap.put("deviceCnt",String.valueOf(code.getDeviceCnt()));
                    resultMap.put("licenseCnt", new String(membuffer).replaceFirst("^0+(?!$)", ""));
                    resultList.add(resultMap);
                }
            }
        }
        return resultList;
    }

    private String getExpireDate(){
        String result = "";
        String info = hasp.getInfo(scope, format, vendorCode);
        try{
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            factory.setNamespaceAware(true);
            InputSource is = new InputSource(new StringReader(info));
            DocumentBuilder builder = factory.newDocumentBuilder();
            Document doc = builder.parse(is);
            NodeList nodeList = doc.getElementsByTagName("feature");
            for(int i=0; i<nodeList.getLength(); i++){
                Node node = nodeList.item(i);
                if (node.getNodeType() == Node.ELEMENT_NODE){
                    Element element = (Element) node;
                    if(element.getAttribute("id").equals(String.valueOf(feature))){
                        Node expDtNode = element.getElementsByTagName("exp_date").item(0);
                        if(expDtNode!=null){
                            long expDate = Long.parseLong(expDtNode.getTextContent()) * 1000;
                            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                            Date date = new Date(expDate);
                            result = sdf.format(date);
                        }
                    }
                }
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        return result;
    }
}
