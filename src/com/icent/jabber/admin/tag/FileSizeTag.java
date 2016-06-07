package com.icent.jabber.admin.tag;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.TagSupport;
import java.io.IOException;
import java.text.DecimalFormat;
import java.util.HashMap;
import java.util.IllegalFormatConversionException;
import java.util.Map;

/**
 * 파일용량 표시</br>
 *
 * @author : kst
 * @version : 1.0
 * @since : 2014. 6. 27.
 * <pre>
 *
 * == 개정이력(Modification Information) ====================
 *
 *  수정일            수정자         수정내용
 * -------------- ------------- ---------------------------
 *  2014. 6. 27.     kst           최초 생성
 * </pre>
 */
public class FileSizeTag extends TagSupport {

//    public enum VolumnType {
//        BYTE(1), KB(2), MB(3), GB(4), TB(5);
//
//        private int value = -1;
//
//        VolumnType(int value) {
//            this.value = value;
//        }
//
//        public int getValue() {
//            return this.value;
//        }
//    }

    private final Map<Integer, String> VOLUMN_MAP = new HashMap<Integer, String>(){{
        put(0,"byte");
        put(1,"KB");
        put(2,"MB");
        put(3,"GB");
        put(4,"TB");
        put(5,"EB");
        put(6,"ZB");
        put(7,"UB");
    }};

    private String resultTag;

//    private VolumnType type = VolumnType.MB;
//
//    public void setType(VolumnType type) {
//        this.type = type;
//    }

    private long value;

    public void setValue(long value) {
        this.value = value;
    }

    private int point = 0;

    public void setPoint(int point) {
        this.point = point;
    }

    @Override
    public int doStartTag() throws JspException {
        if (this.value > 0) {
            makeResultTag();
        }
        return super.doStartTag();
    }

    private void makeResultTag() {

        double temp = Double.valueOf(String.valueOf(this.value));
        String extension = null; //= VOLUMN_MAP.get(type);

        int index = 0;
        while(index <= VOLUMN_MAP.keySet().size()){
            extension = VOLUMN_MAP.get(index);

            if(temp / 1000 >= 1){
                temp = temp / 1000;
                index++;
            }else{
                break;
            }
        }

        try{
            if (index > 1) {
                this.resultTag = String.format("%." + this.point + "f", temp) + extension;
            } else {

                this.resultTag = String.format("%,d", Math.round(temp)) + extension;
            }

        }catch(IllegalFormatConversionException e){
            this.resultTag = temp + extension;
        }


    }


    @Override
    public int doEndTag() throws JspException {
        JspWriter writer = pageContext.getOut();
        try {
            writer.print(this.resultTag);
        } catch (IOException e) {
            throw new JspException(e.getMessage());
        }
        return super.doEndTag();
    }
}
