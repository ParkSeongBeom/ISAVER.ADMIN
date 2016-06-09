<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<c:set value="A00000" var="subMenuId"/>
<c:set value="A00001" var="menuId"/>
<isaver:pageRoleCheck menuId="${menuId}" />
<script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/common-util.js"></script>

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.user"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><isaver:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <form id="userForm" method="POST">
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
                        <th class="point"><spring:message code="user.column.userId"/></th>
                        <td class="point">
                            <input type="text" name="userId" value="${user.userId}" ${empty user ? '' : 'readonly="true"'} />
                        </td>
                        <th class="point"><spring:message code="user.column.userName"/></th>
                        <td class="point">
                            <input type="text" name="userName" value="${user.userName}" />
                        </td>
                    </tr>
                    <tr>
                        <th class="point"><spring:message code="user.column.password"/></th>
                        <td class="point">
                            <input type="password" name="userPassword" value="" placeholder="<spring:message code="common.message.passwordEdit"/>" />
                        </td>
                        <th class="point"><spring:message code="user.column.passwordConfirm"/></th>
                        <td class="point">
                            <input type="password" name="password_confirm" value="" placeholder="<spring:message code="common.message.passwordEdit"/>" />
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code="user.column.role"/></th>
                        <td>
                            <select name="roleId">
                                <option value=""><spring:message code="common.button.select"/> </option>
                                <c:forEach items="${roles}" var="role">
                                    <option value="${role.roleId}" ${user.roleId == role.roleId ? 'selected' : ''}>${role.roleName}</option>
                                </c:forEach>
                            </select>
                        </td>
                        <th><spring:message code="user.column.telephone"/></th>
                        <td>
                            <input type="text" name="telephone" value="${user.telephone}" />
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code="user.column.email"/></th>
                        <td colspan="3">
                            <input type="text" name="email" value="${user.email}" />
                        </td>
                    </tr>
                    <c:if test="${!empty user}">
                        <tr>
                            <th><spring:message code="common.column.insertUser"/></th>
                            <td>${user.insertUserName}</td>
                            <th><spring:message code="common.column.insertDatetime"/></th>
                            <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${user.insertDatetime}" /></td>
                        </tr>
                        <tr>
                            <th><spring:message code="common.column.updateUser"/></th>
                            <td>${user.updateUserName}</td>
                            <th><spring:message code="common.column.updateDatetime"/></th>
                            <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${user.updateDatetime}" /></td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
                <!-- 입력 테이블 End -->
            </div>

            <div class="table_title_area">
                <div class="table_btn_set">
                    <c:if test="${empty user}">
                        <button class="btn btype01 bstyle03" onclick="javascript:addUser(); return false;"><spring:message code="common.button.add"/> </button>
                    </c:if>
                    <c:if test="${!empty user}">
                        <button class="btn btype01 bstyle03" onclick="javascript:saveUser(); return false;"><spring:message code="common.button.save"/> </button>
                        <button class="btn btype01 bstyle03" onclick="javascript:removeUser(); return false;"><spring:message code="common.button.remove"/> </button>
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
    var form = $('#userForm');

    /*
     url defind
     @author kst
     */
    var urlConfig = {
        addUrl      :   "${rootPath}/user/add.json"
        ,saveUrl    :   "${rootPath}/user/save.json"
        ,removeUrl  :   "${rootPath}/user/remove.json"
        ,listUrl    :   "${rootPath}/user/list.html"
        ,existUrl   :   "${rootPath}/user/exist.html"
    };

    /*
     message define
     @author kst
     */
    var messageConfig = {
        'addConfirm':'<spring:message code="user.message.addConfirm"/>'
        ,'saveConfirm':'<spring:message code="user.message.saveConfirm"/>'
        ,'removeConfirm':'<spring:message code="user.message.removeConfirm"/>'
        ,'addFailure':'<spring:message code="user.message.addFailure"/>'
        ,'saveFailure':'<spring:message code="user.message.saveFailure"/>'
        ,'removeFailure':'<spring:message code="user.message.removeFailure"/>'
        ,'addComplete':'<spring:message code="user.message.addComplete"/>'
        ,'saveComplete':'<spring:message code="user.message.saveComplete"/>'
        ,'removeComplete':'<spring:message code="user.message.removeComplete"/>'
        ,'notEqualsPassword':'<spring:message code="user.message.notEqualPassword"/>'
        ,'requireUserId':'<spring:message code="user.message.requireUserId"/>'
        ,'requireUserName':'<spring:message code="user.message.requireUserName"/>'
        ,'requirePassword':'<spring:message code="user.message.requirePassword"/>'
        ,'existUserId':'<spring:message code="user.message.existUserId"/>'
    };

    /*
     validate method
     @author kst
     */
    function validate(type){
        if(form.find('input[name=userId]').val().trim().length == 0){
            alertMessage('requireUserId');
            return false;
        }

        if(form.find('input[name=userName]').val().trim().length == 0 && type != 3){
            alertMessage('requireUserName');
            return false;
        }

        if(form.find('input[name=userPassword]').val().trim().length == 0 && type == 1){
            alertMessage('requirePassword');
            return false;
        }

        if(form.find('input[name=userPassword]').val().trim().length > 0
                && form.find('input[name=userPassword]').val() != form.find('input[name=password_confirm]').val() && type != 3){
            alertMessage('notEqualsPassword');
            return false;
        }
        return true;
    }

    /*
     add method
     @author kst
     */
    function addUser(){
        if(!confirm(messageConfig['addConfirm'])){
            return false;
        }

        if(validate(1)){
            checkUserId();
        }
    }

    /*
     save method
     @author kst
     */
    function saveUser(){
        if(!confirm(messageConfig['saveConfirm'])){
            return false;
        }

        if(validate(2)){
            callAjax('save', form.serialize());
        }
    }
    /*
     remove method
     @author kst
     */
    function removeUser(){
        if(!confirm(messageConfig['removeConfirm'])){
            return false;
        }

        if(validate(3)){
            callAjax('remove', form.serialize());
        }
    }

    /*
     user id useable check
     */
    function checkUserId(){
        sendAjaxPostRequest(urlConfig['existUrl'],form.serialize(),checkUserId_successHandler,checkUserId_errorHandler);
    }

    function checkUserId_successHandler(data, dataType){
        if(data != null && data.hasOwnProperty('exist') && data['exist'] == 'N'){
            callAjax('add', form.serialize());
        }else{
            alertMessage('existUserId');
        }

    }

    function checkUserId_errorHandler(XMLHttpRequest, textStatus, errorThrown){
        alertMessage('addFailure');
    }

    /*
     ajax call
     @author kst
     */
    function callAjax(actionType, data){
        sendAjaxPostRequest(urlConfig[actionType + 'Url'],data,requestCode_successHandler,requestCode_errorHandler,actionType);
    }

    /*
     ajax success handler
     @author kst
     */
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

    /*
     ajax error handler
     @author kst
     */
    function requestCode_errorHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        alertMessage(actionType + 'Failure');
    }

    /*
     alert message method
     @author kst
     */
    function alertMessage(type){
        alert(messageConfig[type]);
    }

    /*
     cancel method
     @author kst
     */
    function cancel(){
        var listForm = $('<FORM>').attr('method','POST').attr('action',urlConfig['listUrl']);
        listForm.append($('<INPUT>').attr('name','reloadList').attr('value','true'));
        listForm.appendTo(document.body);
        listForm.submit();
    }
</script>