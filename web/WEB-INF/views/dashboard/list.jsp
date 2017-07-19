<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set value="H00000" var="menuId"/>
<c:set value="H00000" var="subMenuId"/>

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
    <section class="watch_area <c:if test='${fn:length(childAreas) <= 9}'>area06</c:if>">
        <c:choose>
            <c:when test="${childAreas != null and fn:length(childAreas) > 0}">
                <c:forEach var="childArea" items="${childAreas}">
                    <!--
                        장치 Type 확인 (신호등, 진출입 을 보여주기 위함)
                        (진출입 deviceCode = DEV009)
                        0 : default
                        1 : 신호등 (신호등만 존재)
                        2 : 진출입 (진출입 디바이스만 존재시)
                        3 : 신호등+진출입 (진출입 디바이스 + 그외 디바이스 존재시)
                    -->
                    <c:set var="viewType" value="0"/>
                    <c:forEach var="device" items="${childArea.devices}">
                        <c:choose>
                            <c:when test="${device.deviceCode=='DEV009'}">
                                <c:choose>
                                    <c:when test="${viewType=='0'}">
                                        <c:set var="viewType" value="2"/>
                                    </c:when>
                                    <c:when test="${viewType=='1'}">
                                        <c:set var="viewType" value="3"/>
                                    </c:when>
                                </c:choose>
                            </c:when>
                            <c:otherwise>
                                <c:choose>
                                    <c:when test="${viewType=='0'}">
                                        <c:set var="viewType" value="1"/>
                                    </c:when>
                                    <c:when test="${viewType=='2'}">
                                        <c:set var="viewType" value="3"/>
                                    </c:when>
                                </c:choose>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>

                    <div areaId="${childArea.areaId}">
                        <header>
                            <h3>${childArea.areaName}</h3>
                            <c:if test="${childArea.childAreaIds!=null}">
                                <!-- 구역에 구역이 존재할 때 area -->
                                <button class="area" childAreaIds="${childArea.childAreaIds}" onclick="javascript:moveDashboard('${childArea.areaId}'); return false;" title="AREA VIEW"></button>
                            </c:if>
                            <c:if test="${childArea.devices!=null and fn:length(childArea.devices) > 0}">
                                <c:if test="${viewType=='2' or viewType=='3'}">
                                    <!-- 구역에 진출입 존재할 때 ioset -->
                                    <button class="ioset" title="진출입 설정" onclick="javascript:openInoutConfigListPopup('${childArea.areaId}','${childArea.areaName}'); return false;"></button>
                                </c:if>
                                <!-- 구역에 장치가 존재할 때 device -->
                                <button class="device" title="DEVICE LIST" onclick="javascript:openDeviceListPopup(this); return false;"></button>
                            </c:if>
                        </header>
                        <article>
                            <c:if test="${viewType=='0' or viewType=='1' or viewType=='3'}">
                                <section class="treffic_set">
                                    <c:forEach var="critical" items="${criticalList}">
                                        <div criticalLevel="${critical.codeId}"><p></p></div>
                                    </c:forEach>
                                </section>
                            </c:if>
                            <c:if test="${viewType=='2' or viewType=='3'}">
                                <section class="personnel_set" inoutArea>
                                    <div>
                                        <p gap>0</p>
                                        <p in>0</p>
                                        <p out>0</p>
                                        <p datetime>00:00:00 ~</p>
                                    </div>
                                    <div>
                                        <p gap>0</p>
                                        <p in>0</p>
                                        <p out>0</p>
                                        <p datetime>00:00:00 ~ 23:59:59</p>
                                    </div>
                                </section>
                            </c:if>
                        </article>
                        <c:choose>
                            <c:when test="${childArea.devices != null and fn:length(childArea.devices) > 0}">
                                <!-- 장치 구역일때 장치보기 팝업 삽입 -->
                                <div class="device_popup">
                                    <ul>
                                        <c:forEach var="device" items="${childArea.devices}">
                                            <li <c:if test="${device.linkUrl!=null}">class="cctv_view"</c:if>>
                                                ${device.deviceCodeName}
                                                <c:if test="${device.linkUrl!=null}">
                                                    <button href="#" onclick="javascript:cctvOpen('${device.linkUrl}'); event.stopPropagation();"></button>
                                                </c:if>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </div>
                            </c:when>
                        </c:choose>
                    </div>
                </c:forEach>
            </c:when>
        </c:choose>
    </section>

    <div class="iocount_popup">
        <div>
            <div>
                <header>
                    <h2 areaName></h2>
                    <button class="close_btn" onclick="javascript:closeInoutConfigListPopup();"></button>
                </header>
                <article>
                    <!-- 진출입 모두 보기 셋션 -->
                    <section>
                        <h3><spring:message code="dashboard.title.inoutList"/></h3>
                        <div class="personnel_set"></div>
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

    /*
     url defind
     @author psb
     */
    var urlConfig = {
        eventLogUrl : "${rootPath}/eventLog/dashboard.json"
        ,inoutListUrl : "${rootPath}/eventLogInout/list.json"
        ,inoutDetailUrl : "${rootPath}/eventLogInout/list.json"
        ,saveInoutConfigurationUrl : "${rootPath}/inoutConfiguration/save.json"
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
        for(var key in criticalCss){
            modifyElementClass($(".treffic_set div[criticalLevel='"+key+"']"),"ts-"+criticalCss[key],'add');
        }

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
        dashBoardHelper.addRequestData('eventLog', urlConfig['eventLogUrl'], {areaId:areaId}, dashBoardSuccessHandler, dashBoardFailureHandler);
        /* 진출입 */
        dashBoardHelper.addRequestData('inoutList', urlConfig['inoutListUrl'], {areaIds:getInoutArea()}, dashBoardSuccessHandler, dashBoardFailureHandler);
        /* 이벤트 callback (websocket 리스너) */
        dashBoardHelper.setCallBackEventHandler(appendEventHandler);
        setRefreshTimeCallBack(refreshInoutSetting);
    });

    function refreshInoutSetting(_serverDatetime){
        var refreshFlag = false;
        $.each($(".watch_area div[endDatetime]"),function(){
            if(_serverDatetime.getTime() > $(this).attr("endDatetime")){
                refreshFlag = true;
            }
        });

        if(refreshFlag){
            dashBoardHelper.getData('inoutList');
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
                if(hour<10){ hour = "0" + hour; }
                var minute = Number(numberTags.eq(1).val());
                if(minute<10){ minute = "0" + minute; }
                var second = Number(numberTags.eq(2).val());
                if(second<10){ second = "0" + second; }
                var inoutDateStr = hour + ":" + minute + ":" + second;
                var drawFlag = false;

                for(var index in inoutDatetimes){
                    if(inoutDateStr == inoutDatetimes[index].format("HH:mm:ss")){
                        var endTime = new Date(inoutDatetimes[Number(index)+1]);

                        if(!(endTime == "Invalid Date" || isNaN(endTime))){
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
        $.each($(".watch_area div[areaId]"), function(){
            if($(this).find("section[inoutArea]").length > 0){
                if(areaIds!=""){ areaIds += ",";}
                areaIds += $(this).attr("areaId");
            }
        });

        return areaIds;
    }

    /**
     * 장치목록 팝업 열기
     * @author psb
     */
    function openDeviceListPopup(_this){
        $(_this).toggleClass("on");
        $(_this).parent().parent().toggleClass("on");
    }

    /**
     * 진출입 설정 팝업 열기
     * @author psb
     */
    function openInoutConfigListPopup(_areaId,_areaName){
        $(".iocount_popup").attr("areaId",_areaId);
        $(".iocount_popup h2[areaName]").text(_areaName);
        callAjax('inoutDetail',{areaIds:_areaId});
    }

    /**
     * 진출입 설정 팝업 닫기
     * @author psb
     */
    function closeInoutConfigListPopup(){
        $('.iocount_popup').fadeOut(200);
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
                if(hour<10){ hour = "0" + hour; }
                var minute = Number(numberTags.eq(1).val());
                if(minute<10){ minute = "0" + minute; }
                var second = Number(numberTags.eq(2).val());
                if(second<10){ second = "0" + second; }
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
                inoutAppender(data);
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
            case 'inoutDetail':
                inoutDetailRender(data['eventLogInoutList']);
                break;
            case 'saveInoutConfiguration':
                alertMessage(actionType+'Complete');
                closeInoutConfigListPopup();
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
            $(".watch_area div[areaId]").attr("class","");
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

            var eventCntTag = $(_element).find("[criticalLevel='"+criticalLevel+"'] p");
            if(eventCntTag.length == 0){
                console.debug("[eventLogRender][appendEvent] criticalLevel Tag is not found '" + _data['areaId'] + "' area - " + _data['eventLogId']);
                return false;
            }

            var eventCnt = eventCntTag.text()!="" ? Number(eventCntTag.text()) : 0;
            switch (_config['appendType']){
                case "add" :
                    eventCntTag.text(++eventCnt);
                    modifyElementClass($(_element),"level-"+criticalCss[criticalLevel],'add');
                    break;
                case "remove" :
                    eventCntTag.text(--eventCnt==0?"":eventCnt);
                    if(eventCnt==0){
                        modifyElementClass($(_element),"level-"+criticalCss[criticalLevel],'remove');
                    }
                    break;
            }
        }
    }

    /**
     * 진출입 추가 이벤트 발생시
     */
    function inoutAppender(data){
        var areaTag = $(".watch_area div[areaId='"+data['areaId']+"']");
        if(areaTag.length > 0){
            areaTag.find("section[inoutArea] > div").each(function(){
                var startDatetime = new Date(Number($(this).attr("startDatetime")));
                var endDatetime = new Date(Number($(this).attr("endDatetime")));
                var eventDatetime = new Date(data['eventDatetime']);

                if(eventDatetime>=startDatetime && eventDatetime<=endDatetime){
                    for(var index in data['infos']){
                        var info = data['infos'][index];
                        var updateFlag = false;

                        if(info['key']=="inCount"){
                            var inTag = $(this).find("[in]");
                            var inCount = Number(inTag.text());
                            inCount += Number(info['value']);
                            inTag.text(inCount);
                            updateFlag = true;
                        }else if(info['key']=="outCount"){
                            var outTag = $(this).find("[out]");
                            var outCount = Number(outTag.text());
                            outCount += Number(info['value']);
                            outTag.text(outCount);
                            updateFlag = true;
                        }

                        if(updateFlag){
                            $(this).find("[gap]").text(Number($(this).find("[in]").text())-Number($(this).find("[out]").text()));
                        }
                    }
                }
            });
        }
    }

    /**
     * 구역별 진출입 상태
     */
    function inoutRender(data){
        if(data==null){
            return false;
        }

        var _targetAreaId = null;
        var _eqIndex = 0;

        for(var index in data){
            var inout = data[index];
            var areaTag = $(".watch_area div[areaId='"+inout['areaId']+"']");
            if(areaTag.length > 0){
                if(_targetAreaId==null || _targetAreaId!=inout['areaId']){
                    _targetAreaId = inout['areaId'];
                    _eqIndex = 0;
                }

                var inoutTag = areaTag.find("section[inoutArea] > div:eq("+_eqIndex+")");
                if(inoutTag.length > 0){
                    var inCount = inout['inCount']!=null?inout['inCount']:0;
                    var outCount = inout['outCount']!=null?inout['outCount']:0;
                    inoutTag.find("p[in]").text(inCount);
                    inoutTag.find("p[out]").text(outCount);
                    inoutTag.find("p[gap]").text(inCount-outCount);
                    if(_eqIndex==0){
                        inoutTag.attr("startDatetime",inout['inoutStarttime']);
                        inoutTag.attr("endDatetime",inout['inoutEndtime']);
                        inoutTag.find("p[datetime]").text(new Date(inout['inoutStarttime']).format("HH:mm:ss") + " ~ ");
                    }else{
                        inoutTag.find("p[datetime]").text(new Date(inout['inoutStarttime']).format("HH:mm:ss") + " ~ " + new Date(inout['inoutEndtime']).format("HH:mm:ss"));
                    }
                    _eqIndex++;
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

        var inoutHistoryTag = $(".iocount_popup .personnel_set");
        var inoutDatetimes = [];

        // 진출입 이력초기화
        inoutHistoryTag.empty();

        // 진출입 이력 render
        for(var index in data){
            var inout = data[index];
            var inoutTag = templateHelper.getTemplate("inout");
            var inCount = inout['inCount']!=null?inout['inCount']:0;
            var outCount = inout['outCount']!=null?inout['outCount']:0;
            var inoutStarttime = new Date(inout['inoutStarttime']);
            var inoutEndtime = new Date(inout['inoutEndtime']);

            inoutTag.find("#in").text(inCount);
            inoutTag.find("#out").text(outCount);
            inoutTag.find("#gap").text(inCount-outCount);
            inoutTag.find("#dt").text(inoutStarttime.format("yyyy.MM.dd"));

            if(index==0){
                inoutTag.find("#hms").text(inoutStarttime.format("HH:mm:ss") + " ~ ");
            }else{
                inoutTag.find("#hms").text(inoutStarttime.format("HH:mm:ss") + " ~ " + inoutEndtime.format("HH:mm:ss"));
            }
            inoutHistoryTag.append(inoutTag);
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
        $(".iocount_popup").fadeIn(200);
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

    function minMaxFunc(value, min, max) {
        if(parseInt(value) < min || isNaN(value))
            return 0;
        else if(parseInt(value) > max)
            return max;
        else return value;
    }
</script>