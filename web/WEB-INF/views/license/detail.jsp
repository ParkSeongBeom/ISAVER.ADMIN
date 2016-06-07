<!-- 라이센스 상세 -->
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
        <h3 class="1depth_title"><spring:message code="common.title.license"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><jabber:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <form id="licenseForm" method="POST">
        <input type="hidden" name="licenseKey" value="${license.licenseKey}" />
        <input type="hidden" name="expireDate" value="${license.expireDate}" />
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
                        <th class="point"><spring:message code="license.column.licenseKey"/></th>
                        <td class="point">
                            <input type="text" style="width:50px" name="licenseText" maxlength="5" />~
                            <input type="text" style="width:50px" name="licenseText" maxlength="5" />~
                            <input type="text" style="width:50px" name="licenseText" maxlength="5" />~
                            <input type="text" style="width:50px" name="licenseText" maxlength="5" />~
                            <input type="text" style="width:50px" name="licenseText" maxlength="5" />
                        </td>
                        <th class="point"><spring:message code="license.column.deviceType"/></th>
                        <td class="point">
                            <select name="deviceType">
                                <option value="1">1</option>
                                <option value="1">1</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th class="point"><spring:message code="license.column.expireDate"/></th>
                        <td class="point">
                            <input type="date" name="expireDatetime" />
                        </td>
                        <th class="point"><spring:message code="license.column.licenseCount"/></th>
                        <td class="point">
                            <input type="number" name="licenseCount" value="${license.licenseCount}" />
                        </td>
                    </tr>
                    <c:if test="${!empty license}">
                        <tr>
                            <th><spring:message code="common.column.insertUser"/></th>
                            <td>${license.insertUserName}</td>
                            <th><spring:message code="common.column.insertDatetime"/></th>
                            <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${license.insertDatetime}" /></td>
                        </tr>
                        <tr>
                            <th><spring:message code="common.column.updateUser"/></th>
                            <td>${license.updateUserName}</td>
                            <th><spring:message code="common.column.updateDatetime"/></th>
                            <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${license.updateDatetime}" /></td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
                <!-- 입력 테이블 End -->
            </div>

            <div class="table_title_area">
                <div class="table_btn_set">
                    <c:if test="${empty license}">
                        <button class="btn btype01 bstyle03" onclick="javascript:addLicense(); return false;"><spring:message code="common.button.add"/> </button>
                    </c:if>
                    <c:if test="${!empty license}">
                        <button class="btn btype01 bstyle03" onclick="javascript:saveLicense(); return false;"><spring:message code="common.button.save"/> </button>
                        <button class="btn btype01 bstyle03" onclick="javascript:removeLicense(); return false;"><spring:message code="common.button.remove"/> </button>
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
    var form = $('#licenseForm');

    var urlConfig = {
        'addUrl':'${rootPath}/license/add.json'
        ,'saveUrl':'${rootPath}/license/save.json'
        ,'removeUrl':'${rootPath}/license/remove.json'
        ,'listUrl':'${rootPath}/license/list.html'
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
        ,'requireLicenseKey':'<spring:message code="license.message.requireLicenseKey"/>'
        ,'requireLicenseCount':'<spring:message code="license.message.requireLicenseCount"/>'
    };

    function validate(type){

        if (form.find('input[name=licenseText]:eq(0)').val().length == 0
                &&form.find('input[name=licenseText]:eq(1)').val().length == 0
                &&form.find('input[name=licenseText]:eq(2)').val().length == 0
                &&form.find('input[name=licenseText]:eq(3)').val().length == 0
                &&form.find('input[name=licenseText]:eq(4)').val().length == 0) {
            alertMessage('requireLicenseKey');
            return false;
        }

        if(form.find('input[name=licenseCount]').val().length == 0){
            alertMessage('requireLicenseCount');
            return false;
        }

        return true;
    }

    function addLicense(){
        if(!confirm(messageConfig['addConfirm'])){
            return false;
        }

        if(validate(1)){
            callAjax('add', form.serialize());
        }
    }

    function saveLicense(){
        if(!confirm(messageConfig['saveConfirm'])){
            return false;
        }

        if(validate(1)){
            callAjax('save', form.serialize());
        }
    }

    function removeLicense(){
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

    function setLicenseExpireDay(dateString) {

        var reggie = /(\d{4})(\d{2})(\d{2})/;
        var dateArray = reggie.exec(dateString);
        var dateObject = new Date(
                (+dateArray[1]),
                (+dateArray[2])-1, // Careful, month starts at 0!
                (+dateArray[3])
        );
        return dateObject;
    }

    function getLicenseExpireDay() {
        var expireDate = $("input[name='expireDate']").val();
        return new Date(expireDate).format("yyyyMMdd");
    }

    function setLicenseKey(licenseKey) {

        var reggie = /(\w{5})(\w{5})(\w{5})(\w{5})(\w{5})/;
        var licenseArray = reggie.exec(licenseKey);
        return licenseArray;
    }

    function getLicenseKey() {

        var licenseList = [];
        licenseList.push($("input[name='licenseText']:eq(0)").val());
        licenseList.push($("input[name='licenseText']:eq(1)").val());
        licenseList.push($("input[name='licenseText']:eq(2)").val());
        licenseList.push($("input[name='licenseText']:eq(3)").val());
        licenseList.push($("input[name='licenseText']:eq(4)").val());

        return licenseList.join("");
    }

    $(document).ready(function() {

        try {
            <c:if test="${!empty license}">
                var licenseExpireDate = setLicenseExpireDay('${license.expireDate}').format("yyyy-MM-dd");
                $("input[name='expireDatetime']").val(licenseExpireDate);

                var licenseKeyList = setLicenseKey('${license.licenseKey}');

                if (licenseKeyList != null && licenseKeyList.length > 1) {
                    $("input[name='licenseText']:eq(0)").val(licenseKeyList[1]);
                    $("input[name='licenseText']:eq(1)").val(licenseKeyList[2]);
                    $("input[name='licenseText']:eq(2)").val(licenseKeyList[3]);
                    $("input[name='licenseText']:eq(3)").val(licenseKeyList[4]);
                    $("input[name='licenseText']:eq(4)").val(licenseKeyList[5]);
                }
            </c:if>

            <c:if test="${empty license}">
                var licenseExpireDate = new Date().format("yyyy-MM-dd");
                $("input[name='expireDatetime']").val(licenseExpireDate);
            </c:if>
        }  catch(e) {
            console.error("[document ready error] " + e)
        } finally {

        }

    })



</script>