<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<c:set value="B00051" var="menuId"/>
<c:set value="B00000" var="subMenuId"/>
<isaver:pageRoleCheck menuId="${menuId}" />

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.role"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><isaver:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <form id="roleForm" method="POST">
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
                            <th><spring:message code="role.column.roleId"/></th>
                            <td>
                                <input type="text" name="roleId" value="${role.roleId}" placeholder="<spring:message code="role.message.requireRoleId"/>" readonly="true" />
                            </td>
                            <th class="point"><spring:message code="role.column.roleName"/></th>
                            <td class="point">
                                <input type="text" name="roleName" value="${role.roleName}" placeholder="<spring:message code="role.message.requireRoleName"/>" />
                            </td>
                        </tr>
                        <tr>
                            <th class="point"><spring:message code="common.column.useYn"/></th>
                            <td class="point" colspan="3">
                                <span><input type="radio" name="delYn" value="N" ${!empty role && role.delYn == 'N' ? 'checked' : ''}/><spring:message code="common.column.useYes" /></span>
                                <span><input type="radio" name="delYn" value="Y" ${empty role || role.delYn == 'Y' ? 'checked' : ''}/><spring:message code="common.column.useNo" /></span>
                            </td>
                        </tr>
                        <c:if test="${!empty role}">
                            <tr>
                                <th><spring:message code="common.column.insertUser"/></th>
                                <td>${role.insertUserId}</td>
                                <th><spring:message code="common.column.insertDatetime"/></th>
                                <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${role.insertDatetime}" /></td>
                            </tr>
                            <tr>
                                <th><spring:message code="common.column.updateUser"/></th>
                                <td>${role.updateUserId}</td>
                                <th><spring:message code="common.column.updateDatetime"/></th>
                                <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${role.updateDatetime}" /></td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
                <!-- 입력 테이블 End -->
            </div>

            <div class="table_title_area">
                <div class="table_btn_set">
                    <c:choose>
                        <c:when test="${empty role}">
                            <button class="btn btype01 bstyle03" onclick="javascript:addRole(); return false;"><spring:message code="common.button.add"/> </button>
                        </c:when>
                        <c:otherwise>
                            <button class="btn btype01 bstyle03" onclick="javascript:saveRole(); return false;"><spring:message code="common.button.save"/> </button>
                            <button class="btn btype01 bstyle03" onclick="javascript:removeRole(); return false;"><spring:message code="common.button.remove"/> </button>
                        </c:otherwise>
                    </c:choose>
                    <button class="btn btype01 bstyle03" onclick="javascript:cancel(); return false;"><spring:message code="common.button.cancel"/> </button>
                </div>
            </div>
        </article>
        <!-- 테이블 입력 / 조회 영역 End -->
    </form>
</section>

<script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>
<script type="application/javascript">
    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');
    var form = $('#roleForm');

    var METHOD = {
        ADD:'add',
        SAVE:'save',
        REMOVE:'remove',
        DETAIL:'detail'
    };

    var ACTION = {
        ADD:'add',
        SAVE:'save',
        REMOVE:'remove',
        DETAIL:'detail'
    };

    var messageConfig = {
        'addConfirm':'<spring:message code="role.message.addConfirm"/>'
        ,'saveConfirm':'<spring:message code="role.message.saveConfirm"/>'
        ,'removeConfirm':'<spring:message code="role.message.removeConfirm"/>'
        ,'addFailure':'<spring:message code="role.message.addFailure"/>'
        ,'saveFailure':'<spring:message code="role.message.saveFailure"/>'
        ,'removeFailure':'<spring:message code="role.message.removeFailure"/>'
        ,'addComplete':'<spring:message code="role.message.addComplete"/>'
        ,'saveComplete':'<spring:message code="role.message.saveComplete"/>'
        ,'removeComplete':'<spring:message code="role.message.removeComplete"/>'
        ,'requireRoleName':'<spring:message code="role.message.requireRoleName"/>'
    };

    function getRequestUrl(type, method) {

        var rootUrl = String();
        try {
            rootUrl = String('${rootPath}');
        }catch(e) {rootUrl = '';}

        return {
            add: rootUrl + "/" + type + "/add.json",
            save: rootUrl + "/" + type + "/save.json",
            remove: rootUrl + "/" + type + "/remove.json",
            //detail: rootUrl + "/" + type + "/detail.html",
            list: rootUrl + "/" + type + "/list.html"
        }[method];
    };

    function validate(type){
        if(form.find('input[name=roleName]').val().length == 0 && type != 3){
            alertMessage('requireRoleName');
            return false;
        }

        return true;
    }

    function addRole(){
        if(!confirm(messageConfig['addConfirm'])){
            return false;
        }

        if(validate(1)){
            callAjax(ACTION.ADD, METHOD.ADD);
        }
    }

    function saveRole(){
        if(!confirm(messageConfig['saveConfirm'])){
            return false;
        }

        if(validate(2)) {
            callAjax(ACTION.SAVE, METHOD.SAVE);
        }
    }

    function removeRole(){
        if(!confirm(messageConfig['removeConfirm'])){
            return false;
        }

        if(validate(3)) {
            callAjax(ACTION.REMOVE, METHOD.REMOVE);
        }
    }

    function callAjax(actionType, method){
        var type = 'role';
        var data = form.serialize();

        sendAjaxPostRequest(getRequestUrl(type, method), data, requestCode_successHandler,requestCode_errorHandler, actionType);
    }

    function requestCode_successHandler(data, dataType, actionType){
        alertMessage(actionType + 'Complete');
        switch(actionType){
            case ACTION.SAVE:
                break;
            case ACTION.ADD:
            case ACTION.REMOVE:
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
        location.href=getRequestUrl('role','list');
    }

</script>