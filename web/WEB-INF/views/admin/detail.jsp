<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="jabber" uri="/WEB-INF/views/common/tags/jabber.tld"%>
<c:set value="MN000000-A000-0000-0000-000000000000" var="subMenuId"/>
<c:set value="MN000000-A000-0000-0000-000000000004" var="menuId"/>
<jabber:pageRoleCheck menuId="${menuId}" />
<script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/common-util.js"></script>

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.admin"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><jabber:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <form id="adminForm" method="POST">
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
                            <th class="point"><spring:message code="admin.column.adminId"/></th>
                            <td class="point">
                                <input type="text" name="adminId" value="${admin.adminId}" placeholder="<spring:message code="admin.message.requireAdminId"/>" ${empty admin ? '' : 'readonly="true"'} />
                            </td>
                            <th class="point"><spring:message code="admin.column.name"/></th>
                            <td class="point">
                                <input type="text" name="name" value="${admin.name}"/>
                            </td>
                        </tr>
                        <tr>
                            <th class="point"><spring:message code="admin.column.password"/></th>
                            <td class="point">
                                <input type="password" name="password" placeholder="<spring:message code="common.message.passwordEdit"/>" />
                            </td>
                            <th class="point"><spring:message code="admin.column.passwordConfirm"/></th>
                            <td class="point">
                                <input type="password" name="password_confirm" placeholder="<spring:message code="common.message.passwordEdit"/>" />
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="admin.column.email"/></th>
                            <td>
                                <input type="text" name="email" value="${admin.email}" />
                            </td>
                            <th><spring:message code="admin.column.phoneNumber"/></th>
                            <td>
                                <input type="text" name="phoneNumber" value="${admin.phoneNumber}" onkeypress="isNumber(this)"/>
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="common.column.description"/></th>
                            <td colspan="3">
                                <textarea name="description" class="textboard">${admin.description}</textarea>
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="admin.column.roleName"/></th>
                            <td colspan="3">
                                <select name="roleId">
                                    <option value=""><spring:message code="common.button.select"/> </option>
                                    <c:forEach items="${roles}" var="role">
                                        <option value="${role.roleId}" ${admin.roleId == role.roleId ? 'selected' : ''}>${role.roleName}</option>
                                    </c:forEach>
                                </select>
                            </td>
                        </tr>
                        <c:if test="${!empty admin}">
                            <tr>
                                <th><spring:message code="common.column.insertUser"/></th>
                                <td>${admin.insertUserName}</td>
                                <th><spring:message code="common.column.insertDatetime"/></th>
                                <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${admin.insertDatetime}" /></td>
                            </tr>
                            <tr>
                                <th><spring:message code="common.column.updateUser"/></th>
                                <td>${admin.updateUserName}</td>
                                <th><spring:message code="common.column.updateDatetime"/></th>
                                <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${admin.updateDatetime}" /></td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
                <!-- 입력 테이블 End -->
            </div>

            <div class="table_title_area">
                <div class="table_btn_set">
                    <c:if test="${empty admin}">
                        <button class="btn btype01 bstyle03" onclick="javascript:addAdmin(); return false;"><spring:message code="common.button.add"/> </button>
                    </c:if>
                    <c:if test="${!empty admin}">
                        <button class="btn btype01 bstyle03" onclick="javascript:saveAdmin(); return false;"><spring:message code="common.button.save"/> </button>
                        <button class="btn btype01 bstyle03" onclick="javascript:removeAdmin(); return false;"><spring:message code="common.button.remove"/> </button>
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
    var form = $('#adminForm');

    var urlConfig = {
        'addUrl':'${rootPath}/admin/add.json'
        ,'saveUrl':'${rootPath}/admin/save.json'
        ,'removeUrl':'${rootPath}/admin/remove.json'
        ,'listUrl':'${rootPath}/admin/list.html'
    };

    var messageConfig = {
        'addFailure':'<spring:message code="admin.message.addFailure"/>'
        ,'saveFailure':'<spring:message code="admin.message.saveFailure"/>'
        ,'removeFailure':'<spring:message code="admin.message.removeFailure"/>'
        ,'addComplete':'<spring:message code="admin.message.addComplete"/>'
        ,'saveComplete':'<spring:message code="admin.message.saveComplete"/>'
        ,'removeComplete':'<spring:message code="admin.message.removeComplete"/>'
        ,'addConfirm':'<spring:message code="admin.message.addConfirm"/>'
        ,'saveConfirm':'<spring:message code="admin.message.saveConfirm"/>'
        ,'removeConfirm':'<spring:message code="admin.message.removeConfirm"/>'
        ,'requireAdminId':'<spring:message code="admin.message.requireAdminId"/>'
        ,'requirePassword':'<spring:message code="admin.message.requirePassword"/>'
        ,'requireAdminName':'<spring:message code="admin.message.requireAdminName"/>'
        ,'notEqualPassword':'<spring:message code="admin.message.notEqualPassword"/>'
    };

    /*
     수정전 validate
     @author kst
     */
    function validate(type){
        var validateFlag = true;

        if(form.find('input[name=adminId]').val().length == 0){
            alertMessage('requireAdminId');
            return false;
        }

        if(form.find('input[name=name]').val().length == 0){
            alertMessage('requireAdminName');
            return false;
        }

        switch(type){
            case 1:
                if(form.find('input[name=password]').val().length == 0){
                    alertMessage('requirePassword');
                    return false;
                }else if(form.find('input[name=password]').val() != form.find('input[name=password_confirm]').val()){
                    alertMessage('notEqualPassword');
                    return false;
                }
            case 2:
                if(form.find('input[name=password]').val().length > 0
                    && form.find('input[name=password]').val() != form.find('input[name=password_confirm]').val()){
                    alertMessage('notEqualPassword');
                    return false;
                }
                break;
        }
        return true;
    }

    /*
     관리자 추가
     @author kst
     */
    function addAdmin(){
        if(!confirm(messageConfig['addConfirm'])) {
            return false;
        }

        if(validate(1)){
            callAjax('add', form.serialize());
        }
    }

    /*
     관리자 수정
     @author kst
     */
    function saveAdmin(){
        if(!confirm(messageConfig['saveConfirm'])) {
            return false;
        }

        if(validate(2)){
            callAjax('save', form.serialize());
        }
    }
    /*
     관리자 제거
     @author kst
     */
    function removeAdmin(){
        if(!confirm(messageConfig['removeConfirm'])) {
            return false;
        }

        callAjax('remove', form.serialize());
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
        alertMessage(actionType + 'Failure');
    }

    function alertMessage(type){
        alert(messageConfig[type]);
    }

    function cancel(){
        var listForm = $('<FORM>').attr('method','POST').attr('action',urlConfig['listUrl']);
        listForm.append($('<INPUT>').attr('name','reloadList').attr('value','true'));
        listForm.appendTo(document.body);
        listForm.submit();
    }
</script>