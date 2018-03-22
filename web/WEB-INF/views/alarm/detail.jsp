<!-- 임계치 상세 -->
<!-- @author dhj -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<c:set value="J00021" var="menuId"/>
<c:set value="J00020" var="subMenuId"/>
<isaver:pageRoleCheck menuId="${menuId}" locale="${pageContext.response.locale}"/>

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.alarm"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><isaver:menu menuId="${menuId}" /></span>
        </div>
    </article>

    <!-- 2depth 타이틀 영역 End -->
    <form id="alarmForm" method="POST">
        <input type="hidden" name="alarmInfo" />
        <input type="hidden" name="alarmId" value="${alarm.alarmId}" />

        <article class="table_area">
            <div class="table_contents">
                <!-- 입력 테이블 Start -->
                <table changeTb class="t_defalut t_type02 alarmdetail_col">
                    <colgroup>
                        <col>  <!-- 01 -->
                        <col>  <!-- 02 -->
                        <col>  <!-- 03 -->
                        <col>  <!-- 04 -->
                    </colgroup>
                    <tbody>
                    <tr>
                        <th><spring:message code="alarm.column.alarmId"/></th>
                        <td>
                            <input type="text" value="${alarm.alarmId}" disabled="disabled"/>
                        </td>
                        <th class="point"><spring:message code="common.column.useYn"/></th>
                        <td class="point">
                            <div class="checkbox_set csl_style03">
                                <input type="hidden" name="useYn" value="${!empty alarm && alarm.useYn == 'Y' ? 'Y' : 'N'}"/>
                                <input type="checkbox" ${!empty alarm && alarm.useYn == 'Y' ? 'checked' : ''} onchange="setCheckBoxYn(this,'useYn')"/>
                                <label></label>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th class="point"><spring:message code="alarm.column.alarmName"/></th>
                        <td class="point" colspan="3">
                            <input type="text" name="alarmName" value="${alarm.alarmName}"/>
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code="alarm.column.alarmMessage"/></th>
                        <td colspan="3">
                            <input type="text" name="alarmMessage" value="${alarm.alarmMessage}"/>
                        </td>
                    </tr>
                    <tr dashboard>
                        <c:choose>
                            <c:when test="${dashboardAlarmInfos != null and fn:length(dashboardAlarmInfos) > 0}">
                                <th><spring:message code="alarm.column.alarmDashboardSetting"/></th>
                                <td>
                                    <div class="checkbox_set csl_style03">
                                        <input type="hidden" name="dashboardUseYn" value="Y"/>
                                        <input type="checkbox" checked name="dashboardUseYnCheckBox" onchange="setCheckBoxYn(this,'dashboardUseYn')"/>
                                        <label></label>
                                    </div>
                                </td>
                                <c:forEach var="info" items="${dashboardAlarmInfos[0].infos[0].datas}">
                                    <c:choose>
                                        <c:when test="${info.key=='alarmType'}">
                                            <td><isaver:codeSelectBox groupCodeId="ARM" htmlTagName="alarmType" codeId="${info.value}" /></td>
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
                                <th><spring:message code="alarm.column.alarmDashboardSetting"/></th>
                                <td>
                                    <div class="checkbox_set csl_style03">
                                        <input type="hidden" name="dashboardUseYn" value="N"/>
                                        <input type="checkbox" name="dashboardUseYnCheckBox" onchange="setCheckBoxYn(this,'dashboardUseYn')"/>
                                        <label></label>
                                    </div>
                                </td>
                                <td><isaver:codeSelectBox groupCodeId="ARM" htmlTagName="alarmType" disabled="true"/></td>
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
                    <c:if test="${!empty alarm}">
                        <tr>
                            <th><spring:message code="common.column.insertUser"/></th>
                            <td>${alarm.insertUserName}</td>
                            <th><spring:message code="common.column.insertDatetime"/></th>
                            <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${alarm.insertDatetime}" /></td>
                        </tr>
                        <tr>
                            <th><spring:message code="common.column.updateUser"/></th>
                            <td>${alarm.updateUserName}</td>
                            <th><spring:message code="common.column.updateDatetime"/></th>
                            <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${alarm.updateDatetime}" /></td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
                <!-- 입력 테이블 End -->
            </div>

            <!-- 알림대상장치 설정 -->
            <div class="table_title_area d_none">
                <h4><spring:message code="alarm.column.alarmDeviceSetting"/></h4>
            </div>
            <c:choose>
                <c:when test="${deviceAlarmInfos != null and fn:length(deviceAlarmInfos) > 0}">
                    <c:forEach var="deviceAlarmInfo" items="${deviceAlarmInfos}" varStatus="index">
                        <div <c:if test="${index.count > 1}">appendDiv</c:if> class="table_contents d_none">
                            <!-- 입력 테이블 Start -->
                            <table changeTb <c:if test="${index.count==0}">mainTb</c:if> alarmTargetTb class="t_defalut t_type02 alarmset_col">
                                <tbody>
                                    <tr>
                                        <th><spring:message code="alarm.column.targetDevice"/></th>
                                        <td>
                                            <select name="targetDeviceId">
                                                <c:if test="${index.count == 1}">
                                                    <option value="" <c:if test="${deviceAlarmInfo.targetId==null}">selected="selected"</c:if>><spring:message code="common.selectbox.all"/></option>
                                                </c:if>
                                                <c:forEach var="device" items="${targetDevices}">
                                                    <option value="${device.deviceId}" <c:if test="${device.deviceId == deviceAlarmInfo.targetId}">selected="selected"</c:if>>${device.deviceId} (${device.deviceCodeName})</option>
                                                </c:forEach>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th><spring:message code="alarm.column.alarmDevice"/></th>
                                        <td class="intd">
                                            <!-- 타이틀 영역 -->
                                            <div class="except01">
                                                <p><spring:message code="alarm.column.selectAlarmDevice"/></p>
                                                <p><spring:message code="alarm.column.selectAlarmType"/></p>
                                                <p><spring:message code="alarm.column.selectAlarmFile"/></p>
                                                <div><spring:message code="alarm.column.removeOrAdd"/></div>
                                            </div>
                                            <c:forEach var="infos" items="${deviceAlarmInfo.infos}" varStatus="status">
                                                <div device>
                                                    <c:forEach var="info" items="${infos.datas}">
                                                        <c:if test="${info.key=='alarmDeviceId'}">
                                                            <select name="deviceId">
                                                                <c:forEach var="device" items="${alarmDevices}">
                                                                    <option value="${device.deviceId}" <c:if test="${device.deviceId == info.value}">selected="selected"</c:if>>${device.deviceId} (${device.deviceCodeName})</option>
                                                                </c:forEach>
                                                            </select>
                                                        </c:if>
                                                        <c:if test="${info.key=='alarmType'}">
                                                            <isaver:codeSelectBox groupCodeId="ARM" htmlTagName="alarmType" codeId="${info.value}" />
                                                        </c:if>
                                                        <c:if test="${info.key=='ttsText'}">
                                                            <input type="text" name="ttsText" value="${info.value}"/>
                                                            <select name="fileId" style="display: none;">
                                                                <c:forEach var="file" items="${files}">
                                                                    <option value="${file.fileId}">${file.title}</option>
                                                                </c:forEach>
                                                            </select>
                                                        </c:if>
                                                        <c:if test="${info.key=='fileId'}">
                                                            <input type="text" style="display: none;" name="ttsText"/>
                                                            <select name="fileId">
                                                                <c:forEach var="file" items="${files}">
                                                                    <option value="${file.fileId}" <c:if test="${file.fileId == info.value}">selected="selected"</c:if>>${file.title}</option>
                                                                </c:forEach>
                                                            </select>
                                                        </c:if>
                                                    </c:forEach>
                                                    <div>
                                                        <c:if test="${status.count > 1}">
                                                            <button class='btn ico-minus' onclick='javascript:removeSettingLayer("alarmDevice",this); return false;'></button>
                                                        </c:if>
                                                        <button class='btn ico-plus' onclick="javascript:addSettingLayer('alarmDevice', this); return false;"></button>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                            <div class="table_btn_set type02">
                                <c:if test="${index.count > 1}">
                                    <button class='btn ico-minus' onclick='javascript:removeSettingLayer("targetDevice",this); return false;'></button>
                                </c:if>
                                <button class='btn ico-plus' onclick="javascript:addSettingLayer('targetDevice', this); return false;"></button>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="table_contents d_none">
                        <!-- 입력 테이블 Start -->
                        <table changeTb mainTb alarmTargetTb class="t_defalut t_type02 alarmset_col">
                            <tbody>
                                <tr>
                                    <th><spring:message code="alarm.column.targetDevice"/></th>
                                    <td>
                                        <select name="targetDeviceId">
                                            <option value=""><spring:message code="common.selectbox.all"/></option>
                                            <c:forEach var="device" items="${targetDevices}">
                                                <option value="${device.deviceId}">${device.deviceId} (${device.deviceCodeName})</option>
                                            </c:forEach>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <th><spring:message code="alarm.column.alarmDevice"/></th>
                                    <td class="intd">
                                        <!-- 타이틀 영역 -->
                                        <div class="except01">
                                            <p><spring:message code="alarm.column.selectAlarmDevice"/></p>
                                            <p><spring:message code="alarm.column.selectAlarmType"/></p>
                                            <p><spring:message code="alarm.column.selectAlarmFile"/></p>
                                            <div><spring:message code="alarm.column.removeOrAdd"/></div>
                                        </div>
                                        <div device>
                                            <select name="deviceId">
                                                <c:forEach var="device" items="${alarmDevices}">
                                                    <option value="${device.deviceId}">${device.deviceId} (${device.deviceCodeName})</option>
                                                </c:forEach>
                                            </select>
                                            <isaver:codeSelectBox groupCodeId="ARM" htmlTagName="alarmType"/>
                                            <input type="text" name="ttsText"/>
                                            <select name="fileId" style="display: none;">
                                                <c:forEach var="file" items="${files}">
                                                    <option value="${file.fileId}">${file.title}</option>
                                                </c:forEach>
                                            </select>
                                            <div>
                                                <button class='btn ico-plus' onclick="javascript:addSettingLayer('alarmDevice', this); return false;"></button>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                        <div class="table_btn_set type02">
                            <button name="targetDeviceAddBtn" class='btn ico-plus' onclick="javascript:addSettingLayer('targetDevice', this); return false;"></button>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>

            <div class="table_title_area">
                <div class="table_btn_set">
                    <c:if test="${empty alarm}">
                        <button class="btn" onclick="javascript:addAlarm(); return false;"><spring:message code="common.button.add"/></button>
                    </c:if>
                    <c:if test="${!empty alarm}">
                        <button class="btn" onclick="javascript:saveAlarm(); return false;"><spring:message code="common.button.save"/></button>
                        <button class="btn" onclick="javascript:removeAlarm(); return false;"><spring:message code="common.button.remove"/></button>
                    </c:if>
                    <button class="btn" onclick="javascript:cancel(); return false;"><spring:message code="common.button.list"/></button>
                </div>
            </div>
        </article>
        <!-- 테이블 입력 / 조회 영역 End -->
    </form>
</section>

<div style="display: none">
    <div id="addSettingTag">
        <div class="table_contents">
            <!-- 입력 테이블 Start -->
            <table changeTb class="t_defalut t_type02 alarmset_col">
                <tbody>
                <tr>
                    <th><spring:message code="alarm.column.targetDevice"/></th>
                    <td>
                        <select name="targetDeviceId">
                            <c:forEach var="device" items="${targetDevices}">
                                <option value="${device.deviceId}">${device.deviceId} (${device.deviceCodeName})</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th><spring:message code="alarm.column.alarmDevice"/></th>
                    <td class="intd">
                        <!-- 타이틀 영역 -->
                        <div class="except01">
                            <p><spring:message code="alarm.column.selectAlarmDevice"/></p>
                            <p><spring:message code="alarm.column.selectAlarmType"/></p>
                            <p><spring:message code="alarm.column.selectAlarmFile"/></p>
                            <div><spring:message code="alarm.column.removeOrAdd"/></div>
                        </div>
                        <div device>
                            <select name="deviceId">
                                <c:forEach var="device" items="${alarmDevices}">
                                    <option value="${device.deviceId}">${device.deviceId} (${device.deviceCodeName})</option>
                                </c:forEach>
                            </select>
                            <isaver:codeSelectBox groupCodeId="ARM" htmlTagName="alarmType"/>
                            <input type="text" name="ttsText"/>
                            <select name="fileId" style="display: none;">
                                <c:forEach var="file" items="${files}">
                                    <option value="${file.fileId}">${file.title}</option>
                                </c:forEach>
                            </select>
                            <div>
                                <button class='btn ico-plus' onclick="javascript:addSettingLayer('alarmDevice', this); return false;"></button>
                            </div>
                        </div>
                    </td>
                </tr>
                </tbody>
            </table>
            <div class="table_btn_set type02">
                <button class='btn ico-minus' onclick="javascript:removeSettingLayer('targetDevice', this); return false;"></button>
                <button name="targetDeviceAddBtn" class='btn ico-plus' onclick="javascript:addSettingLayer('targetDevice', this); return false;"></button>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');
    var form = $('#alarmForm');

    var urlConfig = {
        'addUrl':'${rootPath}/alarm/add.json'
        ,'saveUrl':'${rootPath}/alarm/save.json'
        ,'removeUrl':'${rootPath}/alarm/remove.json'
        ,'listUrl':'${rootPath}/alarm/list.html'
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
        ,'emptyAlarmName':'<spring:message code="alarm.message.emptyAlarmName"/>'
        ,'duplicationTargetDevice':'<spring:message code="alarm.message.duplicationTargetDevice"/>'
    };

    $(document).ready(function() {
        $("table[changeTb]").on("change", function(){
            if(event.target.name=="alarmType"){
                changeAlarmType();
            }
        });

        $("table[mainTb] select[name='targetDeviceId']").on("change", function(){
            changeTargetDeviceType();
        });

        $("input[name='dashboardUseYnCheckBox']").on("change", function(){
            if($(this).is(":checked")){
                $("tr[dashboard] select[name='alarmType']").prop("disabled",false);
                $("tr[dashboard] input[name='ttsText']").prop("disabled",false);
                $("tr[dashboard] select[name='fileId']").prop("disabled",false);
            }else{
                $("tr[dashboard] select[name='alarmType']").prop("disabled",true);
                $("tr[dashboard] input[name='ttsText']").prop("disabled",true);
                $("tr[dashboard] select[name='fileId']").prop("disabled",true);
            }
        });

        changeAlarmType();
        changeTargetDeviceType();
    });

    function changeTargetDeviceType(){
        if($("table[mainTb] select[name='targetDeviceId']").val()==''){
            $("div[appendDiv]").remove();
            $("button[name='targetDeviceAddBtn']").hide();
        }else{
            $("button[name='targetDeviceAddBtn']").show();
        }
    }

    function changeAlarmType(){
        $.each($("table[changeTb] tr"),function(){
            var ttsTextTag = $(this).find("input[name='ttsText']");
            var fildIdTag = $(this).find("select[name='fileId']");

            switch ($(this).find("select[name='alarmType']").val()){
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
     * 알림대상장치 레이어 추가
     * _type
     *  targetDevice : 감지장치 추가
     *  alarmDevice : 대상장치 추가
     */
    function addSettingLayer(_type, _this) {
        if(_type=="targetDevice"){
            var tbTag = $("#addSettingTag > div").clone();
            tbTag.attr("appendDiv","").attr("alarmTargetTb","");
            $(_this).parent().parent().after(tbTag);
        }else if(_type=="alarmDevice"){
            var deviceTag = $("#addSettingTag div[device]").clone();
            deviceTag.find("div:last-child").prepend(
                $("<button/>",{class:'btn ico-minus', onclick:'javascript:removeSettingLayer("alarmDevice",this); return false;'})
            );
            $(_this).parent().parent().after(deviceTag);
        }
        changeAlarmType();
    }

    /**
     * 음성 설정 레이어 제거
     * _type
     *  targetDevice : 감지장치 제거
     *  alarmDevice : 대상장치 제거
     */
    function removeSettingLayer(_type, _this) {
        if(_type=="targetDevice"){
            $(_this).parent().parent().remove();
        }else if(_type=="alarmDevice"){
            $(_this).parent().parent().remove();
        }
    }

    function validate(){
        if(form.find('input[name=alarmName]').val().length == 0){
            alertMessage('emptyAlarmName');
            return false;
        }

        if(isDuplicationArray($("table[alarmTargetTb] select[name='targetDeviceId']").map(function(){return this.value}).get())){
            alertMessage('duplicationTargetDevice');
            return false;
        }

        var alarmInfo = addAlarmInfo();
        if(alarmInfo.length==0){
            return false;
        }else{
            $("input[name=alarmInfo]").val(alarmInfo.join());
        }
        return true;
    }

    function addAlarmInfo(){
        var alarmInfo = [];

        if($("input[name='dashboardUseYn']").val()=='Y'){
            var addText = "";

            addText += "DASHBOARD";
            addText += "|alarmType:" + $("tr[dashboard] select[name='alarmType']").val();

            switch ($("tr[dashboard] select[name='alarmType']").val()){
                case "ARM001" :
                    addText += "|ttsText:" + $("tr[dashboard] input[name='ttsText']").val();
                    break;
                case "ARM002" :
                    addText += "|fileId:" + $("tr[dashboard] select[name='fileId']").val();
                    break;
                default :
                    break;
            }
            alarmInfo.push(addText);
        }

        $.each($("table[alarmTargetTb]"),function(){
            var targetDeviceId = $(this).find("select[name='targetDeviceId']").val();

            $.each($(this).find("div[device]"),function(){
                var addText = "";
                addText += targetDeviceId;
                addText +=  "|alarmDeviceId:" + $(this).find("select[name='deviceId']").val();
                addText +=  "|alarmType:" + $(this).find("select[name='alarmType']").val();

                switch ($(this).find("select[name='alarmType']").val()){
                    case "ARM001" :
                        addText += "|ttsText:" + $(this).find("input[name='ttsText']").val()
                        break;
                    case "ARM002" :
                        addText += "|fileId:" + $(this).find("select[name='fileId']").val();
                        break;
                    default :
                        break;
                }
                alarmInfo.push(addText);
            });
        });

        return alarmInfo;
    }

    function addAlarm(){
        if(!confirm(messageConfig['addConfirm'])){
            return false;
        }

        if(validate()){
            callAjax('add', form.serialize());
        }
    }

    function saveAlarm(){
        if(!confirm(messageConfig['saveConfirm'])){
            return false;
        }

        if(validate()){
            callAjax('save', form.serialize());
        }
    }

    function removeAlarm(){
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