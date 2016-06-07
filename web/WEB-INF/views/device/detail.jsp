<!-- 이벤트 상세 -->
<!-- @author dhj -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="jabber" uri="/WEB-INF/views/common/tags/jabber.tld"%>
<c:set value="MN000000-A000-0000-0000-000000000000" var="subMenuId"/>
<c:set value="MN000000-A000-0000-0000-000000000005" var="menuId"/>
<%--<jabber:pageRoleCheck menuId="${menuId}" />--%>
<script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/common-util.js"></script>

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.event"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><jabber:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <form id="eventForm" method="POST">
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
                            <input type="text" name="eventId" value="${event.eventId}" ${empty event ? '' : 'readonly="true"'} />
                        </td>
                        <th class="point"><spring:message code="event.column.eventName"/></th>
                        <td class="point">
                            <input type="text" name="eventName" value="${event.eventName}" placeholder="<spring:message code="code.message.requireCodeId"/>" />
                        </td>
                    </tr>
                    <tr>
                        <th class="point"><spring:message code="event.column.eventFlag"/></th>
                        <td class="point">
                            <select name="eventFlag">
                                <option value="D" <c:if test="${event.eventFlag == 'D'}">selected</c:if>>감지</option>
                                <option value="A" <c:if test="${event.eventFlag == 'A'}">selected</c:if>>알림</option>
                            </select>
                        </td>
                        <th class="point"><spring:message code="common.column.useYn"/></th>
                        <td class="point">
                            <input type="radio" name="delYn" value="N" ${!empty event && event.delYn == 'N' ? 'checked' : ''}/><spring:message code="common.column.useYes" />
                            <input type="radio" name="delYn" value="Y" ${empty event || event.delYn == 'Y' ? 'checked' : ''}/><spring:message code="common.column.useNo" />
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code="common.column.description"/></th>
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
                    <c:if test="${empty event}">
                        <button class="btn btype01 bstyle03" onclick="javascript:addEvent(); return false;"><spring:message code="common.button.add"/> </button>
                    </c:if>
                    <c:if test="${!empty event}">
                        <button class="btn btype01 bstyle03" onclick="javascript:saveEvent(); return false;"><spring:message code="common.button.save"/> </button>
                        <button class="btn btype01 bstyle03" onclick="javascript:removeEvent(); return false;"><spring:message code="common.button.remove"/> </button>
                    </c:if>
                    <button class="btn btype01 bstyle03" onclick="javascript:cancel(); return false;"><spring:message code="common.button.cancel"/> </button>
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
        ,'requireCodeId':'<spring:message code="code.message.requireCodeId"/>'
        ,'requireCodeName':'<spring:message code="code.message.requireCodeName"/>'
    };

    function validate(type){
        if(form.find('input[name=eventId]').val().length == 0){
            alertMessage('requireCodeId');
            return false;
        }

        switch(type){
            case 1:
                if(form.find('input[name=eventName]').val().length == 0){
                    alertMessage('requireCodeName');
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
        sendAjaxPostRequest(urlConfig[actionType + 'Url'],data,requestCode_successHandler,requestCode_errorHandler,actionType);
    }

    function requestCode_successHandler(data, dataType, actionType){
        alertMessage(actionType + 'Complete');
        switch(actionType){
            case 'save':
                break;
            case 'add':
            case 'remove':
                cancel();
                break;
        }
    }

    function requestCode_errorHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        alert(actionType + 'Failure');
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