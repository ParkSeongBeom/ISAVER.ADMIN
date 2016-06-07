<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="jabber" uri="/WEB-INF/views/common/tags/jabber.tld"%>
<c:set value="MN000000-A000-0000-0000-000000000000" var="subMenuId"/>
<c:set value="MN000000-A000-0000-0000-000000000027" var="menuId"/>
<jabber:pageRoleCheck menuId="${menuId}" />
<script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/common-util.js"></script>

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.mobileMenu"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><jabber:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <article class="table_area">
        <form id="mobileMenuForm" method="POST">
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
                            <th><spring:message code="mobileMenu.column.menuId"/></th>
                            <td>
                                <input type="text" name="menuId" value="${mobileMenu.menuId}" placeholder="<spring:message code="mobileMenu.message.requireMobileMenuId"/>" readonly="true" />
                            </td>
                            <th class="point"><spring:message code="mobileMenu.column.device"/></th>
                            <td class="point">
                                <jabber:codeSelectBox groupCodeId="C005" htmlTagName="device" codeId="${mobileMenu.device}"/>
                            </td>
                        </tr>
                        <tr>
                            <th class="point"><spring:message code="mobileMenu.column.menuName"/></th>
                            <td class="point">
                                <input type="text" name="menuName" value="${mobileMenu.menuName}"/>
                            </td>
                            <th class="point"><spring:message code="mobileMenu.column.menuType"/></th>
                            <td class="point">
                                <select name="menuType">
                                    <option value=""><spring:message code="common.button.select"/></option>
                                    <option value="main" ${mobileMenu.menuType == 'main' ? 'selected' : ''}><spring:message code="mobileMenu.selectbox.menuTypeMain"/></option>
                                    <option value="sub" ${mobileMenu.menuType == 'sub' ? 'selected' : ''}><spring:message code="mobileMenu.selectbox.menuTypeSub"/></option>
                                    <option value="web" ${mobileMenu.menuType == 'web' ? 'selected' : ''}><spring:message code="mobileMenu.selectbox.menuTypeWeb"/></option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th class="point"><spring:message code="common.column.useYn"/></th>
                            <td class="point">
                                <span><input type="radio" name="useYn" value="Y" ${!empty mobileMenu && mobileMenu.useYn == 'Y' ? 'checked' : ''}/><spring:message code="common.column.useYes" /></span>
                                <span><input type="radio" name="useYn" value="N" ${empty mobileMenu || mobileMenu.useYn == 'N' ? 'checked' : ''}/><spring:message code="common.column.useNo" /></span>
                            </td>
                            <th><spring:message code="common.column.sortOrder"/></th>
                            <td>
                                <input type="number" name="menuSort" value="${mobileMenu.menuSort}" onkeypress="isNumber(this)"/>
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="mobileMenu.column.menuUrl"/></th>
                            <td>
                                <input type="text" name="menuUrl" value="${mobileMenu.menuUrl}"/>
                            </td>
                            <th><spring:message code="mobileMenu.column.position"/></th>
                            <td>
                                <span><input type="radio" name="position" value="bottom" ${empty mobileMenu || mobileMenu.position == 'bottom' ? 'checked' : ''}/><spring:message code="mobileMenu.selectbox.showBottom" /></span>
                                <span><input type="radio" name="position" value="top" ${!empty mobileMenu && mobileMenu.position == 'top' ? 'checked' : ''}/><spring:message code="mobileMenu.selectbox.showTop" /></span>
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="mobileMenu.column.iconUrl"/></th>
                            <td>
                                <input type="text" name="iconUrl" value="${mobileMenu.iconUrl}"/>
                            </td>
                            <th></th>
                            <td></td>
                        </tr>
                        <c:if test="${!empty mobileMenu}">
                            <tr>
                                <th><spring:message code="common.column.insertUser"/></th>
                                <td>${mobileMenu.insertUserName}</td>
                                <th><spring:message code="common.column.insertDatetime"/></th>
                                <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${mobileMenu.insertDatetime}" /></td>
                            </tr>
                            <tr>
                                <th><spring:message code="common.column.updateUser"/></th>
                                <td>${mobileMenu.updateUserName}</td>
                                <th><spring:message code="common.column.updateDatetime"/></th>
                                <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${mobileMenu.updateDatetime}" /></td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
                <!-- 입력 테이블 End -->
            </div>
        </form>

        <div class="table_title_area">
            <div class="table_btn_set">
                <c:if test="${empty mobileMenu}">
                    <button class="btn btype01 bstyle03" href="#" onclick="javascript:addMobileMenu(); return false;"><spring:message code="common.button.add"/> </button>
                </c:if>
                <c:if test="${!empty mobileMenu}">
                    <button class="btn btype01 bstyle03" href="#" onclick="javascript:saveMobileMenu(); return false;"><spring:message code="common.button.save"/> </button>
                    <button class="btn btype01 bstyle03" href="#" onclick="javascript:removeMobileMenu(); return false;"><spring:message code="common.button.remove"/> </button>
                </c:if>
                <button class="btn btype01 bstyle03" href="#" onclick="javascript:cancel(); return false;"><spring:message code="common.button.cancel"/> </button>
            </div>
        </div>
    </article>
    <!-- 테이블 입력 / 조회 영역 End -->
</section>

<script type="text/javascript">
    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');
    var form = $('#mobileMenuForm');

    var urlConfig = {
        'addUrl':'${rootPath}/mobileMenu/add.json'
        ,'saveUrl':'${rootPath}/mobileMenu/save.json'
        ,'removeUrl':'${rootPath}/mobileMenu/remove.json'
        ,'listUrl':'${rootPath}/mobileMenu/list.html'
    };

    var messageConfig = {
        'addConfirm':'<spring:message code="mobileMenu.message.addConfirm"/>'
        ,'saveConfirm':'<spring:message code="mobileMenu.message.saveConfirm"/>'
        ,'removeConfirm':'<spring:message code="mobileMenu.message.removeConfirm"/>'
        ,'addComplete':'<spring:message code="mobileMenu.message.addComplete"/>'
        ,'saveComplete':'<spring:message code="mobileMenu.message.saveComplete"/>'
        ,'removeComplete':'<spring:message code="mobileMenu.message.removeComplete"/>'
        ,'addFailure':'<spring:message code="mobileMenu.message.addFailure"/>'
        ,'saveFailure':'<spring:message code="mobileMenu.message.saveFailure"/>'
        ,'removeFailure':'<spring:message code="mobileMenu.message.removeFailure"/>'
        ,'emptyMobileMenuName':'<spring:message code="mobileMenu.message.emptyMobileMenuName"/>'
        ,'emptyMobileMenuPopup':'<spring:message code="mobileMenu.message.emptyMobileMenuPopup"/>'
    };

    $(document).ready(function(){
    });

    function validate(){
        if($('input[name=menuName]').val().length == 0){
            alertMessage('emptyMobileMenuName');
            return false;
        }

        if($("select[name='menuType']").val().length == 0){
            alertMessage('emptyMobileMenuPopup');
            return false;
        }

        return true;
    }

    function addMobileMenu(){
        if(!confirm(messageConfig['addConfirm'])){
            return false;
        }

        console.log("??");
        if(validate()){
            callAjax('add',form.serialize());
        }
    }

    function saveMobileMenu(){
        if(!confirm(messageConfig['saveConfirm'])){
            return false;
        }

        if(validate()){
            callAjax('save',form.serialize());
        }
    }

    function removeMobileMenu(){
        if(!confirm(messageConfig['removeConfirm'])){
            return false;
        }
        callAjax('remove',form.serialize());
    }

    function callAjax(actionType, data){
        sendAjaxPostRequest(urlConfig[actionType + 'Url'],data,successHandler,errorHandler,actionType);
    }

    function successHandler(data, dataType, actionType){
        alertMessage(actionType+'Complete');
        switch(actionType){
            case 'save':
                cancel();
                break;
            case 'add':
                cancel();
                break;
            case 'remove':
                cancel();
                break;
        }

    }

    function errorHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        alertMessage(actionType+'Failure');
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