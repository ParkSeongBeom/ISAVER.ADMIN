<!-- 파일관리 상세 -->
<!-- @author psb -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<c:set value="L00030" var="menuId"/>
<c:set value="L00000" var="subMenuId"/>
<isaver:pageRoleCheck menuId="${menuId}" locale="${pageContext.response.locale}"/>

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.fileSetting"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><isaver:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <form id="fileSettingForm" method="POST">
        <input type="hidden" name="fileType" value="${fileSetting.fileType}"/>

        <article class="table_area">
            <div class="table_contents">
                <!-- 입력 테이블 Start -->
                <table class="t_defalut t_type02 filedetail_col">
                    <colgroup>
                        <col>  <!-- 01 -->
                        <col>  <!-- 02 -->
                        <col>  <!-- 03 -->
                        <col>  <!-- 04 -->
                    </colgroup>
                    <tbody>
                        <tr>
                            <th class="point"><spring:message code="fileSetting.column.limitKeepTime"/></th>
                            <td class="point">
                                <input type="text" name="limitKeepTime" value="${fileSetting.limitKeepTime}" maxlength="2" onkeypress="isNumber(this);"/>
                            </td>
                            <th><spring:message code="fileSetting.column.limitKeepType"/></th>
                            <td>
                                <select name="limitKeepType">
                                    <option value="" ><spring:message code="common.selectbox.all"/></option>
                                    <option value="event" <c:if test="${fileSetting.limitKeepType == 'event'}">selected="selected"</c:if>><spring:message code="videoHistory.selectbox.event"/></option>
                                    <option value="normal" <c:if test="${fileSetting.limitKeepType == 'normal'}">selected="selected"</c:if>><spring:message code="videoHistory.selectbox.normal"/></option>
                                </select>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <!-- 입력 테이블 End -->
            </div>

            <div class="table_title_area">
                <div class="table_btn_set">
                    <button class="btn btype01 bstyle03" onclick="javascript:saveFileSetting(); return false;"><spring:message code="common.button.save"/> </button>
                </div>
            </div>
        </article>
        <!-- 테이블 입력 / 조회 영역 End -->
    </form>
</section>

<script type="text/javascript">
    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');
    var form = $('#fileSettingForm');

    var urlConfig = {
        'saveUrl':'${rootPath}/fileSetting/save.json'
    };

    var messageConfig = {
        'saveConfirm':'<spring:message code="fileSetting.message.saveConfirm"/>'
        ,'saveFailure':'<spring:message code="fileSetting.message.saveFailure"/>'
        ,'saveComplete':'<spring:message code="fileSetting.message.saveComplete"/>'
        ,'limitKeepTimeEmpty':'<spring:message code="fileSetting.message.limitKeepTimeEmpty"/>'
    };

    $(document).ready(function() {
    });

    function validate(){
        if(form.find('input[name=limitKeepTime]').val().length == 0){
            alertMessage('limitKeepTimeEmpty');
            return false;
        }
        return true;
    }

    function saveFileSetting(){
        if(!confirm(messageConfig['saveConfirm'])){
            return false;
        }
        if(validate(2)){
            callAjax('save', form.serialize());
        }
    }

    function callAjax(actionType, data){
        sendAjaxPostRequest(urlConfig[actionType + 'Url'],data,requestCode_successHandler,requestCode_errorHandler,actionType);
    }

    function requestCode_successHandler(data, dataType, actionType){
        switch(actionType){
            case 'save':
                alertMessage(actionType + 'Complete');
                break;
        }
    }

    function requestCode_errorHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        alertMessage(actionType + 'Failure');
    }

    function alertMessage(type){
        alert(messageConfig[type]);
    }
</script>