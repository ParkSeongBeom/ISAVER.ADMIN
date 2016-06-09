<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<c:set value="B00021" var="menuId"/>
<c:set value="B00000" var="subMenuId"/>
<script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>
<isaver:pageRoleCheck menuId="${menuId}" />
<script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/common-util.js"></script>

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.code"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><isaver:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <form id="codeForm" method="POST">
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
                                <input type="text" name="groupCodeId" value="${paramBean.groupCodeId}" readonly="true" />
                            </td>
                            <th class="point"><spring:message code="code.column.codeName"/></th>
                            <td class="point">
                                <input type="text" name="codeName" value="${code.codeName}" placeholder="<spring:message code="code.message.requireCodeName"/>" />
                            </td>
                        </tr>
                        <tr>
                            <th class="point"><spring:message code="code.column.codeId"/></th>
                            <td class="point">
                                <input type="text" name="codeId" maxlength="6" value="${code.codeId}" placeholder="<spring:message code="code.message.requireCodeId"/>" ${empty code ? '' : 'readonly="true"'}/>
                            </td>
                            <th><spring:message code="common.column.codeDesc"/></th>
                            <td>
                                <input type="text" name="codeDesc" value="${code.codeDesc}" />
                            </td>
                        </tr>
                        <tr>
                            <th class="point"><spring:message code="common.column.useYn"/></th>
                            <td class="point">
                                <input type="radio" name="useYn" value="Y" ${!empty code && code.useYn == 'Y' ? 'checked' : ''}/><spring:message code="common.column.useYes" />
                                <input type="radio" name="useYn" value="N" ${empty code || code.useYn == 'N' ? 'checked' : ''}/><spring:message code="common.column.useNo" />
                            </td>
                            <th><spring:message code="common.column.sortOrder"/></th>
                            <td>
                                <input type="number" name="sortOrder" value="${code.sortOrder}" onkeypress="isNumber(this)"/>
                            </td>
                        </tr>
                        <c:if test="${!empty code}">
                            <tr>
                                <th><spring:message code="common.column.insertUser"/></th>
                                <td>${code.insertUserName}</td>
                                <th><spring:message code="common.column.insertDatetime"/></th>
                                <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${code.insertDatetime}" /></td>
                            </tr>
                            <tr>
                                <th><spring:message code="common.column.updateUser"/></th>
                                <td>${code.updateUserName}</td>
                                <th><spring:message code="common.column.updateDatetime"/></th>
                                <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${code.updateDatetime}" /></td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
                <!-- 입력 테이블 End -->
            </div>

            <div class="table_title_area">
                <div class="table_btn_set">
                    <c:if test="${empty code}">
                        <button class="btn btype01 bstyle03" onclick="javascript:addCode(); return false;"><spring:message code="common.button.add"/> </button>
                    </c:if>
                    <c:if test="${!empty code}">
                        <button class="btn btype01 bstyle03" onclick="javascript:saveCode(); return false;"><spring:message code="common.button.save"/> </button>
                        <button class="btn btype01 bstyle03" onclick="javascript:removeCode(); return false;"><spring:message code="common.button.remove"/> </button>
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
    var form = $('#codeForm');

    var urlConfig = {
        'addUrl':'${rootPath}/code/add.json'
        ,'saveUrl':'${rootPath}/code/save.json'
        ,'removeUrl':'${rootPath}/code/remove.json'
        ,'listUrl':'${rootPath}/groupcode/list.html'
    };

    var messageConfig = {
        'addConfirm':'<spring:message code="code.message.addConfirm"/>'
        ,'saveConfirm':'<spring:message code="code.message.saveConfirm"/>'
        ,'removeConfirm':'<spring:message code="code.message.removeConfirm"/>'
        ,'addFailure':'<spring:message code="code.message.addFailure"/>'
        ,'saveFailure':'<spring:message code="code.message.saveFailure"/>'
        ,'removeFailure':'<spring:message code="code.message.removeFailure"/>'
        ,'addComplete':'<spring:message code="code.message.addComplete"/>'
        ,'saveComplete':'<spring:message code="code.message.saveComplete"/>'
        ,'removeComplete':'<spring:message code="code.message.removeComplete"/>'
        ,'requireCodeId':'<spring:message code="code.message.requireCodeId"/>'
        ,'lengthFailCodeId':'<spring:message code="code.message.lengthFailCodeId"/>'
        ,'requireCodeName':'<spring:message code="code.message.requireCodeName"/>'
    };

    function validate(type){
        if(form.find('input[name=codeId]').val().length == 0){
            alertMessage('requireCodeId');
            return false;
        }else if(form.find('input[name=codeId]').val().length != 6){
            alertMessage('lengthFailCodeId');
            return false;
        }

        switch(type){
            case 1:
                if(form.find('input[name=codeName]').val().length == 0){
                    alertMessage('requireCodeName');
                    return false;
                }
                break;
            case 2:
                break;
        }

        return true;
    }

    function addCode(){
        if(!confirm(messageConfig['addConfirm'])){
            return false;
        }

        if(validate(1)){
            callAjax('add', form.serialize());
        }
    }

    function saveCode(){
        if(!confirm(messageConfig['saveConfirm'])){
            return false;
        }

        if(validate(1)){
            callAjax('save', form.serialize());
        }
    }

    function removeCode(){
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