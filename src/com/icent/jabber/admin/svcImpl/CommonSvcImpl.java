package com.icent.jabber.admin.svcImpl;

import com.icent.jabber.admin.bean.JabberException;
import com.icent.jabber.admin.resource.AdminResource;
import com.icent.jabber.admin.svc.CommonSvc;
import com.icent.jabber.admin.util.AdminHelper;
import com.icent.jabber.admin.util.ServerConfigHelper;
import com.icent.jabber.repository.bean.CommonBean;
import com.icent.jabber.repository.bean.ServerBean;
import com.kst.common.bean.CommonResourceBean;
import com.kst.common.helper.FileTransfer;
import org.omg.CORBA.StringHolder;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import javax.imageio.ImageIO;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.Map;

/**
 * Common Service Interface
 *
 * @author : psb
 * @version : 1.0
 * @since : 2014. 7. 28.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 7. 28.     psb           최초 생성
 * </pre>
 */
@Service
public class CommonSvcImpl implements CommonSvc {

    @Value("#{configProperties['cnf.profilePhotoExtension']}")
    private String photoExtension;

    @Value("#{configProperties['cnf.noticeFileAttachedUploadPath']}")
    private String noticeUploadPath;

    @Value("#{configProperties['cnf.path.noticeUploadLinkUrl']}")
    private String noticeUploadLinkUrl;

    @Value("#{configProperties['cnf.boardFileAttachedUploadPath']}")
    private String boardUploadPath;

    @Value("#{configProperties['cnf.fnqFileAttachedUploadPath']}")
    private String fnqUploadPath;

    @Value("#{configProperties['cnf.path.fnqUploadLinkUrl']}")
    private String fnqUploadLinkUrl;

    @Value("#{configProperties['cnf.path.boardUploadLinkUrl']}")
    private String boardUploadLinkUrl;

    @Inject
    private ServerConfigHelper serverConfigHelper;

    @Override
    public ModelAndView uploadImage(HttpServletRequest request, Map<String, String> parameters) {
        CommonBean paramBean = AdminHelper.convertMapToBean(parameters,CommonBean.class);

        String imageUploadPath = null;
        String imageUploadLinkPath = null;
        File imageFile = null;
        StringHolder logicalFileName = new StringHolder();

        if (paramBean.getPath().equals("notice")){
            imageUploadPath = noticeUploadPath;
            imageUploadLinkPath = noticeUploadLinkUrl;
        }else if (paramBean.getPath().equals("fnq")){
            imageUploadPath = fnqUploadPath;
            imageUploadLinkPath = fnqUploadLinkUrl;
        }else if (paramBean.getPath().equals("targetboard")){
            imageUploadPath = boardUploadPath;
            imageUploadLinkPath = boardUploadLinkUrl;
        }

        try {
            imageFile = FileTransfer.upload(request, "imageUploadFile", 1024, imageUploadPath, logicalFileName);
        } catch (IOException e) {
            throw new JabberException("");
        }

        if(imageFile != null && parameters.get("photoX") != null && parameters.get("photoY") != null
                && parameters.get("photoW") != null && parameters.get("photoH") != null){
            BufferedImage photoImg = null;
            try {
                int x = 0;
                if(parameters.get("photoX").indexOf(CommonResourceBean.PERIOD_STRING) > -1){
                    x = Integer.valueOf(parameters.get("photoX").substring(0,parameters.get("photoX").indexOf(CommonResourceBean.PERIOD_STRING)));
                }else{
                    x = Integer.valueOf(parameters.get("photoX"));
                }

                int y = 0;
                if(parameters.get("photoY").indexOf(CommonResourceBean.PERIOD_STRING) > -1){
                    y = Integer.valueOf(parameters.get("photoY").substring(0,parameters.get("photoY").indexOf(CommonResourceBean.PERIOD_STRING)));
                }else{
                    y = Integer.valueOf(parameters.get("photoY"));
                }

                int width = 0;
                if(parameters.get("photoW").indexOf(CommonResourceBean.PERIOD_STRING) > 0){
                    width = Integer.valueOf(parameters.get("photoW").substring(0,parameters.get("photoW").indexOf(CommonResourceBean.PERIOD_STRING)));
                }else{
                    width = Integer.valueOf(parameters.get("photoW"));
                }

                int height = 0;
                if(parameters.get("photoH").indexOf(CommonResourceBean.PERIOD_STRING) > 0){
                    height = Integer.valueOf(parameters.get("photoH").substring(0,parameters.get("photoH").indexOf(CommonResourceBean.PERIOD_STRING)));
                }else{
                    height = Integer.valueOf(parameters.get("photoH"));
                }

                photoImg = ImageIO.read(imageFile);
                if(x + width > photoImg.getWidth()){
                    width = photoImg.getWidth() - x;
                }

                if(y + height > photoImg.getHeight()){
                    height = photoImg.getHeight() - y;
                }

                String physicalFileName = imageFile.getName();
                String photoFullPath = imageUploadPath + physicalFileName;
                String extension = physicalFileName.substring(physicalFileName.lastIndexOf(".") + 1);
                ImageIO.write(photoImg.getSubimage(x,y,width,height),extension, new File(photoFullPath));

                int maxWidth = Integer.valueOf(parameters.get("maxWidth"));
                if(width > maxWidth){
                    float widthRatio = maxWidth/(float)width;
                    width = (int)(width*widthRatio);
                    height = (int)(height*widthRatio);
                }

                paramBean.setWidth(width);
                paramBean.setHeight(height);
                paramBean.setFileSize(imageFile.length());
                paramBean.setPhysicalFileName(physicalFileName);
                paramBean.setLogicalFileName(logicalFileName.value);
            } catch (IOException e) {
                throw new JabberException("");
            } catch (Exception e){
                throw new JabberException("");
            } finally {
                photoImg = null;
                imageFile = null;
            }
        }

        ServerBean file = serverConfigHelper.findByServer("file");

        if(file == null){
            return null;
        }

        StringBuilder urlBuilder = new StringBuilder();
        urlBuilder.append(file.getProtocol());
        urlBuilder.append(AdminResource.PROTOCOL_SUBPIX);
        urlBuilder.append(file.getIp());
        urlBuilder.append(CommonResourceBean.COLON_STRING);
        urlBuilder.append(file.getPort());

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("uploadPath", urlBuilder.toString() + imageUploadLinkPath);
        modelAndView.addObject("fileSize", String.valueOf(paramBean.getFileSize()));
        modelAndView.addObject("physicalFileName", paramBean.getPhysicalFileName());
        modelAndView.addObject("logicalFileName", paramBean.getLogicalFileName());
        modelAndView.addObject("width", paramBean.getWidth());
        modelAndView.addObject("height", paramBean.getHeight());
        return modelAndView;
    }
}
