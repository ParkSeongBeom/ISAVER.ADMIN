<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set value="H00000" var="menuId"/>
<c:set value="H00000" var="subMenuId"/>

<link rel="stylesheet" type="text/css" href="${rootPath}/assets/library/chartist/chartist.min.css" >
<link rel="stylesheet" type="text/css" href="${rootPath}/assets/library/chartist/chartist-plugin-tooltip.css" >
<script type="text/javascript" src="${rootPath}/assets/library/chartist/chartist.min.js"></script>
<script type="text/javascript" src="${rootPath}/assets/library/chartist/chartist-plugin-tooltip.js"></script>
<script src="${rootPath}/assets/library/tree/jquery.dynatree.js"type="text/javascript" ></script>

<script type="text/javascript" src="${rootPath}/assets/js/page/dashboard/dashboard-helper.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/page/dashboard/dashboard-resource.js"></script>

<article>
    <div class="sub_title_area">
        <h3>
            <c:if test="${area.areaId!=null}">
                ${area.areaName}
            </c:if>
            <c:if test="${area.areaId==null}">
                <spring:message code="dashboard.title.allText"/>
            </c:if>
        </h3>

        <nav class="navigation">
            <span onclick="javascript:moveDashboard(); return false;">DASHBOARD</span>
            <span onclick="javascript:moveDashboard(); return false;">All</span>
            <c:choose>
                <c:when test="${navList != null and fn:length(navList) > 0}">
                    <c:forEach var="navArea" items="${navList}">
                        <span onclick="javascript:moveDashboard('${navArea.areaId}'); return false;">${navArea.areaName}</span>
                    </c:forEach>
                </c:when>
            </c:choose>
        </nav>

        <div class="expl">
            <c:forEach var="critical" items="${criticalList}">
                <span>${critical.codeName}</span>
            </c:forEach>
        </div>
    </div>

    <!-- 구역이 9개 이하 일때 구역레이아웃 변경 design.js "구역 개수에 따른 레이아웃 변경"-->
    <section class="watch_area"></section>

    <div class="popupbase iocount_popup">
        <div>
            <div>
                <header>
                    <h2><spring:message code="dashboard.title.inoutSetting"/></h2>
                    <button class="close_btn" onclick="javascript:closeInoutConfigListPopup();"></button>
                </header>
                <article>
                    <!-- 진출입 트리보기 센션 -->
                    <section>
                        <div class="tree_table">
                            <div class="table_title_area">
                                <div class="table_btn_set">
                                    <button class="btn" id="expandShow" onclick="javascript:areaCtrl.treeExpandAll(true); return false;"><spring:message code='common.button.viewTheFull'/></button>
                                    <button class="btn" id="expandClose" style="display:none;" onclick="javascript:areaCtrl.treeExpandAll(false); return false;"><spring:message code='common.button.viewTheFullClose'/></button>
                                </div>
                            </div>
                            <div class="table_contents">
                                <div id="menuTreeArea" class="tree_box">
                                    <ul class="dynatree-container dynatree-no-connector">
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </section>

                    <!-- 진출입 설정 셋션 -->
                    <section>
                        <h3><spring:message code="dashboard.title.inoutSetting"/></h3>
                        <ul class="u_defalut time_set_type iotime_set">
                            <c:forEach begin="0" end="5" varStatus="mainLoop">
                                <li settingIndex="${mainLoop.index}">
                                    <div class="checkbox_set csl_style02">
                                        <input type="checkbox" checked="checked" <c:if test="${mainLoop.index==0}">disabled="disabled"</c:if>>
                                        <label></label>
                                    </div>
                                    <div class="timepicker">
                                        <div class="hour">
                                            <input type="number" name="format" value="00" pattern="00" placeholder="시" maxlength="2" onkeyup="this.value = minMaxFunc(this.value, 0, 23)">
                                            <select onchange="this.previousElementSibling.value=this.value">
                                                <c:forEach begin="0" end="23" varStatus="loop">
                                                    <option value="<fmt:formatNumber value="${loop.index}" pattern="00" type="Number"/>"><fmt:formatNumber value="${loop.index}" pattern="00" type="Number"/>시</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="minute">
                                            <input type="number" name="format" value="00" pattern="00" placeholder="분" maxlength="2" onkeyup="this.value = minMaxFunc(this.value, 0, 59)">
                                            <select onchange="this.previousElementSibling.value=this.value">
                                                <c:forEach begin="0" end="5" varStatus="loop">
                                                    <option value="<fmt:formatNumber value="${loop.index*10}" pattern="00" type="Number"/>"><fmt:formatNumber value="${loop.index*10}" pattern="00" type="Number"/>분</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="second">
                                            <input type="number" name="format" value="00" pattern="00" placeholder="초" maxlength="2" onkeyup="this.value = minMaxFunc(this.value, 0, 59)">
                                            <select onchange="this.previousElementSibling.value=this.value">
                                                <c:forEach begin="0" end="5" varStatus="loop">
                                                    <option value="<fmt:formatNumber value="${loop.index*10}" pattern="00" type="Number"/>"><fmt:formatNumber value="${loop.index*10}" pattern="00" type="Number"/>초</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <em>~</em>
                                        <input type="text" name="endTime" disabled="disabled">
                                    </div>
                                </li>
                            </c:forEach>
                        </ul>
                    </section>
                </article>

                <footer>
                    <button class="btn" onclick="javascript:saveInoutConfiguration();"><spring:message code="common.button.save"/></button>
                </footer>
            </div>
        </div>
        <div class="bg" onclick="javascript:closeInoutConfigListPopup();"></div>
    </div>
</article>

<script type="text/javascript">
    var targetMenuId = String('${paramBean.areaId}');
    var subMenuId = String('${subMenuId}');
    var areaId = String('${paramBean.areaId}');
    var dashboardHelper = new DashboardHelper();
    var chartList = {};

    /*
     url defind
     @author psb
     */
    var urlConfig = {
        eventLogUrl : "${rootPath}/eventLog/dashboard.json"
        ,inoutListUrl : "${rootPath}/eventLogInout/list.json"
        ,inoutDetailUrl : "${rootPath}/eventLogInout/list.json"
        ,chartUrl : "${rootPath}/eventLog/chart.json"
        ,saveInoutConfigurationUrl : "${rootPath}/inoutConfiguration/save.json"
        ,inoutConfigAreaTreeUrl : "${rootPath}/area/treeList.json"
    };

    var messageConfig = {
        eventLogFailure   :'<spring:message code="dashboard.message.eventLogFailure"/>'
        , inoutListFailure  :'<spring:message code="dashboard.message.inoutFailure"/>'
        , inoutDetailFailure  :'<spring:message code="dashboard.message.inoutFailure"/>'
        , inoutConfigDuplication : '<spring:message code="dashboard.message.inoutConfigDuplication"/>'
        , saveInoutConfigurationComplete : '<spring:message code="dashboard.message.saveInoutConfigurationComplete"/>'
        , saveInoutConfigurationFailure : '<spring:message code="dashboard.message.saveInoutConfigurationFailure"/>'
    };

    $(document).ready(function(){
        dashboardHelper.initialize($(".watch_area"),{
            <c:forEach var="childArea" items="${childAreas}">
            '${childArea.areaId}' : {
                'areaName' : '${childArea.areaName}'
                ,'templateCode' : '${childArea.templateCode}'
                ,'childAreaIds' : '${childArea.childAreaIds}'
                ,'devices' : [
                    <c:forEach var="device" items="${childArea.devices}">
                    {
                        'deviceId' : '${device.deviceId}'
                        ,'deviceCode' : '${device.deviceCode}'
                        ,'deviceCodeName' : '${device.deviceCodeName}'
                    },
                    </c:forEach>
                ]
                ,'areas' : [
                    <c:forEach var="area" items="${childArea.areas}">
                    {
                        'areaId' : '${area.areaId}'
                        ,'templateCode' : '${area.templateCode}'
                    },
                    </c:forEach>
                ]
            },
            </c:forEach>
        },new DashboardResource());
        dashboardHelper.setTrefficTemplate(
            $("<section/>", {class:"treffic_set"})
            <c:forEach var="critical" items="${criticalList}">
                .append(
                    $("<div/>",{criticalLevel:"${critical.codeId}", class:"ts-"+criticalCss['${critical.codeId}']}).append($("<p>"))
                )
            </c:forEach>
        );
        dashboardHelper.areaRender();

        // 조회주기 체크 제어
        $(".iotime_set .checkbox_set > input[type='checkbox']").click(function(){
            if($(this).is(":checked")) {
                $(this).parent().addClass("on");
            } else {
                $(this).parent().removeClass("on");
            }
        });

        $(".iotime_set").on('change',function(){
            updateInoutSettingDatetime();
        });

        /* 이벤트 */
        requestHelper.addRequestData('eventLog', urlConfig['eventLogUrl'], {areaId:areaId}, dashBoardSuccessHandler, dashBoardFailureHandler);
        /* 진출입 */
        requestHelper.addRequestData('inoutList', urlConfig['inoutListUrl'], {areaIds:getInoutArea()}, dashBoardSuccessHandler, dashBoardFailureHandler);
        /* 이벤트 callback (websocket 리스너) */
        requestHelper.setCallBackEventHandler(appendEventHandler);
        setRefreshTimeCallBack(refreshInoutSetting);
        initInoutConfigAreaDynatree();
        initChartList();
    });

    function initChartList(){
        $(".watch_area div[chartAreaId]").each(function(){
           chartList[$(this).attr("chartAreaId")] = new Chartist.Line(this, {
               labels: [],
               series: [[], []]
           }, {
               low: 0,
               showArea: true,
               showLabel: true,
               fullWidth: false,
               axisY: {
                   onlyInteger: true,
                   offset: 20
               },
               lineSmooth: Chartist.Interpolation.simple({
                   divisor: 100
               }),
               plugins: [
                   Chartist.plugins.tooltip()
               ]
           });
        });

        $(".watch_area ul[nhrDeviceList]").each(function(){
            $(this).find("li:eq(0)").trigger("click");
        });
    }

    function dateSelTypeClick(_areaId, _this){
        if($(_this).hasClass("on")){
            return false;
        }else{
            $(_this).parent().find("button").removeClass("on");
            $(_this).addClass("on");

            updateChart(_areaId, $(".watch_area div[areaId='"+_areaId+"'] li[deviceId].on").attr("deviceId"));
        }
    }

    function initInoutConfigAreaDynatree(){
        callAjax('inoutConfigAreaTree');
    }

    function refreshInoutSetting(_serverDatetime){
        var refreshFlag = false;
        $.each($(".watch_area div[inoutArea]"),function(){
            if(_serverDatetime.getTime() > $(this).attr("endDatetime")){
                refreshFlag = true;
            }
        });

        if(refreshFlag){
            requestHelper.getData('inoutList');
        }
    }

    /**
     * 진출입 조회주기 종료시간 자동 입력
     * @author psb
     */
    function updateInoutSettingDatetime(){
        var inoutDatetimes = [];

        $.each($(".iotime_set li"),function(){
            if($(this).find("input[type='checkbox']").is(":checked")){
                var numberTags = $(this).find("input[type='number']");
                var inoutDateStr = new Date("2000-01-01 " + numberTags.eq(0).val() + ":" + numberTags.eq(1).val() + ":" + numberTags.eq(2).val());
                inoutDatetimes.push(inoutDateStr)
            }else{
                $(this).find("input[name='endTime']").val("");
            }
        });

        inoutDatetimes.sort();

        $.each($(".iotime_set li"),function(){
            if($(this).find("input[type='checkbox']").is(":checked")){
                var numberTags = $(this).find("input[type='number']");
                var hour = Number(numberTags.eq(0).val());
                if(hour>=0 && hour<10) {hour = "0" + hour;}
                var minute = Number(numberTags.eq(1).val());
                if(minute>=0 && minute<10) {minute = "0" + minute;}
                var second = Number(numberTags.eq(2).val());
                if(second>=0 && second<10) {second = "0" + second;}
                var inoutDateStr = hour + ":" + minute + ":" + second;
                var drawFlag = false;

                for(var index in inoutDatetimes){
                    if(inoutDateStr == inoutDatetimes[index].format("HH:mm:ss")){
                        var endTime = new Date(inoutDatetimes[Number(index)+1]);

                        if(!(endTime == "Invalid Date" || isNaN(endTime.getTime()))){
                            endTime.setSeconds(-1);
                            $(this).find("input[name='endTime']").val(endTime.format("HH:mm:ss"));
                            drawFlag = true;
                        }
                    }
                }

                if(!drawFlag){
                    $(this).find("input[name='endTime']").val('23:59:59');
                }
            }
        });
    }

    /**
     * 진출입 데이터를 가져와야할 구역 조회
     * @author psb
     */
    function getInoutArea(){
        var areaIds = "";
        $.each($(".watch_area div[inoutArea]"), function(){
            if(areaIds!=""){ areaIds += ",";}
            areaIds += $(this).attr("areaId");
        });

        return areaIds;
    }

    /**
     * 진출입 설정 팝업 열기
     * @author psb
     */
    function openInoutConfigListPopup(_areaId,_areaName){
        $(".iocount_popup").attr("areaId",_areaId);
        $(".iocount_popup").fadeIn(200);

        $("#menuTreeArea").dynatree("getTree").visit(function(node){
            if(node.data.id === _areaId){
                node.activate();
                node.select();
                node.focus();
            }
        });
    }

    /**
     * 진출입 설정 팝업 닫기
     * @author psb
     */
    function closeInoutConfigListPopup(){
        $('.iocount_popup').fadeOut(200);
    }

    /**
     * 진출입 설정 구역 선택
     * @author psb
     */
    function selectInoutConfigArea(_areaId){
        callAjax('inoutDetail',{areaIds:_areaId});
    }

    /**
     * inout configuration save
     * @author psb
     */
    function saveInoutConfiguration(){
        var areaId = $(".iocount_popup").attr("areaId");

        if(areaId==null){
            console.error("[saveInoutConfiguration] areaId is null");
            alertMessage();
            return false;
        }

        var inoutDatetimes = [];

        $.each($(".iotime_set li"),function(){
            if($(this).find("input[type='checkbox']").is(":checked")){
                var numberTags = $(this).find("input[type='number']");
                var hour = Number(numberTags.eq(0).val());
                if(hour>=0 && hour<10) {hour = "0" + hour;}
                var minute = Number(numberTags.eq(1).val());
                if(minute>=0 && minute<10) {minute = "0" + minute;}
                var second = Number(numberTags.eq(2).val());
                if(second>=0 && second<10) {second = "0" + second;}
                var inoutDateStr = hour + ":" + minute + ":" + second;

                inoutDatetimes.push(inoutDateStr+"|"+$(this).find("input[name='endTime']").val());
            }
        });

        inoutDatetimes.sort();
        if(isDuplicationArray(inoutDatetimes)){
            alertMessage('inoutConfigDuplication');
            return false;
        }

        var param = {
            'areaId' : areaId
            ,'inoutDatetimes' : inoutDatetimes.join(",")
        };
        callAjax('saveInoutConfiguration',param);
    }

    /**
     * alarm success handler
     * @author psb
     * @private
     */
    function appendEventHandler(data, messageType){
        switch (messageType) {
            case "addEvent" : // 일반 이벤트
                switch ($(".watch_area div[areaId='"+data['areaId']+"']").attr("templateCode")){
                    case "TMP001": // 신호등
                        break;
                    case "TMP002": // 감시구역 침입
                        break;
                    case "TMP003": // 전시물 보호
                        break;
                    case "TMP004": // 진출입
                        inoutAppender(data);
                        break;
                    case "TMP005": // NHR
                        nhrAppender(data);
                        break;
                }
                break;
            case "addAlarmEvent": // 알림이벤트 등록
            case "removeAlarmEvent": // 알림이벤트 해제
            case "refreshView" : // 초기로딩 및 리스트 교체
                eventLogRender(data, messageType);
                break;
        }
    }

    function callAjax(actionType, data){
        sendAjaxPostRequest(urlConfig[actionType + 'Url'],data,dashBoardSuccessHandler,dashBoardFailureHandler,actionType);
    }

    /**
     * alarm success handler
     * @author psb
     * @private
     */
    function dashBoardSuccessHandler(data, dataType, actionType){
        switch(actionType){
            case 'eventLog':
                eventLogRender(data['eventLogs'], "refreshView");
                break;
            case 'inoutList':
                inoutRender(data['eventLogInoutList']);
                break;
            case 'chart':
                chartRender(data);
                break;
            case 'inoutDetail':
                inoutDetailRender(data['eventLogInoutList']);
                break;
            case 'saveInoutConfiguration':
                alertMessage(actionType+'Complete');
                closeInoutConfigListPopup();
                break;
            case 'inoutConfigAreaTree':
                var areaList = data['areaList'];
                var _treeModel = [];
                for(var index in areaList){
                    var area = areaList[index];
                    var appendFlag = false;
                    var view = {
                        id        : String(area.areaId),
                        title     : "<span style='font-weight: bold;'>"+String(area['areaName'] + "</span> (" + area['areaId'] +")"),
                        isFolder  : false,
                        children  : []
                    };

                    for(var i in _treeModel){
                        var _parentNode = _treeModel[i];
                        if(_parentNode['id']==area['parentAreaId']){
                            _parentNode['children'].push(view);
                            appendFlag = true;
                        }
                    }

                    if(!appendFlag){
                        _treeModel.push(view);
                    }
                }

                $("#menuTreeArea").dynatree({
                    minExpandLevel: 1,
                    debugLevel: 1,
                    persist: false,
                    onPostInit: function (isReloading, isError) {
                        var myParam = location.search.split('ctrl=')[1];
                        if (myParam) {
                            if ("reload" == myParam) {
                                this.reactivate();
                            }
                        }
                    }
                    ,children: _treeModel
                    ,onActivate: function (node) {
                        var id = node.data.id;
                        $(".iocount_popup").attr("areaId",id);
                        selectInoutConfigArea(id);
                    }
                });
                break;
        }
    }

    function findAreaElement(_areaId){
        var _element = null;

        $.each($(".watch_area div[areaId]"), function(){
            if($(this).attr("areaId")==_areaId){
                _element = this;
            }else if($(this).find(".area[childAreaIds]").length > 0){
                var childAreaIds = $(this).find(".area[childAreaIds]").attr("childAreaIds");
                if(childAreaIds.indexOf(_areaId) > -1){
                    _element = this;
                }
            }
        });
        return _element;
    }

    /**
     * 구역별 알림 상태
     */
    function eventLogRender(data, messageType){
        if(data==null){
            return false;
        }

        // Config
        var renderConfig = {
            'refreshFlag' : true // 초기화여부
            ,'appendType' : 'add'
        };

        switch (messageType) {
            case "addAlarmEvent": // 알림이벤트 등록
                renderConfig['refreshFlag'] = false;
                break;
            case "removeAlarmEvent": // 알림이벤트 해제
                renderConfig['refreshFlag'] = false;
                renderConfig['appendType'] = 'remove';
                break;
            case "refreshView" : // 초기로딩 및 리스트 교체
                renderConfig['refreshFlag'] = true;
                break;
        }

        // 초기화
        if(renderConfig['refreshFlag']){
            for(var index in criticalCss){
                modifyElementClass($(".watch_area div[areaId]"),"level-"+criticalCss[index],'remove');
            }
            $(".watch_area div[areaId] div[criticalLevel] p").text("");
        }

        if(Array.isArray(data)){
            for(var index in data){
                appendEvent(data[index], renderConfig);
            }
        }else{
            appendEvent(data, renderConfig);
        }

        function appendEvent(_data, _config){
            var _element = findAreaElement(_data['areaId']);
            if(_element==null){
                console.debug("[eventLogRender][appendEvent] do not need to work on '" + _data['areaId'] + "' area - " + _data['eventLogId']);
                return false;
            }

            var eventLogInfo = _data['infos'];
            var criticalLevel = null;
            for(var i in eventLogInfo){
                var _info = eventLogInfo[i];
                if(_info['key']=='criticalLevel'){
                    criticalLevel = _info['value'];
                }
            }

            if(criticalLevel==null){
                console.debug("[eventLogRender][appendEvent] criticalLevel is not found - " + _data['eventLogId']);
                return false;
            }

            var eventCntTag;
            var deviceElement = $(_element).find("li[deviceId='"+_data['deviceId']+"']");
            if(deviceElement.length > 0){
                eventCntTag = deviceElement.find("[criticalLevel='"+criticalLevel+"'] p");
            }else{
                eventCntTag = $(_element).find("[criticalLevel='"+criticalLevel+"'] p");
            }

            if(eventCntTag.length == 0){
                console.debug("[eventLogRender][appendEvent] criticalLevel Tag is not found '" + _data['areaId'] + "' area - " + _data['eventLogId']);
                return false;
            }

            var eventCnt = eventCntTag.text()!="" ? Number(eventCntTag.text()) : 0;
            switch (_config['appendType']){
                case "add" :
                    eventCntTag.text(++eventCnt);
                    modifyElementClass($(_element),"level-"+criticalCss[criticalLevel],'add');
                    if(deviceElement!=null){
                        modifyElementClass(deviceElement,"ts-"+criticalCss[criticalLevel],'add');
                    }
                    $(_element).find("p[messageBox]").append(
                        $("<span/>",{eventLogId:_data['eventLogId']}).text(_data['areaName']+" "+_data['deviceName']+" "+_data['eventName']+" "+new Date(_data['eventDatetime']).format("yyyy.MM.dd HH:mm:ss"))
                    );
                    break;
                case "remove" :
                    eventCntTag.text(--eventCnt==0?"":eventCnt);
                    if(eventCnt==0){
                        modifyElementClass($(_element),"level-"+criticalCss[criticalLevel],'remove');
                        if(deviceElement!=null){
                            modifyElementClass(deviceElement,"ts-"+criticalCss[criticalLevel],'remove');
                        }
                    }
                    $(_element).find("p[messageBox] span[eventLogId='"+_data['eventLogId']+"']").remove();
                    break;
            }

            nhrAppender(_data);
        }
    }

    /**
     * 진출입 이벤트 발생시
     */
    function inoutAppender(data){
        var inoutAreaTag = $(".watch_area div[inoutArea][areaId='"+data['areaId']+"']");
        if(inoutAreaTag.length > 0){
            var startDatetime = new Date(Number(inoutAreaTag.attr("startDatetime")));
            var endDatetime = new Date(Number(inoutAreaTag.attr("endDatetime")));
            var eventDatetime = new Date(data['eventDatetime']);
            var updateFlag = false;

            if(eventDatetime>=startDatetime && eventDatetime<=endDatetime){
                for(var index in data['infos']){
                    var info = data['infos'][index];

                    if(info['key']=="inCount"){
                        var inTag = inoutAreaTag.find("[in]");
                        var inCount = Number(inTag.text());
                        inCount += Number(info['value']);
                        inTag.text(inCount);
                        updateFlag = true;
                    }else if(info['key']=="outCount"){
                        var outTag = inoutAreaTag.find("[out]");
                        var outCount = Number(outTag.text());
                        outCount += Number(info['value']);
                        outTag.text(outCount);
                        updateFlag = true;
                    }
                }
            }

            if(updateFlag){
                inoutAreaTag.find("[gap]").text(Number(inoutAreaTag.find("[in]").text())-Number(inoutAreaTag.find("[out]").text()));
            }
        }
    }

    /**
     * NHR 이벤트 발생시
     */
    function nhrAppender(data){
        var nhrDeviceTag = $(".watch_area div[areaId='"+data['areaId']+"'] li[deviceId='"+data['deviceId']+"']");
        if(nhrDeviceTag.length > 0) {
            var updateFlag = false;
            for(var index in data['infos']){
                var info = data['infos'][index];

                if(info['key']=="value"){
                    nhrDeviceTag.find("span[evtValue]").text(info['value']);
                    updateFlag = true;
                }
            }

            if(nhrDeviceTag.hasClass("on") && updateFlag){
                updateChart(data['areaId'], data['deviceId']);
            }
        }
    }

    function updateChart(_chartAreaId, _deviceId){
        var dateSelType = $("div[areaId='"+_chartAreaId+"'] div[dateSelType] button.on").attr("value");
        var truncType;
        var truncValue = 1;
        switch (dateSelType){
            case 'day':
                truncType = 'hour';
                truncValue = 4;
                break;
            case 'week':
                truncType = 'day';
                break;
            case 'month':
                truncType = 'week';
                break;
            case 'year':
                truncType = 'month';
                break;
        }
        callAjax('chart',{areaId:_chartAreaId, deviceId:_deviceId, dateType: dateSelType, truncType: truncType, truncValue:truncValue});
    }

    /**
     * 구역별 진출입 상태
     */
    function inoutRender(data){
        if(data==null){
            return false;
        }

        var _targetAreaId = null;

        for(var index in data){
            var inout = data[index];
            if(_targetAreaId==null || _targetAreaId!=inout['areaId']){
                _targetAreaId = inout['areaId'];
                var inoutTag = $(".watch_area div[inoutArea][areaId='"+inout['areaId']+"']");
                if(inoutTag.length > 0){
                    var inCount = inout['inCount']!=null?inout['inCount']:0;
                    var outCount = inout['outCount']!=null?inout['outCount']:0;
                    inoutTag.find("p[in]").text(inCount);
                    inoutTag.find("p[out]").text(outCount);
                    inoutTag.find("p[gap]").text(inCount-outCount);
                    inoutTag.attr("startDatetime",inout['inoutStarttime']);
                    inoutTag.attr("endDatetime",inout['inoutEndtime']);
                }
            }
        }
    }

    /**
     * 해당구역의 진출입 상세
     */
    function inoutDetailRender(data){
        if(data==null){
            return false;
        }

        var inoutDatetimes = [];
        for(var index in data){
            var inout = data[index];
            var inoutStarttime = new Date(inout['inoutStarttime']);
            inoutDatetimes.push(inoutStarttime.format("HH:mm:ss"));
        }

        inoutDatetimes.sort();
        inoutDatetimes = uniqArrayList(inoutDatetimes);

        var inoutSetTag = $(".iocount_popup .iotime_set");
        // 진출입 조회주기 설정 초기화
        inoutSetTag.find(".checkbox_set").removeClass("on");
        inoutSetTag.find("input[type='checkbox']").not(":eq(0)").prop("checked",false);
        inoutSetTag.find("input[type='number']").val(0);
        inoutSetTag.find("input[name='endTime']").val("");

        // 진출입 조회주기 설정 render
        for(var index in inoutDatetimes){
            try{
                var inoutDatetime = inoutDatetimes[index].split(":");
                var settingTag = inoutSetTag.find("li[settingIndex='"+index+"']");
                settingTag.find("input[type='number']:eq(0)").val(inoutDatetime[0]);
                settingTag.find("input[type='number']:eq(1)").val(inoutDatetime[1]);
                settingTag.find("input[type='number']:eq(2)").val(inoutDatetime[2]);
                if(index>0){
                    settingTag.find(".checkbox_set").addClass("on");
                    settingTag.find("input[type='checkbox']").prop("checked",true);
                }
            }catch(e){
                console.error(e);
            }
        }

        updateInoutSettingDatetime();
    }

    /**
     * 차트 가공 진출입
     * @author psb
     */
    function chartRender(data) {
        var paramBean = data['paramBean'];

        if(chartList[paramBean['areaId']]==null || chartList[paramBean['areaId']] == undefined){
            return false;
        }

        if (data['eventLogChartList'] != null) {
            var eventLogChartList = data['eventLogChartList'];
            var _chartList = [];
            var _eventDateList = [];

            for(var index in eventLogChartList){
                var item = eventLogChartList[index];
                var _eventDate = new Date();
                _eventDate.setTime(item['eventDatetime']);
                _chartList.push(item['value']);
                switch (paramBean['truncType']){
                    case 'hour':
                        _eventDateList.push(_eventDate.format("HH"));
                        break;
                    case 'day':
                        _eventDateList.push(_eventDate.format("es"));
                        break;
                    case 'week':
                        _eventDateList.push(_eventDate.getWeekOfMonth()+"주");
                        break;
                    case 'month':
                        _eventDateList.push(_eventDate.format("MM"));
                        break;
                }
            }
            _chartList.reverse();
            _eventDateList.reverse();

            chartList[paramBean['areaId']].data.series[0] = _chartList;
            chartList[paramBean['areaId']].data.labels = _eventDateList;
            chartList[paramBean['areaId']].update();
        }

    }

    /*
     ajax error handler
     @author psb
     */
    function dashBoardFailureHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
//        console.error(messageConfig[actionType + 'Failure']);
        alertMessage(actionType + 'Failure');
    }

    /*
     alert message method
     @author psb
     */
    function alertMessage(type){
        alert(messageConfig[type]);
    }
</script>