<!-- 대응 상세 -->
<!-- @author dhj -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<c:set value="F00011" var="menuId"/>
<c:set value="F00010" var="subMenuId"/>
<isaver:pageRoleCheck menuId="${menuId}" locale="${pageContext.response.locale}"/>

<div class="sub_title_area">
    <!-- 2depth 타이틀 Start-->
    <h3 class="1depth_title"><spring:message code="common.title.action"/></h3>
    <!-- 2depth 타이틀 End -->
    <div class="navigation">
        <span><isaver:menu menuId="${menuId}" /></span>
    </div>
</div>

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <form id="actionForm" method="POST">
        <article class="table_area">
            <div class="table_contents">
                <!-- 입력 테이블 Start -->
                <table class="t_defalut t_type02 actiondetail_col">
                    <colgroup>
                        <col>  <!-- 01 -->
                        <col>  <!-- 02 -->
                        <col>  <!-- 03 -->
                        <col>  <!-- 04 -->
                    </colgroup>
                    <tbody>
                    <tr>
                        <th><spring:message code="action.column.actionId"/></th>
                        <td>
                            <input type="text" name="actionId" value="${action.actionId}" placeholder="<spring:message code="action.message.requireActionId"/>"  disabled />
                        </td>
                        <th class="point"><spring:message code="action.column.actionCode"/></th>
                        <td class="point">
                            <isaver:codeSelectBox groupCodeId="ACT" codeId="${action.actionCode}" htmlTagId="actionCode" htmlTagName="actionCode" />
                            <%----%>
                            <%--<select name="actionCode">--%>
                                <%--<option value="ACT001" <c:if test="${action.actionCode == 'ACT001'}">selected</c:if>>쓰러짐</option>--%>
                                <%--<option value="ACT002" <c:if test="${action.actionCode == 'ACT002'}">selected</c:if>>크레인사고</option>--%>
                                <%--<option value="ACT003" <c:if test="${action.actionCode == 'ACT003'}">selected</c:if>>가스유출</option>--%>
                            <%--</select>--%>
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code="action.column.actionDesc"/></th>
                        <td colspan="3">
                            <textarea name="actionDesc" class="textboard">${action.actionDesc}</textarea>
                        </td>
                    </tr>
                    <c:if test="${!empty action}">
                        <tr>
                            <th><spring:message code="common.column.insertUser"/></th>
                            <td>${action.insertUserName}</td>
                            <th><spring:message code="common.column.insertDatetime"/></th>
                            <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${action.insertDatetime}" /></td>
                        </tr>
                        <tr>
                            <th><spring:message code="common.column.updateUser"/></th>
                            <td>${action.updateUserName}</td>
                            <th><spring:message code="common.column.updateDatetime"/></th>
                            <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${action.updateDatetime}" /></td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
                <!-- 입력 테이블 End -->
            </div>

            <div class="table_title_area">
                <div class="table_btn_set">
                    <c:if test="${empty action}">
                        <button class="btn btype01 bstyle03" onclick="javascript:addAction(); return false;"><spring:message code="common.button.add"/> </button>
                    </c:if>
                    <c:if test="${!empty action}">
                        <button class="btn btype01 bstyle03" onclick="javascript:saveAction(); return false;"><spring:message code="common.button.save"/> </button>
                        <button class="btn btype01 bstyle03" onclick="javascript:removeAction(); return false;"><spring:message code="common.button.remove"/> </button>
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
    var form = $('#actionForm');

    var urlConfig = {
        'addUrl':'${rootPath}/action/add.json'
        ,'saveUrl':'${rootPath}/action/save.json'
        ,'removeUrl':'${rootPath}/action/remove.json'
        ,'listUrl':'${rootPath}/action/list.html'
    };

    var messageConfig = {
        'addConfirm':'<spring:message code="action.message.addConfirm"/>'
        ,'saveConfirm':'<spring:message code="action.message.saveConfirm"/>'
        ,'removeConfirm':'<spring:message code="action.message.removeConfirm"/>'
        ,'addFailure':'<spring:message code="action.message.addFailure"/>'
        ,'saveFailure':'<spring:message code="action.message.saveFailure"/>'
        ,'removeFailure':'<spring:message code="action.message.removeFailure"/>'
        ,'addComplete':'<spring:message code="action.message.addComplete"/>'
        ,'saveComplete':'<spring:message code="action.message.saveComplete"/>'
        ,'removeComplete':'<spring:message code="action.message.removeComplete"/>'
        ,'onlyOneSelect' : '<spring:message code="action.message.onlyOneSelect"/>'
        ,'actionAddExistFail' : '<spring:message code="action.message.actionAddExistFail"/>'
        <%--,'requireActionId':'<spring:message code="action.message.requireActionId"/>'--%>
    };


    function validate(type){
//        if(form.find('input[name=actionId]').val().length == 0){
//            alertMessage('requireCodeId');
//            return false;
//        }

        return true;
    }

    function addAction(){
        if(!confirm(messageConfig['addConfirm'])){
            return false;
        }

        if(validate(1)){
            callAjax('add', form.serialize());
        }
    }

    function saveAction(){
        if(!confirm(messageConfig['saveConfirm'])){
            return false;
        }

        if(validate(1)){
            var disabled = form.find(':input:disabled').removeAttr('disabled');
            callAjax('save', form.serialize());
            disabled.attr('disabled','disabled');
        }
    }

    function removeAction(){
        if(!confirm(messageConfig['removeConfirm'])){
            return false;
        }

        if(validate(2)){
            var disabled = form.find(':input:disabled').removeAttr('disabled');
            callAjax('remove', form.serialize());
            disabled.attr('disabled','disabled');
        }
    }

    function callAjax(actionType, data){
        sendAjaxPostRequest(urlConfig[actionType + 'Url'],data,requestAction_successHandler,requestAction_errorHandler,actionType);
    }

    function requestAction_successHandler(data, dataType, actionType){

        switch(actionType){
            case 'save':
                alertMessage(actionType + 'Complete');
                cancel();
                break;
            case 'add':
                if (data['existFlag'] == "true") {
                    alertMessage('actionAddExistFail');
                } else {
                    alertMessage(actionType + 'Complete');
                    cancel();
                }
                break;
            case 'remove':
                alertMessage(actionType + 'Complete');
                cancel();
                break;
        }

    }

    function requestAction_errorHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
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