package com.icent.isaver.admin.util;

import com.kst.common.util.POIExcelUtil;
import java.net.URLEncoder;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.web.servlet.view.document.AbstractExcelView;

/**
 * Created by meous on 2019-07-29.
 */
public class POIExcelViewCustom extends AbstractExcelView {
    private String fileExtension = ".xls";

    public POIExcelViewCustom() {
    }

    public void setFileExtension(String fileExtension) {
        this.fileExtension = fileExtension;
    }

    protected void buildExcelDocument(Map<String, Object> model, HSSFWorkbook workbook, HttpServletRequest req, HttpServletResponse res) throws Exception {
        String excelName = (String)model.get("filename");
        String userAgent = req.getHeader("User-Agent");
        String fileName = excelName + this.fileExtension;
        if(userAgent.indexOf("Trident") <= -1 && userAgent.indexOf("MSIE") <= -1) {
            fileName = new String(fileName.getBytes("utf-8"), "iso-8859-1");
        } else {
            fileName = URLEncoder.encode(fileName, "utf-8");
        }

        res.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\";");
        res.setHeader("Content-Transfer-Encoding", "binary");
        HSSFCellStyle style = workbook.createCellStyle();
        style.setFillForegroundColor((short)22);
        style.setFillPattern((short)1);
        style.setAlignment((short)2);
        String dataType = (String)model.get("dataType");
        String[] heads = null;
        String[] columns = null;
        List dataList = null;

        try {
            if("excelMapListType".equalsIgnoreCase(dataType)) {
                String[] e1 = (String[])((String[])model.get("sheetName"));
                if(e1 == null) {
                    e1 = new String[0];
                }

                Map headMap = (Map)model.get("head");
                Map columnMap = (Map)model.get("columns");
                Map dataMap = (Map)model.get("data");
                if(headMap.size() != dataMap.size() || dataMap.size() != columnMap.size()) {
                    throw new ArrayIndexOutOfBoundsException();
                }

                Integer sheetNum = Integer.valueOf(0);

                for(Iterator i$ = dataMap.keySet().iterator(); i$.hasNext(); sheetNum = Integer.valueOf(sheetNum.intValue() + 1)) {
                    String key = (String)i$.next();
                    heads = (String[])((String[])headMap.get(key));
                    columns = (String[])((String[])columnMap.get(key));
                    dataList = (List)dataMap.get(key);
                    POIExcelUtil.createSheetAndRow(dataList, heads, columns, workbook, e1[sheetNum.intValue()] == null?key:e1[sheetNum.intValue()], style, sheetNum);
                }
            } else if("excelListType".equalsIgnoreCase(dataType)) {
                String e = (String)model.get("sheetName");
                heads = (String[])((String[])model.get("head"));
                columns = (String[])((String[])model.get("columns"));
                dataList = (List)model.get("data");

                List<List> ret = CommonUtil.splitList(dataList, 65535);
                for (int i=0; i<ret.size(); i++) {
                    String sheetName = (e == null?excelName:e);
                    if(i>0){sheetName+="_"+i;}
                    POIExcelUtil.createSheetAndRow(ret.get(i), heads, columns, workbook, sheetName, style, i);
                }
            }

        } catch (Exception var22) {
            throw var22;
        }
    }
}
