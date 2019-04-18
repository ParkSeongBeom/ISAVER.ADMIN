<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<c:set value="B00021" var="menuId"/>
<c:set value="B00020" var="subMenuId"/>
<isaver:pageRoleCheck menuId="${menuId}" locale="${pageContext.response.locale}"/>

<div class="sub_title_area">
    <h3 class="1depth_title"><spring:message code="common.title.groupCode"/></h3>
    <div class="navigation">
        <span><isaver:menu menuId="${menuId}" /></span>
    </div>
</div>

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <form id="groupCodeForm" method="POST">
        <article class="table_area">
            <div class="table_contents">
                <!-- 입력 테이블 Start -->
                <table class="t_defalut t_type02 groupcodedetail_col">
                    <colgroup>
                        <col>  <!-- 01 -->
                        <col>  <!-- 02 -->
                        <col>  <!-- 03 -->
                        <col>    <!-- 04 -->
                    </colgroup>
                    <tbody>
                        <tr>
                            <th class="point"><spring:message code="groupcode.column.groupCodeId"/></th>
                            <td class="point">
                                <input type="text" name="groupCodeId" maxlength="3" value="${groupCode.groupCodeId}" placeholder="<spring:message code="groupcode.message.requireGroupCodeId"/>" ${empty groupCode ? '' : 'readonly="true"'} />
                            </td>
                            <th class="point"><spring:message code="groupcode.column.groupName"/></th>
                            <td class="point">
                                <input type="text" name="groupName" value="${groupCode.groupName}" placeholder="<spring:message code="groupcode.message.requireGroupName"/>" />
                            </td>
                        </tr>
                        <c:if test="${!empty groupCode}">
                            <tr>
                                <th><spring:message code="common.column.insertUser"/></th>
                                <td>${groupCode.insertUserName}</td>
                                <th><spring:message code="common.column.insertDatetime"/></th>
                                <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${groupCode.insertDatetime}" /></td>
                            </tr>
                            <tr>
                                <th><spring:message code="common.column.updateUser"/></th>
                                <td>${groupCode.updateUserName}</td>
                                <th><spring:message code="common.column.updateDatetime"/></th>
                                <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${groupCode.updateDatetime}" /></td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
                <!-- 입력 테이블 End -->
            </div>

            <div class="table_title_area">
                <div class="table_btn_set">
                    <c:if test="${empty groupCode}">
                        <button class="btn btype01 bstyle03" onclick="javascript:addGroupCode(); return false;"><spring:message code="common.button.add"/> </button>
                    </c:if>
                    <c:if test="${!empty groupCode}">
                        <button class="btn btype01 bstyle03" onclick="javascript:saveGroupCode(); return false;"><spring:message code="common.button.save"/> </button>
                        <button class="btn btype01 bstyle03" onclick="javascript:removeGroupCode(); return false;"><spring:message code="common.button.remove"/> </button>
                    </c:if>
                    <button class="btn btype01 bstyle03" onclick="javascript:cancel(); return false;"><spring:message code="common.button.list"/> </button>
                </div>
            </div>
        </article>
        <!-- 테이블 입력 / 조회 영역 End -->
    </form>
</section>

<script type="text/javascript">
    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');
    var form = $('#groupCodeForm');

    var urlConfig = {
        'addUrl':'${rootPath}/groupcode/add.json'
        ,'saveUrl':'${rootPath}/groupcode/save.json'
        ,'removeUrl':'${rootPath}/groupcode/remove.json'
        ,'listUrl':'${rootPath}/groupcode/list.html'
    };

    var messageConfig = {
        'addConfirm':'<spring:message code="groupcode.message.addConfirm"/>'
        ,'saveConfirm':'<spring:message code="groupcode.message.saveConfirm"/>'
        ,'removeConfirm':'<spring:message code="groupcode.message.removeConfirm"/>'
        ,'addFailure':'<spring:message code="groupcode.message.addFailure"/>'
        ,'saveFailure':'<spring:message code="groupcode.message.saveFailure"/>'
        ,'removeFailure':'<spring:message code="groupcode.message.removeFailure"/>'
        ,'addComplete':'<spring:message code="groupcode.message.addComplete"/>'
        ,'saveComplete':'<spring:message code="groupcode.message.saveComplete"/>'
        ,'removeComplete':'<spring:message code="groupcode.message.removeComplete"/>'
        ,'requireGroupCodeId':'<spring:message code="groupcode.message.requireGroupCodeId"/>'
        ,'lengthFailGroupCodeId':'<spring:message code="groupcode.message.lengthFailGroupCodeId"/>'
        ,'requireGroupName':'<spring:message code="groupcode.message.requireGroupName"/>'
    };

    function validate(type){
        if(form.find('input[name=groupCodeId]').val().length == 0){
            alertMessage('requireGroupCodeId');
            return false;
        }else if(form.find('input[name=groupCodeId]').val().length != 3){
            alertMessage('lengthFailGroupCodeId');
            return false;
        }

        switch(type){
            case 1:
                if(form.find('input[name=groupName]').val().length == 0){
                    alertMessage('requireGroupName');
                    return false;
                }
                break;
            case 2:
                break;
            default:
        }
        return true;
    }

    function addGroupCode(){
        if(!confirm(messageConfig['addConfirm'])){
            return false;
        }


        if(validate(1)){
            callAjax('add', form.serialize());
        }
    }

    function saveGroupCode(){
        if(!confirm(messageConfig['saveConfirm'])){
            return false;
        }

        if(validate(1)){
            callAjax('save', form.serialize());
        }
    }

    function removeGroupCode(){
        if(!confirm(messageConfig['removeConfirm'])){
            return false;
        }

        if(validate(2)){
            callAjax('remove', form.serialize());
        }
    }

    function callAjax(actionType, data){
        sendAjaxPostRequest(urlConfig[actionType + 'Url'],data,requestCode_successHandler,requestCode_errorHandler,actionType);
    }

    function requestCode_successHandler(data, dataType, actionType){
        alertMessage(actionType + 'Complete');
        switch(actionType){
            case 'save':
            case 'add':
            case 'remove':
                cancel();
                break;
        }
    }

    function requestCode_errorHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        alertMessage(actionType + 'Failure');
    }

    function alertMessage(type){
        alert(messageConfig[type]);
    }

    function cancel(){
        var listForm = $('<FORM>').attr('method','POST').attr('action',urlConfig['listUrl']);
        listForm.appendTo(document.body);
        listForm.submit();
    }
</script>