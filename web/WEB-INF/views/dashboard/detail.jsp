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
<section  class="container">
    <!-- 확대보기 레이어 팝업 -->
    <aside class="layer_popup detail_popup">
        <section class="layer_wrap i_type05">
            <article class="layer_area"></article>
        </section>
        <div class="layer_popupbg ipop_close"></div>
    </aside>

    <!-- 진출입 셋팅 레이어 팝업 -->
    <aside class="layer_popup sett_popup">
        <section class="layer_wrap i_type05">
            <article class="layer_area">
                <div class="mp_header">
                    <h2>진출입자 조회 주기 설정</h2>
                    <div>
                        <button class="db_btn zoomclose_btn ipop_close"></button>
                    </div>
                </div>

                <div class="mp_contents vh_mode">
                    <div class="search_contents">
                        <p class="itype_01">
                            <span>구역</span>
                            <span>
                                <select>
                                    <option value="">A-Area</option>
                                    <option value="">B-Area</option>
                                    <option value="">C-Area</option>
                                </select>
                            </span>
                        </p>
                    </div>
                    <div class="mc_element nano ">
                        <div class="time_select_contents nano-content">
                            <div>
                                <div class="check_box_set">
                                    <input type="checkbox" name="" class="check_input">
                                    <label class="lablebase lb_style01"></label>
                                </div>
                                <span>Cycle 01Cycle 01Cycle 01Cycle 01Cycle 01</span>
                                <select>
                                    <option value="">AM</option>
                                    <option value="">PM</option>
                                </select>
                                <input type="number" name="" class="">
                                <input type="number" name="" class="">
                                <input type="number" name="" class="">
                                <p>AM 07:59:59</p>
                            </div>
                            <div>
                                <div class="check_box_set">
                                    <input type="checkbox" name="" class="check_input">
                                    <label class="lablebase lb_style01"></label>
                                </div>
                                <span>Cycle 02</span>
                                <select>
                                    <option value="">AM</option>
                                    <option value="">PM</option>
                                </select>
                                <input type="number" name="" class="">
                                <input type="number" name="" class="">
                                <input type="number" name="" class="">
                                <p>AM 07:59:59</p>
                            </div>
                            <div>
                                <div class="check_box_set">
                                    <input type="checkbox" name="" class="check_input">
                                    <label class="lablebase lb_style01"></label>
                                </div>
                                <span>Cycle 02</span>
                                <select>
                                    <option value="">AM</option>
                                    <option value="">PM</option>
                                </select>
                                <input type="number" name="" class="">
                                <input type="number" name="" class="">
                                <input type="number" name="" class="">
                                <p>AM 07:59:59</p>
                            </div>
                        </div>
                    </div>
                    <div class="lmc_btn_area mc_tline">
                        <button class="btn btype01 bstyle07" name="">저장</button>
                    </div>
                </div>
            </article>
        </section>
        <div class="layer_popupbg ipop_close"></div>
    </aside>

    <!-- 2depth 타이틀 영역 Start -->
    <article class="main_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title">${area.areaName}</h3>
        <!-- 마키 영역 Start -->
        <div id="marqueeList" class="marquee"></div>
        <!-- 마키 영역 End -->
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <article class="dash_contents_area nano">
        <div class="nano-content">
            <div class="metro_root mr_h70">
                <div class="metro_parent v_mode">
                    <div id="workerDiv" title="<spring:message code="dashboard.title.worker"/>">
                        <div class="mp_header">
                            <h2><spring:message code="dashboard.title.worker"/></h2>
                            <div>
                                <button class="db_btn alra_btn">0</button>
                                <button class="db_btn zoom_btn" href="#" onclick="javascript:openDetailPopup('worker');"></button>
                            </div>
                        </div>
                        <div class="mp_contents vh_mode">
                            <div class="mc_element_set nano">
                                <div class="workerContens nano-content">
                                    <c:choose>
                                        <c:when test="${workerEvents != null and fn:length(workerEvents) > 0}">
                                            <c:forEach var="workerEvent" items="${workerEvents}">
                                                <div id="${workerEvent.eventId}" class="mc_element">
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
                                <button class="db_btn alra_btn">0</button>
                                <button class="db_btn zoom_btn" href="#" onclick="javascript:openDetailPopup('crane');"></button>
                            </div>
                        </div>
                        <div class="mp_contents vh_mode">
                            <div class="mc_element_set nano">
                                <div class="craneContens nano-content">
                                    <c:choose>
                                        <c:when test="${craneEvents != null and fn:length(craneEvents) > 0}">
                                            <c:forEach var="craneEvent" items="${craneEvents}">
                                                <div id="${craneEvent.eventId}" class="mc_element">
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
                                <button class="db_btn sett_btn"></button>
                            </div>
                        </div>
                        <div class="mp_contents vh_mode">
                            <div class="personnel">
                                <div id="nowInout" class="now">
                                    <p id="nowInoutDatetime">AM 08:00:00 ~</p>
                                    <span id="nowInoutGap">76</span>
                                    <div id="nowInCnt">98</div>
                                    <div id="nowOutCnt">22</div>
                                </div>
                                <div id="beforeInout" class="past">
                                    <p id="beforeInoutDatetime">AM 08:00:00 ~</p>
                                    <span id="beforeInoutGap">76</span>
                                    <div id="beforeInCnt">98</div>
                                    <div id="beforeOutCnt">22</div>
                                </div>
                            </div>

                            <div id="chart02" class="ct-chart">
                                <div class="mp_header ct-name">
                                    <div>
                                        <span class="ch_name co_gren"><spring:message code="dashboard.column.workerIn"/></span>
                                        <span class="ch_name co_purp"><spring:message code="dashboard.column.workerOut"/></span>
                                        <select name="type">
                                            <option value="">30 min</option>
                                            <option value="">60 min</option>
                                            <option value="">90 min</option>
                                            <option value="">120 min</option>
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
                                <button class="db_btn alra_btn">0</button>
                                <button class="db_btn zoom_btn" href="#" onclick="javascript:openDetailPopup('gas');"></button>
                            </div>
                        </div>
                        <div class="mp_contents">
                            <div class="mc_bico type03 gas_level02">
                                <p>CO2 62% / C 0.5% / H2S 0%</p>
                            </div>
                            <div class="mc_element nano">
                                <ul class="gasList mc_list nano-content"></ul>
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
                                <select name="type">
                                    <option value="">30 min</option>
                                    <option value="">60 min</option>
                                    <option value="">90 min</option>
                                    <option value="">120 min</option>
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
    var targetMenuId = String('${paramBean.areaId}');
    var subMenuId = String('${subMenuId}');
    var areaId = String('${area.areaId}');

    /*
     url defind
     @author psb
     */
    var urlConfig = {
        workerUrl  :   "${rootPath}/eventLogWorker/list.json"
        ,craneUrl  :   "${rootPath}/eventLogCrane/list.json"
        ,inoutUrl  :   "${rootPath}/eventLogInout/list.json"
        ,chartUrl  :   "${rootPath}/eventLogChart/list.json"
    };

    var messageConfig = {
        workerFailure   :'<spring:message code="dashboard.message.workerFailure"/>'
        , craneFailure  :'<spring:message code="dashboard.message.craneFailure"/>'
        , inoutFailure  :'<spring:message code="dashboard.message.inoutFailure"/>'
        , chartFailure  :'<spring:message code="dashboard.message.chartFailure"/>'
    };

    $(document).ready(function(){
        $(".ipop_close").on("click",function(){
           $(".layer_popup").hide();
        });

//        dashBoardHelper.addRequestData('worker', urlConfig['workerUrl'], null, dashBoardSuccessHandler, dashBoardFailureHandler);
//        dashBoardHelper.addRequestData('crane', urlConfig['craneUrl'], null, dashBoardSuccessHandler, dashBoardFailureHandler);
//        dashBoardHelper.addRequestData('inout', urlConfig['inoutUrl'], null, dashBoardSuccessHandler, dashBoardFailureHandler);
    });

    /*
     open detail popup
     @author psb
     */
    function openDetailPopup(type){
        var targetTag = null;

        switch(type){
            case 'worker':
                targetTag = $("#workerDiv");
                break;
            case 'crane':
                targetTag = $("#craneDiv");
                break;
            case 'gas':
                targetTag = $("#gasDiv");
                break;
        }

        if(targetTag==null){
            console.error("[openDetailPopup] error - type fail");
            return false;
        }

        var headerTag = targetTag.find(".mp_header").clone();
        var contentsTag = targetTag.find(".mp_contents").clone();

        modifyElementClass(contentsTag,'vh_mode','remove');
        modifyElementClass(contentsTag.find(".mc_element"),'mc_tline','remove');

        $(".detail_popup .layer_area").empty().append(headerTag).append(contentsTag);
        $(".detail_popup").show();
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
            case 'chart':
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
                    workerEventCnt++;
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
                    craneEventCnt++;
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
                    modifyElementClass(buttonTag,'level03','remove');

                    if(buttonTag.find("#beforeGap").length>0){
                        buttonTag.find("#beforeGap").remove();
                    }
                }
            }

            if(inoutEventCnt>0){
                modifyElementClass($("#inoutDiv"),'level02','add');
            }else{
                modifyElementClass($("#inoutDiv"),'level03','remove');
            }
        }
    }

    /*
     ajax error handler
     @author psb
     */
    function dashBoardFailureHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        alertMessage(actionType + 'Failure');
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