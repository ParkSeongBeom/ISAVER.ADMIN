package com.icent.isaver.admin.tag;

import com.icent.isaver.admin.resource.AdminResource;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.TagSupport;
import java.io.IOException;
import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.Map;

/**
 * 공통 리소스 기반으로 선택형 element를 그린다.</br>
 * - AdminResource.class 기반
 * - select, radio 지원</br>
 * - array형태의 field는 key,value값이 동일하도록 제작</br>
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
public class ResourceElementTag extends TagSupport {

    /**
     * 대상 리소스 명
     * @author kst
     */
    private String resourceName = null;

    /**
     * 구현 엘리먼트 타입.
     * @author kst
     */
    private String elementType = "select";

    /**
     * 구현 엘리먼트 name attribute
     * @author kst
     */
    private String elementName = null;

    /**
     * 엘리먼트 string
     * @author kst
     */
    private String resultTag = AdminResource.EMPTY_STRING;

    /**
     * 초기선택값
     * @author kst
     */
    private String initValue = null;

    public void setResourceName(String resourceName){
        this.resourceName = resourceName;
    }

    public void setElementType(String elementType){
        this.elementType = elementType;
    }

    public void setElementName(String elementName) {
        this.elementName = elementName;
    }

    public void setInitValue(String initValue) {
        this.initValue = initValue;
    }

    @Override
    public int doStartTag() throws JspException {
        Field resource = null;
        if(this.resourceName != null){
            try {
                resource = AdminResource.class.getField(this.resourceName);
            } catch (NoSuchFieldException e) {

            }
        }

        Map<String, String> resourceMap = null;
        if(resource != null){

            try {
                resourceMap = convertFieldToMap(resource);
            } catch (IllegalAccessException e) {
                e.printStackTrace();
            }
        }

        if(resourceMap != null){
            makeElement(resourceMap);
        }

        return super.doStartTag();
    }

    private Map<String, String> convertFieldToMap(Field field) throws IllegalAccessException {
        Map<String, String> resultMap = null;
        if(field.getType() == String[].class){
            String[] resourceArr = (String[]) field.get(null);

            resultMap = new HashMap<String, String>();
            for(String value : resourceArr){
                resultMap.put(value,value);
            }
        }else if(field.getType() == Map.class){
            resultMap = (Map<String, String>) field.get(null);
        }
        return resultMap;
    }

    private void makeElement(Map<String, String> resourceMap){
        StringBuilder sb = new StringBuilder("");

        switch(this.elementType){
            case "select":
            case "SELECT":
                makeElementSelectBox(sb, resourceMap);
                break;
            case "radio":
            case "RADIO":
                makeElementRadio(sb, resourceMap);
                break;
            default:
        }

        this.resultTag = sb.toString();
    }

    private void makeElementRadio(StringBuilder sb, Map<String, String> resourceMap){
        String nameAttribute = AdminResource.EMPTY_STRING;
        if(this.elementName != null){
            nameAttribute = " name=\"" + this.elementName + "\"";
        }

        for(String key : resourceMap.keySet()){
            sb.append("<span>");
            sb.append("<input type=\"radio\"");
            sb.append(nameAttribute);
            sb.append(" value=\"");
            sb.append(key);
            sb.append("\"");
            if(this.initValue != null && this.initValue.equalsIgnoreCase(key)){
                sb.append(" checked");
            }
            sb.append(">");
            sb.append(resourceMap.get(key));
            sb.append("</span>");
        }

    }

    private void makeElementSelectBox(StringBuilder sb, Map<String, String> resourceMap){
        sb.append("<select");
        if(this.elementName != null){
            sb.append(" name=\"");
            sb.append(this.elementName);
            sb.append("\"");
        }
        sb.append(">");

        for(String key : resourceMap.keySet()){
            sb.append("<option value=\"");
            sb.append(key);
            sb.append("\"");
            if(this.initValue != null && this.initValue.equalsIgnoreCase(key)){
                sb.append(" selected");
            }
            sb.append(">");
            sb.append(resourceMap.get(key));
            sb.append("</option>");
        }

        sb.append("</select>");
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
