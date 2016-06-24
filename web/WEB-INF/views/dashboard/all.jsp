<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<c:set value="H00010" var="menuId"/>
<c:set value="H00000" var="subMenuId"/>
<isaver:pageRoleCheck menuId="${menuId}" />

<link rel="stylesheet" type="text/css" href="${rootPath}/assets/library/chartist/chartist.min.css" >
<script type="text/javascript" src="${rootPath}/assets/library/chartist/chartist.min.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/jquery.marquee.js"></script>

<!-- section Start -->
<section  class="container">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="main_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title">All</h3>
        <!-- 마키 영역 Start -->
        <div id="marqueeList" class="marquee"></div>
        <!-- 마키 영역 End -->
    </article>

    <!-- 2depth 타이틀 영역 End -->
    <article class="dash_contents_area nano">
        <div class="nano-content">
            <div class="metro_root mr_h70">
                <div class="metro_parent">
                    <div id="workerDiv" title="<spring:message code="dashboard.title.worker"/>">
                        <div class="mp_header">
                            <h2><spring:message code="dashboard.title.worker"/></h2>
                            <div>
                                <button class="alra_btn" href="#" onclick="javascript:alramShowHide('list','show');">0</button>
                            </div>
                        </div>
                        <div class="mp_contents">
                            <div class="mc_bico type01 worker"></div>
                            <div class="mc_element nano">
                                <div id="eventLogWorkerList" class="mce_btn_area nano-content">
                                    <c:choose>
                                        <c:when test="${areas != null and fn:length(areas) > 0}">
                                            <c:forEach var="area" items="${areas}">
                                                <button areaId="${area.areaId}" href="#" onclick="javascript:moveDashBoardDetail('${area.areaId}')">
                                                    <span>${area.areaName}</span>
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
                                                    <span>${area.areaName}</span>
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
                                <button class="alra_btn" href="#" onclick="javascript:alramShowHide('list','show');">0</button>
                            </div>
                        </div>
                        <div class="mp_contents">
                            <div class="mc_bico type01 crane"></div>
                            <div class="mc_element nano">
                                <div id="eventLogCraneList" class="mce_btn_area nano-content">
                                    <c:choose>
                                        <c:when test="${areas != null and fn:length(areas) > 0}">
                                            <c:forEach var="area" items="${areas}">
                                                <button areaId="${area.areaId}" href="#" onclick="javascript:moveDashBoardDetail('${area.areaId}')">
                                                    <span>${area.areaName}</span>
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
                    <div id="gasDiv" title="<spring:message code="dashboard.title.gasState"/>">
                        <div class="mp_header">
                            <h2><spring:message code="dashboard.title.gasState"/></h2>
                            <div>
                                <button class="alra_btn" href="#" onclick="javascript:alramShowHide('list','show');">0</button>
                            </div>
                        </div>
                        <div class="mp_contents">
                            <div class="mc_bico type01 gas"></div>
                            <div class="mc_element nano">
                                <div class="mce_btn_area nano-content">
                                    <c:choose>
                                        <c:when test="${areas != null and fn:length(areas) > 0}">
                                            <c:forEach var="area" items="${areas}">
                                                <button areaId="${area.areaId}" href="#" onclick="javascript:moveDashBoardDetail('${area.areaId}')">
                                                    <span>${area.areaName}</span>
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
            </div>
            <div class="metro_root mr_h30">
                <div class="metro_parent">
                    <div>
                        <div class="mp_header">
                            <h2><spring:message code="dashboard.title.issue"/></h2>
                            <div>
                                <span class="ch_name co_gren"><spring:message code="dashboard.column.worker"/></span>
                                <span class="ch_name co_purp"><spring:message code="dashboard.column.crane"/></span>
                                <span class="ch_name co_yell"><spring:message code="dashboard.column.gas"/></span>
                                <select id="chartRefreshTime">
                                    <option value="30">30 min</option>
                                    <option value="60">60 min</option>
                                    <option value="90">90 min</option>
                                    <option value="120">120 min</option>
                                </select>
                            </div>
                        </div>
                        <div class="mp_contents" id="chart"></div>
                    </div>
                </div>
            </div>
        </div>
    </article>
</section>

<script type="text/javascript">
    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');

    /*
     url defind
     @author psb
     */
    var urlConfig = {
        workerUrl  :   "${rootPath}/eventLogWorker/list.json"
        ,craneUrl  :   "${rootPath}/eventLogCrane/list.json"
        ,inoutUrl  :   "${rootPath}/eventLogInout/list.json"
        ,chartUrl  :   "${rootPath}/eventLogChart/all.json"
    };

    var messageConfig = {
        workerFailure   :'<spring:message code="dashboard.message.workerFailure"/>'
        , craneFailure  :'<spring:message code="dashboard.message.craneFailure"/>'
        , inoutFailure  :'<spring:message code="dashboard.message.inoutFailure"/>'
        , chartFailure  :'<spring:message code="dashboard.message.chartFailure"/>'
    };

    $(document).ready(function(){
        /* 작업자 */
        dashBoardHelper.addRequestData('worker', urlConfig['workerUrl'], null, dashBoardSuccessHandler, dashBoardFailureHandler);
        /* 크래인 */
        dashBoardHelper.addRequestData('crane', urlConfig['craneUrl'], null, dashBoardSuccessHandler, dashBoardFailureHandler);
        /* 진출입 */
        dashBoardHelper.addRequestData('inout', urlConfig['inoutUrl'], null, dashBoardSuccessHandler, dashBoardFailureHandler);
        /* 차트 */
        dashBoardHelper.addRequestData('chart', urlConfig['chartUrl'], {pageIndex : 20, minutesCount : $("select[id=chartRefreshTime]").val()}, dashBoardSuccessHandler, dashBoardFailureHandler);
    });

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
            case 'chart':
                chartRender(data);
                dashBoardHelper.saveRequestData('chart', {pageIndex : 20, minutesCount : $("select[id=chartRefreshTime]").val()});
                break;
        }
    }

    function workerRender(data){
        var workerList = data['eventLogWorkerList'];
        if(workerList!=null){
            var workerEventCnt = 0;
            for(var index in workerList){
                var worker = workerList[index];
                var buttonTag = $("#eventLogWorkerList button[areaId='"+worker['areaId']+"']");

                workerEventCnt += Number(worker['eventCnt']);
                if(Number(worker['eventCnt'])>0){
                    if(buttonTag.find("#eventCnt").length>0){
                        if(buttonTag.find("#eventCnt").text() != String(worker['eventCnt'])){
                            buttonTag.find("#eventCnt").text(worker['eventCnt']);
                        }
                    }else{
                        buttonTag.append(
                            $("<span/>", {id:"eventCnt"}).text(worker['eventCnt'])
                        )
                    }

                    modifyElementClass(buttonTag,'level03','add');
                }else{
                    modifyElementClass(buttonTag,'level03','remove');

                    if(buttonTag.find("#eventCnt").length>0){
                        buttonTag.find("#eventCnt").remove();
                    }
                }
            }

            if($("#workerDiv").find(".alra_btn").text() != String(workerEventCnt)){
                $("#workerDiv").find(".alra_btn").text(workerEventCnt);
            }

            if(workerEventCnt>0){
                modifyElementClass($("#workerDiv"),'level03','add');
            }else{
                modifyElementClass($("#workerDiv"),'level03','remove');
            }
        }
    }

    function craneRender(data){
        var craneList = data['eventLogCraneList'];
        if(craneList!=null){
            var craneEventCnt = 0;
            for(var index in craneList){
                var crane = craneList[index];
                var buttonTag = $("#eventLogCraneList button[areaId='"+crane['areaId']+"']");

                craneEventCnt += Number(crane['eventCnt']);
                if(Number(crane['eventCnt'])>0){
                    if(buttonTag.find("#eventCnt").length>0){
                        if(buttonTag.find("#eventCnt").text() != String(crane['eventCnt'])){
                            buttonTag.find("#eventCnt").text(crane['eventCnt']);
                        }
                    }else{
                        buttonTag.append(
                            $("<span/>", {id:"eventCnt"}).text(crane['eventCnt'])
                        )
                    }

                    modifyElementClass(buttonTag,'level03','add');
                }else{
                    modifyElementClass(buttonTag,'level03','remove');

                    if(buttonTag.find("#eventCnt").length>0){
                        buttonTag.find("#eventCnt").remove();
                    }
                }
            }

            if($("#craneDiv").find(".alra_btn").text() != String(craneEventCnt)){
                $("#craneDiv").find(".alra_btn").text(craneEventCnt);
            }

            if(craneEventCnt>0){
                modifyElementClass($("#craneDiv"),'level03','add');
            }else{
                modifyElementClass($("#craneDiv"),'level03','remove');
            }
        }
    }

    function inoutRender(data){
        var inoutList = data['eventLogInoutList'];
        if(inoutList!=null){
            var inoutEventCnt = 0;
            for(var index in inoutList){
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

    /**
     * 차트 가공 [상태 ]
     * @author dhj
     */
    function chartRender(data) {
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
            mychart.data.series[0] = chartList;
            mychart.data.labels = eventDateList;
        }

        if (data['eventLogCraneChart'] != null) {
            var eventLogCraneChart = data['eventLogCraneChart'];
            var chartList = [];

            for (var i =0;i<eventLogCraneChart.length;i++) {
                var item = eventLogCraneChart[i];
                chartList.push(item['eventCnt']);
            }
            chartList.reverse();
            mychart.data.series[1] = chartList;
        }

        mychart.update();
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

    var mychart = new Chartist.Line('#chart', {
        labels: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20],
        series: [
            [],
            []
        ]
    }, {
        low: 0,
        showArea: true,
        lineSmooth: Chartist.Interpolation.simple({
            divisor: 100
        })
    });

    mychart.on('draw', function(data) {
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