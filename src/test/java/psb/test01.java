package test.java.psb;

import Aladdin.Hasp;
import Aladdin.HaspStatus;
import com.icent.isaver.admin.bean.License;
import com.icent.isaver.admin.resource.AdminResource;
import org.junit.Test;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import java.io.StringReader;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Created by icent on 16. 6. 27..
 */
public class test01 {
    private long feature = 6;

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

    private Hasp hasp = new Hasp(feature);

    @Test
    public void test() {
        String info = hasp.getInfo(scope, format, vendorCode);
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        factory.setNamespaceAware(true);
        DocumentBuilder builder;
        Document doc = null;
        try{
            InputSource is = new InputSource(new StringReader(info));
            builder = factory.newDocumentBuilder();
            doc = builder.parse(is);
            NodeList nodeList = doc.getElementsByTagName("feature");
            for(int i=0; i<nodeList.getLength(); i++){
                Node node = nodeList.item(i);
                if (node.getNodeType() == Node.ELEMENT_NODE){
                    Element element = (Element) node;
                    if(element.getAttribute("id").equals(String.valueOf(feature))){
                        long expDate = Long.parseLong(element.getElementsByTagName("exp_date").item(0).getTextContent()) * 1000;
                        System.out.println(expDate);
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                        Date date = new Date(expDate);
                        System.out.println(date.toString());
                        System.out.println(sdf.format(date));
                    }
                }
            }

//            XPathFactory xPathFactory = XPathFactory.newInstance();
//            XPath xPath = xPathFactory.newXPath();
//            XPathExpression expr = xPath.compile("//items/item");
//            NodeList nodeList = (NodeList) expr.evaluate(doc, XPathConstants.NODESET);
//            for(int i=0; i<nodeList.getLength(); i++){
//                NodeList child = nodeList.item(i).getChildNodes();
//                for(int j=0; j<child.getLength(); j++){
//                    Node node = child.item(j);
//
//                    if (node.getNodeType() == Node.ELEMENT_NODE){
//                        Element element = (Element) node;
//                        System.out.println(element.getAttribute("id"));
//                    }
//
////                        if(node.getNodeName().equals("feature")){
////                        System.out.println(eElement.getAttribute("rollno"));
////                        System.out.println(node.getPrefix());
////                    }
//                }
//            }
        }catch(Exception e){
            e.printStackTrace();
        }
//        License license = read("DEV002");
//
//        String licenseJsonTxt = new Gson().toJson(license);
//        System.out.println(licenseJsonTxt);
//        License login = login();
//
//        if (HaspStatus.HASP_STATUS_OK == login.getStatus()) {
//            License license = read("DEV002");
//
//            Map licenseMap = new HashMap<>();
//            licenseMap.put("messageType","licenseStatus");
//            licenseMap.put("license",license);
//            String licenseJsonTxt = new Gson().toJson(licenseMap);
//            System.out.println(licenseJsonTxt);
//
//            // Expire Date
//            byte[] dtMembuffer = new byte[8];
//            hasp.read(Hasp.HASP_FILEID_RO, 0, dtMembuffer);
//            int dtStatus = hasp.getLastError();
//            license.setStatus(dtStatus);
//
//            if(dtStatus==HaspStatus.HASP_STATUS_OK){
//                Map<String,String> resultMap = new HashMap<>();
//                resultMap.put("licenseType","expireDt");
//                resultMap.put("expireDt", new String(dtMembuffer));
//                String txt = new Gson().toJson(resultMap);
//                System.out.println(txt);
//            }
//        }
    }

    public License login() {
        License license = new License();
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
                license.setStatus(-99);
        }
        return license;
    }

    public License read(String deviceCode) {
        License license = new License();

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
                    license.setStatus(-1);
            }
        }else{
            license.setMessage("Undefined device code");
            license.setStatus(-2);
        }
        return license;
    }
}
