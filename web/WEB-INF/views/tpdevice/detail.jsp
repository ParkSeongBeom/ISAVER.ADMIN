<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="jabber" uri="/WEB-INF/views/common/tags/jabber.tld"%>
<c:set value="MN000000-H000-0000-0000-000000000000" var="subMenuId"/>
<c:set value="MN000000-F000-0000-0000-000000000001" var="menuId"/>

<jabber:pageRoleCheck menuId="${menuId}" />
<script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/common-util.js"></script>

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.tpdevice"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><jabber:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <form id="tpDeviceForm" method="POST">
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
                            <th><spring:message code="tpdevice.column.deviceId"/></th>
                            <td>
                                <input type="text" name="deviceId" value="${tpDevice.deviceId}" readonly="true" />
                            </td>
                            <th class="point"><spring:message code="tpdevice.column.deviceName"/></th>
                            <td class="point">
                                <input type="text" name="deviceName" value="${tpDevice.deviceName}" />
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="tpdevice.column.ipAddress"/></th>
                            <td>
                                <input type="text" name="ipAddress" value="${tpDevice.ipAddress}" />
                            </td>
                            <th><spring:message code="tpdevice.column.sipUrl"/></th>
                            <td>
                                <input type="text" name="sipUrl" value="${tpDevice.sipUrl}" />
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="tpdevice.column.h323Id"/></th>
                            <td>
                                <input type="text" name="h323Id" value="${tpDevice.h323Id}" />
                            </td>
                            <th><spring:message code="tpdevice.column.type"/></th>
                            <td>
                                <jabber:codeSelectBox groupCodeId="C011" codeId="${tpDevice.type}" htmlTagName="type"/>
                            </td>
                        </tr>
                        <tr>
                            <th><spring:message code="common.column.useYn"/></th>
                            <td colspan="3">
                                <jabber:codeSelectBox groupCodeId="C008" codeId="${tpDevice.useYn}" htmlTagName="useYn"/>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <!-- 입력 테이블 End -->
            </div>

            <div class="table_title_area">
                <div class="table_btn_set">
                    <c:if test="${empty tpDevice}">
                        <button class="btn btype01 bstyle03" onclick="javascript:addTpDevice(); return false;"><spring:message code="common.button.add"/> </button>
                    </c:if>
                    <c:if test="${!empty tpDevice}">
                        <button class="btn btype01 bstyle03" onclick="javascript:saveTpDevice(); return false;"><spring:message code="common.button.save"/> </button>
                        <button class="btn btype01 bstyle03" onclick="javascript:removeTpDevice(); return false;"><spring:message code="common.button.remove"/> </button>
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
    var form = $('#tpDeviceForm');

    var urlConfig = {
        'addUrl':'${rootPath}/tpdevice/add.json'
        ,'saveUrl':'${rootPath}/tpdevice/save.json'
        ,'removeUrl':'${rootPath}/tpdevice/remove.json'
        ,'listUrl':'${rootPath}/tpdevice/list.html'
    };

    var messageConfig = {
        'addConfirm':'<spring:message code="tpdevice.message.addConfirm"/>'
        ,'saveConfirm':'<spring:message code="tpdevice.message.saveConfirm"/>'
        ,'removeConfirm':'<spring:message code="tpdevice.message.removeConfirm"/>'
        ,'requireDeviceName':'<spring:message code="tpdevice.message.requireDeviceName"/>'
        ,'addFailure':'<spring:message code="tpdevice.message.addFailure"/>'
        ,'saveFailure':'<spring:message code="tpdevice.message.saveFailure"/>'
        ,'removeFailure':'<spring:message code="tpdevice.message.removeFailure"/>'
        ,'addComplete':'<spring:message code="tpdevice.message.addComplete"/>'
        ,'saveComplete':'<spring:message code="tpdevice.message.saveComplete"/>'
        ,'removeComplete':'<spring:message code="tpdevice.message.removeComplete"/>'
    };

    /*
     validate method
     @author psb
     */
    function validate(type){
        if(form.find('input[name=deviceName]').val().trim().length == 0){
            alertMessage('requireDeviceName');
            return false;
        }
        return true;
    }

    /*
     초기화
     @author psb
     */
    function reset(){
        form[0].reset();
    }

    /*
     TP 장비 추가
     @author psb
     */
    function addTpDevice(){
        if(!confirm(messageConfig['addConfirm'])) {
            return false;
        }

        if(validate(1)){
            callAjax('add', form.serialize());
        }
    }

    /*
     TP 장비 수정
     @author psb
     */
    function saveTpDevice(){
        if(!confirm(messageConfig['saveConfirm'])) {
            return false;
        }

        if(validate(2)){
            callAjax('save', form.serialize());
        }
    }
    /*
     TP 장비 제거
     @author psb
     */
    function removeTpDevice(){
        if(!confirm(messageConfig['removeConfirm'])) {
            return false;
        }

        callAjax('remove', form.serialize());
    }

    function callAjax(actionType, data){
            sendAjaxPostRequest(urlConfig[actionType + 'Url'],data,requestCode_successHandler,requestCode_errorHandler,actionType);
    }

    function requestCode_successHandler(data, dataType, actionType){
        alert(messageConfig[actionType + 'Complete']);
        switch(actionType){
            case 'save':
                break;
            case 'add':
            case 'remove':
                cancel();
                break;
        }
    }

    function alertMessage(type){
        alert(messageConfig[type]);
    }

    function requestCode_errorHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        alert(messageConfig[actionType + 'Failure']);
    }

    function cancel(){
        var listForm = $('<FORM>').attr('method','POST').attr('action',urlConfig['listUrl']);
        listForm.append($('<INPUT>').attr('name','reloadList').attr('value','true'));
        listForm.appendTo(document.body);
        listForm.submit();
    }
</script>