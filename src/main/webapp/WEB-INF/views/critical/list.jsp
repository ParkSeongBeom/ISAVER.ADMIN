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
<spring:message code="common.selectbox.notSelect" var="allSelectText"/>
<script type="text/javascript" src="${rootPath}/assets/js/util/page-navigater.js"></script>

<style>
    .cycleOn{
        color: #b42d6e !important;
        font-weight: bold !important;
    }
</style>

<div class="sub_title_area">
    <h3 class="1depth_title"><spring:message code="common.title.critical"/></h3>
    <div class="navigation">
        <span><isaver:menu menuId="${menuId}" /></span>
    </div>
</div>

<section class="container sub_area">
    <article class="table_area">
        <div class="critical-ui">
            <section class="critical-title" id="criticalTitle">
                <h4><spring:message code="critical.title.event"/></h4>
                <h4>
                    <spring:message code="critical.title.critical"/>
                    <button class="ico-plus addBtn" disabled="disabled" onclick="javascript:$(this).toggleClass('on');"></button>
                    <!-- 임계치 추가 시작 -->
                    <div class="zoom-box" id="addCriticalBox">
                        <h4>
                            <span><spring:message code="critical.title.criticalAdd"/></span>
                            <button class="ico-save" onclick="javascript:addCritical();" title="<spring:message code="common.button.save"/>"></button>
                            <button class="ico-close" onclick="javascript:$('.addBtn').trigger('click');"></button>
                        </h4>
                        <p><spring:message code="critical.column.criticalValue"/></p>
                        <input type="text" name="criticalValue" value=""/>
                        <p><spring:message code="critical.column.criticalLevel"/></p>
                        <select name="criticalLevel">
                            <option value="LEV000"><spring:message code="critical.selectbox.cancel"/></option>
                            <c:forEach var="critical" items="${criticalList}">
                                <option value="${critical.codeId}">${critical.codeName}</option>
                            </c:forEach>
                        </select>
                        <p><spring:message code="critical.column.dashboardSoundSetting"/></p>
                        <isaver:fileSelectBox htmlTagName="dashboardFileId" allModel="true" fileType="${alarmFileType}" allText="${allSelectText}"/>
                    </div>
                    <!-- 임계치 추가 끝 -->
                </h4>
                <h4><spring:message code="critical.title.detectDevice"/></h4>
                <h4><spring:message code="critical.title.targetDevice"/></h4>
            </section>

            <section class="critical-content">
                <div class="list-event">
                    <div>
                        <input id="eventId" type="hidden"/>
                        <select id="eventSelectBox">
                            <option value=""><spring:message code="critical.selectbox.selectEvent"/></option>
                            <c:forEach var="event" items="${eventList}">
                                <c:if test="${event.delYn=='N'}">
                                    <option value="${event.eventId}">${event.eventName}(${event.eventId})</option>
                                </c:if>
                            </c:forEach>
                        </select>
                        <button class="btn" onclick="javascript:search();"><spring:message code="common.button.search"/></button>
                    </div>
                    <div class="btn_set">
                        <button class="btn" onclick="javascript:save();"><spring:message code="critical.button.add"/></button>
                    </div>
                </div>
                <ul class="list-criti" id="criticalListDiv"></ul>
            </section>
        </div>
    </article>

    <ul style="display:none;" id="criticalTemplate">
        <!-- 임계치 템플릿 -->
        <li onclick="javascript:deviceClickHandler(this,event);">
            <div>
                <p clickOn="true" name="criticalName"></p>
                <button class="ico-zoom"></button> <!-- 상세보기 버튼 -->
                <button class="ico-minus"></button> <!-- 삭제 버튼 -->
                <!-- 상세보기 시작 -->
                <div class="zoom-box">
                    <p><spring:message code="critical.column.criticalValue"/></p>
                    <input type="text" name="criticalValue" value=""/>
                    <p><spring:message code="critical.column.criticalLevel"/></p>
                    <select name="criticalLevel">
                        <option value="LEV000"><spring:message code="critical.selectbox.cancel"/></option>
                        <c:forEach var="critical" items="${criticalList}">
                            <option value="${critical.codeId}">${critical.codeName}</option>
                        </c:forEach>
                    </select>
                    <p><spring:message code="critical.column.dashboardSoundSetting"/></p>
                    <isaver:fileSelectBox htmlTagName="dashboardFileId" allModel="true" fileType="${alarmFileType}" allText="${allSelectText}"/>
                </div>
                <!-- 상세보기 끝 -->
            </div>

            <!-- 감지장치 템플릿 -->
            <ul class="list-detec">
                <c:forEach var="detect" items="${detectDeviceList}">
                    <li detectDeviceId="${detect.deviceId}" fenceId="${detect.fenceId}" onclick="javascript:deviceClickHandler(this,event);">
                        <div>
                            <div class="btn-check list-check">
                                <input type="checkbox" name="detectDeviceUseYn"/>
                                <label class="ico-check"></label>
                            </div>
                            <input type="hidden" name="fenceId" <c:if test="${detect.fenceId!=null}">value="${detect.fenceId}"</c:if>/>
                            <p clickOn="true" name="detectDeviceName">${detect.deviceName}<c:if test="${detect.fenceName!=null}">-${detect.fenceName}</c:if>(${detect.deviceId})</p>
                            <button class="ico-zoom"></button>
                            <!-- 상세보기 시작 -->
                            <div class="zoom-box">
                                <p><spring:message code="critical.column.deviceConfigDatetime"/></p>
                                <c:forEach begin="0" end="2" varStatus="loop">
                                    <div class="cycle-setting">
                                        <div class="checkbox_set csl_style02">
                                            <input type="checkbox" name="detectConfigUseYn">
                                            <label></label>
                                        </div>
                                        <div>
                                            <input type="number" maxlength="2" value="00" name="startHour" placeholder='<spring:message code="common.column.hour"/>'>
                                            <input type="number" maxlength="2" value="00" name="startMinute" placeholder='<spring:message code="common.column.minute"/>'>
                                            <input type="number" maxlength="2" value="00" name="startSecond" placeholder='<spring:message code="common.column.second"/>'>
                                            ~
                                            <input type="number" maxlength="2" value="00" name="endHour" placeholder='<spring:message code="common.column.hour"/>'>
                                            <input type="number" maxlength="2" value="00" name="endMinute" placeholder='<spring:message code="common.column.minute"/>'>
                                            <input type="number" maxlength="2" value="00" name="endSecond" placeholder='<spring:message code="common.column.second"/>'>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                            <!-- 상세보기 끝 -->
                        </div>

                        <!-- 대상장치 템플릿 -->
                        <ul class="list-objec">
                            <c:forEach var="target" items="${targetDeviceList}">
                                <li targetDeviceId="${target.deviceId}">
                                    <div>
                                        <div class="btn-check list-check">
                                            <input type="checkbox" name="targetDeviceUseYn">
                                            <label class="ico-check"></label>
                                        </div>
                                        <p>${target.deviceName}(${target.deviceId})</p>
                                        <button class="ico-zoom"></button>
                                        <!-- 상세보기 시작 -->
                                        <div class="zoom-box">
                                            <p><spring:message code="critical.column.alarmType"/></p>
                                            <select name="alarmType">
                                                <option value="control"><spring:message code="critical.selectbox.control"/></option>
                                                <option value="file"><spring:message code="critical.selectbox.file"/></option>
                                            </select>
                                            <p><spring:message code="critical.column.alarmMessage"/></p>
                                            <select name="alarmMessage">
                                                <option value="on"><spring:message code="critical.selectbox.on"/></option>
                                                <option value="off"><spring:message code="critical.selectbox.off"/></option>
                                            </select>
                                            <p><spring:message code="critical.column.alarmFile"/></p>
                                            <isaver:fileSelectBox htmlTagName="alarmFileId" allModel="true" fileType="${alarmFileType}" allText="${allSelectText}"/>
                                        </div>
                                        <!-- 상세보기 끝 -->
                                    </div>
                                </li>
                            </c:forEach>
                        </ul>
                    </li>
                </c:forEach>
            </ul>
        </li>
    </ul>
</section>

<script type="text/javascript">
    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');

    var messageConfig = {
        /** 임계치 */
        'requireEvent':'<spring:message code="critical.message.requireEvent"/>'
        ,'saveConfirm':'<spring:message code="critical.message.saveConfirm"/>'
        ,'saveFailure':'<spring:message code="critical.message.saveFailure"/>'
        ,'saveComplete':'<spring:message code="critical.message.saveComplete"/>'
        ,'criticalExist':'<spring:message code="critical.message.criticalExist"/>'
        ,'detectExist':'<spring:message code="critical.message.detectExist"/>'
        ,'requireAlarmFileId':'<spring:message code="critical.message.requireAlarmFileId"/>'
        ,'formatConfigDatetime':'<spring:message code="critical.message.formatConfigDatetime"/>'
        ,'earlyConfigDatetime':'<spring:message code="critical.message.earlyConfigDatetime"/>'
        ,'overlapConfigDatetime':'<spring:message code="critical.message.overlapConfigDatetime"/>'
    };

    var criticalLevelNameList = {
        'LEV000' : '<spring:message code="critical.selectbox.cancel"/>',
        <c:forEach var="criticalLevel" items="${criticalList}" varStatus="status">
            '${criticalLevel.codeId}' : '${criticalLevel.codeName}' ${!status.last?',':''}
        </c:forEach>
    };

    var urlConfig = {
        'listUrl':'${rootPath}/critical/list.json'
        ,'saveUrl':'${rootPath}/critical/save.json'
    };

    $(document).ready(function(){
    });

    function search(){
        var eventId = $("#eventSelectBox").val();

        if(eventId==null || eventId==""){
            alertMessage('requireEvent');
            return false;
        }

        $("#eventId").val(eventId);
        callAjax('list',{'eventId':eventId});
    }

    function save(){
        if(!confirm(messageConfig['saveConfirm'])){
            return false;
        }

        var criticalList = [];
        try{
            // 임계치 목록
            $.each($("#criticalListDiv > li"),function(){
                var criticalId = uuid32();
                var criticalParam = {
                    criticalId:criticalId
                    ,eventId:$("#eventId").val()
                    ,criticalValue:$(this).find("input[name='criticalValue']").val()?eval($(this).find("input[name='criticalValue']").val()):null
                    ,criticalLevel:$(this).find("select[name='criticalLevel'] option:selected").val()
                    ,dashboardFileId:$(this).find("select[name='dashboardFileId'] option:selected").val()
                    ,criticalDetects:[]
                };

                var existCriticalValue = {
                    'flag' : false
                    ,'index' : []
                };

                // 임계치 validate
                for(var i in criticalList){
                    if(criticalList[i]['criticalValue']==criticalParam['criticalValue'] && criticalList[i]['criticalLevel']==criticalParam['criticalLevel']){
                        alertMessage('criticalExist');
                        throw "validateError";
                    }else if(criticalList[i]['criticalValue']==criticalParam['criticalValue']){
                        // 윤대호K 요청으로 스케줄별로 다른 임계치 적용되게 변경
//                        existCriticalValue['flag'] = true;
                        existCriticalValue['index'].push(i);
                    }
                }

                // 감지장치 목록
                $.each($(this).find("li[detectDeviceId]"),function(){
                    var criticalDetectId = uuid32();
                    var criticalDetectParam = {
                        criticalId:criticalId
                        ,criticalDetectId:criticalDetectId
                        ,detectDeviceId:$(this).attr("detectDeviceId")
                        ,fenceId:$(this).find("input[name='fenceId']").val()
                        ,useYn:$(this).find("input[name='detectDeviceUseYn']").is(":checked")?"Y":"N"
                        ,criticalDetectConfigs:[]
                        ,criticalTargets:[]
                    };

                    // 감지장치 validate
                    if(existCriticalValue['flag'] && criticalDetectParam['useYn']=="Y"){
                        for(var i in existCriticalValue['index']){
                            var criticalIndex = existCriticalValue['index'][i];
                            if(criticalList.length>criticalIndex){
                                for(var k in criticalList[criticalIndex]['criticalDetects']){
                                    if(criticalList[criticalIndex]['criticalDetects'][k]['useYn']=='Y' &&
                                       criticalList[criticalIndex]['criticalDetects'][k]['detectDeviceId'] == criticalDetectParam['detectDeviceId'] &&
                                       (criticalDetectParam['fenceId']!=null?(criticalList[criticalIndex]['criticalDetects'][k]['fenceId'] == criticalDetectParam['fenceId']):true)){
                                        alertMessage('detectExist');
                                        throw "validateError";
                                    }
                                }
                            }
                        }
                    }

                    // 감지장치 설정 목록
                    $.each($(this).find(".cycle-setting"),function(){
                        var criticalDetectConfigId = uuid32();
                        var startHour = eval($(this).find("input[name='startHour']").val());
                        if(startHour==null){startHour="00"}else if(startHour>=0 && startHour<10) {startHour = "0" + startHour;}
                        var startMinute = eval($(this).find("input[name='startMinute']").val());
                        if(startMinute==null){startMinute="00"}else if(startMinute>=0 && startMinute<10) {startMinute = "0" + startMinute;}
                        var startSecond = eval($(this).find("input[name='startSecond']").val());
                        if(startSecond==null){startSecond="00"}else if(startSecond>=0 && startSecond<10) {startSecond = "0" + startSecond;}
                        var startDatetime = startHour+":"+startMinute+":"+startSecond;

                        var endHour = eval($(this).find("input[name='endHour']").val());
                        if(endHour==null){endHour="00"}else if(endHour>=0 && endHour<10) {endHour = "0" + endHour;}
                        var endMinute = eval($(this).find("input[name='endMinute']").val());
                        if(endMinute==null){endMinute="00"}else if(endMinute>=0 && endMinute<10) {endMinute = "0" + endMinute;}
                        var endSecond = eval($(this).find("input[name='endSecond']").val());
                        if(endSecond==null){endSecond="00"}else if(endSecond>=0 && endSecond<10) {endSecond = "0" + endSecond;}
                        var endDatetime = endHour+":"+endMinute+":"+endSecond;

                        // 감지장치 설정 시간 validate
                        if(startDatetime>endDatetime){
                            alertMessage('earlyConfigDatetime');
                            throw "validateError";
                        }else if(!startDatetime.isTime(":") || !endDatetime.isTime(":")){
                            alertMessage('formatConfigDatetime');
                            throw "validateError";
                        }

                        var detectConfigUseYn = $(this).find("input[name='detectConfigUseYn']").is(":checked");
                        for(var i in criticalDetectParam['criticalDetectConfigs']){
                            if(detectConfigUseYn && criticalDetectParam['criticalDetectConfigs'][i]['useYn']=="Y" &&
                                    (
                                        (criticalDetectParam['criticalDetectConfigs'][i]['startDatetime'] <= startDatetime && criticalDetectParam['criticalDetectConfigs'][i]['endDatetime'] > startDatetime) ||
                                        (criticalDetectParam['criticalDetectConfigs'][i]['startDatetime'] <= endDatetime && criticalDetectParam['criticalDetectConfigs'][i]['endDatetime'] > endDatetime)
                                    )
                            ){
                                alertMessage('overlapConfigDatetime');
                                throw "validateError";
                            }
                        }

                        criticalDetectParam['criticalDetectConfigs'].push({
                            criticalDetectConfigId:criticalDetectConfigId
                            ,criticalDetectId:criticalDetectId
                            ,startDatetime:startDatetime
                            ,endDatetime:endDatetime
                            ,useYn:detectConfigUseYn?"Y":"N"
                        });
                    });

                    // 대상장치 설정 목록
                    $.each($(this).find("li[targetDeviceId]"),function(){
                        var criticalTargetParam = {
                            criticalDetectId:criticalDetectId
                            ,targetDeviceId:$(this).attr("targetDeviceId")
                            ,alarmType:$(this).find("select[name='alarmType'] option:selected").val()
                            ,alarmMessage:$(this).find("select[name='alarmMessage'] option:selected").val()
                            ,alarmFileId:$(this).find("select[name='alarmFileId'] option:selected").val()
                            ,useYn:$(this).find("input[name='targetDeviceUseYn']").is(":checked")?"Y":"N"
                        };

                        // 대상장치 설정 validate
                        if(criticalTargetParam['alarmType']=='file' && criticalTargetParam['alarmFileId']==''){
                            alertMessage('requireAlarmFileId');
                            throw "validateError";
                        }
                        criticalDetectParam['criticalTargets'].push(criticalTargetParam);
                    });
                    criticalParam['criticalDetects'].push(criticalDetectParam);
                });

                criticalList.push(criticalParam);
            });
        }catch(e){
            if(e!="validateError"){console.error("[save] error",e);}
            return false;
        }

        callAjax('save',{'eventId':$("#eventId").val(),'criticalList':JSON.stringify(criticalList)});
    }

    function deviceClickHandler(_this,event){
        if($(event.target).attr("clickOn")!='true'){
            return false;
        }

        if(!$(_this).hasClass('on')){
            $(_this).parent().find(">li").removeClass('on');
            $(_this).addClass('on');
        }else{
            $(_this).removeClass('on');
        }
        event.stopPropagation();
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
            case 'list':
                $("#criticalListDiv").empty();
                $(".addBtn").prop("disabled",false);
                var criticalList = data['list'];
                for(var index in criticalList){
                    criticalRender(criticalList[index]);
                }
                break;
            case 'save':
                alertMessage(actionType + 'Complete');
                break;
        }
    }

    /*
     ajax error handler
     @author psb
     */
    function critical_errorHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        alertMessage(actionType + 'Failure');
    }

    function addCritical(){
        var parentElement = $("#addCriticalBox");
        var param = {
            'eventId' : $("#eventId").val()
            ,'criticalId' : uuid32()
            ,'criticalLevel' : parentElement.find("select[name='criticalLevel'] option:selected").val()
            ,'criticalValue' : parentElement.find("input[name='criticalValue']").val()
            ,'dashboardFileId' : parentElement.find("select[name='dashboardFileId'] option:selected").val()
        };
        criticalRender(param);
        $('.addBtn').trigger('click');
    }

    function removeCritical(criticalId){
        $("#criticalListDiv > li[criticalId='"+criticalId+"']").remove();
    }

    function criticalRender(critical){
        var criticalTag = $("#criticalTemplate > li").clone();

        if(criticalCss[critical['criticalLevel']]!=null){
            criticalTag.addClass('level-'+criticalCss[critical['criticalLevel']]);
        }else{
            criticalTag.addClass('level-end');
        }
        criticalTag.attr("criticalId",critical['criticalId']);
        criticalTag.find("p[name='criticalName']").text(criticalLevelNameList[critical['criticalLevel']]);
        criticalTag.find("button.ico-zoom").on('click',function(){
            $(this).toggleClass('on');
        });
        criticalTag.find("button.ico-minus").click({criticalId:critical['criticalId']},function(evt){
            removeCritical(evt.data.criticalId);
        });
        criticalTag.find("input[name='criticalValue']").val(critical['criticalValue']);
        criticalTag.find("select[name='criticalLevel']").val(critical['criticalLevel']);
        criticalTag.find("select[name='dashboardFileId']").val(critical['dashboardFileId']);
        $("#criticalListDiv").append(criticalTag);

        // 감지장치
        var detectList = critical['criticalDetects'];
        for(var index in detectList){
            detectRender(detectList[index], criticalTag);
        }
    }

    function detectRender(detect, parentElement){
        var detectTag = null;

        if(detect['fenceId']!=null){
            detectTag = parentElement.find("li[detectDeviceId='"+detect['detectDeviceId']+"'][fenceId='"+detect['fenceId']+"']");
        }else{
            detectTag = parentElement.find("li[detectDeviceId='"+detect['detectDeviceId']+"']");
        }
        // 감지시간 설정 시 구분 가능하게 처리
        detectTag.find("input[name='detectConfigUseYn']").change(function(evt){
            if(detectTag.find("input[name='detectConfigUseYn']").is(":checked")){
                detectTag.find("p[name='detectDeviceName']").addClass("cycleOn");
            }else{
                detectTag.find("p[name='detectDeviceName']").removeClass("cycleOn");
            }
        });

        if(detectTag==null || detectTag.length==0){
            console.log("[detectRender] detect device li tag null", detect);
            return false;
        }
        detectTag.find("input[name='detectDeviceUseYn']").prop("checked",detect['useYn']=='Y');

        // 감지장치 설정
        var detectConfigList = detect['criticalDetectConfigs'];
        for(var index in detectConfigList){
            detectConfigRender(detectConfigList[index], detectTag, index);
        }

        // 대상장치
        var targetList = detect['criticalTargets'];
        for(var index in targetList){
            targetRender(targetList[index], detectTag);
        }
    }

    function detectConfigRender(detectConfig, parentElement, index){
        var detectConfigTag = parentElement.find(".cycle-setting:eq("+index+")");

        if(detectConfigTag==null || detectConfigTag.length==0){
            console.log("[detectConfigRender] detect config tag null");
            return false;
        }
        detectConfigTag.find("input[name='detectConfigUseYn']").prop("checked",detectConfig['useYn']=='Y').trigger("change");
        var startDatetime = detectConfig['startDatetime'].split(":");
        if(startDatetime.length==3){
            detectConfigTag.find("input[name='startHour']").val(startDatetime[0]);
            detectConfigTag.find("input[name='startMinute']").val(startDatetime[1]);
            detectConfigTag.find("input[name='startSecond']").val(startDatetime[2]);
        }
        var endDatetime = detectConfig['endDatetime'].split(":");
        if(endDatetime.length==3){
            detectConfigTag.find("input[name='endHour']").val(endDatetime[0]);
            detectConfigTag.find("input[name='endMinute']").val(endDatetime[1]);
            detectConfigTag.find("input[name='endSecond']").val(endDatetime[2]);
        }
    }

    function targetRender(target,parentElement){
        var targetTag = parentElement.find("li[targetDeviceId='"+target['targetDeviceId']+"']");

        if(targetTag==null || targetTag.length==0){
            console.log("[targetRender] target device li tag null");
            return false;
        }
        targetTag.find("input[name='targetDeviceUseYn']").prop("checked",target['useYn']=='Y');
        targetTag.find("select[name='alarmType']").val(target['alarmType']);
        targetTag.find("select[name='alarmMessage']").val(target['alarmMessage']);
        targetTag.find("select[name='alarmFileId']").val(target['alarmFileId']);
    }

    function alertMessage(type){
        alert(messageConfig[type]);
    }
</script>