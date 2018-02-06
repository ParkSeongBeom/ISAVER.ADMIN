<!-- 이벤트 상세 -->
<!-- @author dhj -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<%@ taglib prefix="for" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set value="F00013" var="menuId"/>
<c:set value="F00012" var="subMenuId"/>
<isaver:pageRoleCheck menuId="${menuId}" />

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.eventAction"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><isaver:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->
    <form id="eventForm" method="POST" onsubmit="return false;">
        <input type="hidden" name="eventId" value="${event.eventId}" />
        <article class="table_area">
            <div class="table_contents">
                <!-- 입력 테이블 Start -->
                <table class="t_defalut t_type02 eventactiondetail_col">
                    <colgroup>
                        <col>  <!-- 01 -->
                        <col>  <!-- 02 -->
                        <col>  <!-- 03 -->
                        <col>  <!-- 04 -->
                    </colgroup>
                    <tbody>
                    <tr>
                        <th><spring:message code="event.column.eventId"/></th>
                        <td>${event.eventId}</td>
                        <th><spring:message code="event.column.eventFlag"/></th>
                        <td>${event.eventFlagName}</td>
                    </tr>
                    <tr>
                        <th><spring:message code="event.column.eventName"/></th>
                        <td colspan="3">${event.eventName}</td>
                    </tr>
                    <tr>
                        <th><spring:message code="event.column.eventDesc"/></th>
                        <td colspan="3">${event.eventDesc}</td>
                    </tr>
                    <tr>
                        <th><spring:message code="action.column.actionId"/></th>
                        <td colspan="3">
                            <select name="actionId">
                                <option value="">선택안함</option>
                                <c:forEach var="action" items="${actions}">
                                    <option value="${action.actionId}" actionDesc="${action.actionDesc}" ${event.actionId==action.actionId?'selected':''}>${action.actionId} - ${action.actionCode}</option>
                                </c:forEach>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code="action.column.actionDesc"/></th>
                        <td colspan="3" desc>${event.actionDesc}</td>
                    </tr>
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
        'listUrl':'${rootPath}/eventAction/list.html'
        ,'actionListUrl':'${rootPath}/action/list.json'
        ,'saveUrl':'${rootPath}/eventAction/save.json'
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
        ,'actionListFailure':'<spring:message code="action.message.actionListFailure"/>'
        ,'onlyOneSelect' : '<spring:message code="action.message.onlyOneSelect"/>'
        ,'eventAddExistFail' : '<spring:message code="event.message.eventAddExistFail"/>'
    };

    $(document).ready(function() {
        $("select[name='actionId']").on('change',function(){
            var actionDesc = $(this).find("option:selected").attr("actionDesc");
            $("td[desc]").text(actionDesc!=null?actionDesc:'');
        });
    });

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

        callAjax('save', form.serialize());
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
                cancel();
                break;
            case 'add':
                if (data['existFlag'] == "true") {
                    alertMessage('eventAddExistFail');
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