<!-- 이벤트 상세 -->
<!-- @author dhj -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<c:set value="B00031" var="menuId"/>
<c:set value="B00030" var="subMenuId"/>
<isaver:pageRoleCheck menuId="${menuId}" locale="${pageContext.response.locale}"/>

<div class="sub_title_area">
    <h3 class="1depth_title"><spring:message code="common.title.event"/></h3>
    <div class="navigation">
        <span><isaver:menu menuId="${menuId}" /></span>
    </div>
</div>

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <form id="eventForm" method="POST">
        <input type="hidden" name="actionId" value="${event.actionId}" />
        <article class="table_area">
            <div class="table_contents">
                <!-- 입력 테이블 Start -->
                <table class="t_defalut t_type02 t_style03">
                    <colgroup>
                        <col style="width:16%">  <!-- 01 -->
                        <col style="width:34%">  <!-- 02 -->
                        <col style="width:16%">  <!-- 03 -->
                        <col style="width:*">    <!-- 04 -->
                    </colgroup>
                    <tbody>
                    <tr>
                        <th class="point"><spring:message code="event.column.eventId"/></th>
                        <td class="point">
                            <input type="text" name="eventId" value="${event.eventId}" placeholder="<spring:message code="event.message.requireEventId"/>" readonly="readonly" maxlength="6"/>
                        </td>
                        <th class="point"><spring:message code="event.column.eventName"/></th>
                        <td class="point">
                            <input type="text" name="eventName" value="${event.eventName}" placeholder="<spring:message code="event.message.requireEventName"/>" />
                        </td>
                    </tr>
                    <tr>
                        <th class="point"><spring:message code="event.column.eventFlag"/></th>
                        <td class="point">
                            <isaver:codeSelectBox groupCodeId="EVT" codeId="${event.eventFlag}" htmlTagName="eventFlag"/>
                        </td>
                        <th class="point"><spring:message code="common.column.useYn"/></th>
                        <td class="point">
                            <div class="checkbox_set csl_style03">
                                <input type="hidden" name="delYn" value="${!empty event && event.delYn == 'Y' ? 'Y' : 'N'}"/>
                                <input type="checkbox" ${!empty event && event.delYn == 'N' ? 'checked' : ''} onchange="setCheckBoxYn(this,'delYn',true)"/>
                                <label></label>
                            </div>
                            <%--<isaver:codeSelectBox groupCodeId="STS" codeId="${event.statisticsCode}" htmlTagName="statisticsCode" disabled="true"/>--%>
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code="event.column.eventDesc"/></th>
                        <td colspan="3">
                            <textarea name="eventDesc" class="textboard">${event.eventDesc}</textarea>
                        </td>
                    </tr>
                    <c:if test="${!empty event}">
                        <tr>
                            <th><spring:message code="common.column.insertUser"/></th>
                            <td>${event.insertUserName}</td>
                            <th><spring:message code="common.column.insertDatetime"/></th>
                            <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${event.insertDatetime}" /></td>
                        </tr>
                        <tr>
                            <th><spring:message code="common.column.updateUser"/></th>
                            <td>${event.updateUserName}</td>
                            <th><spring:message code="common.column.updateDatetime"/></th>
                            <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${event.updateDatetime}" /></td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
                <!-- 입력 테이블 End -->
            </div>

            <div class="table_title_area">
                <div class="table_btn_set">
                    <%--<c:if test="${empty event}">--%>
                        <%--<button class="btn btype01 bstyle03" onclick="javascript:addEvent(); return false;"><spring:message code="common.button.add"/> </button>--%>
                    <%--</c:if>--%>
                    <c:if test="${!empty event}">
                        <button class="btn btype01 bstyle03" onclick="javascript:saveEvent(); return false;"><spring:message code="common.button.save"/> </button>
                        <%--<button class="btn btype01 bstyle03" onclick="javascript:removeEvent(); return false;"><spring:message code="common.button.remove"/> </button>--%>
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
    var form = $('#eventForm');

    var urlConfig = {
        'addUrl':'${rootPath}/event/add.json'
        ,'saveUrl':'${rootPath}/event/save.json'
        ,'removeUrl':'${rootPath}/event/remove.json'
        ,'listUrl':'${rootPath}/event/list.html'
        ,'actionListUrl':'${rootPath}/action/list.html'
    };

    var messageConfig = {
        'addConfirm':'<spring:message code="event.message.addConfirm"/>'
        ,'saveConfirm':'<spring:message code="event.message.saveConfirm"/>'
        ,'removeConfirm':'<spring:message code="event.message.removeConfirm"/>'
        ,'addFailure':'<spring:message code="event.message.addFailure"/>'
        ,'saveFailure':'<spring:message code="event.message.saveFailure"/>'
        ,'removeFailure':'<spring:message code="event.message.removeFailure"/>'
        ,'addComplete':'<spring:message code="event.message.addComplete"/>'
        ,'saveComplete':'<spring:message code="event.message.saveComplete"/>'
        ,'removeComplete':'<spring:message code="event.message.removeComplete"/>'
        ,'emptyEventName':'<spring:message code="event.message.emptyEventName"/>'
        ,'eventAddExistFail' : '<spring:message code="event.message.eventAddExistFail"/>'
    };

    $(document).ready(function() {
    });

    function validate(type){
        switch(type){
            case 1:
                if(form.find('input[name=eventName]').val().length == 0){
                    alertMessage('emptyEventName');
                    return false;
                }
                break;
            case 2:
                break;
        }

        return true;
    }

    function addEvent(){
        if(!confirm(messageConfig['addConfirm'])){
            return false;
        }

        if(validate(1)){
            callAjax('add', form.serialize());
        }
    }

    function saveEvent(){
        if(!confirm(messageConfig['saveConfirm'])){
            return false;
        }

        if(validate(1)){
            callAjax('save', form.serialize());
        }
    }

    function removeEvent(){
        if(!confirm(messageConfig['removeConfirm'])){
            return false;
        }

        if(validate(2)){
            callAjax('remove', form.serialize());
        }
    }

    function callAjax(actionType, data){
        sendAjaxPostRequest(urlConfig[actionType + 'Url'],data,requestEvent_successHandler,requestEvent_errorHandler,actionType);
    }

    function requestEvent_successHandler(data, dataType, actionType){
        switch(actionType){
            case 'save':
                alertMessage(actionType + 'Complete');
                break;
            case 'add':
                if (data['existFlag'] == "true") {
                    alertMessage('eventAddExistFail');
                } else {
                    alertMessage(actionType + 'Complete');
                }
                break;
            case 'remove':
                alertMessage(actionType + 'Complete');
                break;
        }
        cancel();
    }

    function requestEvent_errorHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
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