package com.icent.isaver.admin.util;

import Aladdin.Hasp;
import Aladdin.HaspStatus;
import com.icent.isaver.admin.bean.CodeBean;
import com.icent.isaver.admin.bean.License;
import com.icent.isaver.admin.dao.CodeDao;
import com.icent.isaver.admin.resource.AdminResource;
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

    private long feature = 1;
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
            "oF7wgy3Jznt92ez5JOWR4WvU3YnNOYau4hm7y4wpu+0smlpCe24JImJllY2mu8V+ZVUStI3XBEAP5Jxf" +
            "KdNvaCjeBUTr9uwuGx97bAhop5xevgv88p13DNC1zLLF6cUZ+iXfQ4YYDzy7k7RKtT770imGtgz5ec11" +
            "Qj5paDuNPZBudftJt+qwfrAoBuXPb5OAxa1M5T9h7pVE4rL73rXaNCHcdWyuPH6M/fp6skxs/RpuLUQs" +
            "bo+mrQZtsnmHHQEZ6Xn/FWr6Acbo09OjdDqpvtgbGstNb7/JqtEt4Ta8htlGeuNKicYjNkxu3PxtpE/h" +
            "bBX+jWPB4oVT7IKfS8rRLXvmpPbUyu4WQkLUtVJcTEDqVzg1ebh40ixh7yzL21yaj7NoDB8wspbbDij8" +
            "IqHuzLB606m+7rN7gI8c2tutXXZfP/7OcRluanxhuS5HvKf8s0mMZiBfRH10cV3Gc7SbFEQ/WYO1ul/g" +
            "+JsBAxSw26ZPewQ40vqAmcwF7fpNsmAKFWwdFKfNxLSBK39gSqg1XSaXSuPbYboV5itacwvokAmxYg29" +
            "LbKppP3/xCwHrhqbr4UENAq5f4Uk+7aE/TSrGUnOz6RySm4sJUhoZPa700dupzyn5BC6FOirRin9HDoV" +
            "xsJxOC7JKnm02n4ymbvvaxaF7A79YuE4RJPNp25V4aSncx1EDEwA32JUAYqAQMWnAKxxrxMvz+w8xcqy" +
            "mhK8kiQBHbwTuMu0HLBbHuR4P2+CamYloNxBhOGpVCVgNsQv80hlhQsEm14ByC+nrh2nUAluAkVaARDM" +
            "vea9qIlz/41iPaAjOCxHw2DVoK0yVnkpxaEzj8es/RKJtilA0zfsiLXak1EDzQlVVWRfr4TzSO06xuts" +
            "8yMfukK1ATtk5HeV2OoAYHxQ4lpepzdsdsnP2zFlLO9ck3CAYIfSItQEOzAeY60g4LBdzVFeUlZv51q0" +
            "6AmQzpSAY53YdPIQonhM2A==";

    public static final int BASE_LENGTH = 2;
    private Hasp hasp;

    @Inject
    private CodeDao codeDao;

    public void setHasp(String hostAddress, String noneLicenseTargets, String deployMode){
        String hostIp = null;
        if(hostAddress != null && hostAddress.length() > 1){
            try{
                InetAddress address = InetAddress.getByName(hostAddress);
                hostIp = address.getHostAddress();
            }catch (Exception e){
                logger.error(e.getMessage());
            }
        }

        if(StringUtils.notNullCheck(deployMode) && deployMode.equals("dev")){
            authorLicenseFlag = false;
        }else{
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
        }

        if(authorLicenseFlag){
            hasp = new Hasp(feature);
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
                if(ignoreDevice(deviceCode)){
                    license.setMessage("none authorize license");
                    license.setStatus(AdminResource.NONE_LICENSE_TARGET);
                }else if(AdminResource.DEVICE_CODE_LICENSE.get(deviceCode)!=null){
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

    private boolean ignoreDevice(String deviceCode){
        boolean ignoreTargetFlag = false;
        if (StringUtils.notNullCheck(deviceCode)) {
            if(AdminResource.IGNORE_DEVICE_CODE_LICENSE != null && AdminResource.IGNORE_DEVICE_CODE_LICENSE.length > 1){
                for(String ignoreDeviceCode : AdminResource.IGNORE_DEVICE_CODE_LICENSE){
                    if(deviceCode.equals(ignoreDeviceCode)){ // 라이센스 체크 대상이 아님.
                        ignoreTargetFlag = true;
                        break;
                    }
                }
            }
        }
        return ignoreTargetFlag;
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
