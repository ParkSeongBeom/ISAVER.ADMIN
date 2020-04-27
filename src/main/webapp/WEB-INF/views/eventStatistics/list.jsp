<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set value="2A0020" var="menuId"/>
<c:set value="2A0000" var="subMenuId"/>

<link href="${rootPath}/assets/css/school.css?version=${version}" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="${rootPath}/assets/library/chartist/chartist.min.css" >
<link rel="stylesheet" type="text/css" href="${rootPath}/assets/library/chartist/chartist-plugin-tooltip.css" >
<script type="text/javascript" src="${rootPath}/assets/library/chartist/chartist.min.js"></script>
<script type="text/javascript" src="${rootPath}/assets/library/chartist/chartist-plugin-tooltip.js"></script>
<script type="text/javascript" src="${rootPath}/assets/library/excelexport/jquery.techbytarun.excelexportjs.js"></script>
<script src="${rootPath}/assets/library/svg/jquery.svg.js?version=${version}" type="text/javascript" ></script>
<script src="${rootPath}/assets/library/svg/jquery.svgdom.js?version=${version}" type="text/javascript" ></script>
<script src="${rootPath}/assets/js/page/dashboard/custom-map-mediator.js?version=${version}" type="text/javascript" charset="UTF-8"></script>
<script src="${rootPath}/assets/library/d3/d3.min.js?version=${version}" type="text/javascript" ></script>
<script src="${rootPath}/assets/library/d3/MultiLine.js?version=${version}" type="text/javascript" ></script>
<script src="${rootPath}/assets/library/jspdf/jspdf.debug.js?version=${version}" type="text/javascript" ></script>
<script src="${rootPath}/assets/library/jspdf/html2canvas.min.js?version=${version}" type="text/javascript" ></script>
<script src="${rootPath}/assets/library/d3/d3-save-svg.js?version=${version}" type="text/javascript" ></script>

<style>
    .securityReportPop .set-chart {
        height:100%;
    }
    .securityReportPop .set-chart .canvas-chart {
        min-width: auto;
        padding-right: 0;
        padding-left: 0;
        padding-bottom: 10px;
    }
    .securityReportPop .set-chart > .chart_label > * {
        padding: 0 10px 15px 0;
    }
    .securityReportPop .chart_label.header{
        overflow: auto;
        height: 175px;
    }
</style>

<div class="sub_title_area">
    <h3 class="1depth_title"><spring:message code="common.title.eventStatistics"/></h3>
    <div class="navigation">
        <span><isaver:menu menuId="${menuId}" /></span>
    </div>
</div>

<!-- section Start -->
<section class="container sub_area">
    <!-- 트리 영역 Start -->
    <article class="flex-area-w eventStatistics">
        <!-- 목록 -->
        <section class="box-list">
            <!-- 목록 상단 버튼 영역 -->
            <div class="set-btn type-01">
                <button class="ico-plus" onclick="detailRender(null,true);"></button>
                <div class="set-option">
                    <select id="autoRefresh" onchange="javascript:autoSearch();">
                        <option value="" selected="selected"><spring:message code="common.column.selectNo"/></option>
                        <option value="10">10<spring:message code="common.column.second"/></option>
                        <option value="30">30<spring:message code="common.column.second"/></option>
                        <option value="60">1<spring:message code="common.column.minute"/></option>
                        <option value="300">5<spring:message code="common.column.minute"/></option>
                        <option value="600">10<spring:message code="common.column.minute"/></option>
                        <option value="1800">30<spring:message code="common.column.minute"/></option>
                        <option value="3600">1<spring:message code="common.column.hour"/></option>
                    </select>
                </div>
            </div>
            <!--
            목록 영역

            1. 선택된 항목에 <li>에 class "on"을 추가 시 반응
            2. 선택 차트 저장 항목에 선택 차트 class 부여.
                ex) <i class="ico-chartl"></i> 라인차트 선택되어 자장 시 class "ico-chartl" 삽입하여
                    해당 항목에 선택 저장된 차트 아이콘 표출.
            -->
            <ul class="set-ul eventstatistics" id="statisticsList"></ul>
            <!-- 목록 상단 버튼 영역 -->
            <div class="set-btn type-01">
                <button class="ico-tracker" style="width: 100%;" onclick="openHeatMapPopup();">HeatMap</button>
                <button class="ico-tracker" style="width: 100%;" onclick="openSecurityReportPopup();">Security Report</button>
            </div>
        </section>

        <!-- 상세 -->
        <section class="box-detail school">
            <!-- 상세 상단 버튼 영역 -->
            <div class="set-btn type-01">
                <button class="ico-play" title="<spring:message code="statistics.placeholder.play"/>" onclick="search();"></button>
                <button class="ico-copy" title="<spring:message code="statistics.placeholder.copy"/>" onclick="addStatistics();"></button>
                <button class="ico-save" title="<spring:message code="statistics.placeholder.save"/>" onclick="saveStatistics();"></button>
                <div class="set-option">
                    <button class="ico-option option-open" onclick="$('.set-option').toggleClass('on'); $('.option-popup').toggleClass('on');"></button>
                    <div class="set-itembox option-popup">
                        <h4>OPTION</h4>
                        <div class="set-item">
                            <h4><spring:message code="statistics.column.fenceAutoComplete"/></h4>
                            <div>
                                <spring:message code="common.selectbox.notSelect" var="notSelectText"/>
                                <isaver:areaSelectBox htmlTagId="autoCompleteAreaId" allModel="true" allText="${notSelectText}" templateCode="TMP005,TMP012"/>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!--
            1. 상세 각 항목은 <div class="set-item"> 안에 삽입.
            2. 열고 닫기가 필요한 항목은  <div class="set-itembox"> 레이어 안에 삽입.
                <button class="ico-open"> 클릭 시 열고 닫기 작동.
            -->
            <div class="set-area">
                <input type="hidden" id="statisticsId" />
                <div class="set-item">
                    <h4>Name</h4>
                    <div>
                        <input type="text" id="statisticsName" />
                    </div>
                    <h4>Template</h4>
                    <div>
                        <select id="template" onchange="templateChange(this);">
                            <option value="custom"><spring:message code="statistics.selectbox.custom"/></option>
                            <option value="crossing"><spring:message code="statistics.selectbox.crossing"/></option>
                            <option value="trespassers"><spring:message code="statistics.selectbox.trespassers"/></option>
                            <option value="vehicleTraffic"><spring:message code="statistics.selectbox.vehicleTraffic"/></option>
                            <option value="speedingVehicleTraffic"><spring:message code="statistics.selectbox.speedingVehicleTraffic"/></option>
                            <option value="vehicleSpeed"><spring:message code="statistics.selectbox.vehicleSpeed"/></option>
                            <option value="vehicleSpeedTime"><spring:message code="statistics.selectbox.vehicleSpeedTime"/></option>
                        </select>
                    </div>
                    <h4 class="countingMethod">집계방식</h4>
                    <div class="countingMethod">
                        <select class="select-chart" id="countingMethod">
                            <option value="max">Max</option>
                            <option value="min">Min</option>
                            <option value="avg">Avg</option>
                        </select>
                    </div>
                </div>

                <div id="customDetail">
                    <div class="set-item">
                        <h4>Chart Type</h4>
                        <div>
                            <select id="chartType">
                                <option value=""><spring:message code="common.selectbox.select"/></option>
                                <option value="line">Line Chart</option>
                                <option value="bar">Bar Chart</option>
                                <option value="pie">Pie Chart</option>
                                <option value="table">Data Table</option>
                            </select>
                        </div>
                        <h4>Collection</h4>
                        <div>
                            <select id="collectionName">
                                <option value="eventLog">Event Log</option>
                                <option value="tracking">Tracking</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div id="xAxis">
                    <div class="set-itembox">
                        <h4>X-Axis</h4>
                        <div class="set-item">
                            <h4>Interval</h4>
                            <div>
                                <select name="interval">
                                    <option value="day">Day</option>
                                    <option value="week">Week</option>
                                    <option value="month">Month</option>
                                    <option value="year">Year</option>
                                </select>
                            </div>
                            <h4>Term</h4>
                            <div>
                                <input type="text" id="startDatetime" class="datepicker dpk_normal_type" placeholder='<spring:message code="statistics.placeholder.start"/>'/>
                                <select id="startDtHour"></select>
                            </div>
                            <div>
                                <input type="text" id="endDatetime" class="datepicker dpk_normal_type" placeholder='<spring:message code="statistics.placeholder.end"/>'/>
                                <select id="endDtHour"></select>
                            </div>
                        </div>
                    </div>
                </div>

                <div id="templateDetail">
                    <!-- s : 조회 조건 -->
                    <div class="set-itembox">
                        <h4><spring:message code="statistics.title.condition"/></h4>
                        <button class="ico-open on" onclick="$(this).toggleClass('on');"></button> <!-- 열고 닫기 버튼 -->
                        <!-- s : 펜스선택 -->
                        <div class="set-item">
                            <h4>Fence</h4>
                            <div class="type01">
                                <c:forEach var="fence" items="${fenceList}">
                                    <c:if test="${fence.fenceType=='normal'}">
                                        <div class="csl_style07">
                                            <input type="checkbox" name="fences" fenceSubType="${fence.fenceSubType}" areaName="${fence.areaName}" fenceName="${fence.fenceName}" value="${fence.fenceId}">
                                            <label></label>
                                            <span>[${fence.areaName}] ${fence.fenceName}</span>
                                        </div>
                                    </c:if>
                                </c:forEach>
                            </div>
                        </div>
                        <!-- s : 이벤트 선택 -->
                        <div class="set-item ">
                            <h4>Event</h4>
                            <div class="type01">
                                <c:forEach var="event" items="${eventList}">
                                    <c:if test="${event.eventId=='EVT314' or event.eventId=='EVT316' or event.eventId=='EVT320'}">
                                        <div class="csl_style07">
                                            <input type="checkbox" name="events" value="${event.eventId}">
                                            <label></label>
                                            <span>${event.eventName}</span>
                                        </div>
                                    </c:if>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                    <!-- s : 추가 옵션 -->
                    <div class="set-itembox">
                        <h4><spring:message code="statistics.title.options"/></h4>
                        <button class="ico-open on" onclick="$(this).toggleClass('on');"></button> <!-- 열고 닫기 버튼 -->
                        <div class="set-item ">
                            <h4>Option</h4>
                            <div class="type01">
                                <!-- s : title -->
                                <div class="set-column">
                                    <p><spring:message code="statistics.title.condition"/></p>
                                    <p><spring:message code="statistics.title.conditionType"/></p>
                                    <p><spring:message code="statistics.title.conditionRange"/></p>
                                </div>
                                <!-- s : 부피 -->
                                <div class="set-column addOption" name="size.x">
                                    <div>
                                        <p><spring:message code="statistics.column.volume"/> Width(X)</p>
                                    </div>
                                    <div class="selectbox-type01">
                                        <select name="type">
                                            <option value=""><spring:message code="statistics.selectbox.typeNone"/></option>
                                            <option value="include"><spring:message code="statistics.selectbox.typeInclude"/></option>
                                            <option value="exclude"><spring:message code="statistics.selectbox.typeExclude"/></option>
                                        </select>
                                    </div>
                                    <div class="selectbox-type01">
                                        <div>
                                            <input type="number" name="start" onkeypress="isNumberWithPoint(this);">
                                            <input type="number" name="end" onkeypress="isNumberWithPoint(this);">
                                        </div>
                                    </div>
                                </div>
                                <div class="set-column addOption" name="size.y">
                                    <div>
                                        <p><spring:message code="statistics.column.volume"/> Height(Y)</p>
                                    </div>
                                    <div class="selectbox-type01">
                                        <select name="type">
                                            <option value=""><spring:message code="statistics.selectbox.typeNone"/></option>
                                            <option value="include"><spring:message code="statistics.selectbox.typeInclude"/></option>
                                            <option value="exclude"><spring:message code="statistics.selectbox.typeExclude"/></option>
                                        </select>
                                    </div>
                                    <div class="selectbox-type01">
                                        <div>
                                            <input type="number" name="start" onkeypress="isNumberWithPoint(this);">
                                            <input type="number" name="end" onkeypress="isNumberWithPoint(this);">
                                        </div>
                                    </div>
                                </div>
                                <div class="set-column addOption" name="size.z">
                                    <div>
                                        <p><spring:message code="statistics.column.volume"/> Depth(Z)</p>
                                    </div>
                                    <div class="selectbox-type01">
                                        <select name="type">
                                            <option value=""><spring:message code="statistics.selectbox.typeNone"/></option>
                                            <option value="include"><spring:message code="statistics.selectbox.typeInclude"/></option>
                                            <option value="exclude"><spring:message code="statistics.selectbox.typeExclude"/></option>
                                        </select>
                                    </div>
                                    <div class="selectbox-type01">
                                        <div>
                                            <input type="number" name="start" onkeypress="isNumberWithPoint(this);">
                                            <input type="number" name="end" onkeypress="isNumberWithPoint(this);">
                                        </div>
                                    </div>
                                </div>
                                <!-- s : 높이 -->
                                <div class="set-column addOption" name="z">
                                    <div>
                                        <p><spring:message code="statistics.column.height"/></p>
                                    </div>
                                    <div class="selectbox-type01">
                                        <select name="type">
                                            <option value=""><spring:message code="statistics.selectbox.typeNone"/></option>
                                            <option value="include"><spring:message code="statistics.selectbox.typeInclude"/></option>
                                            <option value="exclude"><spring:message code="statistics.selectbox.typeExclude"/></option>
                                        </select>
                                    </div>
                                    <div class="selectbox-type01">
                                        <div>
                                            <input type="number" name="start" onkeypress="isNumberWithPoint(this);">
                                            <input type="number" name="end" onkeypress="isNumberWithPoint(this);">
                                        </div>
                                    </div>

                                </div>
                                <!-- s : 속도 -->
                                <div class="set-column addOption" name="speed">
                                    <div>
                                        <p><spring:message code="statistics.column.speed"/></p>
                                    </div>
                                    <div class="selectbox-type01">
                                        <select name="type">
                                            <option value=""><spring:message code="statistics.selectbox.typeNone"/></option>
                                            <option value="include"><spring:message code="statistics.selectbox.typeInclude"/></option>
                                            <option value="exclude"><spring:message code="statistics.selectbox.typeExclude"/></option>
                                        </select>
                                    </div>
                                    <div class="selectbox-type01">
                                        <div>
                                            <input type="number" name="start" onkeypress="isNumberWithPoint(this);">
                                            <input type="number" name="end" onkeypress="isNumberWithPoint(this);">
                                        </div>
                                    </div>
                                </div>
                                <!-- s : 집중 시간대표시 -->
                                <div class="set-column">
                                    <div class="csl_style07">
                                        <input type="checkbox" name="intensiveTime">
                                        <label></label>
                                        <span><spring:message code="statistics.column.intensiveTime"/></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- school 영역 -->
        <section class="box-ctbox">
            <header class="pdfSaveTitleElement">
                <h4 name="templateName"></h4>
                <button class="ico-excel" data-html2canvas-ignore="true" onclick="schoolExcelDownload();"></button>
                <button class="ico-pdf" data-html2canvas-ignore="true" onclick="schoolPdfDownload();"></button>
            </header>
            <article>
                <div class="chart-canvas">
                    <div class="expl-sub zone pdfSaveTitleElement" name="fenceTitle"></div>
                    <div>
                        <!-- 차트 삽입 레이어 -->
                        <div class="o-line chart-box" name="lineChart"></div>
                    </div>
                </div>
                <div class="chart-table">
                    <header class="pdfSaveElement">
                        <h4><spring:message code="statistics.column.statisticsReport"/></h4>
                        <%--<input type="text" readonly  value="이벤트 명 + 추가조회옵션 조건 선택명" >--%>
                        <%--<input type="text" readonly  value="2020-03-19 합계 or 평균" >--%>
                    </header>

                    <div class="d_defalut d_type01 pdfSaveElement" name="defaultTable">
                        <div class="d_thead">
                            <div name="gubn"></div>
                            <div name="fenceName"></div>
                        </div>
                        <div class="d_tbody"></div>
                    </div>

                    <!-- 가장 많은 시간대 -->
                    <div class="d_defalut d_type01 pdfSaveElement" name="mostTimeTable">
                        <div class="d_thead">
                            <div>
                                <span><spring:message code="statistics.column.mostTimeZone"/></span>
                                <span><spring:message code="statistics.column.personnel"/></span>
                            </div>
                        </div>
                        <div class="d_tbody"></div>
                    </div>

                    <!-- 구역별 분포도 -->
                    <div class="d_defalut d_type01 pdfSaveElement" name="distTable">
                        <div class="d_thead"><!-- thead -->
                            <div>
                                <span><spring:message code="statistics.column.distAreaChart"/></span>
                                <span>%</span>
                            </div>  <!-- head -->
                        </div>
                        <div class="d_tbody"></div>
                    </div>
                </div>
            </article>
        </section>

        <!-- custom 차트 -->
        <section class="box-chart"></section>

        <!-- 로딩바 -->
        <section class="loding_bar"></section>

        <!-- 조회전 조건 입력 안내 멘트 -->
        <section class="ment box-ment">
            <div>Click the after-view button</div>
        </section>
    </article>
    <!-- 트리 영역 End -->

    <div id="excelEventStatisticsList" style="display:none;"></div>
</section>

<select name="fenceList" style="display:none;">
    <c:forEach var="fence" items="${fenceList}">
        <option style="display:none;" areaId="${fence.areaId}" value="${fence.fenceId}">${fence.fenceName}</option>
    </c:forEach>
</select>

<section class="popup-layer">
    <!-- 히트맵 팝업 -->
    <div class="popupbase map_pop heatMapPop">
        <div>
            <div>
                <header>
                    <h2>HeatMap</h2>
                    <button onclick="closeHeatMapPopup();"></button>
                </header>

                <article class="search_area" style="height:auto;">
                    <div class="search_contents">
                        <spring:message code="common.selectbox.select" var="allSelectText"/>
                        <!-- 일반 input 폼 공통 -->
                        <p class="itype_01">
                            <span><spring:message code="statistics.column.area" /></span>
                            <span><isaver:areaSelectBox htmlTagName="areaId" allModel="true" allText="${allSelectText}"/></span>
                        </p>
                        <p class="itype_04">
                            <span><spring:message code="statistics.column.datetime" /></span>
                            <span class="plable04">
                                <input type="text" name="startDatetimeStr" />
                                <select id="startDatetimeHourSelect" name="startDatetimeHour"></select>
                                <em>~</em>
                                <input type="text" name="endDatetimeStr" />
                                <select id="endDatetimeHourSelect" name="endDatetimeHour"></select>
                            </span>
                        </p>
                        <p class="itype_04">
                            <span><spring:message code="statistics.column.fenceName" /></span>
                            <span>
                                <select name="fenceId">
                                    <option value=""><spring:message code="common.selectbox.select"/></option>
                                </select>
                            </span>
                        </p>
                        <p class="itype_04">
                            <span><spring:message code="statistics.column.speed" /></span>
                            <span class="plable04">
                                <input type="number" name="startSpeed" onkeypress="isNumberWithPoint(this);"/>
                                <em>~</em>
                                <input type="number" name="endSpeed" onkeypress="isNumberWithPoint(this);"/>
                            </span>
                        </p>
                    </div>
                    <div class="search_btn">
                        <button onclick="searchHeatMap(); return false;" class="btn bstyle01 btype01"><spring:message code="common.button.search"/></button>
                    </div>
                </article>

                <div class="trackinghistory-box">
                    <article class="map_sett_box">
                        <section class="map">
                            <div>
                                <div name="mapElement" class="map_images"></div>
                                <div class="loding_bar"></div>
                            </div>
                        </section>
                    </article>
                </div>
            </div>
        </div>
        <div class="bg option_pop_close" onclick="closeHeatMapPopup();"></div>
    </div>

    <!-- 보안리포트 팝업 -->
    <div class="popupbase map_pop securityReportPop">
        <div>
            <div>
                <header>
                    <h2>Security Report</h2>
                    <button onclick="closeSecurityReportPopup();"></button>
                </header>

                <article class="search_area" style="height:auto;">
                    <div class="search_contents">
                        <spring:message code="common.selectbox.select" var="allSelectText"/>
                        <!-- 일반 input 폼 공통 -->
                        <p class="itype_01">
                            <span><spring:message code="statistics.column.area" /></span>
                            <span><isaver:areaSelectBox htmlTagName="areaId" allModel="true" allText="${allSelectText}"/></span>
                        </p>
                        <p class="itype_04">
                            <span><spring:message code="statistics.column.datetime" /></span>
                            <span><input type="text" name="securityDatetime" /></span>
                        </p>
                    </div>
                    <div class="search_btn">
                        <button onclick="searchSecurityReport(); return false;" class="btn bstyle01 btype01"><spring:message code="common.button.search"/></button>
                    </div>
                </article>

                <div style="height:100%">
                    <div style="background-color: white; color: #3c3c3c; width: 45%; height:100%; float:left;">
                        <section style="border-style: solid; border-width: 1px;border-color: #040404; width:100%; height: 100%">
                            <div class="securityChart1" style="width:100%; height:50%">
                                <section class="box-chart" style="width:100%; height:100%"></section>
                            </div>
                            <div class="securityChart2" style="width:100%; height:50%">
                                <section class="box-chart" style="width:100%; height:100%"></section>
                            </div>
                        </section>
                    </div>
                    <div style="float:right; width: 55%; height:100%;" class="trackinghistory-box">
                        <article class="map_sett_box">
                            <section class="map">
                                <div>
                                    <div name="mapElement" class="map_images"></div>
                                </div>
                            </section>
                        </article>
                    </div>
                    <div class="loding_bar"></div>
                </div>
            </div>
        </div>
        <div class="bg option_pop_close" onclick="closeSecurityReportPopup();"></div>
    </div>
</section>

<script type="text/javascript">
    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');

    var urlConfig = {
        'listUrl':'${rootPath}/eventStatistics/list.json'
        ,'searchUrl':'${rootPath}/eventStatistics/search.json'
        ,'addUrl':'${rootPath}/eventStatistics/add.json'
        ,'saveUrl':'${rootPath}/eventStatistics/save.json'
        ,'removeUrl':'${rootPath}/eventStatistics/remove.json'
        ,'heatMapUrl':'${rootPath}/notification/heatMap.json'
    };

    var messageConfig = {
        'searchFailure':'<spring:message code="statistics.message.searchFailure"/>'
        ,'emptyStatisticsName':'<spring:message code="statistics.message.emptyStatisticsName"/>'
        ,'emptyChartType':'<spring:message code="statistics.message.emptyChartType"/>'
        ,'emptyStartDatetime':'<spring:message code="statistics.message.emptyStartDatetime"/>'
        ,'emptyEndDatetime':'<spring:message code="statistics.message.emptyEndDatetime"/>'
        ,'earlyDatetime':'<spring:message code="statistics.message.earlyDatetime"/>'
        ,'emptyArea':'<spring:message code="statistics.message.emptyArea"/>'
        ,'emptyFence':'<spring:message code="statistics.message.emptyFence"/>'
        ,'emptyEvent':'<spring:message code="statistics.message.emptyEvent"/>'
        ,   addConfirmMessage  :'<spring:message code="common.message.addConfirm"/>'
        ,   saveConfirmMessage  :'<spring:message code="common.message.saveConfirm"/>'
        ,   removeConfirmMessage  :'<spring:message code="common.message.removeConfirm"/>'
        ,   addComplete        :'<spring:message code="common.message.addComplete"/>'
        ,   saveComplete        :'<spring:message code="common.message.saveComplete"/>'
        ,   removeComplete        :'<spring:message code="common.message.removeComplete"/>'
        ,   addFailure         :'<spring:message code="common.message.addFailure"/>'
        ,   saveFailure         :'<spring:message code="common.message.saveFailure"/>'
        ,   removeFailure         :'<spring:message code="common.message.removeFailure"/>'
    };

    var chartClass = {
        'line' : 'ico-chartl'
        ,'bar' : 'ico-chartb'
        ,'pie' : 'ico-chartc'
        ,'table' : 'ico-chartt'
    };
    var autoCompleteEvt = {
        "EVT314":"거수자 감지"
        ,"EVT316":"Object 감지"
        ,"EVT320":"챠량 감지"
    };
    var statisticsList = {};
    var searchToggleId = "";
    var autoRefInterval = null;
    var customMapMediator;
    // template 기준정보
    let templateInfo = {
        'crossing' : { // 보행자 인원(횡단보도)
            'eventId' : 'EVT314'
            ,'fenceSubType' : 'crosswalk'
        }
        ,'trespassers' : { // 보행자 인원(무단횡단)
            'eventId' : 'EVT314'
            ,'fenceSubType' : 'driveway'
        }
        ,'vehicleTraffic' : { // 차량 통행량
            'eventId' : 'EVT320'
            ,'fenceSubType' : 'driveway'
        }
        ,'speedingVehicleTraffic' : { // 과속차량 통행량
            'eventId' : 'EVT320'
            ,'fenceSubType' : 'driveway'
        }
        ,'vehicleSpeed' : { // 위치별 차량 속도(속도별)
            'eventId' : 'EVT320'
            ,'fenceSubType' : 'driveway'
        }
        ,'vehicleSpeedTime' : { // 위치별 차량 속도(시간대별)
            'eventId' : 'EVT320'
            ,'fenceSubType' : 'driveway'
        }
    };


    var conditionTag = $("<div/>",{name:'condition'}).append(
        $("<input/>",{type:'text',name:'key'})
    ).append(
        $("<select/>",{name:'type'}).append(
            $("<option/>",{value:'$eq'}).text("=")
        ).append(
            $("<option/>",{value:'$gt'}).text("<")
        ).append(
            $("<option/>",{value:'$lt'}).text(">")
        ).append(
            $("<option/>",{value:'$gte'}).text("<=")
        ).append(
            $("<option/>",{value:'$lte'}).text(">=")
        )
    ).append(
        $("<input/>",{type:'text',name:'value'})
    ).append(
        $("<button/>",{class:'ico-close'})
    );

    $(document).ready(function(){
        calendarHelper.load($('#startDatetime'));
        calendarHelper.load($('#endDatetime'));
        calendarHelper.load($('input[name=startDatetimeStr]'));
        calendarHelper.load($('input[name=endDatetimeStr]'));
        calendarHelper.load($('input[name=securityDatetime]'));
        setHourDataToSelect($('#startDtHour'),"00");
        setHourDataToSelect($('#endDtHour'),"23");
        setHourDataToSelect($('#startDatetimeHourSelect'),"00");
        setHourDataToSelect($('#endDatetimeHourSelect'),"23");

        $('input[name=startDatetimeStr]').val(serverDatetime.format("yyyy-MM-dd"));
        $('input[name=endDatetimeStr]').val(serverDatetime.format("yyyy-MM-dd"));
        $('#startDatetimeHourSelect').val(serverDatetime.format("HH")).prop("selected",true);
        getList();

        $("#autoCompleteAreaId").on("change",function(){
            $("#template option:eq(0)").prop("selected",true).trigger("change");
            let areaId = $(this).val();
            if(areaId!=null && areaId!=""){
                $(".box-detail div[name='yAxis']").remove();
                $.each($("select[name='fenceList'] option[areaId='"+areaId+"']"),function(){
                    var index = 0;
                    for(var eventId in autoCompleteEvt){
                        addYaxis({
                            aggregation:"count"
                            ,field:"eventId"
                            ,label:autoCompleteEvt[eventId]+"("+$(this).text()+")"
                            ,index : index
                            ,condition:[
                                {
                                    key:"eventId"
                                    ,type:"$eq"
                                    ,value:eventId
                                },
                                {
                                    key:"fenceId"
                                    ,type:"$eq"
                                    ,value:$(this).val()
                                }
                            ]
                        });
                        index++;
                    }
                });
                if($(".box-detail div[name='yAxis']").length==0){
                    addYaxis(null, true);
                }
            }
        });

        $(".heatMapPop select[name='areaId']").on("change",function() {
            var fenceTag = $(".heatMapPop select[name='fenceId']");
            $(fenceTag).val("");
            $(fenceTag).find("option").not("option[value='']").remove();

            $.each($("select[name='fenceList'] option[areaId='"+$(this).val()+"']"),function(){
                $(fenceTag).append(
                    $("<option/>",{value:$(this).val()}).text($(this).text())
                );
            });
            $(fenceTag).find("option:eq(0)").prop("selected",true);
        });
    });

    function templateChange(_this){
        let template = _this.value;
        if(template=='custom'){
            $("#customDetail").show();
            $("#templateDetail").hide();
            $(".countingMethod").hide();
        }else{
            if(template=='vehicleSpeed' || template=='vehicleSpeedTime'){
                $(".countingMethod").show();
            }else{
                $(".countingMethod").hide();
            }

            $("#customDetail").hide();
            $("#templateDetail").show();
            $("#templateDetail").find("input[name='fences']").not("[fenceSubType='"+templateInfo[template]['fenceSubType']+"']").prop("checked",false).parent().hide();
            $("#templateDetail").find("input[name='events']").not("[value='"+templateInfo[template]['eventId']+"']").prop("checked",false).parent().hide();

            if(templateInfo[template]!=null){
                $("#templateDetail").find("input[name='fences'][fenceSubType='"+templateInfo[template]['fenceSubType']+"']").parent().show();
                $("#templateDetail").find("input[name='events'][value='"+templateInfo[template]['eventId']+"']").parent().show();
            }
        }
    }

    function validate(type) {
        if ($("#statisticsName").val() == null || $("#statisticsName").val().trim() == '') {
            alertMessage('emptyStatisticsName');
            return false;
        }
        if ($("#chartType").val() == null || $("#chartType").val().trim() == '') {
            alertMessage('emptyChartType');
            return false;
        }

        switch (type){
            case "search":
                if($("#template").val()!='custom'){
                    var fences = $("input[name='fences']:checked").map(function(i,el){
                        return {
                            "fenceId":$(el).val()
                            ,"fenceName":$(el).attr("fenceName")
                            ,"areaName":$(el).attr("areaName")
                        };
                    }).get();
                    if(fences.length==0){
                        alertMessage('emptyFence');
                        return false;
                    }

                    var events =  $("input[name='events']:checked").map(function(i,el){ return $(el).val();}).get();
                    if(events.length==0){
                        alertMessage('emptyEvent');
                        return false;
                    }
                }
                break;
        }
//        if ($("#startDatetime").val() == null || $("#startDatetime").val().trim() == '') {
//            alertMessage('emptyStartDatetime');
//            return false;
//        }
//        if ($("#endDatetime").val() == null || $("#endDatetime").val().trim() == '') {
//            alertMessage('emptyEndDatetime');
//            return false;
//        }
        return true;
    }

    function getParam(xAxisAutoDate){
        let startDatetime = "";
        let endDatetime = "";
        if(xAxisAutoDate==true){
            startDatetime = new Date().format("yyyy-MM-dd 00:00:00");
            endDatetime = new Date().format("yyyy-MM-dd 23:59:59");
        }
        if($("#startDatetime").val()!=''){
            startDatetime = $("#startDatetime").val() + " " + $("#startDtHour option:selected").val()+":00:00";
        }
        if($("#endDatetime").val()!=''){
            endDatetime = $("#endDatetime").val() + " " + $("#endDtHour option:selected").val()+":00:00";
        }

        if($("#template option:selected").val()=='custom'){
            var jsonData = {
                "xAxis" : {
                    'interval' : $("select[name='interval'] option:selected").val()
                    ,'startDatetime' : startDatetime
                    ,'endDatetime' : endDatetime
                },
                "yAxis" : []
            };

            var index = 0;
            $.each($("div[name='yAxis']"),function(){
                let yAxis = {
                    'aggregation' : $(this).find("select[name='aggregation'] option:selected").val()
                    ,'field' : $(this).find("input[name='field']").val()
                    ,'label' : $(this).find("input[name='label']").val()
                    ,'index' : index
                    ,'condition' : []
                };
                $.each($(this).find("div[name='condition']"),function(){
                    if($(this).find("input[name='key']").val().trim()!='' && $(this).find("input[name='value']").val().trim()!=''){
                        let condition = {
                            'key' : $(this).find("input[name='key']").val()
                            ,'value' : $(this).find("input[name='value']").val()
                            ,'type' : $(this).find("select[name='type'] option:selected").val()
                        };
                        yAxis['condition'].push(condition);
                    }
                });
                jsonData['yAxis'].push(yAxis);
                index++;
            });

            return {
                'statisticsId' : $("#statisticsId").val()
                ,'statisticsName' : $("#statisticsName").val()
                ,'chartType' : $("#chartType option:selected").val()
                ,'collectionName' : $("#collectionName option:selected").val()
                ,'template' : $("#template option:selected").val()
                ,'jsonData' : JSON.stringify(jsonData)
            };
        }else{
            var jsonData = {
                "xAxis" : {
                    'interval' : $("select[name='interval'] option:selected").val()
                    ,'startDatetime' : startDatetime
                    ,'endDatetime' : endDatetime
                }
                ,"rows" : $("input[name='fences']:checked").map(function(i,el){
                    return {
                        "fenceId":$(el).val()
                        ,"fenceName":$(el).attr("fenceName")
                        ,"areaName":$(el).attr("areaName")
                    };
                }).get()
                ,'condition' : [
                    {
                        "key" : "eventId"
                        ,"type" : "$in"
                        ,"value" : $("input[name='events']:checked").map(function(i,el){ return $(el).val();}).get()
                    }
                ]
                ,"group" : {
                    "aggregation" : "count"
                    ,"field" : "$location.speed"
                    ,"customLabel" : []
                }
                ,"customCondition" : []
                ,'intensiveTime' : $("input[name='intensiveTime']").is(":checked")
            };

            switch ($("#template option:selected").val()){
                case "speedingVehicleTraffic":
                    jsonData['condition'].push({
                        'key' : 'criticalLevel'
                        ,'type' : '$eq'
                        ,'value' : 'LEV003'
                    });
                    break;
                case "vehicleSpeed":
                    let countingMethod = $("#countingMethod option:selected").val();
                    jsonData['group']['customLabel'].push("~10km/h");
                    jsonData['group']['customLabel'].push("~20km/h");
                    jsonData['group']['customLabel'].push("~30km/h");
                    jsonData['group']['customLabel'].push("~40km/h");
                    jsonData['group']['customLabel'].push("~50km/h");
                    jsonData['group']['customLabel'].push("~60km/h");
                    jsonData['group']['customLabel'].push("~70km/h");
                    jsonData['group']['customLabel'].push("~80km/h");
                    jsonData['group']['customLabel'].push("~90km/h");
                    jsonData['group']['customLabel'].push("~100km/h");
                    jsonData['group']['aggregation'] = countingMethod;
                    break;
                case "vehicleSpeedTime":
                    jsonData['group']['aggregation'] = $("#countingMethod option:selected").val();
                    break;
            }
            $.each($(".addOption"),function(){
                jsonData['customCondition'].push({
                    'key' : $(this).attr("name")
                    ,'type' : $(this).find("select[name='type'] option:selected").val()
                    ,'start' : Number($(this).find("input[name='start']").val())
                    ,'end' : Number($(this).find("input[name='end']").val())
                });
            });
            return {
                'statisticsId' : $("#statisticsId").val()
                ,'statisticsName' : $("#statisticsName").val()
                ,'chartType' : 'line'
                ,'collectionName' : 'tracking'
                ,'intensiveTime' : $("input[name='intensiveTime']").is(":checked")
                ,'template' : $("#template option:selected").val()
                ,'jsonData' : JSON.stringify(jsonData)
            };
        }
    }

    /*
     get List
     @author psb
     */
    function getList(){
        callAjax('list',{mode:'search'});
    }

    function autoSearch(){
        if(autoRefInterval!=null){
            clearInterval(autoRefInterval);
            autoRefInterval = null;
        }

        let autoRefTime = $("#autoRefresh option:selected").val();
        if(autoRefTime!=null && autoRefTime!=''){
            let refDelay = Number(autoRefTime)*1000;
            autoRefInterval = setInterval(function() {
                let obj = Object.keys(statisticsList);
                let searchType = "chart";
                if(searchToggleId==null){
                    searchToggleId = obj[0];
                }else{
                    let index = obj.indexOf(searchToggleId)+1;
                    if(index>=obj.length){
                        searchType = "heatmap";
                        searchToggleId = null;
                    }else{
                        searchToggleId = obj[index];
                    }
                }

                if(searchType=="chart"){
                    detailRender(searchToggleId);
                    closeHeatMapPopup();
                    search();
                }else{
                    openHeatMapPopup();
                    let searchDt = new Date();
                    searchDt.setHours(searchDt.getHours()-1);
                    searchHeatMap(searchDt);
                }
            }, refDelay);
        }
    }

    /*
     search
     @author psb
     */
    function search(){
        if(validate('search')){
            $(".eventStatistics").find(".box-chart").empty().removeClass("on");
            $(".eventStatistics").find(".box-ctbox").removeClass("on");
            $(".loding_bar").addClass("on");
            callAjax('search',getParam(true));
        }
    }

    function heatMapValidate(){
        var start = new Date($("input[name='startDatetimeStr']").val() + " " + $("#startDatetimeHourSelect").val() + ":00:00");
        var end = new Date($("input[name='endDatetimeStr']").val() + " " + $("#endDatetimeHourSelect").val() + ":00:00");

        if(start>end){
            alertMessage("earlyDatetime");
            return false;
        }
        return true;
    }

    function searchSecurityReport(){
        let target = $(".securityReportPop");
        target.find(".box-chart").empty().removeClass("on");
        let areaId = target.find("select[name='areaId']").val();
        if(areaId==null || areaId==''){
            alertMessage("emptyArea");
            return false;
        }
        let startDatetimeStr = target.find("input[name='securityDatetime']").val();
        if(startDatetimeStr==null || startDatetimeStr==''){
            startDatetimeStr = new Date().format("yyyy-MM-dd")
        }
        let startDatetime = startDatetimeStr + " 00:00:00";
        let endDatetime = startDatetimeStr + " 23:59:59";
        var jsonData = {
            "xAxis" : {
                'interval' : 'day'
                ,'startDatetime' : startDatetime
                ,'endDatetime' : endDatetime
            },
            "yAxis" : []
        };
        $.each($("select[name='fenceList'] option[areaId='"+areaId+"']"),function(){
            var index = 0;
            for(var eventId in autoCompleteEvt){
                jsonData['yAxis'].push(
                    {
                        aggregation:"count"
                        ,field:"eventId"
                        ,label:autoCompleteEvt[eventId]+"("+$(this).text()+")"
                        ,index : index
                        ,condition:[
                            {
                                key:"eventId"
                                ,type:"$eq"
                                ,value:eventId
                            },
                            {
                                key:"fenceId"
                                ,type:"$eq"
                                ,value:$(this).val()
                            }
                        ]
                    }
                );
                index++;
            }
        });
        callAjax('search',{searchType:"securityReportPop", 'jsonData' : JSON.stringify(jsonData)});
        callAjax('heatMap',{
            'areaId' : areaId
            ,'startDatetimeStr' : startDatetime
            ,'endDatetimeStr' : endDatetime
            ,'popupName' : 'securityReportPop'
            ,'fenceId' : null
            ,'startSpeed' : null
            ,'endSpeed' : null
        });
    }

    function searchHeatMap(startDatetime){
        if(heatMapValidate()){
            let target = $(".heatMapPop");
            let areaId = target.find("select[name='areaId']").val();
            if(areaId==null || areaId==''){
                alertMessage("emptyArea");
                return false;
            }

            let startDatetimeStr = target.find("input[name='startDatetimeStr']").val();
            if(startDatetime!=null){
                startDatetimeStr = startDatetime.format("yyyy-MM-dd HH:00:00");
            }else if(startDatetimeStr!=null && startDatetimeStr!=''){
                startDatetimeStr += " " + target.find("#startDatetimeHourSelect").val() + ":00:00";
            }

            let endDatetimeStr = target.find("input[name='endDatetimeStr']").val();
            if(endDatetimeStr!=null && endDatetimeStr!=''){
                endDatetimeStr += " " + target.find("#endDatetimeHourSelect").val() + ":59:59";
            }

            let param = {
                'areaId' : areaId
                ,'startDatetimeStr' : startDatetimeStr
                ,'endDatetimeStr' : endDatetimeStr
                ,'popupName' : 'heatMapPop'
                ,'fenceId' : target.find("select[name='fenceId'] option:selected").val()
                ,'startSpeed' : target.find("input[name='startSpeed']").val()
                ,'endSpeed' : target.find("input[name='endSpeed']").val()
            };
            callAjax('heatMap',param);
        }
    }

    function addStatistics(){
        if(validate()){
            callAjax('add',getParam());
        }
    }

    function saveStatistics(){
        if($("#statisticsId").val()!=null && $("#statisticsId").val()!=''){
            if(validate()){
                callAjax('save',getParam());
            }
        }else{
            addStatistics();
        }
    }

    /*
     list Render
     @author psb
     */
    function listRender(data){
        $("#statisticsList").empty();
        statisticsList = {};

        for(var index in data){
            let statistics = data[index];
            statisticsList[statistics['statisticsId']] = statistics;
            $("#statisticsList").append(
                $("<li/>").click({'statisticsId':statistics['statisticsId']},function(evt){
                    if($(this).hasClass("on")){
                        $(this).removeClass("on");
                        $(".box-detail").removeClass("on");
                    }else{
                        $("#statisticsList > li").removeClass("on");
                        $(this).addClass("on");
                        detailRender(evt.data.statisticsId, true);
                    }
                }).append(
                    $("<div/>").append(
                        $("<p/>").text(statistics['statisticsName'])
                    ).append(
                        $("<i/>").addClass(chartClass[statistics['chartType']])
                    ).append(
                        $("<button/>",{class:"ico-play",title:"<spring:message code='statistics.placeholder.play'/>"}).click({'statisticsId':statistics['statisticsId']},function(evt){
                            detailRender(evt.data.statisticsId);
                            search();
                            evt.stopPropagation();
                        })
                    ).append(
                        $("<button/>",{title:"<spring:message code='statistics.placeholder.remove'/>"}).click({'statisticsId':statistics['statisticsId']},function(evt){
                            if(confirm(messageConfig['removeConfirmMessage'])){
                                callAjax('remove',{'statisticsId':evt.data.statisticsId});
                            }
                            evt.stopPropagation();
                        })
                    )
                )
            )
        }
    }

    function detailRender(statisticsId, showFlag){
        $(".box-detail div[name='yAxis']").remove();
        $(".box-detail").find("input[type='text'], input[type='number']").val("");
        $(".box-detail").find("input[type='checkbox']").prop("checked", false);
        $(".box-detail").find("select option:eq(0)").prop("selected", true).trigger("change");

        if(statisticsId==null || statisticsList[statisticsId]==null){
            $("#statisticsList > li").removeClass("on");
            $(".ico-copy").hide();
            $("#statisticsId").val("");
            $("#startDtHour").val("00").prop("selected", true);
            $("#endDtHour").val("23").prop("selected", true);
            addYaxis(null, false);
        }else{
            // saveMode
            $(".ico-copy").show();
            var statistics = statisticsList[statisticsId];
            $("#statisticsId").val(statistics['statisticsId']);
            $("#statisticsName").val(statistics['statisticsName']);
            $("#chartType").val(statistics['chartType']).prop("selected", true);
            $("#collectionName").val(statistics['collectionName']).prop("selected", true);

            var jsonData = statistics['jsonData'];
            try{
                jsonData = JSON.parse(jsonData);
            }catch(e){
                console.warn("[detailRender] json parse error - " + jsonData);
                return false;
            }
            let xAxis = jsonData['xAxis'];
            if(xAxis['startDatetime']!=null && xAxis['startDatetime']!=''){
                let startDt = new Date(xAxis['startDatetime']);
                $("#startDatetime").val(startDt.format("yyyy-MM-dd"));
                $("#startDtHour").val(startDt.format("HH")).prop("selected", true);
            }
            if(xAxis['endDatetime']!=null && xAxis['endDatetime']!=''){
                let endDt = new Date(xAxis['endDatetime']);
                $("#endDatetime").val(endDt.format("yyyy-MM-dd"));
                $("#endDtHour").val(endDt.format("HH")).prop("selected", true);
            }
            $("select[name='interval']").val(xAxis['interval']).prop("selected", true);

            let yAxis = jsonData['yAxis'];
            if(yAxis!=null){
                for(var index in yAxis){
                    addYaxis(yAxis[index]);
                }
            }else{
                addYaxis(null, true);
            }

            if(statistics['template']!='custom'){
                let rows = jsonData['rows'];
                for(var i in rows){
                    $("input[name='fences'][value='"+rows[i]['fenceId']+"'").prop("checked",true);
                }
                let condition = jsonData['condition'];
                for(var index in condition){
                    let con = condition[index];
                    if(con['key']=='eventId'){
                        for(var k in con['value']){
                            $("input[name='events'][value='"+con['value'][k]+"'").prop("checked",true);
                        }
                    }
                }
                let customCondition = jsonData['customCondition'];
                for(var index in customCondition){
                    let con = customCondition[index];
                    let prDiv = $(".addOption[name='"+con['key']+"']");
                    if(prDiv!=null && prDiv.length>0){
                        prDiv.find("select[name='type']").val(con['type']);
                        prDiv.find("input[name='start']").val(con['start']);
                        prDiv.find("input[name='end']").val(con['end']);
                    }
                }
                $("#countingMethod").val(jsonData['group']['aggregation']).prop("selected", true);
                $("input[name='intensiveTime']").prop("checked",jsonData['intensiveTime']?jsonData['intensiveTime']:false);
            }
            $("#template").val(statistics['template']).prop("selected", true).trigger("change");
        }

        if(showFlag){
            $(".box-detail").addClass("on");
        }
    }

    function addYaxis(data, focusFlag){
        let yAxisTag = $("<div/>",{class:'set-itembox',name:'yAxis'}).append(
            $("<h4/>").text("Y-Axis")
        ).append(
            $("<button/>",{class:'ico-open on',title:"<spring:message code='statistics.placeholder.openAndClose'/>"}).click(function(){
                $(this).toggleClass("on");
            })
        ).append(
            $("<button/>",{class:'ico-plus',title:"<spring:message code='statistics.placeholder.add'/>"}).click(function(){
                addYaxis(null, true);
            })
        ).append(
            $("<button/>",{class:'ico-close',title:"<spring:message code='statistics.placeholder.remove'/>"}).click(function(){
                if($("div[name='yAxis']").length>1){
                    $(this).parent().remove();
                }
            })
        ).append(
            $("<div/>",{class:'set-item'}).append(
                $("<h4/>").text("Aggregation")
            ).append(
                $("<div/>").append(
                    $("<select/>",{name:'aggregation'}).append(
                        $("<option/>",{value:'count'}).text("Count")
                    ).append(
                        $("<option/>",{value:'avg'}).text("Avg")
                    ).append(
                        $("<option/>",{value:'sum'}).text("Sum")
                    ).append(
                        $("<option/>",{value:'min'}).text("Min")
                    ).append(
                        $("<option/>",{value:'max'}).text("Max")
                    )
                )
            ).append(
                $("<h4/>").text("Field")
            ).append(
                $("<div/>").append(
                    $("<input/>",{type:'text',name:'field'})
                )
            ).append(
                $("<h4/>").text("Custom Label")
            ).append(
                $("<div/>").append(
                    $("<input/>",{type:'text',name:'label'})
                )
            ).append(
                $("<h4/>").text("Condition")
            ).append(
                $("<button/>",{class:'ico-plus'}).click(function(){
                    let condition = conditionTag.clone();
                    condition.find(".ico-close").click(function(){
                        $(this).parent().remove();
                    });
                    $(this).parent().append(condition);
                })
            )
        );

        if(data!=null){
            yAxisTag.find("select[name='aggregation']").val(data['aggregation']).prop("selected",true);
            yAxisTag.find("input[name='field']").val(data['field']);
            yAxisTag.find("input[name='label']").val(data['label']);
            for(var index in data['condition']){
                let condition = data['condition'][index];
                let _conditionTag = conditionTag.clone();
                _conditionTag.find(".ico-close").click(function(){
                    $(this).parent().remove();
                });
                _conditionTag.find("input[name='key']").val(condition['key']);
                _conditionTag.find("select[name='type']").val(condition['type']).prop("selected",true);
                _conditionTag.find("input[name='value']").val(condition['value']);
                yAxisTag.find(".set-item").append(_conditionTag);
            }
        }
        $("#customDetail").append(yAxisTag);
        if(focusFlag){
            yAxisTag.find("select[name='aggregation']").focus();
        }
    }

    function getDateStr(_interval, dateStr){
        var date = new Date(dateStr);
        if(isNaN(date.getTime())){
            return dateStr;
        }
        let datetimeText;
        switch (_interval){
            case 'day':
                datetimeText = date.format("HH");
                break;
            case 'week':
            case 'month':
                datetimeText = date.format("MM/dd");
                break;
            case 'year':
                datetimeText = date.format("yyyy-MM");
                break;
        }
        return datetimeText;
    }

    function getDataValue(aggregation, values){
        var result = 0;
        if(values instanceof Array){
            switch (aggregation){
                case "count" :
                    result = values.length;
                    break;
                case "avg" :
                    var sum = 0;
                    for(var value in values){
                        sum += value;
                    }
                    result = sum/values.length;
                    break;
                case "sum" :
                    for(var value in values){
                        result += value;
                    }
                    break;
                case "min" :
                    result = Math.max.apply(null,values);
                    break;
                case "max" :
                    result = Math.min.apply(null,values);
                    break;
            }
        }else{
            result = values;
        }
        return result;
    }

    /*
     chart Render
     @author psb
     */
    function chartRender(paramBean, chartList, dateList, headerHide){
        let searchType = paramBean['searchType'];
        let detailElement = $("."+searchType).find(".box-chart");
        let chartTag = $("<div/>",{class:'set-chart'});
        if(!headerHide){
            chartTag.append(
                $("<div/>",{class:'chart_label header'})
            );
        }

        var _seriesList = [];
        var _max = 0;
        var _aggregationSeriesList = [];
        var _labels = [];
        for(var index in dateList){
            _labels.push(getDateStr(paramBean['interval'], dateList[index]));
        }
        for(var index in chartList){
            var chart = chartList[index];
            var series = [];
            var aggregationValue = 0;

            for(var i in dateList){
                let flag = false;
                for(var k in chart['dataList']){
                    let value = toRound(Number(getDataValue(chart['aggregation'],chart['dataList'][k]['value'])),2);
                    if(_max<value){
                        _max = value;
                    }
                    if(getDateStr(paramBean['interval'], dateList[i])==getDateStr(paramBean['interval'], chart['dataList'][k]['_id'])){
                        series.push({meta:chart['label'],label:getDateStr(paramBean['interval'], chart['dataList'][k]['_id']),value:value});

                        switch (chart['aggregation']){
                            case "count" :
                            case "avg" :
                            case "sum" :
                                aggregationValue += value;
                                break;
                            case "min" :
                                if(aggregationValue>value){
                                    aggregationValue = value;
                                }
                                break;
                            case "max" :
                                if(aggregationValue<value){
                                    aggregationValue = value;
                                }
                                break;
                        }
                        flag = true;
                        break;
                    }
                }
                if(!flag){
                    series.push({meta:chart['label'],label:getDateStr(paramBean['interval'], dateList[i]),value:0});
                }
            }

            if(chart['aggregation']=='avg'){
                aggregationValue = aggregationValue/dateList.length;
            }
            _seriesList.push(series);
            _aggregationSeriesList.push(aggregationValue);
            chartTag.find(".header").append(
                $("<span/>",{meta:chart['label']}).append(
                    $("<b/>").text(commaNum(toRound(aggregationValue,2)) + " ("+chart['aggregation']+")")
                ).append(
                    $("<i/>").text(chart['label'])
                )
            );
        }

        switch (paramBean['chartType']){
            case "line":
                chartTag.addClass("chart-line");
                chartTag.append(
                    $("<div/>",{class:'canvas-chart line '+searchType})
                );
                detailElement.append(chartTag);
                new Chartist.Line('.canvas-chart.'+searchType, {
                    labels: _labels,
                    series: _seriesList
                }, {
                    low: 0,
                    high:_max+(_max/20),
                    showArea: true,
                    showLabel: true,
                    fullWidth: true,
                    axisY: {
                        onlyInteger: true
                    },
//                    lineSmooth: Chartist.Interpolation.cardinal({
//                        fillHoles: true
//                    }),
                    plugins: [
                        Chartist.plugins.tooltip()
                    ]
                });
                break;
            case "bar":
                chartTag.addClass("chart-bar");
                chartTag.append(
                    $("<div/>",{class:'canvas-chart bar '+searchType})
                );
                detailElement.append(chartTag);
                new Chartist.Bar('.canvas-chart.'+searchType, {
                    labels: _labels,
                    series: _seriesList
                }, {
                    low: 0,
                    high:_max+(_max/20),
                    seriesBarDistance: 10,
                    axisY: {
                        onlyInteger: true,
                        scaleMinSpace: 15
                    },
                    plugins: [
                        Chartist.plugins.tooltip()
                    ]
                });
                break;
            case "pie":
                chartTag.addClass("chart-pie");
                chartTag.append(
                    $("<div/>",{class:'canvas-chart pie '+searchType})
                );
                detailElement.append(chartTag);
                new Chartist.Pie('.canvas-chart.'+searchType, {
                    series: _aggregationSeriesList
                }, {
                    labelInterpolationFnc: function(value, index) {
                        return $(".chart_label.header span:eq("+index+")").attr("meta") + " (" + Math.round(value / _aggregationSeriesList.reduce(function(a, b) { return a + b }) * 100) + '%)';
                    },
                    plugins: [
                        Chartist.plugins.tooltip()
                    ]
                });
                break;
            case "table":
                chartTag.addClass("chart-ex");
                chartTag.prepend(
                    $("<div/>",{class:'set-btn type-01'}).append(
                        $("<button/>",{class:'ico-chartt'}).click(function(){
                            excelDownload();
                        }).append(
                            $("<p/>").text("<spring:message code='common.button.excelDownload'/>")
                        )
                    )
                );
                chartTag.append(
                    $("<div/>",{class:'excel'})
                );
                for(var index in _labels){
                    let childTag = $("<div/>").append(
                        $("<p/>").text(_labels[index])
                    ).append(
                        $("<div/>",{class:'chart_label',label:_labels[index]})
                    );
                    chartTag.find(".excel").append(childTag);
                }
                for(var index in _seriesList){
                    for(var i in _seriesList[index]){
                        let series = _seriesList[index][i];
                        chartTag.find(".chart_label[label='"+series['label']+"']").append(
                            $("<span/>",{meta:series['meta'],title:commaNum(series['value'])}).text(commaNum(series['value']))
                        )
                    }
                }
                detailElement.append(chartTag);
                break;
        }
        detailElement.addClass("on");
    }

    var multiLine;
    var multiLineUuid;

    /*
     school chart Render
     @author psb
     */
    function schoolChartRender(paramBean, chartList, dateList){
        let detailElement = $(".box-ctbox");
        detailElement.find("[name='templateName']").text($("#template option[value='"+paramBean['template']+"']").text());
        // 테이블 초기화
        detailElement.find(".chart-table").find("div[name='gubn'], div[name='fenceName']").empty();
        detailElement.find(".chart-table").find(".d_tbody").empty();
        detailElement.addClass("on");

        // 라인차트
        var _labels = [];
        for(var index in dateList){
            _labels.push({
                'date' : getDateStr(paramBean['interval'], dateList[index])
                ,'cnt' : 0
            });
        }
        multiLine = new MultiLine(_labels,{
            'width':detailElement.find(".chart-canvas div[name='lineChart']").width()
            ,'height':detailElement.find(".chart-canvas div[name='lineChart']").height()
        });
        multiLineUuid = multiLine.setElement(detailElement.find(".chart-canvas"));
        var chartData = [];
        var totalCnt = 0;
        for(var index in chartList){
            var chart = chartList[index];
            let fenceData = {
                'id' : chart['fenceId']
                ,'name' : chart['fenceName']
                ,'areaName' : chart['areaName']
                ,'values' : []
            };

            var sum = 0;
            for(var i in dateList){
                let label = getDateStr(paramBean['interval'], dateList[i]);
                let values = {
                    'date' : label
                    ,'cnt' : 0
                };

                for(var k in chart['dataList']){
                    if(label==getDateStr(paramBean['interval'], chart['dataList'][k]['_id'])){
                        let cnt = toRound(Number(getDataValue(chart['aggregation'],chart['dataList'][k]['value'])),2);
                        sum += cnt;
                        values['cnt'] = cnt;
                    }
                }
                fenceData['values'].push(values);
            }
            fenceData['sum'] = sum;
            totalCnt += sum;
            chartData.push(fenceData);
        }
        multiLine.setValue(multiLineUuid, chartData);

        // 테이블
        let defaultTbEl = detailElement.find("div[name='defaultTable']");
        defaultTbEl.find("div[name='gubn']").append( $("<span/>").text("<spring:message code='statistics.column.gubn'/>") );
        defaultTbEl.find("div[name='fenceName']").append( $("<span/>").text("<spring:message code='statistics.column.fenceName'/>") );
        defaultTbEl.find(".d_tbody").append($("<div/>",{"name":"header"}));
        let mostTime = [];
        for(var i in dateList){
            let label = getDateStr(paramBean['interval'], dateList[i]);
            defaultTbEl.find("div[name='header']").append(
                $("<span/>").text(label)
            );
            mostTime.push({label:label,cnt:0});
        }
        for(var index in chartData){
            let fenceData = chartData[index];
            defaultTbEl.find("div[name='gubn']").append(
                $("<span/>").text(fenceData['areaName'])
            );
            defaultTbEl.find("div[name='fenceName']").append(
                $("<span/>").text(fenceData['name'])
            );
            let addEl = $("<div/>");
            for(var k in fenceData['values']){
                addEl.append(
                    $("<span/>",{title:commaNum(fenceData['values'][k]['cnt'])}).text(fenceData['values'][k]['cnt'])
                );
                mostTime[k]['cnt']+=fenceData['values'][k]['cnt'];
            }
            defaultTbEl.find(".d_tbody").append(addEl);
        }

        // 집중시간대 표시
        let mostTimeTbEl = detailElement.find("div[name='mostTimeTable']");
        let distTbEl = detailElement.find("div[name='distTable']");
        if(paramBean['template']!="vehicleSpeed" && paramBean['template']!="vehicleSpeedTime" && JSON.parse(paramBean['intensiveTime'])){
            mostTimeTbEl.find(".d_tbody").append($("<div/>",{"name":"header"})).append($("<div/>",{"name":"cnt"}));
            mostTime.sort(function(a,b){
                return b['cnt'] - a['cnt']
            });
            var viewCount = 0;
            for(var i in mostTime){
                if(viewCount>5){ break; }
                mostTimeTbEl.find("div[name='header']").append(
                    $("<span/>",{title:mostTime[i]['label']}).text(mostTime[i]['label'])
                );
                mostTimeTbEl.find("div[name='cnt']").append(
                    $("<span/>",{title:commaNum(mostTime[i]['cnt'])}).text(mostTime[i]['cnt'])
                );
                viewCount++;
            }
            mostTimeTbEl.show();

            distTbEl.find(".d_tbody").append($("<div/>",{"name":"header"})).append($("<div/>",{"name":"cnt"}));
            for(var index in chartData){
                let fenceData = chartData[index];
                distTbEl.find("div[name='header']").append(
                    $("<span/>",{title:fenceData['name']}).text(fenceData['name'])
                );
                let avg = totalCnt==0?0:toRound(Number(fenceData['sum'])/totalCnt*100,1);
                distTbEl.find("div[name='cnt']").append(
                    $("<span/>",{title:avg+"%"}).text(avg+"%")
                );
            }
            distTbEl.show();
        }else{
            mostTimeTbEl.hide();
            distTbEl.hide();
        }
    }

    /*
     ajax call
     @author psb
     */
    function callAjax(actionType, data){
        sendAjaxPostRequest(urlConfig[actionType + 'Url'],data,successHandler,failureHandler,actionType);
    }

    /*
     ajax success handler
     @author psb
     */
    function successHandler(data, dataType, actionType){
        switch (actionType){
            case "list":
                listRender(data['statisticsList']);
                break;
            case "search":
                $(".loding_bar").removeClass("on");
                if(data['paramBean']!=null && data['chartList']!=null && data['dateList']!=null){
                    if(data['paramBean']['template']=='custom'){
                        if(data['paramBean']['searchType']!=null){
                            data['paramBean']['searchType'] = 'securityChart1';
                            data['paramBean']['chartType'] = 'line';
                            chartRender(data['paramBean'], data['chartList'], data['dateList']);
                            data['paramBean']['searchType'] = 'securityChart2';
                            data['paramBean']['chartType'] = 'pie';
                            chartRender(data['paramBean'], data['chartList'], data['dateList'], true);
                        }else{
                            data['paramBean']['searchType'] = 'eventStatistics';
                            chartRender(data['paramBean'], data['chartList'], data['dateList']);
                        }
                    }else{
                        schoolChartRender(data['paramBean'], data['chartList'], data['labelList']!=null?data['labelList']:data['dateList']);
                    }
                }else{
                    alertMessage(actionType+['Failure']);
                }
                break;
            case "add":
            case "save":
            case "remove":
                alertMessage(actionType+['Complete']);
                getList();
                break;
            case "heatMap":
                let notificationList = data['notifications'];
                let paramBean = data['paramBean'];
                customMapMediator = new CustomMapMediator(String('${rootPath}'),String('${version}'));
                try{
                    $("."+paramBean['popupName']).find(".loding_bar").addClass("on");
                    customMapMediator.setElement($("."+paramBean['popupName']), $("."+paramBean['popupName']).find("div[name='mapElement']"));
                    customMapMediator.init(data['paramBean']['areaId'],{
                        'element' : {
                            'lastPositionUseFlag' : true
                            ,'lastPositionSaveFlag' : true
                        },
                        'custom' : {
                            'fenceView' : true
                            ,'openLinkFlag' : false
                            ,'onLoad' : function(){
                                if(notificationList!=null) {
                                    for(var i in notificationList){
                                        let noti = notificationList[i];
                                        let trackingJson = JSON.parse(noti['trackingJson']);
                                        let removeArr = [];
                                        for(let k in trackingJson){
                                            if(trackingJson[k]['speed']!=null){
                                                if(paramBean['startSpeed']!="" && Number(trackingJson[k]['speed'])<Number(paramBean['startSpeed'])){
                                                    removeArr.push(k);
                                                }else if(paramBean['endSpeed']!="" && Number(trackingJson[k]['speed'])>Number(paramBean['endSpeed'])){
                                                    removeArr.push(k);
                                                }
                                            }
                                        }
                                        while(removeArr.length){
                                            trackingJson.splice(removeArr.pop(), 1);
                                        }
                                        if(trackingJson.length>0){
                                            var marker = {
                                                'areaId' : noti['areaId']
                                                ,'deviceId' : noti['deviceId']
                                                ,'objectType' : 'heatmap'
                                                ,'id' : noti['objectId']
                                                ,'location' : trackingJson
                                            };
                                            customMapMediator.saveMarker('object', marker);
                                        }
                                    }
                                    $(".loding_bar").removeClass("on");
                                }
                            }
                        }
                        ,'object' :{
                            'pointsHide' : false
                            ,'pointShiftCnt' : null
                        }
                    });
                }catch(e){
                    $(".loding_bar").removeClass("on");
                    console.error("[openHeatMapPopup] custom map mediator init error - "+ e.message);
                }
                break;
        }
    }

    /*
     ajax error handler
     @author psb
     */
    function failureHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        alertMessage(actionType+['Failure']);
        $(".loding_bar").removeClass("on");
    }

    /*
     alert message method
     @author psb
     */
    function alertMessage(type){
        alert(messageConfig[type]);
    }

    /*
     excel download
     @author psb
     */
    function excelDownload(){
        $("#excelEventStatisticsList").empty();

        var excelDownloadHtml = $("<table/>",{id:"excelDownloadTb"}).append(
            $("<thead/>").append(
                $("<tr/>").append(
                    $("<th/>").text("<spring:message code='statistics.column.gubn'/>")
                ).append(
                    $("<th/>").text("<spring:message code='statistics.column.sum'/>")
                )
            )
        ).append(
            $("<tbody/>")
        );

        var excelTag = $(".excel");

        // header
        excelTag.find("p").each(function(){
            excelDownloadHtml.find("thead tr").append(
                $("<th/>").text($(this).text())
            );
        });

        // 구분 & 합계
        $(".header span").each(function(){
            excelDownloadHtml.append(
                $("<tr/>",{meta:$(this).attr("meta")}).append(
                    $("<td/>").text($(this).attr("meta"))
                ).append(
                    $("<td/>").text($(this).find("b").text())
                )
            )
        });

        // 요소
        excelTag.find("span").each(function(){
            excelDownloadHtml.find("tbody tr[meta='"+$(this).attr("meta")+"']").append(
                $("<td/>").text($(this).text())
            )
        });
        $("#excelEventStatisticsList").append(excelDownloadHtml);

        var uri = $("#excelDownloadTb").excelexportjs({
            containerid: "excelDownloadTb"
            , datatype: 'table'
            , worksheetName: "<spring:message code="common.title.eventStatistics"/>"
            , returnUri: true
        });

        var link = document.createElement('a');
        link.download = "<spring:message code="common.title.eventStatistics"/>_"+new Date().format("yyyyMMddhhmmss")+".xls";
        link.href = uri;
        link.click();
    }

    /*
     excel download
     @author psb
     */
    function schoolExcelDownload(){
        $("#excelEventStatisticsList").empty();

        var excelDownloadHtml = $("<table/>",{id:"excelDownloadTb"});

        // 통계리포트
        var defaultTable = $("div[name='defaultTable']");
        var defaultTbody = $("<tbody/>");
        defaultTable.find(".d_thead div[name='gubn'] span").each(function(e){
            var row = $("<tr/>").append(
                $("<td/>").text($(this).text())
            ).append(
                $("<td/>").text(defaultTable.find(".d_thead div[name='fenceName'] span:eq("+e+")").text())
            );
            defaultTable.find(".d_tbody div:eq("+e+") span").each(function(){
                row.append($((e==0?"<th/>":"<td/>")).text($(this).text()));
            });
            if(e==0){
                excelDownloadHtml.append($("<thead/>").append(row));
            }else{
                defaultTbody.append(row);
            }
        });
        excelDownloadHtml.append(defaultTbody);

        if($("input[name='intensiveTime']").is(":checked")){
            let mostTimeTbEl = $("div[name='mostTimeTable']");
            var mostTimeTbody = $("<tbody/>");
            mostTimeTbEl.find(".d_thead span").each(function(e){
                var row = $("<tr/>").append($("<th/>").text($(this).text()));
                mostTimeTbEl.find(".d_tbody div:eq("+e+") span").each(function(){
                    row.append($((e==0?"<th/>":"<td/>")).text($(this).text()));
                });
                if(e==0){
                    excelDownloadHtml.append($("<thead/>").append(row));
                }else{
                    mostTimeTbody.append(row);
                }
            });
            excelDownloadHtml.append(mostTimeTbody);

            let distTbEl = $("div[name='distTable']");
            var distTbody = $("<tbody/>");
            distTbEl.find(".d_thead span").each(function(e){
                var row = $("<tr/>").append($("<th/>").text($(this).text()));
                distTbEl.find(".d_tbody div:eq("+e+") span").each(function(){
                    row.append($((e==0?"<th/>":"<td/>")).text($(this).text()));
                });
                if(e==0){
                    excelDownloadHtml.append($("<thead/>").append(row));
                }else{
                    distTbody.append(row);
                }
            });
            excelDownloadHtml.append(distTbody);
        }

        $("#excelEventStatisticsList").append(excelDownloadHtml);

        var uri = $("#excelDownloadTb").excelexportjs({
            containerid: "excelDownloadTb"
            , datatype: 'table'
            , worksheetName: "<spring:message code="common.title.eventStatistics"/>"
            , returnUri: true
        });

        var link = document.createElement('a');
        link.download = "<spring:message code="common.title.eventStatistics"/>_"+$("#statisticsName").val()+new Date().format("yyyyMMddhhmmss")+".xls";
        link.href = uri;
        link.click();
    }

    function schoolPdfDownload(){
        var chart = multiLine.getChart(multiLineUuid);
        if(chart!=null){
            const doc = new jsPDF('l','mm','a4');
            var drawList = [];
            drawList.push({'element':$(".pdfSaveTitleElement")[0],'nextPositionMargin':5,'type':'html'});
            drawList.push({'element':chart['node'],'nextPositionMargin':5,'type':'svg'});
            $(".pdfSaveElement").each(function(){
                if($(this).css("display")!="none"){
                    drawList.push({'element':$(this)[0],'nextPositionMargin':5,'type':'html'});
                }
            });
            addPdf(doc, 0, drawList);
        }
    }

    function addPdf(doc, leftPosition, drawList){
        function recursive(_doc, _leftPosition){
            drawList.shift();
            if(drawList.length>0){
                addPdf(_doc, _leftPosition, drawList);
            }else{
                _doc.save("<spring:message code="common.title.eventStatistics"/>_" + $("#statisticsName").val() + new Date().format("yyyyMMddhhmmss") + '.pdf');
            }
        }

        if(drawList.length>0){
            var draw = drawList[0];
            switch (draw['type']){
                case "svg" :
                    d3_save_svg.addSvgToPdf(doc, draw['element'], leftPosition, draw['nextPositionMargin'], recursive);
                    break;
                case "html" :
                    d3_save_svg.addHtml2canvasPdf(doc, draw['element'], leftPosition, draw['nextPositionMargin'], recursive);
                    break;
            }
        }
    }

    /*
     open 히트맵 popup
     @author psb
     */
    function openHeatMapPopup(){
        $(".heatMapPop").fadeIn();
    }

    /*
     close HeatMap popup
     @author psb
     */
    function closeHeatMapPopup(){
        $(".heatMapPop").fadeOut();
    }

    /*
     open 보안리포트 popup
     @author psb
     */
    function openSecurityReportPopup(){
        $(".securityReportPop").fadeIn();
    }

    /*
     close 보안리포트 popup
     @author psb
     */
    function closeSecurityReportPopup(){
        $(".securityReportPop").fadeOut();
    }
</script>