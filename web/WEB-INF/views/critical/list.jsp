<!-- 임계치 관리, @author dhj -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<c:set value="J00010" var="menuId"/>
<c:set value="J00000" var="subMenuId"/>
<isaver:pageRoleCheck menuId="${menuId}" locale="${pageContext.response.locale}"/>
<script type="text/javascript" src="${rootPath}/assets/js/util/page-navigater.js"></script>

<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.critical"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><isaver:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <article class="table_area">
        <div class="critical_title">
            <p><spring:message code="critical.title.event"/></p>
            <p><spring:message code="critical.title.critical"/></p>
            <p><spring:message code="critical.title.detectDevice"/></p>
            <p><spring:message code="critical.title.targetDevice"/></p>
        </div>

        <ul class="critical_tree_set">
            <c:forEach var="event" items="${eventList}">
                <li>
                    <div>
                        <button>${event.eventName}(${event.eventId})</button>
                    </div>
                    <ul>
                        <c:forEach var="critical" items="${event.criticals}">
                            <li>
                                <div <c:if test="${criticalLevelCss[critical.criticalLevel]!=null}">class="level-${criticalLevelCss[critical.criticalLevel]}"</c:if>>
                                    <button onclick="javascript:openPopup('critical',{mode:'modify',criticalId:'${critical.criticalId}'});">
                                        <c:if test="${critical.criticalName!=null}">
                                            ${critical.criticalName}
                                        </c:if>
                                        <c:if test="${critical.criticalName==null && critical.criticalLevel=='LEV000'}">
                                            <spring:message code="critical.selectbox.cancel"/>
                                        </c:if>
                                    </button>
                                    <button onclick="remove('critical',{criticalId:'${critical.criticalId}'});"></button>
                                </div>
                                <ul>
                                    <c:forEach var="criticalDetect" items="${critical.criticalDetects}">
                                        <li criticalDetectId="${criticalDetect.criticalDetectId}">
                                            <div>
                                                <button onclick="javascript:openPopup('detect',{mode:'modify',criticalDetectId:'${criticalDetect.criticalDetectId}'});">${criticalDetect.detectDeviceName}(${criticalDetect.detectDeviceId})</button>
                                                <button onclick="remove('detect',{criticalDetectId:'${criticalDetect.criticalDetectId}'});"></button>
                                            </div>
                                            <ul>
                                                <c:forEach var="criticalTarget" items="${criticalDetect.criticalTargets}">
                                                    <li targetDeviceId="${criticalTarget.targetDeviceId}">
                                                        <div>
                                                            <button onclick="javascript:openPopup('target',{mode:'modify',criticalDetectId:'${criticalDetect.criticalDetectId}',targetDeviceId:'${criticalTarget.targetDeviceId}'});">${criticalTarget.targetDeviceName}(${criticalTarget.targetDeviceId})</button>
                                                            <button onclick="remove('target',{criticalDetectId:'${criticalDetect.criticalDetectId}',targetDeviceId:'${criticalTarget.targetDeviceId}'});"></button>
                                                        </div>
                                                    </li>
                                                </c:forEach>
                                                <li>
                                                    <button onclick="openPopup('target',{mode:'new',eventId:'${event.eventId}',criticalLevel:'${critical.criticalLevel}',criticalDetectId:'${criticalDetect.criticalDetectId}',detectDeviceId:'${criticalDetect.detectDeviceId}'});"></button>
                                                </li>
                                            </ul>
                                        </li>
                                    </c:forEach>
                                    <li>
                                        <button onclick="openPopup('detect',{mode:'new',eventId:'${event.eventId}',criticalId:'${critical.criticalId}',criticalLevel:'${critical.criticalLevel}'});"></button>
                                    </li>
                                </ul>
                            </li>
                        </c:forEach>
                        <li>
                            <button onclick="openPopup('critical',{mode:'new',eventId:'${event.eventId}'});"></button>
                        </li>
                    </ul>
                </li>
            </c:forEach>
        </ul>
    </article>

    <!-- 임계치 설정 팝업 -->
    <div class="popupbase critical_pop" popupType="critical">
        <input type="hidden" name="criticalId" value=""/>
        <div>
            <div>
                <header>
                    <h2><spring:message code="critical.title.criticalPopup"/></h2>
                    <button class="close_btn" onclick="javascript:closePopup('critical');"></button>
                </header>
                <article>
                    <section class="critical_set_list">
                        <div>
                            <p><spring:message code="critical.column.event"/></p>
                            <div>
                                <select name="eventId" disabled="disabled">
                                    <c:forEach var="event" items="${eventList}">
                                        <option value="${event.eventId}">${event.eventName}(${event.eventId})</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div>
                            <p><spring:message code="critical.column.criticalValue"/></p>
                            <div><input type="text" name="criticalValue" value=""/></div>
                        </div>
                        <div>
                            <p><spring:message code="critical.column.criticalLevel"/></p>
                            <div>
                                <select name="criticalLevel">
                                    <option value=""><spring:message code="common.selectbox.select"/></option>
                                    <option value="LEV000"><spring:message code="critical.selectbox.cancel"/></option>
                                    <c:forEach var="critical" items="${criticalList}">
                                        <option value="${critical.codeId}">${critical.codeName}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div>
                            <p><spring:message code="critical.column.dashboardSoundSetting"/></p>
                            <div>
                                <select name="dashboardFileId">
                                    <option value=""><spring:message code="common.selectbox.notSelect"/></option>
                                    <c:forEach var="file" items="${alarmFileList}">
                                        <option value="${file.fileId}">${file.title}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                    </section>
                </article>
                <footer>
                    <button class="btn addBtn" onclick="javascript:add('critical');"><spring:message code="common.button.add"/></button>
                    <button class="btn saveBtn" onclick="javascript:save('critical');"><spring:message code="common.button.save"/></button>
                </footer>
            </div>
        </div>
        <div class="bg" onclick="javascript:closePopup('critical');"></div>
    </div>

    <!-- 감지장치 설정 팝업 -->
    <div class="popupbase critical_pop" popupType="detect">
        <input type="hidden" name="criticalId" value=""/>
        <input type="hidden" name="criticalDetectId" value=""/>
        <div>
            <div>
                <header>
                    <h2><spring:message code="critical.title.detectPopup"/></h2>
                    <button class="close_btn" onclick="javascript:closePopup('detect');"></button>
                </header>
                <article>
                    <section class="critical_set_list">
                        <div>
                            <p><spring:message code="critical.column.event"/></p>
                            <div>
                                <select name="eventId" disabled="disabled">
                                    <c:forEach var="event" items="${eventList}">
                                        <option value="${event.eventId}">${event.eventName}(${event.eventId})</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div>
                            <p><spring:message code="critical.column.criticalLevel"/></p>
                            <div>
                                <select name="criticalLevel" disabled="disabled">
                                    <option value="LEV000"><spring:message code="critical.selectbox.cancel"/></option>
                                    <c:forEach var="critical" items="${criticalList}">
                                        <option value="${critical.codeId}">${critical.codeName}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div>
                            <p><spring:message code="critical.column.detectDevice"/></p>
                            <div>
                                <select name="detectDeviceId" onchange="javascript:detectDeviceChangeHandler('detect',this);">
                                    <option value=""><spring:message code="common.selectbox.select"/></option>
                                    <c:forEach var="device" items="${deviceList}">
                                        <option deviceCode="${device.deviceCode}" value="${device.deviceId}">${device.deviceName}(${device.deviceId})</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div fenceDiv>
                            <p><spring:message code="critical.column.fenceId"/></p>
                            <div>
                                <select name="fenceId">
                                    <option value=""><spring:message code="common.selectbox.select"/></option>
                                </select>
                            </div>
                        </div>
                    </section>
                </article>
                <footer>
                    <button class="btn addBtn" onclick="javascript:add('detect');"><spring:message code="common.button.add"/></button>
                    <button class="btn saveBtn" onclick="javascript:save('detect');"><spring:message code="common.button.save"/></button>
                </footer>
            </div>
        </div>
        <div class="bg" onclick="javascript:closePopup('detect');"></div>
    </div>

    <!-- 대상장치 설정 팝업 -->
    <div class="popupbase critical_pop" popupType="target">
        <input type="hidden" name="criticalDetectId" value=""/>
        <div>
            <div>
                <header>
                    <h2><spring:message code="critical.title.targetPopup"/></h2>
                    <button class="close_btn" onclick="javascript:closePopup('target');"></button>
                </header>
                <article>
                    <section class="critical_set_list">
                        <div>
                            <p><spring:message code="critical.column.event"/></p>
                            <div>
                                <select name="eventId" disabled="disabled">
                                    <c:forEach var="event" items="${eventList}">
                                        <option value="${event.eventId}">${event.eventName}(${event.eventId})</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div>
                            <p><spring:message code="critical.column.criticalLevel"/></p>
                            <div>
                                <select name="criticalLevel" disabled="disabled">
                                    <option value="LEV000"><spring:message code="critical.selectbox.cancel"/></option>
                                    <c:forEach var="critical" items="${criticalList}">
                                        <option value="${critical.codeId}">${critical.codeName}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div>
                            <p><spring:message code="critical.column.detectDevice"/></p>
                            <div>
                                <select name="detectDeviceId" disabled="disabled">
                                    <c:forEach var="device" items="${deviceList}">
                                        <c:if test="${device.deviceTypeCode==detectDeviceTypeCode}">
                                            <option value="${device.deviceId}">${device.deviceName}(${device.deviceId})</option>
                                        </c:if>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div>
                            <p><spring:message code="critical.column.targetDevice"/></p>
                            <div>
                                <select name="targetDeviceId">
                                    <option value=""><spring:message code="common.selectbox.select"/></option>
                                    <c:forEach var="device" items="${deviceList}">
                                        <c:if test="${device.deviceTypeCode==targetDeviceTypeCode}">
                                            <option value="${device.deviceId}">${device.deviceName}(${device.deviceId})</option>
                                        </c:if>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div>
                            <p><spring:message code="critical.column.alarmType"/></p>
                            <div>
                                <select name="alarmType">
                                    <option value="file"><spring:message code="critical.selectbox.file"/></option>
                                    <option value="control"><spring:message code="critical.selectbox.control"/></option>
                                </select>
                            </div>
                        </div>
                        <div>
                            <p><spring:message code="critical.column.alarmMessage"/></p>
                            <div>
                                <select name="alarmMessage">
                                    <option value="on"><spring:message code="critical.selectbox.on"/></option>
                                    <option value="off"><spring:message code="critical.selectbox.off"/></option>
                                </select>
                            </div>
                        </div>
                        <div>
                            <p><spring:message code="critical.column.alarmFile"/></p>
                            <div>
                                <select name="alarmFileId">
                                    <option value=""><spring:message code="common.selectbox.notSelect"/></option>
                                    <c:forEach var="file" items="${alarmFileList}">
                                        <option value="${file.fileId}">${file.title}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                    </section>
                </article>
                <footer>
                    <button class="btn addBtn" onclick="javascript:add('target');"><spring:message code="common.button.add"/></button>
                    <button class="btn saveBtn" onclick="javascript:save('target');"><spring:message code="common.button.save"/></button>
                </footer>
            </div>
        </div>
        <div class="bg" onclick="javascript:closePopup('target');"></div>
    </div>
</section>

<script type="text/javascript">
    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');

    var messageConfig = {
        /** 임계치 */
        'requireCriticalLevel':'<spring:message code="critical.message.requireCriticalLevel"/>'
        ,'criticalDetailFailure':'<spring:message code="critical.message.criticalDetailFailure"/>'
        ,'criticalAddConfirm':'<spring:message code="critical.message.criticalAddConfirm"/>'
        ,'criticalSaveConfirm':'<spring:message code="critical.message.criticalSaveConfirm"/>'
        ,'criticalRemoveConfirm':'<spring:message code="critical.message.criticalRemoveConfirm"/>'
        ,'criticalAddFailure':'<spring:message code="critical.message.criticalAddFailure"/>'
        ,'criticalSaveFailure':'<spring:message code="critical.message.criticalSaveFailure"/>'
        ,'criticalRemoveFailure':'<spring:message code="critical.message.criticalRemoveFailure"/>'
        ,'criticalAddComplete':'<spring:message code="critical.message.criticalAddComplete"/>'
        ,'criticalSaveComplete':'<spring:message code="critical.message.criticalSaveComplete"/>'
        ,'criticalRemoveComplete':'<spring:message code="critical.message.criticalRemoveComplete"/>'
        ,'criticalExist':'<spring:message code="critical.message.criticalExist"/>'
        /** 감지장치 */
        ,'requireDetectDeviceId':'<spring:message code="critical.message.requireDetectDeviceId"/>'
        ,'requireFenceId':'<spring:message code="critical.message.requireFenceId"/>'
        ,'detectDetailFailure':'<spring:message code="critical.message.detectDetailFailure"/>'
        ,'detectAddConfirm':'<spring:message code="critical.message.detectAddConfirm"/>'
        ,'detectSaveConfirm':'<spring:message code="critical.message.detectSaveConfirm"/>'
        ,'detectRemoveConfirm':'<spring:message code="critical.message.detectRemoveConfirm"/>'
        ,'detectAddFailure':'<spring:message code="critical.message.detectAddFailure"/>'
        ,'detectSaveFailure':'<spring:message code="critical.message.detectSaveFailure"/>'
        ,'detectRemoveFailure':'<spring:message code="critical.message.detectRemoveFailure"/>'
        ,'detectAddComplete':'<spring:message code="critical.message.detectAddComplete"/>'
        ,'detectSaveComplete':'<spring:message code="critical.message.detectSaveComplete"/>'
        ,'detectRemoveComplete':'<spring:message code="critical.message.detectRemoveComplete"/>'
        ,'detectExist':'<spring:message code="critical.message.detectExist"/>'
        /** 대상장치 */
        ,'requireTargetDeviceId':'<spring:message code="critical.message.requireTargetDeviceId"/>'
        ,'requireAlarmFileId':'<spring:message code="critical.message.requireAlarmFileId"/>'
        ,'targetDetailFailure':'<spring:message code="critical.message.targetDetailFailure"/>'
        ,'targetAddConfirm':'<spring:message code="critical.message.targetAddConfirm"/>'
        ,'targetSaveConfirm':'<spring:message code="critical.message.targetSaveConfirm"/>'
        ,'targetRemoveConfirm':'<spring:message code="critical.message.targetRemoveConfirm"/>'
        ,'targetAddFailure':'<spring:message code="critical.message.targetAddFailure"/>'
        ,'targetSaveFailure':'<spring:message code="critical.message.targetSaveFailure"/>'
        ,'targetRemoveFailure':'<spring:message code="critical.message.targetRemoveFailure"/>'
        ,'targetAddComplete':'<spring:message code="critical.message.targetAddComplete"/>'
        ,'targetSaveComplete':'<spring:message code="critical.message.targetSaveComplete"/>'
        ,'targetRemoveComplete':'<spring:message code="critical.message.targetRemoveComplete"/>'
    };

    var urlConfig = {
        'listUrl':'${rootPath}/critical/list.html'
        ,'criticalDetailUrl':'${rootPath}/critical/detail.json'
        ,'criticalAddUrl':'${rootPath}/critical/add.json'
        ,'criticalSaveUrl':'${rootPath}/critical/save.json'
        ,'criticalRemoveUrl':'${rootPath}/critical/remove.json'
        ,'detectDetailUrl':'${rootPath}/criticalDetect/detail.json'
        ,'detectAddUrl':'${rootPath}/criticalDetect/add.json'
        ,'detectSaveUrl':'${rootPath}/criticalDetect/save.json'
        ,'detectRemoveUrl':'${rootPath}/criticalDetect/remove.json'
        ,'targetDetailUrl':'${rootPath}/criticalTarget/detail.json'
        ,'targetAddUrl':'${rootPath}/criticalTarget/add.json'
        ,'targetSaveUrl':'${rootPath}/criticalTarget/save.json'
        ,'targetRemoveUrl':'${rootPath}/criticalTarget/remove.json'
    };
    $(document).ready(function(){
    });

    function detectDeviceChangeHandler(actionType, _this){
        var deviceId = $(_this).val();
        var deviceCode = $(_this).find("option:selected").attr("deviceCode");
        var targetElement = $(".popupbase[popupType='"+actionType+"']");
        targetElement.find("select[name='fenceId'] option").not("[value='']").remove();

        if(deviceCode!="DEV013"){
            targetElement.find("div[fenceDiv]").addClass("d_none");
        }else{
            targetElement.find("div[fenceDiv]").removeClass("d_none");
            var fenceList = notificationHelper.getFenceList('deviceId',deviceId);
            for(var index in fenceList){
                var fence = fenceList[index];
                if(fence['fenceType']!='ignore'){
                    targetElement.find("select[name='fenceId']").append(
                        $("<option/>",{value:fence['fenceId']}).text(fence['fenceName']!=null?fence['fenceName']:fence['fenceId'])
                    );
                }
            }
        }
    }

    function openPopup(actionType, data){
        if(data['mode']=='modify'){
            callAjax(actionType+"Detail",data);
        }else{
            switch(actionType){
                case 'critical':
                    criticalRender(data);
                    break;
                case 'detect':
                    detectRender(data);
                    break;
                case 'target':
                    targetRender(data);
                    break;
            }
        }
    }

    function closePopup(actionType){
        $(".popupbase[popupType='"+actionType+"']").fadeOut(200);
    }

    function validate(targetElement, actionType){
        switch(actionType) {
            case 'critical':
                if(targetElement.find("select[name='criticalLevel'] option:selected").val()==''){
                    alertMessage('requireCriticalLevel');
                    return false;
                }
                break;
            case 'detect':
                if(targetElement.find("select[name='detectDeviceId'] option:selected").val()==''){
                    alertMessage('requireDetectDeviceId');
                    return false;
                }

                if(targetElement.find("select[name='eventId'] option:selected").val()!='EVT999'){
                    if(targetElement.find("select[name='detectDeviceId'] option:selected").attr("deviceCode")=='DEV013'
                            && targetElement.find("select[name='fenceId'] option:selected").val()==''){
                        alertMessage('requireFenceId');
                        return false;
                    }
                }
                break;
            case 'target':
                if(targetElement.find("select[name='targetDeviceId'] option:selected").val()==''){
                    alertMessage('requireTargetDeviceId');
                    return false;
                }

                if(targetElement.find("select[name='alarmType'] option:selected").val()=='file' && targetElement.find("select[name='alarmFileId'] option:selected").val()==''){
                    alertMessage('requireAlarmFileId');
                    return false;
                }
                break;
        }
        return true;
    }

    function add(actionType){
        var targetElement = $(".popupbase[popupType='"+actionType+"']");

        if(targetElement.length>0){
            var param = null;

            switch(actionType){
                case 'critical':
                    param = {
                        'criticalId' : targetElement.find("input[name='criticalId']").val()
                        ,'eventId' : targetElement.find("select[name='eventId'] option:selected").val()
                        ,'criticalLevel' : targetElement.find("select[name='criticalLevel'] option:selected").val()
                        ,'criticalValue' : targetElement.find("input[name='criticalValue']").val()
                        ,'dashboardFileId' : targetElement.find("select[name='dashboardFileId'] option:selected").val()
                    };
                    break;
                case 'detect':
                    param = {
                        'criticalId' : targetElement.find("input[name='criticalId']").val()
                        ,'eventId' : targetElement.find("select[name='eventId'] option:selected").val()
                        ,'detectDeviceId' : targetElement.find("select[name='detectDeviceId'] option:selected").val()
                        ,'fenceId' : targetElement.find("select[name='fenceId'] option:selected").val()
                    };
                    break;
                case 'target':
                    param = {
                        'criticalDetectId' : targetElement.find("input[name='criticalDetectId']").val()
                        ,'targetDeviceId' : targetElement.find("select[name='targetDeviceId'] option:selected").val()
                        ,'alarmType' : targetElement.find("select[name='alarmType'] option:selected").val()
                        ,'alarmMessage' : targetElement.find("select[name='alarmMessage'] option:selected").val()
                        ,'alarmFileId' : targetElement.find("select[name='alarmFileId'] option:selected").val()
                    };
                    break;
            }

            if(validate(targetElement,actionType) && param!=null){
                if(!confirm(messageConfig[actionType+'AddConfirm'])){
                    return false;
                }
                callAjax(actionType+'Add',param);
            }
        }
    }

    function save(actionType){
        var targetElement = $(".popupbase[popupType='"+actionType+"']");

        if(targetElement.length>0){
            var param = null;

            switch(actionType){
                case 'critical':
                    param = {
                        'criticalId' : targetElement.find("input[name='criticalId']").val()
                        ,'criticalLevel' : targetElement.find("select[name='criticalLevel'] option:selected").val()
                        ,'criticalValue' : targetElement.find("input[name='criticalValue']").val()
                        ,'dashboardFileId' : targetElement.find("select[name='dashboardFileId'] option:selected").val()
                    };
                    break;
                case 'detect':
                    param = {
                        'criticalId' : targetElement.find("input[name='criticalId']").val()
                        ,'eventId' : targetElement.find("select[name='eventId'] option:selected").val()
                        ,'criticalDetectId' : targetElement.find("input[name='criticalDetectId']").val()
                        ,'detectDeviceId' : targetElement.find("select[name='detectDeviceId'] option:selected").val()
                        ,'fenceId' : targetElement.find("select[name='fenceId'] option:selected").val()
                    };
                    break;
                case 'target':
                    param = {
                        'criticalDetectId' : targetElement.find("input[name='criticalDetectId']").val()
                        ,'targetDeviceId' : targetElement.find("select[name='targetDeviceId'] option:selected").val()
                        ,'alarmType' : targetElement.find("select[name='alarmType'] option:selected").val()
                        ,'alarmMessage' : targetElement.find("select[name='alarmMessage'] option:selected").val()
                        ,'alarmFileId' : targetElement.find("select[name='alarmFileId'] option:selected").val()
                    };
                    break;
            }

            if(validate(targetElement,actionType) && param!=null){
                if(!confirm(messageConfig[actionType+'SaveConfirm'])){
                    return false;
                }
                callAjax(actionType+'Save',param);
            }
        }
    }

    function remove(actionType, data){
        if(!confirm(messageConfig[actionType+'RemoveConfirm'])){
            return false;
        }
        callAjax(actionType+'Remove',data);
    }

    /*
     ajax call
     @author psb
     */
    function callAjax(actionType, data){
        sendAjaxPostRequest(urlConfig[actionType + 'Url'],data,critical_successHandler,critical_errorHandler,actionType);
    }

    /*
     ajax success handler
     @author psb
     */
    function critical_successHandler(data, dataType, actionType){
        switch(actionType){
            case 'criticalDetail':
                criticalRender(data['critical']);
                break;
            case 'detectDetail':
                detectRender(data['criticalDetect']);
                break;
            case 'targetDetail':
                targetRender(data['criticalTarget']);
                break;
            default :
                if(data['resultCode']!=null){
                    switch (data['resultCode']){
                        case "ERR100":
                            alertMessage('criticalExist');
                            break;
                        case "ERR101":
                            alertMessage('detectExist');
                            break;
                    }
                }else{
                    alertMessage(actionType + 'Complete');
                    cancel();
                }
        }
    }

    function criticalRender(data){
        var targetElement = $(".popupbase[popupType='critical']");

        if(targetElement.length>0){
            targetElement.find("input[name='criticalId']").val(data['criticalId']);
            targetElement.find("select[name='eventId']").val(data['eventId']);
            targetElement.find("input[name='criticalValue']").val(data['criticalValue']?data['criticalValue']:'');
            targetElement.find("select[name='criticalLevel']").val(data['criticalLevel']?data['criticalLevel']:'');
            targetElement.find("select[name='dashboardFileId']").val(data['dashboardFileId']?data['dashboardFileId']:'');

            switch(data['mode']){
                case 'new':
                    targetElement.find(".addBtn").show();
                    targetElement.find(".saveBtn").hide();
                    break;
                default :
                    targetElement.find(".saveBtn").show();
                    targetElement.find(".addBtn").hide();
            }
            targetElement.show();
        }
    }

    function detectRender(data){
        var targetElement = $(".popupbase[popupType='detect']");

        if(targetElement.length>0){
            targetElement.find("input[name='criticalId']").val(data['criticalId']);
            targetElement.find("input[name='criticalDetectId']").val(data['criticalDetectId']);
            targetElement.find("select[name='eventId']").val(data['eventId']);
            targetElement.find("select[name='criticalLevel']").val(data['criticalLevel']);
            targetElement.find("select[name='detectDeviceId']").val(data['detectDeviceId']?data['detectDeviceId']:'').trigger('change');
            targetElement.find("select[name='fenceId']").val(data['fenceId']);

            switch(data['mode']){
                case 'new':
                    targetElement.find(".addBtn").show();
                    targetElement.find(".saveBtn").hide();
                    break;
                default :
                    targetElement.find(".saveBtn").show();
                    targetElement.find(".addBtn").hide();
            }
            targetElement.show();
        }
    }

    function targetRender(data){
        var targetElement = $(".popupbase[popupType='target']");

        if(targetElement.length>0){
            targetElement.find("select[name='targetDeviceId'] option").prop("disabled",false);
            $.each($("li[criticalDetectId='"+data['criticalDetectId']+"'] li[targetDeviceId]"), function(){
                targetElement.find("select[name='targetDeviceId'] option[value='"+$(this).attr("targetDeviceId")+"']").prop("disabled",true);
            });

            targetElement.find("input[name='criticalDetectId']").val(data['criticalDetectId']);
            targetElement.find("select[name='eventId']").val(data['eventId']);
            targetElement.find("select[name='criticalLevel']").val(data['criticalLevel']);
            targetElement.find("select[name='detectDeviceId']").val(data['detectDeviceId']);
            targetElement.find("select[name='targetDeviceId']").val(data['targetDeviceId']?data['targetDeviceId']:'');
            if(data['alarmType']!=null){
                targetElement.find("select[name='alarmType']").val(data['alarmType']);
            }
            if(data['alarmMessage']!=null){
                targetElement.find("select[name='alarmMessage']").val(data['alarmMessage']);
            }
            targetElement.find("select[name='alarmFileId']").val(data['alarmFileId']?data['alarmFileId']:'');

            switch(data['mode']){
                case 'new':
                    targetElement.find("select[name='targetDeviceId']").prop("disabled",false);
                    targetElement.find(".addBtn").show();
                    targetElement.find(".saveBtn").hide();
                    break;
                default :
                    targetElement.find("select[name='targetDeviceId']").prop("disabled",true);
                    targetElement.find(".saveBtn").show();
                    targetElement.find(".addBtn").hide();
            }
            targetElement.show();
        }
    }

    /*
     ajax error handler
     @author psb
     */
    function critical_errorHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        alertMessage(actionType + 'Failure');
    }

    function cancel(){
        var listForm = $('<FORM>').attr('method','POST').attr('action',urlConfig['listUrl']);
        listForm.appendTo(document.body);
        listForm.submit();
    }

    function alertMessage(type){
        alert(messageConfig[type]);
    }
</script>