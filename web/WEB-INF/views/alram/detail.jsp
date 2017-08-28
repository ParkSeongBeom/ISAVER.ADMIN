<!-- 임계치 상세 -->
<!-- @author dhj -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<c:set value="J00011" var="menuId"/>
<c:set value="J00010" var="subMenuId"/>
<%--<jabber:pageRoleCheck menuId="${menuId}" />--%>

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.alram"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><isaver:menu menuId="${menuId}" /></span>
        </div>
    </article>

    <!-- 2depth 타이틀 영역 End -->
    <form id="alramForm" method="POST">
        <input type="hidden" name="alramInfo" />
        <input type="hidden" name="alramId" value="${alram.alramId}" />

        <article class="table_area">
            <div class="table_contents">
                <!-- 입력 테이블 Start -->
                <table changeTb class="t_defalut t_type02 t_style03">
                    <colgroup>
                        <col style="width:16%">  <!-- 01 -->
                        <col style="width:34%">  <!-- 02 -->
                        <col style="width:16%">  <!-- 03 -->
                        <col style="width:*">    <!-- 04 -->
                    </colgroup>
                    <tbody>
                    <tr>
                        <th><spring:message code="alram.column.alramId"/></th>
                        <td>
                            <input type="text" value="${alram.alramId}" disabled="disabled"/>
                        </td>
                        <th class="point"><spring:message code="common.column.useYn"/></th>
                        <td class="point">
                            <select name="useYn">
                                <option value="Y" <c:if test="${alram.useYn == 'Y'}">selected="selected"</c:if>><spring:message code="common.column.useYes"/></option>
                                <option value="N" <c:if test="${alram.useYn == 'N'}">selected="selected"</c:if>><spring:message code="common.column.useNo"/></option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th class="point"><spring:message code="alram.column.alramName"/></th>
                        <td class="point" colspan="3">
                            <input type="text" name="alramName" value="${alram.alramName}"/>
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code="alram.column.alramMessage"/></th>
                        <td colspan="3">
                            <input type="text" name="alramMessage" value="${alram.alramMessage}"/>
                        </td>
                    </tr>
                    <tr dashboard>
                        <c:choose>
                            <c:when test="${dashboardAlramInfos != null and fn:length(dashboardAlramInfos) > 0}">
                                <th><spring:message code="alram.column.alramDashboardSetting"/></th>
                                <td>
                                    <select name="dashboardUseYn">
                                        <option value="Y" selected="selected"><spring:message code="common.column.useYes"/></option>
                                        <option value="N"><spring:message code="common.column.useNo"/></option>
                                    </select>
                                </td>
                                <c:forEach var="info" items="${dashboardAlramInfos[0].datas}">
                                    <c:choose>
                                        <c:when test="${info.key=='alramType'}">
                                            <td><isaver:codeSelectBox groupCodeId="ARM" htmlTagName="alramType" codeId="${info.value}" /></td>
                                        </c:when>
                                        <c:when test="${info.key=='fileId'}">
                                            <td>
                                                <input type="text" style="display: none;" name="ttsText"/>
                                                <select name="fileId">
                                                    <c:forEach var="file" items="${files}">
                                                        <option value="${file.fileId}" <c:if test="${file.fileId == info.value}">selected="selected"</c:if>>${file.title}</option>
                                                    </c:forEach>
                                                </select>
                                            </td>
                                        </c:when>
                                        <c:when test="${info.key=='ttsText'}">
                                            <td>
                                                <input type="text" name="ttsText" value="${info.value}"/>
                                                <select name="fileId" style="display: none;">
                                                    <c:forEach var="file" items="${files}">
                                                        <option value="${file.fileId}">${file.title}</option>
                                                    </c:forEach>
                                                </select>
                                            </td>
                                        </c:when>
                                    </c:choose>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <th><spring:message code="alram.column.alramDashboardSetting"/></th>
                                <td>
                                    <select name="dashboardUseYn">
                                        <option value="Y"><spring:message code="common.column.useYes"/></option>
                                        <option value="N" selected="selected"><spring:message code="common.column.useNo"/></option>
                                    </select>
                                </td>
                                <td><isaver:codeSelectBox groupCodeId="ARM" htmlTagName="alramType" disabled="true"/></td>
                                <td>
                                    <input type="text" name="ttsText" disabled="disabled"/>
                                    <select name="fileId" disabled="disabled">
                                        <c:forEach var="file" items="${files}">
                                            <option value="${file.fileId}">${file.title}</option>
                                        </c:forEach>
                                    </select>
                                </td>
                            </c:otherwise>
                        </c:choose>
                    </tr>
                    <tr>
                        <th><spring:message code="alram.column.alramDeviceSetting"/></th>
                        <td colspan="3">
                            <table class="t_defalut t_type02 t_style03">
                                <c:choose>
                                    <c:when test="${deviceAlramInfos != null and fn:length(deviceAlramInfos) > 0}">
                                        <c:forEach var="deviceAlramInfo" items="${deviceAlramInfos}" varStatus="status">
                                            <tr device>
                                                <c:forEach var="info" items="${deviceAlramInfo.datas}">
                                                    <c:if test="${info.key=='deviceId'}">
                                                        <td>
                                                            <select name="deviceId">
                                                                <c:forEach var="device" items="${devices}">
                                                                    <option value="${device.deviceId}" <c:if test="${device.deviceId == info.value}">selected="selected"</c:if>>${device.deviceId} (${device.deviceCodeName})</option>
                                                                </c:forEach>
                                                            </select>
                                                        </td>
                                                    </c:if>
                                                </c:forEach>
                                                <c:forEach var="info" items="${deviceAlramInfo.datas}">
                                                    <c:if test="${info.key=='alramType'}">
                                                        <td><isaver:codeSelectBox groupCodeId="ARM" htmlTagName="alramType" codeId="${info.value}" /></td>
                                                    </c:if>
                                                </c:forEach>
                                                <c:forEach var="info" items="${deviceAlramInfo.datas}">
                                                    <c:if test="${info.key=='ttsText'}">
                                                        <td>
                                                            <input type="text" name="ttsText" value="${info.value}"/>
                                                            <select name="fileId" style="display: none;">
                                                                <c:forEach var="file" items="${files}">
                                                                    <option value="${file.fileId}">${file.title}</option>
                                                                </c:forEach>
                                                            </select>
                                                        </td>
                                                    </c:if>
                                                </c:forEach>
                                                <c:forEach var="info" items="${deviceAlramInfo.datas}">
                                                    <c:if test="${info.key=='fileId'}">
                                                        <td>
                                                            <input type="text" style="display: none;" name="ttsText"/>
                                                            <select name="fileId">
                                                                <c:forEach var="file" items="${files}">
                                                                    <option value="${file.fileId}" <c:if test="${file.fileId == info.value}">selected="selected"</c:if>>${file.title}</option>
                                                                </c:forEach>
                                                            </select>
                                                        </td>
                                                    </c:if>
                                                </c:forEach>
                                                <td>
                                                    <c:if test="${status.count > 1}">
                                                        <button class='btn btype01 bstyle03' onclick='javascript:removeSettingLayer(this); return false;'>X</button>
                                                    </c:if>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr device>
                                            <td>
                                                <select name="deviceId">
                                                    <c:forEach var="device" items="${devices}">
                                                        <option value="${device.deviceId}" >${device.deviceId} (${device.deviceCodeName})</option>
                                                    </c:forEach>
                                                </select>
                                            </td>
                                            <td><isaver:codeSelectBox groupCodeId="ARM" htmlTagName="alramType" /></td>
                                            <td>
                                                <input type="text" name="ttsText" />
                                                <select name="fileId">
                                                    <c:forEach var="file" items="${files}">
                                                        <option value="${file.fileId}">${file.title}</option>
                                                    </c:forEach>
                                                </select>
                                            </td>
                                            <td></td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                                <tr id="addBtn">
                                    <td class="point" colspan="4">
                                        <button class="btn btype01 bstyle03" onclick="javascript:addSettingLayer(); return false;"><spring:message code="common.button.addRow"/></button>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <c:if test="${!empty alram}">
                        <tr>
                            <th><spring:message code="common.column.insertUser"/></th>
                            <td>${alram.insertUserName}</td>
                            <th><spring:message code="common.column.insertDatetime"/></th>
                            <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${alram.insertDatetime}" /></td>
                        </tr>
                        <tr>
                            <th><spring:message code="common.column.updateUser"/></th>
                            <td>${alram.updateUserName}</td>
                            <th><spring:message code="common.column.updateDatetime"/></th>
                            <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${alram.updateDatetime}" /></td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
                <!-- 입력 테이블 End -->
            </div>

            <div class="table_title_area">
                <div class="table_btn_set">
                    <c:if test="${empty alram}">
                        <button class="btn btype01 bstyle03" onclick="javascript:addAlram(); return false;"><spring:message code="common.button.add"/></button>
                    </c:if>
                    <c:if test="${!empty alram}">
                        <button class="btn btype01 bstyle03" onclick="javascript:saveAlram(); return false;"><spring:message code="common.button.save"/></button>
                        <button class="btn btype01 bstyle03" onclick="javascript:removeAlram(); return false;"><spring:message code="common.button.remove"/></button>
                    </c:if>
                    <button class="btn btype01 bstyle03" onclick="javascript:cancel(); return false;"><spring:message code="common.button.cancel"/></button>
                </div>
            </div>
        </article>
        <!-- 테이블 입력 / 조회 영역 End -->
    </form>
</section>

<div style="display: none">
    <table id="addSettingTag">
        <tr device>
            <td>
                <select name="deviceId">
                    <c:forEach var="device" items="${devices}">
                        <option value="${device.deviceId}" >${device.deviceId} (${device.deviceCodeName})</option>
                    </c:forEach>
                </select>
            </td>
            <td><isaver:codeSelectBox groupCodeId="ARM" htmlTagName="alramType" /></td>
            <td>
                <input type="text" name="ttsText" />
                <select name="fileId">
                    <c:forEach var="file" items="${files}">
                        <option value="${file.fileId}">${file.title}</option>
                    </c:forEach>
                </select>
            </td>
            <td>
                <button class='btn btype01 bstyle03' onclick='javascript:removeSettingLayer(this); return false;'>X</button>
            </td>
        </tr>
    </table>
</div>

<script type="text/javascript">
    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');
    var form = $('#alramForm');

    var urlConfig = {
        'addUrl':'${rootPath}/alram/add.json'
        ,'saveUrl':'${rootPath}/alram/save.json'
        ,'removeUrl':'${rootPath}/alram/remove.json'
        ,'listUrl':'${rootPath}/alram/list.html'
    };

    var messageConfig = {
        'addConfirm':'<spring:message code="common.message.addConfirm"/>'
        ,'saveConfirm':'<spring:message code="common.message.saveConfirm"/>'
        ,'removeConfirm':'<spring:message code="common.message.removeConfirm"/>'
        ,'addFailure':'<spring:message code="common.message.addFailure"/>'
        ,'saveFailure':'<spring:message code="common.message.saveFailure"/>'
        ,'removeFailure':'<spring:message code="common.message.removeFailure"/>'
        ,'addComplete':'<spring:message code="common.message.addComplete"/>'
        ,'saveComplete':'<spring:message code="common.message.saveComplete"/>'
        ,'removeComplete':'<spring:message code="common.message.removeComplete"/>'
        ,'emptyAlramName':'<spring:message code="alram.message.emptyAlramName"/>'
    };

    $(document).ready(function() {
        $("table[changeTb]").on("change", function(){
            if(event.target.name=="alramType"){
                changeAlramType();
            }
        });

        $("select[name='dashboardUseYn']").on("change", function(){
            if(this.value=='Y'){
                $("tr[dashboard] select[name='alramType']").prop("disabled",false);
                $("tr[dashboard] input[name='ttsText']").prop("disabled",false);
                $("tr[dashboard] select[name='fileId']").prop("disabled",false);
            }else{
                $("tr[dashboard] select[name='alramType']").prop("disabled",true);
                $("tr[dashboard] input[name='ttsText']").prop("disabled",true);
                $("tr[dashboard] select[name='fileId']").prop("disabled",true);
            }
        });

        changeAlramType();
    });

    function changeAlramType(){
        $.each($("table[changeTb] tr"),function(){
            var ttsTextTag = $(this).find("input[name='ttsText']");
            var fildIdTag = $(this).find("select[name='fileId']");

            switch ($(this).find("select[name='alramType']").val()){
                case "ARM002" :
                    ttsTextTag.hide();
                    fildIdTag.show();
                    break;
                case "ARM001" :
                default :
                    ttsTextTag.show();
                    fildIdTag.hide();
                    break;
            }
        });
    }

    /**
     * 음성 설정 레이어 추가
     */
    function addSettingLayer() {
        $("#addBtn").before($("#addSettingTag tr").clone());
        changeAlramType();
    }

    /**
     * 음성 설정 레이어 제거
     */
    function removeSettingLayer(_this) {
        $(_this).parent().parent().remove();
    }

    function validate(){
        if(form.find('input[name=alramName]').val().length == 0){
            alertMessage('emptyAlramName');
            return false;
        }

        var alramInfo = addAlramInfo();
        if(alramInfo.length==0){
            return false;
        }else{
            $("input[name=alramInfo]").val(alramInfo.join());
        }
        return true;
    }

    function addAlramInfo(){
        var alramInfo = [];

        if($("select[name='dashboardUseYn']").val()=='Y'){
            var addText = "";

            addText += "targetType:dashboard";
            addText += "|alramType:" + $("tr[dashboard] select[name='alramType']").val();

            switch ($("tr[dashboard] select[name='alramType']").val()){
                case "ARM001" :
                    addText += "|ttsText:" + $("tr[dashboard] input[name='ttsText']").val();
                    break;
                case "ARM002" :
                    addText += "|fileId:" + $("tr[dashboard] select[name='fileId']").val();
                    break;
                default :
                    break;
            }
            alramInfo.push(addText);
        }

        $.each($("table[changeTb] tr[device]"),function(){
            var addText = "";

            addText += "targetType:device";
            addText +=  "|deviceId:" + $(this).find("select[name='deviceId']").val();
            addText +=  "|alramType:" + $(this).find("select[name='alramType']").val();

            switch ($(this).find("select[name='alramType']").val()){
                case "ARM001" :
                    addText += "|ttsText:" + $(this).find("input[name='ttsText']").val()
                    break;
                case "ARM002" :
                    addText += "|fileId:" + $(this).find("select[name='fileId']").val();
                    break;
                default :
                    break;
            }
            alramInfo.push(addText);
        });

        return alramInfo;
    }

    function addAlram(){
        if(!confirm(messageConfig['addConfirm'])){
            return false;
        }

        if(validate()){
            callAjax('add', form.serialize());
        }
    }

    function saveAlram(){
        if(!confirm(messageConfig['saveConfirm'])){
            return false;
        }

        if(validate()){
            callAjax('save', form.serialize());
        }
    }

    function removeAlram(){
        if(!confirm(messageConfig['removeConfirm'])){
            return false;
        }

        callAjax('remove', form.serialize());
    }

    function callAjax(actionType, data){
        sendAjaxPostRequest(urlConfig[actionType + 'Url'],data,successHandler,errorHandler,actionType);
    }

    function successHandler(data, dataType, actionType){
        switch(actionType){
            case 'add':
            case 'save':
            case 'remove':
                alertMessage(actionType + 'Complete');
                break;
        }
        cancel();
    }

    function errorHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
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