package psb;

import Aladdin.Hasp;
import Aladdin.HaspStatus;
import com.google.gson.Gson;
import com.icent.isaver.admin.bean.License;
import com.icent.isaver.admin.resource.AdminResource;
import org.junit.Test;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by icent on 16. 6. 27..
 */
public class test01 {
    private long feature = 2;
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
        License license = read("DEV002");

        Map licenseMap = new HashMap<>();
        licenseMap.put("messageType","licenseStatus");
        licenseMap.put("license",license);

        String licenseJsonTxt = new Gson().toJson(licenseMap);

        System.out.println(licenseJsonTxt);
        System.out.println("status code : " + license.getStatus());
        System.out.println("message : " + license.getMessage());
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
        License license = login();

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
                        license.setStatus(-1);
                }
            }else{
                license.setMessage("Undefined device code");
                license.setStatus(-2);
            }
        }
        return license;
    }
}
