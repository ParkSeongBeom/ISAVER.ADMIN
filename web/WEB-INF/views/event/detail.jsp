<!-- 이벤트 상세 -->
<!-- @author dhj -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<c:set value="B00031" var="menuId"/>
<c:set value="B00030" var="subMenuId"/>
<%--<jabber:pageRoleCheck menuId="${menuId}" />--%>

<div class="popupbase admin_popup code_select_popup">
    <div>
        <div>
            <header>
                <h2>대응목록</h2>
            </header>
            <article>
                <input type="hidden" name="pageNumber">
                <div class="search_area">
                    <div class="search_contents">
                        <!-- 일반 input 폼 공통 -->
                        <p class="itype_01">
                            <span>ID</span>
                            <span>
                                <input type="text" name="pop_action_id" >
                            </span>
                        </p>
                        <p class="itype_01">
                            <span>구분</span>
                            <span>
                                <isaver:codeSelectBox groupCodeId="ACT" codeId="" htmlTagId="pop_action_code"/>
                            </span>
                        </p>
                    </div>
                    <div class="search_btn">
                        <button onclick="javascript:actionListLoad(); return false;" class="btn">조회</button>
                    </div>
                </div>
                <div class="table_area">
                    <div class="table_contents">
                        <!-- 입력 테이블 Start -->
                        <table id="actionList" class="t_defalut t_type01 t_style02">
                            <colgroup>
                                <col style="width: 5%;">
                                <col style="width: 15%;">
                                <col style="width: 20%;">
                                <col style="width: *%;">
                            </colgroup>
                            <thead>
                            <tr>
                                <th class="t_center"></th>
                                <th><spring:message code="action.column.actionId"/></th>
                                <th><spring:message code="action.column.actionId"/></th>
                                <th><spring:message code="action.column.actionDesc"/></th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr>
                                <td class="t_center"><input id="" type="checkbox" class="checkbox" name="checkbox01"></td>
                                <td title="">001</td>
                                <td title="">
                                    크레인 충돌
                                </td>
                                <td title="">
                                    <p class="editable01">
                                        크레인 충돌 발생시 대응 방법<br>
                                        비상연락망<br>
                                        홍길동 주임 : 010.0000.0000<br>
                                        크레인 충돌 방생 시 신속한 대처와 인명 사고 최소화를 위해 각 구역 담당관 및 주변인과의 실시간 무전 상태를 유지
                                    </p>
                                </td>
                            </tr>
                            <tr>
                                <td class="t_center"><input id="" type="checkbox" class="checkbox" name="checkbox01"></td>
                                <td title="">001</td>
                                <td title="">
                                    크레인 충돌
                                </td>
                                <td title="">
                                    <p class="editable01">
                                        크레인 충돌 발생시 대응 방법<br>
                                        비상연락망<br>
                                        홍길동 주임 : 010.0000.0000<br>
                                        크레인 충돌 방생 시 신속한 대처와 인명 사고 최소화를 위해 각 구역 담당관 및 주변인과의 실시간 무전 상태를 유지
                                    </p>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </article>
            <footer>
                <button class="btn" onclick="javascript:popup_applyButton(); return false;"><spring:message code="common.button.confirm"/></button>
                <button class="btn" onclick="javascript:popup_cancelButton(); return false;"><spring:message code="common.button.cancel"/></button>
            </footer>
        </div>
    </div>
    <div class="bg ipop_close" onclick="popup_cancelButton();"></div>
</div>

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.event"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><isaver:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->
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
                        <td class="point" colspan="3">
                            <isaver:codeSelectBox groupCodeId="EVT" codeId="${event.eventFlag}" htmlTagId="selectEventFlag" htmlTagName="eventFlag"/>
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
                    <%--<c:if test="${!empty event}">--%>
                        <%--<button class="btn btype01 bstyle03" onclick="javascript:saveEvent(); return false;"><spring:message code="common.button.save"/> </button>--%>
                        <%--<button class="btn btype01 bstyle03" onclick="javascript:removeEvent(); return false;"><spring:message code="common.button.remove"/> </button>--%>
                    <%--</c:if>--%>
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
        ,'requireCodeId':'<spring:message code="code.message.requireCodeId"/>'
        ,'requireCodeName':'<spring:message code="code.message.requireCodeName"/>'
        ,'actionListFailure':'<spring:message code="action.message.actionListFailure"/>'
        ,'onlyOneSelect' : '<spring:message code="action.message.onlyOneSelect"/>'
        ,'eventAddExistFail' : '<spring:message code="event.message.eventAddExistFail"/>'
    };

    function validate(type){
//        if(form.find('input[name=eventId]').val().length == 0){
//            alertMessage('requireCodeId');
//            return false;
//        }

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

    /* 팝업 보이기 버튼 */
    function popup_openButton() {
        $(".code_select_popup").fadeIn();
        actionListLoad();
    }

    /* 대응코드 추가 하기*/
    function popup_applyButton() {

        var checkBoxList = $("#actionList input[type=checkbox]:checkbox:checked");

        if (checkBoxList.length != 1) {
            alert(messageConfig['onlyOneSelect']);
            return;
        }

        popup_cancelButton();

        var actionId = checkBoxList.parent().parent().attr("action_id");
        $("input[name=actionId]").val(actionId);
        $(".code_list > div[action_id]").remove();
        addActionId(actionId);
    }

    /* 팝업 취소 버튼 */
    function popup_cancelButton() {
        $(".code_select_popup").fadeOut();
        return false;
    }

    /* 대응 목록 조회*/
    function actionListLoad() {
        var actionType = "actionList";

        var data = {
            actionId : $("input[name=pop_action_id]").val()
            , actionCode : $("input[name=pop_action_code]").val()
        };
        /* 대응 목록 - 내용 */
        $("#actionList > tbody").empty();

        sendAjaxPostRequest(urlConfig[actionType + 'Url'],data,requestAction_successHandler,requestAction_errorHandler,actionType);
    }

    function requestAction_successHandler(data, dataType, actionType){
        switch(actionType){
            case 'actionList':
                makeActionListFunc(data['actions']);
                break;
        }
    }

    function makeActionListFunc(actions) {
        if (actions == null && actions.length == 0) {
            return;
        }

        for (var i=0; i< actions.length; i++) {
            var action = actions[i];

            var actionId = action['actionId'];
            var actionCode = action['actionCode'];
            var actionDesc = action['actionDesc'];

            var html_item= "<tr>\n" +
                    "<td class=\"t_center\"><input id=\"\" type=\"checkbox\" class=\"checkbox\" name=\"checkbox01\"></td>\n" +
                    "<td title=\"\">" +actionId +"</td>\n" +
                    "<td title=\"\">" + actionCode + "</td>" +
                    "<td title=\"\">" + actionDesc + "</td>" +
            "    </p>\n" +
            "</td>\n" +
            "</tr>";

            var itemObject = $(html_item);
            if (actionId == $("input[name=actionId]").val()) {
                itemObject.find("input[type='checkbox']").attr("checked", "checked");
            }

            itemObject.attr("action_id", actionId );
            $("#actionList > tbody").append(itemObject);
        }
    }


    function requestAction_errorHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        alert(actionType + 'Failure');
    }

    /* 대응 코드 추가 -> hidden */
    function addActionId(_actionId) {
        if (_actionId != null && _actionId != "") {
            $("input[name=actionId]").val(_actionId);

            var btn_item = "<div action_id='"+_actionId+"'><button title='자세히 보기'>" + _actionId + "</button><button onclick='removeActoinId(this); return false;'></button></div>";

            $(".code_list").prepend(btn_item);
        }

    };

    /* 대응 코드 삭제 */
    function removeActoinId(_this) {
        var actionId = $(_this).parent().attr("action_id");
        $("input[name=actionId]").val("");
        $(_this).parent().remove();
    }

    $(document).ready(function() {

        var clistRemove = $(".code_list > div > button:nth-of-type(2)");
        /* 대응 코드 삭제 */
        clistRemove.click(function () {
            removeActoinId(this);
        });


    })
</script>