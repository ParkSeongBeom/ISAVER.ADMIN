<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<c:set value="H00000" var="menuId"/>
<c:set value="H00000" var="subMenuId"/>
<%--<isaver:pageRoleCheck menuId="${menuId}" />--%>

<!-- section Start -->
<section class="container">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="main_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title">All</h3>
    </article>

    <!-- 2depth 타이틀 영역 End -->
    <article class="dash_contents_area">
        <div>
            <div class="metro_root mr_h70">
                <div class="metro_parent">
                    <div id="workerDiv" title="<spring:message code="dashboard.title.worker"/>">
                        <div class="mp_header">
                            <h2><spring:message code="dashboard.title.worker"/></h2>
                            <div>
                                <button class="alra_btn" href="#" onclick="javascript:alarmShowHide('list','show');" name="worker" style="display: none;">0</button>
                            </div>
                        </div>
                        <div class="mp_contents">
                            <div class="mc_bico type01 worker"></div>
                            <div class="mc_element nano">
                                <div id="eventLogWorkerList" class="mce_btn_area nano-content">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="inoutDiv" title="<spring:message code="dashboard.title.workerInout"/>">
                        <div class="mp_header">
                            <h2><spring:message code="dashboard.title.workerInout"/></h2>
                        </div>
                        <div class="mp_contents">
                            <div class="mc_bico type01 going"></div>
                            <div class="mc_element nano">
                                <div id="eventLogInoutList" class="mce_btn_area nano-content">
                                    <c:choose>
                                    <c:when test="${areas != null and fn:length(areas) > 0}">
                                        <c:forEach var="area" items="${areas}">
                                            <button areaId="${area.areaId}" href="#" onclick="javascript:moveDashBoardDetail('${area.areaId}')">
                                                <span><em>${area.areaName}</em></span>
                                                <span id="nowGap">0</span>
                                            </button>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                    </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="metro_parent">
                    <div id="craneDiv" title="<spring:message code="dashboard.title.crane"/>">
                        <div class="mp_header">
                            <h2><spring:message code="dashboard.title.crane"/></h2>
                            <div>
                                <button class="alra_btn" href="#" onclick="javascript:alarmShowHide('list','show');" name="crane" style="display: none;">0</button>
                            </div>
                        </div>
                        <div class="mp_contents">
                            <div class="mc_bico type01 crane"></div>
                            <div class="mc_element nano">
                                <div id="eventLogCraneList" class="mce_btn_area nano-content">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="gasDiv" title="<spring:message code="dashboard.title.gasState"/>">
                        <div class="mp_header">
                            <h2><spring:message code="dashboard.title.gasState"/></h2>
                            <div>
                                <button class="alra_btn" href="#" onclick="javascript:alarmShowHide('list','show');" name="gas" style="display: none;">0</button>
                            </div>
                        </div>
                        <div class="mp_contents">
                            <div class="mc_bico type01 gas"></div>
                            <div class="mc_element nano">
                                <div id="eventLogGasList" class="mce_btn_area nano-content">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </article>
</section>

<script type="text/javascript">
    var targetMenuId = String('${paramBean.areaId}');
    var subMenuId = String('${subMenuId}');
    /*
     url defind
     @author psb
     */
    var urlConfig = {
        workerUrl  :   "${rootPath}/eventLogWorker/list.json"
        ,craneUrl  :   "${rootPath}/eventLogCrane/list.json"
        ,inoutUrl  :   "${rootPath}/eventLogInout/list.json"
    };

    var criticalLevel = {
        'LEV001' : 'level01'
        ,'LEV002' : 'level02'
        ,'LEV003' : 'level03'
    };

    var messageConfig = {
        workerFailure   :'<spring:message code="dashboard.message.workerFailure"/>'
        , craneFailure  :'<spring:message code="dashboard.message.craneFailure"/>'
        , inoutFailure  :'<spring:message code="dashboard.message.inoutFailure"/>'
    };

    $(document).ready(function(){

        $.each($(".mce_btn_area button span em"),function(){
            if($(this).height()>28){
                $(this).addClass("marqueeEm");
            }
        });

        /* 작업자 */
        dashBoardHelper.addRequestData('worker', urlConfig['workerUrl'], null, dashBoardSuccessHandler, dashBoardFailureHandler, appendEventHandler);
        /* 크레인 */
        dashBoardHelper.addRequestData('crane', urlConfig['craneUrl'], null, dashBoardSuccessHandler, dashBoardFailureHandler, appendEventHandler);
        /* 진출입 */
        dashBoardHelper.addRequestData('inout', urlConfig['inoutUrl'], null, dashBoardSuccessHandler, dashBoardFailureHandler, appendEventHandler);
    });

    /**
     * alarm success handler
     * @author psb
     * @private
     */
    function appendEventHandler(data, messageType){
        if(data['eventId']==null){
            console.log("[dashboard all][appendEventHandler] eventId is null");
            return false;
        }

        switch(findEventIdType(data['eventId'])){
            case 'worker':
                workerRender(data, messageType);
                break;
            case 'crane':
                craneRender(data, messageType);
                break;
            case 'inout':
                break;
            default :
                console.log("[dashboard all][appendEventHandler] This event does not require action");
        }
    }

    /**
     * alarm success handler
     * @author psb
     * @private
     */
    function dashBoardSuccessHandler(data, dataType, actionType){
        switch(actionType){
            case 'worker':
                workerRender(data['eventLogWorkerList'], "refreshView");
                break;
            case 'crane':
                craneRender(data['eventLogCraneList'], "refreshView");
                break;
            case 'inout':
                inoutRender(data);
                break;
        }
    }

    function refreshLevel(actionType, eventCnt){
        var _element = $("#" + actionType + "Div");
        if(_element==null){
            return false;
        }

        for(var key in criticalLevel){
            if(_element.find("."+criticalLevel[key]).length > 0){
                modifyElementClass(_element,criticalLevel[key],'add');
            }else{
                modifyElementClass(_element,criticalLevel[key],'remove');
            }
        }

        if(eventCnt>0){
            _element.find(".alra_btn").text(eventCnt);
            $(".alra_btn[name='"+actionType+"']").show();
        }else{
            $(".alra_btn[name='"+actionType+"']").hide();
        }
    }

    /**
     * 작업자 상태
     */
    function workerRender(data, messageType){
        if(data==null){
            return false;
        }

        var workerEventCnt = 0;
        var _config = {
            'refreshFlag' : true // 초기화여부
            ,'addFlag' : true
        };

        switch (messageType) {
            case "addAlarmEvent": // 알림이벤트 등록
                _config['refreshFlag'] = false;
                break;
            case "removeAlarmEvent": // 알림이벤트 해제
                _config['refreshFlag'] = false;
                _config['addFlag'] = false;
                break;
            case "refreshView" : // 초기로딩 및 리스트 교체
                _config['refreshFlag'] = true;
                break;
        }

        if(_config['refreshFlag']){
            $("#workerDiv").attr("class","");
            $("#eventLogWorkerList").find("button").attr("class","");
            $("#eventLogWorkerList").find("button span[id='eventCnt']").remove()
        }

        for(var index in data){
            var worker = data[index];
            var workerInfo = worker['infos'];
            var buttonTag = $("#eventLogWorkerList button[areaId='"+worker['areaId']+"']");
            if(buttonTag.find("#eventCnt").length==0 && _config['addFlag']){
                buttonTag.append(
                    $("<span/>", {id:"eventCnt"}).text("0")
                )
            }

            var eventCntTag = buttonTag.find("#eventCnt");
            var eventCnt = Number(eventCntTag.text());
            if(_config['addFlag']){
                eventCnt++;
                workerEventCnt++;
            }else{
                eventCnt--;
                workerEventCnt--;
            }
            eventCntTag.text(eventCnt);

            for(var i in workerInfo){
                var _info = workerInfo[i];
                if(_info['key']=='criticalLevel'){
                    modifyElementClass(buttonTag,criticalLevel[_info['value']],_config['addFlag'] ? 'add' : 'remove');
                }
            }
            if(eventCnt<0 && eventCntTag.length>0){
                buttonTag.find("#eventCnt").remove();
            }
        }
        refreshLevel('worker', workerEventCnt);
    }

    /**
     * 크레인 상태
     */
    function craneRender(data, messageType){
        if(data==null){
            return false;
        }

        var craneEventCnt = 0;
        var _config = {
            'refreshFlag' : true // 초기화여부
            ,'addFlag' : true
        };

        switch (messageType) {
            case "addAlarmEvent": // 알림이벤트 등록
                _config['refreshFlag'] = false;
                break;
            case "removeAlarmEvent": // 알림이벤트 해제
                _config['refreshFlag'] = false;
                _config['addFlag'] = false;
                break;
            case "refreshView" : // 초기로딩 및 리스트 교체
                _config['refreshFlag'] = true;
                break;
        }

        if(_config['refreshFlag']){
            $("#craneDiv").attr("class","");
            $("#eventLogCraneList").find("button").attr("class","");
            $("#eventLogCraneList").find("button span[id='eventCnt']").remove()
        }

        for(var index in data){
            var crane = data[index];
            var craneInfo = crane['infos'];
            var buttonTag = $("#eventLogCraneList button[areaId='"+crane['areaId']+"']");
            if(buttonTag.find("#eventCnt").length==0 && _config['addFlag']){
                buttonTag.append(
                        $("<span/>", {id:"eventCnt"}).text("0")
                )
            }

            var eventCntTag = buttonTag.find("#eventCnt");
            var eventCnt = Number(eventCntTag.text());
            if(_config['addFlag']){
                eventCnt++;
                craneEventCnt++;
            }else{
                eventCnt--;
                craneEventCnt--;
            }
            eventCntTag.text(eventCnt);

            for(var i in craneInfo){
                var _info = craneInfo[i];
                if(_info['key']=='criticalLevel'){
                    modifyElementClass(buttonTag,criticalLevel[_info['value']],_config['addFlag'] ? 'add' : 'remove');
                }
            }
            if(eventCnt<0 && eventCntTag.length>0){
                buttonTag.find("#eventCnt").remove();
            }
        }
        refreshLevel('crane', craneEventCnt);
    }

    /**
     * 진출입 관련
     */
    function inoutRender(data){
        var inoutList = data['eventLogInoutList'];
        if(inoutList!=null){
            var inoutEventCnt = 0;
            for(var index =0; index < inoutList.length; index++){
                var inout = inoutList[index];

                var buttonTag = $("#eventLogInoutList button[areaId='"+inout['areaId']+"']");
                var nowGap = inout['nowInCnt'] - inout['nowOutCnt'];
                var beforeGap = inout['beforeInCnt'] - inout['beforeOutCnt'];

                if(buttonTag.find("#nowGap").text() != String(nowGap)){
                    buttonTag.find("#nowGap").text(String(nowGap));
                }

                if(beforeGap>0){
                    if(buttonTag.find("#beforeGap").length>0){
                        if(buttonTag.find("#beforeGap").text() != "/"+String(beforeGap)){
                            buttonTag.find("#beforeGap").text(beforeGap);
                        }
                    }else{
                        buttonTag.find("#nowGap").append(
                            $("<em/>", {id:"beforeGap"}).text("/"+String(beforeGap))
                        )
                    }

                    modifyElementClass(buttonTag,'level02','add');
                    inoutEventCnt++;
                }else{
                    modifyElementClass(buttonTag,'level02','remove');

                    if(buttonTag.find("#beforeGap").length>0){
                        buttonTag.find("#beforeGap").remove();
                    }
                }
            }

            if(inoutEventCnt>0){
                modifyElementClass($("#inoutDiv"),'level02','add');
            }else{
                modifyElementClass($("#inoutDiv"),'level02','remove');
            }
        }
    }

    /*
     ajax error handler
     @author psb
     */
    function dashBoardFailureHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        console.error(messageConfig[actionType + 'Failure']);
//        alertMessage(actionType + 'Failure');
    }

    /*
     alert message method
     @author psb
     */
    function alertMessage(type){
        alert(messageConfig[type]);
    }
</script>