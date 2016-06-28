<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<c:set value="H00000" var="subMenuId"/>

<link rel="stylesheet" type="text/css" href="${rootPath}/assets/library/chartist/chartist.min.css" >
<script type="text/javascript" src="${rootPath}/assets/library/chartist/chartist.min.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/jquery.marquee.js"></script>
<!-- section Start -->
<section class="container">
    <!-- 확대보기 레이어 팝업 -->
    <aside class="layer_popup detail_popup">
        <section class="layer_wrap i_type05">
            <article class="layer_area"></article>
        </section>
        <div class="layer_popupbg ipop_close" href="#" onclick="javascript:closeDetailPopup();"></div>
    </aside>

    <!-- 진출입 셋팅 레이어 팝업 -->
    <aside class="layer_popup sett_popup">
        <section class="layer_wrap i_type06">
            <article class="layer_area">
                <div class="mp_header">
                    <h2><spring:message code="dashboard.title.inoutSetting"/></h2>
                    <div><button class="db_btn zoomclose_btn ipop_close" href="#" onclick="javascript:closeDetailPopup();"></button></div>
                </div>
                <div class="mp_contents vh_mode">
                    <p class="mpct">${area.areaName}</p>
                    <div class="time_select_contents">
                        <input type="number" id="inoutHour" min="0" max="23" maxlength="2" value="0" onkeypress="onlyNumberPress(event);" oninput="inputNumberCheck(this)"/>
                        <input type="number" id="inoutMinute" min="0" max="59" maxlength="2" value="0" onkeypress="onlyNumberPress(event);" oninput="inputNumberCheck(this)"/>
                        <input type="number" id="inoutSecond" min="0" max="59" maxlength="2" value="0" onkeypress="onlyNumberPress(event);" oninput="inputNumberCheck(this)"/>
                        <button href="#" onclick="javascript:appendInoutConfiguration();"></button>
                    </div>
                    <div class="mc_element nano">
                        <ul class="nano-content time_select_list">
                            <li class="fixedTime firstTime" time="000000"><span>00:00:00</span></li> <!-- 시작 시간 -->
                            <li class="fixedTime lastTime" time="235959"><span>23:59:59</span></li> <!-- 종료 시간 -->
                        </ul>
                    </div>
                    <div class="lmc_btn_area mc_tline">
                        <button class="btn btype01 bstyle07" href="#" onclick="javascript:saveInoutConfiguration();"><spring:message code="common.button.save"/></button>
                    </div>
                </div>
            </article>
        </section>
        <div class="layer_popupbg ipop_close" href="#" onclick="javascript:closeDetailPopup();"></div>
    </aside>

    <!-- 2depth 타이틀 영역 -->
    <article class="main_title_area">
        <!-- 2depth 타이틀 -->
        <h3 class="1depth_title">${area.areaName}</h3>
        <!-- 마키 영역 -->
        <%--<div id="marqueeList" class="marquee"></div>--%>
        <div class="marquee">
            <marquee DIRECTION="LEFT" id="marqueeList" onmouseover="this.stop();" onmouseout="this.start();" scrollamount="5"></marquee>
        </div>
    </article>

    <article class="dash_contents_area">
        <div>
            <div class="metro_root mr_h70">
                <div class="metro_parent v_mode">
                    <div id="workerDiv" title="<spring:message code="dashboard.title.worker"/>">
                        <div class="mp_header">
                            <h2><spring:message code="dashboard.title.worker"/></h2>
                            <div>
                                <button class="db_btn alra_btn workerAlramCnt" href="#" onclick="javascript:alramShowHide('list','show');">0</button>
                                <button class="db_btn zoom_btn" href="#" onclick="javascript:openDetailPopup('worker');"></button>
                            </div>
                        </div>
                        <div class="mp_contents vh_mode">
                            <div class="mc_element_set nano">
                                <div class="workerContens nano-content">
                                    <c:choose>
                                        <c:when test="${workerEvents != null and fn:length(workerEvents) > 0}">
                                            <c:forEach var="workerEvent" items="${workerEvents}">
                                                <div eventId="${workerEvent.eventId}" class="mc_element">
                                                    <div class="mc_bico type02 worker"></div>
                                                    <div class="mc_box">
                                                        <p>${workerEvent.eventName}</p>
                                                        <p class="eventCnt">0</p>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="mc_element mc_tline nano">
                                <ul class="workerList mc_list nano-content"></ul>
                            </div>
                        </div>
                    </div>
                    <div id="craneDiv" title="<spring:message code="dashboard.title.crane"/>">
                        <div class="mp_header">
                            <h2><spring:message code="dashboard.title.crane"/></h2>
                            <div>
                                <button class="db_btn alra_btn craneAlramCnt" href="#" onclick="javascript:alramShowHide('list','show');">0</button>
                                <button class="db_btn zoom_btn" href="#" onclick="javascript:openDetailPopup('crane');"></button>
                            </div>
                        </div>
                        <div class="mp_contents vh_mode">
                            <div class="mc_element_set nano">
                                <div class="craneContens nano-content">
                                    <c:choose>
                                        <c:when test="${craneEvents != null and fn:length(craneEvents) > 0}">
                                            <c:forEach var="craneEvent" items="${craneEvents}">
                                                <div eventId="${craneEvent.eventId}" class="mc_element">
                                                    <div class="mc_bico type02 crane"></div>
                                                    <div class="mc_box">
                                                        <p>${craneEvent.eventName}</p>
                                                        <p class="eventCnt">0</p>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="mc_element mc_tline nano">
                                <ul class="craneList mc_list nano-content"></ul>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="metro_parent">
                    <div id="inoutDiv" title="<spring:message code="dashboard.title.inout"/>">
                        <div class="mp_header">
                            <h2><spring:message code="dashboard.title.inout"/></h2>
                            <div>
                                <button class="db_btn sett_btn" href="#" onclick="javascript:openInoutSettingPopup();"></button>
                            </div>
                        </div>
                        <div class="mp_contents vh_mode">
                            <div class="personnel">
                                <div id="nowInout" class="now">
                                    <p id="nowInoutDatetime">00:00:00</p>
                                    <span id="nowInoutGap">0</span>
                                    <div id="nowInCnt">0</div>
                                    <div id="nowOutCnt">0</div>
                                </div>
                                <div id="beforeInout" class="past">
                                    <p id="beforeInoutDatetime">00:00:00 ~ 23:59:59</p>
                                    <span id="beforeInoutGap">0</span>
                                    <div id="beforeInCnt">0</div>
                                    <div id="beforeOutCnt">0</div>
                                </div>
                            </div>

                            <div class="ct-chart"  id="chart1">
                                <div class="mp_header ct-name">
                                    <div>
                                        <span class="ch_name co_gren"><spring:message code="dashboard.column.workerIn"/></span>
                                        <span class="ch_name co_purp"><spring:message code="dashboard.column.workerOut"/></span>
                                        <select name="type" id="chartRefreshTime1">
                                            <option value="30">30 min</option>
                                            <option value="60">60 min</option>
                                            <option value="90">90 min</option>
                                            <option value="120">120 min</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="metro_root mr_h30">
                <div class="metro_parent v_mode">
                    <div id="gasDiv" title="<spring:message code="dashboard.title.gas"/>">
                        <div class="mp_header">
                            <h2><spring:message code="dashboard.title.gas"/></h2>
                            <div>
                                <button class="db_btn alra_btn gasAlramCnt" href="#" onclick="javascript:alramShowHide('list','show');">0</button>
                                <button class="db_btn zoom_btn" href="#" onclick="javascript:openDetailPopup('gas');"></button>
                            </div>
                        </div>
                        <div class="mp_contents">
                            <div class="mc_bico type03 gas_level02">
                                <p>O2 22% / CO2 21ppm / H2S 3ppm</p>
                            </div>
                            <div class="mc_element nano">
                                <ul class="mc_list nano-content" tabindex="0" style="right: -8px;">
                                    <li>
                                        <span>경고</span>
                                        <span>산소 부족 탐지</span>
                                        <span>23:00:20</span>
                                    </li>
                                    <li>
                                        <span>경고</span>
                                        <span>이산화탄소 과다 탐지</span>
                                        <span>23:00:15</span>
                                    </li>
                                    <li>
                                        <span>경고</span>
                                        <span>산소 부족 탐지</span>
                                        <span>23:00:13</span>
                                    </li>
                                    <li>
                                        <span>경고</span>
                                        <span>황화수소 과다 탐지</span>
                                        <span>23:00:11</span>
                                    </li>
                                    <li>
                                        <span>경고</span>
                                        <span>산소 부족 탐지</span>
                                        <span>22:59:23</span>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div title="<spring:message code="dashboard.title.issue"/>">
                        <div class="mp_header">
                            <h2><spring:message code="dashboard.title.issue"/></h2>
                            <div>
                                <span class="ch_name co_gren"><spring:message code="dashboard.column.worker"/></span>
                                <span class="ch_name co_purp"><spring:message code="dashboard.column.crane"/></span>
                                <span class="ch_name co_yell"><spring:message code="dashboard.column.gas"/></span>
                                <select name="type" id="chartRefreshTime2">
                                    <option value="30">30 min</option>
                                    <option value="60">60 min</option>
                                    <option value="90">90 min</option>
                                    <option value="120">120 min</option>
                                </select>
                            </div>
                        </div>
                        <div class="mp_contents" id="chart2"></div>
                    </div>
                </div>
            </div>
        </div>
    </article>
</section>

<script type="text/javascript">
    var targetMenuId = String('${paramBean.areaId}');
    var subMenuId = String('${subMenuId}');
    var areaId = String('${area.areaId}');

    /*
     url defind
     @author psb
     */
    var urlConfig = {
        workerUrl : "${rootPath}/eventLogWorker/detail.json"
        ,craneUrl : "${rootPath}/eventLogCrane/detail.json"
        ,inoutUrl : "${rootPath}/eventLogInout/detail.json"
        ,chartInoutUrl : "${rootPath}/eventLogChart/detail.json"
        ,chartStatusUrl : "${rootPath}/eventLogChart/detail.json"
        ,inoutConfigurationListUrl : "${rootPath}/inoutConfiguration/list.json"
        ,saveInoutConfigurationUrl : "${rootPath}/inoutConfiguration/save.json"
    };

    var messageConfig = {
        detection   : '<spring:message code="dashboard.column.detection"/>'
        , cancellation : '<spring:message code="dashboard.column.cancellation"/>'
        , workerFailure : '<spring:message code="dashboard.message.workerFailure"/>'
        , craneFailure : '<spring:message code="dashboard.message.craneFailure"/>'
        , inoutFailure : '<spring:message code="dashboard.message.inoutFailure"/>'
        , chartInoutFailure : '<spring:message code="dashboard.message.chartFailure"/>'
        , chartStatusFailure : '<spring:message code="dashboard.message.chartFailure"/>'
        , inoutConfigHourFailure : '<spring:message code="dashboard.message.inoutConfigHourFailure"/>'
        , inoutConfigMinuteFailure : '<spring:message code="dashboard.message.inoutConfigMinuteFailure"/>'
        , inoutConfigSecondFailure : '<spring:message code="dashboard.message.inoutConfigSecondFailure"/>'
        , inoutConfigDuplication : '<spring:message code="dashboard.message.inoutConfigDuplication"/>'
        , inoutConfigEmpty : '<spring:message code="dashboard.message.inoutConfigEmpty"/>'
        , saveInoutConfigurationComplete : '<spring:message code="dashboard.message.saveInoutConfigurationComplete"/>'
    };

    $(document).ready(function(){
        /* 작업자 */
        dashBoardHelper.addRequestData('worker', urlConfig['workerUrl'], {areaId:areaId}, dashBoardSuccessHandler, dashBoardFailureHandler);
        /* 크래인 */
        dashBoardHelper.addRequestData('crane', urlConfig['craneUrl'], {areaId:areaId}, dashBoardSuccessHandler, dashBoardFailureHandler);
        /* 진출입 */
        dashBoardHelper.addRequestData('inout', urlConfig['inoutUrl'], {areaId:areaId}, dashBoardSuccessHandler, dashBoardFailureHandler);
        /* 진출입 차트 */
        dashBoardHelper.addRequestData('chartInout', urlConfig['chartInoutUrl'], {'requestType' : 0, 'areaId' : areaId, pageIndex : 10, minutesCount : $("select[id=chartRefreshTime1]").val()}, dashBoardSuccessHandler, dashBoardFailureHandler);
        /* 상태 차트 */
        dashBoardHelper.addRequestData('chartStatus', urlConfig['chartStatusUrl'], {'requestType' : 1, 'areaId' : areaId, pageIndex : 10, minutesCount : $("select[id=chartRefreshTime2]").val()}, dashBoardSuccessHandler, dashBoardFailureHandler);
    });

    /*
     open detail popup
     @author psb
     */
    function openDetailPopup(type){
        var targetTag = $("#"+type+"Div");

        if(targetTag==null){
            console.error("[openDetailPopup] error - type fail");
            return false;
        }

        var headerTag = targetTag.find(".mp_header").clone();
        headerTag.find(".zoom_btn").removeClass("zoom_btn").addClass("zoomclose_btn ipop_close").attr("onclick","javascript:closeDetailPopup();");

        var contentsTag = targetTag.find(".mp_contents").clone();
        contentsTag.find(".mc_element_set").css("height","inherit");
        modifyElementClass(contentsTag,'vh_mode','remove');
        modifyElementClass(contentsTag.find(".mc_element"),'mc_tline','remove');

        $(".detail_popup .layer_area").attr("type",type).append(headerTag).append(contentsTag);
        $(".detail_popup").find(".nano").nanoScroller();
        $(".detail_popup").show();
    }

    /*
     close detail popup
     @author psb
     */
    function closeDetailPopup(){
        $(".layer_popup").hide();
        $(".time_select_list li:not('.fixedTime')").remove();
        $(".detail_popup .layer_area").attr("type","").empty();
    }

    /*
     open setting popup
     @author psb
     */
    function openInoutSettingPopup(){
        callAjax('inoutConfigurationList', {areaId : areaId});
    }

    /*
     append inout setting
     @author psb
     */
    function appendInoutConfiguration(_hour, _minute, _second){
        var hour = _hour!=null?_hour:$("#inoutHour").val();
        hour = Number(hour)<10?"0"+Number(hour):hour;
        var minute = _minute!=null?_minute:$("#inoutMinute").val();
        minute = Number(minute)<10?"0"+Number(minute):minute;
        var second = _second!=null?_second:$("#inoutSecond").val();
        second = Number(second)<10?"0"+Number(second):second;
        var fullDate = hour+minute+second;

        if(Number(hour)>23){
            alertMessage('inoutConfigHourFailure');
            $("#inoutHour").focus();
            return false;
        }else if(Number(minute)>59){
            alertMessage('inoutConfigMinuteFailure');
            $("#inoutMinute").focus();
            return false;
        }else if(Number(second)>59){
            alertMessage('inoutConfigSecondFailure');
            $("#inoutSecond").focus();
            return false;
        }

        if($(".time_select_list li[time='"+fullDate+"']").length>0){
            alertMessage('inoutConfigDuplication');
            return false;
        }

        var inoutSettingTag = templateHelper.getTemplate("inoutSetting");
        inoutSettingTag.attr("time",fullDate);
        inoutSettingTag.find("span").text(hour + ":" + minute + ":" + second);
        inoutSettingTag.find("button").on("click",function(){
           $(this).parent().remove();
        });

        var beforeTag;
        $.each($(".time_select_list li"),function(){
            if(Number($(this).attr("time")) < Number(fullDate)){
                beforeTag = $(this);
            }else{
                beforeTag.after(inoutSettingTag);
                return false;
            }
        });
    }

    /*
     save setting popup
     @author psb
     */
    function saveInoutConfiguration(){
//        if($(".time_select_list li:not('.fixedTime')").length==0){
//            alertMessage('inoutConfigEmpty');
//            return false;
//        }

        var param = {
            'areaId' : areaId
            ,'inoutDatetimes' : ""
        };

        var beforeTag = null;
        $.each($(".time_select_list li"),function(){
            if(beforeTag!=null){
                var inoutStarttime = beforeTag.find("span").text();
                var inoutEndtime = $(this).find("span").text();

                if(!$(this).hasClass("lastTime")){
                    var inoutEndtimeArray = inoutEndtime.split(":");
                    var dateTime = new Date();
                    dateTime.setHours(Number(inoutEndtimeArray[0]));
                    dateTime.setMinutes(Number(inoutEndtimeArray[1]));
                    dateTime.setSeconds(Number(inoutEndtimeArray[2])-1);
                    inoutEndtime = dateTime.format("HH:mm:ss");
                }

                param['inoutDatetimes'] += inoutStarttime + "|" + inoutEndtime + ",";
            }
            beforeTag = $(this);
        });

        param['inoutDatetimes'] = param['inoutDatetimes'].slice(0,-1);
        callAjax('saveInoutConfiguration',param);
    }

    /*
     ajax call
     @author psb
     */
    function callAjax(actionType, data){
        sendAjaxPostRequest(urlConfig[actionType + 'Url'],data,dashBoardSuccessHandler,dashBoardFailureHandler,actionType);
    }

    /**
     * alram success handler
     * @author psb
     * @private
     */
    function dashBoardSuccessHandler(data, dataType, actionType){
        switch(actionType){
            case 'worker':
                workerRender(data);
                break;
            case 'crane':
                craneRender(data);
                break;
            case 'inout':
                inoutRender(data);
                break;
            case 'chartInout':
            case 'chartStatus':
                chartRender(data);
                dashBoardHelper.saveRequestData('chartInout', {'requestType' : 0, 'areaId' : areaId, pageIndex : 10, minutesCount : $("select[id=chartRefreshTime1]").val()});
                dashBoardHelper.saveRequestData('chartStatus', {'requestType' : 1, 'areaId' : areaId, pageIndex : 10, minutesCount : $("select[id=chartRefreshTime2]").val()});
                break;
            case 'inoutConfigurationList':
                inoutConfigurationRender(data);
                break;
            case 'saveInoutConfiguration':
                alertMessage(actionType + 'Complete');
                break;
        }
    }

    /**
     * 작업자 상태
     * @author psb
     */
    function workerRender(data){
        var countList = data['eventLogWorkerCountList'];

        if(countList!=null){
            var workerEventCnt = 0;
            for(var index in countList){
                var worker = countList[index];
                var divTag = $(".workerContens").find("div[eventId='"+worker['eventId']+"']");

                workerEventCnt += Number(worker['eventCnt']);
                if(Number(worker['eventCnt'])>0){
                    modifyElementClass(divTag.find(".worker"),'level03','add');
                }else{
                    modifyElementClass(divTag.find(".worker"),'level03','remove');
                }

                if(divTag!=null && divTag.find(".eventCnt").text() != String(worker['eventCnt'])){
                    divTag.find(".eventCnt").text(Number(worker['eventCnt']));
                }
            }

            if($(".workerAlramCnt").text() != String(workerEventCnt)){
                $(".workerAlramCnt").text(workerEventCnt);
            }

            if(workerEventCnt>0){
                modifyElementClass($(".detail_popup .layer_area[type='worker']"),'level03','add');
                modifyElementClass($("#workerDiv"),'level03','add');
            }else{
                modifyElementClass($(".detail_popup .layer_area[type='worker']"),'level03','remove');
                modifyElementClass($("#workerDiv"),'level03','remove');
            }
        }

        var workerList = data['eventLogWorkerList'];
        if(workerList!=null){
            for(var i=workerList.length-1; i >= 0; i--){
                var worker = workerList[i];
                var cancelType = worker['eventCancelUserId']==null?"N":"Y";

                if($(".workerList li[eventLogId='"+worker['eventLogId']+"'][cancelType='"+cancelType+"']").length==0){
                    var eventListTag = templateHelper.getTemplate("eventList");
                    eventListTag.attr("eventLogId",worker['eventLogId']).attr("cancelType",cancelType).find("#eventName").text(worker['eventName']);
                    if(cancelType=="N"){ // 감지
                        modifyElementClass(eventListTag,'level03','add');
                        eventListTag.find("#status").text(messageConfig['detection']);
                        eventListTag.find("#eventDatetime").text(new Date(worker['eventDatetime']).format("HH:mm:ss"));
                    }else{ // 해제
                        eventListTag.find("#status").text(messageConfig['cancellation']);
                        eventListTag.find("#eventDatetime").text(new Date(worker['eventCancelDatetime']).format("HH:mm:ss"));
                    }
                    $(".workerList").prepend(eventListTag);
                }
            }

            if(workerList.length>0){
                dashBoardHelper.saveRequestData('worker',{areaId:areaId, datetime:new Date(workerList[0]['eventDatetime']).format("yyyy-MM-dd HH:mm:ss")});
            }

            $.each($(".workerList"),function(){
                $(this).children(":gt(49)").remove();
            });

            $("#workerDiv.nano").nanoScroller();
        }
    }

    /**
     * 크래인 상태
     * @author psb
     */
    function craneRender(data){
        var countList = data['eventLogCraneCountList'];

        if(countList!=null){
            var craneEventCnt = 0;
            for(var index in countList){
                var crane = countList[index];
                var divTag = $(".craneContens").find("div[eventId='"+crane['eventId']+"']");

                craneEventCnt += Number(crane['eventCnt']);
                if(Number(crane['eventCnt'])>0){
                    modifyElementClass(divTag.find(".crane"),'level03','add');
                }else{
                    modifyElementClass(divTag.find(".crane"),'level03','remove');
                }

                if(divTag!=null && divTag.find(".eventCnt").text() != String(crane['eventCnt'])){
                    divTag.find(".eventCnt").text(Number(crane['eventCnt']));
                }
            }

            if($(".craneAlramCnt").text() != String(craneEventCnt)){
                $(".craneAlramCnt").text(craneEventCnt);
            }

            if(craneEventCnt>0){
                modifyElementClass($(".detail_popup .layer_area[type='crane']"),'level03','add');
                modifyElementClass($("#craneDiv"),'level03','add');
            }else{
                modifyElementClass($(".detail_popup .layer_area[type='crane']"),'level03','remove');
                modifyElementClass($("#craneDiv"),'level03','remove');
            }
        }

        var craneList = data['eventLogCraneList'];
        if(craneList!=null){
            for(var i=craneList.length-1; i >= 0; i--){
                var crane = craneList[i];
                var cancelType = crane['eventCancelUserId']==null?"N":"Y";

                if($(".craneList li[eventLogId='"+crane['eventLogId']+"'][cancelType='"+cancelType+"']").length==0){
                    var eventListTag = templateHelper.getTemplate("eventList");
                    eventListTag.attr("eventLogId",crane['eventLogId']).attr("cancelType",cancelType).find("#eventName").text(crane['eventName']);
                    if(cancelType=="N"){ // 감지
                        modifyElementClass(eventListTag,'level03','add');
                        eventListTag.find("#status").text(messageConfig['detection']);
                        eventListTag.find("#eventDatetime").text(new Date(crane['eventDatetime']).format("HH:mm:ss"));
                    }else{ // 해제
                        eventListTag.find("#status").text(messageConfig['cancellation']);
                        eventListTag.find("#eventDatetime").text(new Date(crane['eventCancelDatetime']).format("HH:mm:ss"));
                    }
                    $(".craneList").prepend(eventListTag);
                }
            }

            if(craneList.length>0){
                dashBoardHelper.saveRequestData('crane',{areaId:areaId, datetime:new Date(craneList[0]['eventDatetime']).format("yyyy-MM-dd HH:mm:ss")});
            }

            $.each($(".craneList"),function(){
                $(this).children(":gt(49)").remove();
            });

            $("#craneDiv .nano").nanoScroller();
        }
    }

    /**
     * 진출입
     * @author psb
     */
    function inoutRender(data){
        var inout = data['eventLogInout'];
        var paramBean = data['paramBean'];
        var nowGap = inout['nowInCnt'] - inout['nowOutCnt'];
        var beforeGap = inout['beforeInCnt'] - inout['beforeOutCnt'];

//        $("#nowInoutDatetime").text(new Date(paramBean['nowInoutStarttime']).format("HH:mm:ss") + " ~ " + new Date(paramBean['nowInoutEndtime']).format("HH:mm:ss"));
        $("#nowInoutDatetime").text(new Date(paramBean['nowInoutStarttime']).format("HH:mm:ss"));
        $("#nowInoutGap").text(Number(nowGap));
        $("#nowInCnt").text(Number(inout['nowInCnt']));
        $("#nowOutCnt").text(Number(inout['nowOutCnt']));

        $("#beforeInoutDatetime").text(new Date(paramBean['beforeInoutStarttime']).format("HH:mm:ss") + " ~ " + new Date(paramBean['beforeInoutEndtime']).format("HH:mm:ss"));
        $("#beforeInoutGap").text(Number(beforeGap));
        $("#beforeInCnt").text(Number(inout['beforeInCnt']));
        $("#beforeOutCnt").text(Number(inout['beforeOutCnt']));
    }

    /**
     * 진출입 설정
     * @author psb
     */
    function inoutConfigurationRender(data){
        var inoutConfigurationList = data['inoutConfigurationList'];

        if(inoutConfigurationList!=null && inoutConfigurationList.length>0){
            for(var index in inoutConfigurationList){
                var inoutConfiguration = inoutConfigurationList[index];
                var inoutStarttime = inoutConfiguration['inoutStarttime'].split(":");
                if(!(inoutStarttime[0]=="00" && inoutStarttime[1]=="00" && inoutStarttime[2]=="00")){
                    appendInoutConfiguration(inoutStarttime[0], inoutStarttime[1], inoutStarttime[2]);
                }
            }
        }
        $(".sett_popup").show();
    }

    /**
     * 차트 가공 [진출입 / 상태 ]
     * @author dhj
     */
    function chartRender(data) {
        /* 작업자 상태 */
        if (data['eventLogWorkerChart'] != null) {
            var eventLogWorkerChart = data['eventLogWorkerChart'];
            var chartList = [];
            var eventDateList = [];

            for (var i =0;i<eventLogWorkerChart.length;i++) {
                var item = eventLogWorkerChart[i];
                var eventDate  = new Date();
                eventDate.setTime(item['eventDatetime']);

                chartList.push(item['eventCnt']);
                eventDateList.push(eventDate.format("HH:mm"));
            }
            chartList.reverse();
            eventDateList.reverse();
            mychart2.data.series[0] = chartList;
            mychart2.data.labels = eventDateList;
        }

        /* 크레인 용 */
        if (data['eventLogCraneChart'] != null) {
            var eventLogCraneChart = data['eventLogCraneChart'];
            var chartList = [];

            for (var i =0;i<eventLogCraneChart.length;i++) {
                var item = eventLogCraneChart[i];
                chartList.push(item['eventCnt']);
            }
            chartList.reverse();
            mychart2.data.series[1] = chartList;
        }

        /* 진출입용 */
        if (data['eventLogInoutChart'] != null) {
            var eventLogInoutChart = data['eventLogInoutChart'];
            var chartList1 = [];
            var chartList2 = [];
            var eventDateList = [];

            for (var i =0;i<eventLogInoutChart.length;i++) {
                var item = eventLogInoutChart[i];
                var eventDate  = new Date();
                eventDate.setTime(item['eventDatetime']);
                chartList1.push(item['inCount']);
                chartList2.push(item['outCount']);
                eventDateList.push(eventDate.format("HH:mm"));
            }

            chartList1.reverse();
            chartList2.reverse();
            eventDateList.reverse();

            mychart1.data.series[0] = chartList1;
            mychart1.data.series[1] = chartList2;
            mychart1.data.labels = eventDateList;
        }

        if (mychart1 != undefined) {
            mychart1.update();
        }

        if (mychart2 != undefined) {
            mychart2.update();
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

    /* 진출입용 차트 */
    var mychart1 = new Chartist.Line('#chart1', {
        labels: [],
        series: [ [], [] ]
    }, {
        low: 0,
        showArea: true,
        fullWidth: false,
        axisY: {
            onlyInteger: true,
            offset: 20
        },
        lineSmooth: Chartist.Interpolation.simple({
            divisor: 100
        })
    });

    mychart1.on('draw', function(data) {
        if(data.type === 'slice') {
            if (data.index == 0) {
                data.element.attr({
                    'style': 'stroke: rgba(193, 0, 104, 1)'
                });
                data.element.animate ({
                    'stroke-dashoffset': {
                        begin: '1s',
                        dur: '21s',
                        from: '0',
                        to: '600',
                        easing: 'easeOutQuart',
                        d:"part1"
                    },
                    'stroke-dasharray': {
                        from: '0',
                        to: '1000'
                    }
                }, false);
            } else {
                data.element.attr({
                    'style': 'stroke: rgba(102, 102, 102, 1)'
                });
                data.element.animate ({
                    'stroke-dashoffset': {
                        begin: "part1.end",
                        dur: 1000,
                        from: '0 250 150',
                        to: '360 250 150',
                        easing: 'easeOutQuart'
                    }
                });
            }
        }
    });

    /* 알림 상태용 차트 */
    var mychart2 = new Chartist.Line('#chart2', {
        labels: [],
        series: [ [], [] ]
    }, {
        low: 0,
        showArea: true,
        fullWidth: false,
        axisY: {
            onlyInteger: true,
            offset: 20
        },
        lineSmooth: Chartist.Interpolation.simple({
            divisor: 100
        })
    });

    mychart2.on('draw', function(data) {
        if(data.type === 'slice') {
            if (data.index == 0) {
                data.element.attr({
                    'style': 'stroke: rgba(193, 0, 104, 1)'
                });
                data.element.animate ({
                    'stroke-dashoffset': {
                        begin: '1s',
                        dur: '21s',
                        from: '0',
                        to: '600',
                        easing: 'easeOutQuart',
                        d:"part1"
                    },
                    'stroke-dasharray': {
                        from: '0',
                        to: '1000'
                    }
                }, false);
            } else {
                data.element.attr({
                    'style': 'stroke: rgba(102, 102, 102, 1)'
                });
                data.element.animate ({
                    'stroke-dashoffset': {
                        begin: "part1.end",
                        dur: 1000,
                        from: '0 250 150',
                        to: '360 250 150',
                        easing: 'easeOutQuart'
                    }
                });
            }
        }
    });
</script>