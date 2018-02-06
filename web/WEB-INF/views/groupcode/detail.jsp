<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<c:set value="B00021" var="menuId"/>
<c:set value="B00020" var="subMenuId"/>
<isaver:pageRoleCheck menuId="${menuId}" />

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.groupCode"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><isaver:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <form id="groupCodeForm" method="POST">
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
                        <%--<button id="add_btn" class="btn btype01 bstyle03" onclick="javascript:addGroupCode(); return false;"><spring:message code="common.button.add"/> </button>--%>
                        <button id="add_btn" class="btn btype01 bstyle03"><spring:message code="common.button.add"/> </button>
                    </c:if>
                    <c:if test="${!empty groupCode}">
                        <%--<button class="btn btype01 bstyle03" onclick="javascript:saveGroupCode(); return false;"><spring:message code="common.button.save"/> </button>--%>
                        <button  id="save_btn" class="btn btype01 bstyle03"><spring:message code="common.button.save"/> </button>
                        <%--<button  id="remove_btn" class="btn btype01 bstyle03" onclick="javascript:removeGroupCode(); return false;"><spring:message code="common.button.remove"/> </button>--%>
                        <button  id="remove_btn" class="btn btype01 bstyle03"><spring:message code="common.button.remove"/> </button>
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

            if (addBtnObj['checkVar'] == 0) {
                addBtnObj['checkVar'] = 1;
                callAjax('add', form.serialize());
            }

        }
    }

    function saveGroupCode(){
        if(!confirm(messageConfig['saveConfirm'])){
            return false;
        }

        if(validate(1)){

            if (saveBtnObj['checkVar'] == 0) {
                saveBtnObj['checkVar'] = 1;
                callAjax('save', form.serialize());
            }

        }
    }

    function removeGroupCode(){
        if(!confirm(messageConfig['removeConfirm'])){
            return false;
        }

        if(validate(2)){
            if (removeBtnObj['checkVar'] == 0) {
                removeBtnObj['checkVar'] = 1;
                callAjax('remove', form.serialize());
            }

        }
    }

    function callAjax(actionType, data){
        sendAjaxPostRequest(urlConfig[actionType + 'Url'],data,requestCode_successHandler,requestCode_errorHandler,actionType);
    }

    function requestCode_successHandler(data, dataType, actionType){

        alertMessage(actionType + 'Complete');

        switch(actionType){
            case 'save':
                saveBtnObj['checkVar'] = 0;
                break;
            case 'add':
                addBtnObj['checkVar'] = 0;
                break;
            case 'remove':
                removeBtnObj['checkVar'] = 0;
                cancel();
                break;
        }
    }

    function requestCode_errorHandler(XMLHttpRequest, textStatus, errorThrown, actionType){

        addBtnObj['checkVar'] = saveBtnObj['checkVar'] = removeBtnObj['checkVar'] = 0;
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

    /** 등록 버튼**/
    var addBtnObj = {
        checkVar : 0
        /** HTML 엘리먼트 ID **/
        , element_id : "add_btn"
        /** javascript 실행 함수 명 **/
        , executeFunctionName : "addGroupCode"
        /** 중복 클릭 시 메세지 명 **/
        , msgText : '<spring:message code="common.message.userDoubleClick"/>'
        /** 중복 클릭 시 메세지  출력 타임 아웃(ms) **/
        , timeoutCnt : 1000
    };

    /** 저장 버튼**/
    var saveBtnObj = {
        checkVar : 0
        /** HTML 엘리먼트 ID **/
        , element_id : "save_btn"
        /** javascript 실행 함수 명 **/
        , executeFunctionName : "saveGroupCode"
        /** 중복 클릭 시 메세지 명 **/
        , msgText : '<spring:message code="common.message.userDoubleClick"/>'
        /** 중복 클릭 시 메세지  출력 타임 아웃(ms) **/
        , timeoutCnt : 1000
    };

    /** 삭제 버튼**/
    var removeBtnObj = {
        checkVar : 0
        /** HTML 엘리먼트 ID **/
        , element_id : "remove_btn"
        /** javascript 실행 함수 명 **/
        , executeFunctionName : "removeGroupCode"
        /** 중복 클릭 시 메세지 명 **/
        , msgText : '<spring:message code="common.message.userDoubleClick"/>'
        /** 중복 클릭 시 메세지  출력 타임 아웃(ms) **/
        , timeoutCnt : 1000
    };

    /**
     * HTML 버튼 이벤트 추가
     * @author dhj
     */
    function eventAddListener() {
        /** 등록 **/
        createDoubleClickEventListener(addBtnObj);
        /** 수정 **/
        createDoubleClickEventListener(saveBtnObj);
        /** 삭제 **/
        createDoubleClickEventListener(removeBtnObj);
    }

    $(document).ready(function() {
        /** HTML 태그 이벤트 추가, @author dhj **/
        eventAddListener();
    });
</script>