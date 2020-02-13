<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set value="2A0020" var="menuId"/>
<c:set value="2A0000" var="subMenuId"/>

<link rel="stylesheet" type="text/css" href="${rootPath}/assets/library/chartist/chartist.min.css" >
<link rel="stylesheet" type="text/css" href="${rootPath}/assets/library/chartist/chartist-plugin-tooltip.css" >
<script type="text/javascript" src="${rootPath}/assets/library/chartist/chartist.min.js"></script>
<script type="text/javascript" src="${rootPath}/assets/library/chartist/chartist-plugin-tooltip.js"></script>
<script type="text/javascript" src="${rootPath}/assets/library/excelexport/jquery.techbytarun.excelexportjs.js"></script>
<script src="${rootPath}/assets/library/svg/jquery.svg.js?version=${version}" type="text/javascript" ></script>
<script src="${rootPath}/assets/library/svg/jquery.svgdom.js?version=${version}" type="text/javascript" ></script>
<script src="${rootPath}/assets/js/page/dashboard/custom-map-mediator.js?version=${version}" type="text/javascript" charset="UTF-8"></script>

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
            </div>
        </section>

        <!-- 상세 -->
        <section class="box-detail">
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
                                <isaver:areaSelectBox htmlTagId="autoCompleteAreaId" allModel="true" allText="${notSelectText}" templateCode="TMP005"/>
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
                    <h4>Type</h4>
                    <div>
                        <select class="select-chart" id="chartType">
                            <option value=""><spring:message code="common.selectbox.select"/></option>
                            <option value="line">Line Chart</option>
                            <option value="bar">Bar Chart</option>
                            <option value="pie">Pie Chart</option>
                            <option value="table">Data Table</option>
                        </select>
                    </div>
                </div>

                <div class="set-itembox" id="xAxis">
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
                            <input type="text" id="startDatetime" class="datepicker dpk_normal_type" disabled placeholder='<spring:message code="statistics.placeholder.start"/>'/>
                            <select id="startDtHour"></select>
                        </div>
                        <div>
                            <input type="text" id="endDatetime" class="datepicker dpk_normal_type" disabled placeholder='<spring:message code="statistics.placeholder.end"/>'/>
                            <select id="endDtHour"></select>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- 차트 -->
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

<section class="popup-layer">
    <!-- 트래킹이력 팝업 -->
    <div class="popupbase map_pop">
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
                            <span><spring:message code="statistics.column.speed" /></span>
                            <span class="plable04">
                                <input type="number" name="startSpeed" />
                                <em>~</em>
                                <input type="number" name="endSpeed" />
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
                                <div id="mapElement" class="map_images"></div>
                                <div id="heatmapLoading" class="loding_bar"></div>
                            </div>
                        </section>
                    </article>
                </div>
            </div>
        </div>
        <div class="bg option_pop_close" onclick="closeHeatMapPopup();"></div>
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
        ,'fenceListUrl':'${rootPath}/fence/statistics.json'
    };

    var messageConfig = {
        'searchFailure':'<spring:message code="statistics.message.searchFailure"/>'
        ,'emptyStartDatetime':'<spring:message code="statistics.message.emptyStartDatetime"/>'
        ,'emptyEndDatetime':'<spring:message code="statistics.message.emptyEndDatetime"/>'
        ,'earlyDatetime':'<spring:message code="statistics.message.earlyDatetime"/>'
        ,'emptyArea':'<spring:message code="statistics.message.emptyArea"/>'
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
    var loadingBarFlag = false;
    var statisticsList = {};
    var searchToggleId = "";
    var autoRefInterval = null;
    var customMapMediator;

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
        setHourDataToSelect($('#startDtHour'),"00");
        setHourDataToSelect($('#endDtHour'),"23");
        setHourDataToSelect($('#startDatetimeHourSelect'),"00");
        setHourDataToSelect($('#endDatetimeHourSelect'),"23");

        $('input[name=startDatetimeStr]').val(serverDatetime.format("yyyy-MM-dd"));
        $('input[name=endDatetimeStr]').val(serverDatetime.format("yyyy-MM-dd"));
        $('#startDatetimeHourSelect').val(serverDatetime.format("HH")).prop("selected",true);
        getList();

        $("#autoCompleteAreaId").on("change",function(){
            let areaId = $(this).val();
            if(areaId!=null && areaId!=""){
                callAjax('fenceList',{areaId:areaId});
            }
        });
    });

    function getParam(){
        var jsonData = {
            "xAxis" : {
                'interval' : $("select[name='interval'] option:selected").val()
                ,'startDatetime' : $("#startDatetime").val() + " " + $("#startDtHour option:selected").val()+":00:00"
                ,'endDatetime' : $("#endDatetime").val() + " " + $("#endDtHour option:selected").val()+":59:59"
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
                let condition = {
                    'key' : $(this).find("input[name='key']").val()
                    ,'value' : $(this).find("input[name='value']").val()
                    ,'type' : $(this).find("select[name='type'] option:selected").val()
                };
                yAxis['condition'].push(condition);
            });
            jsonData['yAxis'].push(yAxis);
            index++;
        });

        return {
            'statisticsId' : $("#statisticsId").val()
            ,'statisticsName' : $("#statisticsName").val()
            ,'chartType' : $("#chartType option:selected").val()
            ,'jsonData' : JSON.stringify(jsonData)
        };
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
        $(".box-chart").empty().removeClass("on");
        if(loadingBarFlag){
            $(".loding_bar").addClass("on");
        }
        callAjax('search',getParam());
    }

    function addStatistics(){
        callAjax('add',getParam());
    }

    function saveStatistics(){
        if($("#statisticsId").val()!=null && $("#statisticsId").val()!=''){
            callAjax('save',getParam());
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
                        $("<button/>").click({'statisticsId':statistics['statisticsId'],title:"<spring:message code='statistics.placeholder.remove'/>"},function(evt){
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

        if(statisticsId==null || statisticsList[statisticsId]==null){
            $("#statisticsList > li").removeClass("on");
            // addMode
            $(".ico-copy").hide();
            $("#statisticsId").val("");
            $("#statisticsName").val("");
            $("#chartType").val("").prop("selected", true);
            $("#xAxis").find("select[name='interval']:eq(0)").prop("selected", true);
            $("#startDatetime").val("");
            $("#startDtHour").val("00").prop("selected", true);
            $("#endDatetime").val("");
            $("#endDtHour").val("23").prop("selected", true);
            addYaxis(null, false);
        }else{
            // saveMode
            $(".ico-copy").show();
            var statistics = statisticsList[statisticsId];
            $("#statisticsId").val(statistics['statisticsId']);
            $("#statisticsName").val(statistics['statisticsName']);
            $("#chartType").val(statistics['chartType']).prop("selected", true);

            var jsonData = statistics['jsonData'];
            try{
                jsonData = JSON.parse(jsonData);
            }catch(e){
                console.warn("[detailRender] json parse error - " + jsonData);
                return false;
            }
            let xAxis = jsonData['xAxis'];
            let startDt = new Date(xAxis['startDatetime']);
            let endDt = new Date(xAxis['endDatetime']);
            $("#startDatetime").val(startDt.format("yyyy-MM-dd"));
            $("#startDtHour").val(startDt.format("HH")).prop("selected", true);
            $("#endDatetime").val(endDt.format("yyyy-MM-dd"));
            $("#endDtHour").val(endDt.format("HH")).prop("selected", true);
            $("select[name='interval']").val(xAxis['interval']).prop("selected", true);

            let yAxis = jsonData['yAxis'];
            if(yAxis!=null){
                for(var index in yAxis){
                    addYaxis(yAxis[index]);
                }
            }else{
                addYaxis(null, true);
            }
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
        yAxisTag.insertBefore($("#xAxis"));
        if(focusFlag){
            yAxisTag.find("select[name='aggregation']").focus();
        }
    }

    /*
     chart Render
     @author psb
     */
    function chartRender(paramBean, chartList, dataList){
        function getDateStr(_interval, date){
            let datetimeText;
            switch (_interval){
                case 'day':
                    datetimeText = date.format("MM-dd HH");
                    break;
                case 'week':
                case 'month':
                    datetimeText = date.format("MM-dd");
                    break;
                case 'year':
                    datetimeText = date.format("yyyy-MM");
                    break;
            }
            return datetimeText;
        }

        let chartTag = $("<div/>",{class:'set-chart'}).append(
            $("<div/>",{class:'chart_label header'})
        );

        var _seriesList = [];
        var _max = 0;
        var _sumSeriesList = [];
        var _labels = [];
        for(var index in dataList){
            _labels.push(getDateStr(paramBean['interval'], new Date(dataList[index])));
        }
        for(var index in chartList){
            var chart = chartList[index];
            var series = [];
            var sumValue = 0;

            for(var i in dataList){
                let flag = false;
                for(var k in chart['dataList']){
                    if(_max<chart['dataList'][k]['value']){
                        _max = chart['dataList'][k]['value'];
                    }
                    if(getDateStr(paramBean['interval'], new Date(dataList[i]))==getDateStr(paramBean['interval'], new Date(chart['dataList'][k]['_id']))){
                        series.push({meta:chart['label'],label:getDateStr(paramBean['interval'], new Date(chart['dataList'][k]['_id'])),value:chart['dataList'][k]['value']});
                        sumValue += Number(chart['dataList'][k]['value']);
                        flag = true;
                        break;
                    }
                }
                if(!flag){
                    series.push({meta:chart['label'],label:getDateStr(paramBean['interval'], new Date(dataList[i])),value:0});
                }
            }
            _seriesList.push(series);
            _sumSeriesList.push(sumValue);
            chartTag.find(".header").append(
                $("<span/>",{label:chart['label']}).append(
                    $("<b/>").text(commaNum(sumValue))
                ).append(
                    $("<i/>").text(chart['label'])
                )
            );
        }

        switch (paramBean['chartType']){
            case "line":
                chartTag.addClass("chart-line");
                chartTag.append(
                    $("<div/>",{class:'canvas-chart line'})
                );
                $(".box-chart").append(chartTag);
                new Chartist.Line('.canvas-chart', {
                    labels: _labels,
                    series: _seriesList
                }, {
                    low: 0,
                    high:_max+(_max/20),
                    showArea: true,
                    showLabel: true,
                    fullWidth: false,
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
                    $("<div/>",{class:'canvas-chart bar'})
                );
                $(".box-chart").append(chartTag);
                new Chartist.Bar('.canvas-chart', {
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
                    $("<div/>",{class:'canvas-chart pie'})
                );
                $(".box-chart").append(chartTag);
                new Chartist.Pie('.canvas-chart', {
                    series: _sumSeriesList
                }, {
                    labelInterpolationFnc: function(value, index) {
                        return $(".chart_label.header span:eq("+index+")").attr("label") + " (" + Math.round(value / _sumSeriesList.reduce(function(a, b) { return a + b }) * 100) + '%)';
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
                        $("<div/>",{class:'chart_label'})
                    );
                    for(var i=0; i<_seriesList.length;i++){
                        childTag.find(".chart_label").append(
                            $("<span/>",{label:_labels[index]}).text(0)
                        )
                    }
                    chartTag.find(".excel").append(childTag);
                }
                for(var index in _seriesList){
                   for(var i in _seriesList[index]){
                        let series = _seriesList[index][i];
                        chartTag.find("span[label='"+series['label']+"']:eq("+index+")").text(commaNum(series['value']))
                    }
                }
                $(".box-chart").append(chartTag);
                break;
        }
        $(".box-chart").addClass("on");
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
            case "fenceList":
                let fenceList = data['fenceList'];
                if(fenceList.length>0){
                    $(".box-detail div[name='yAxis']").remove();
                    for(var i in fenceList){
                        addYaxis({
                            aggregation:"count"
                            ,field:"eventId"
                            ,label:"거수자 감지("+fenceList[i]['fenceName']+")"
                            ,condition:[
                                {
                                    key:"eventId"
                                    ,type:"$eq"
                                    ,value:"EVT314"
                                },
                                {
                                    key:"fenceId"
                                    ,type:"$eq"
                                    ,value:fenceList[i]['fenceId']
                                }
                            ]
                        });
                    }
                }else{
                    alert("해당 구역에 펜스가 없습니다.")
                }
                break;
            case "search":
                $(".loding_bar").removeClass("on");
                if(data['paramBean']!=null && data['chartList']!=null && data['dateList']!=null){
                    chartRender(data['paramBean'], data['chartList'], data['dateList']);
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
                    if(loadingBarFlag){
                        $("#heatmapLoading").addClass("on");
                    }
                    customMapMediator.setElement($(".map_pop"), $(".map_pop").find("#mapElement"));
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
                                    $("#heatmapLoading").removeClass("on");
                                }
                            }
                        }
                        ,'object' :{
                            'pointsHide' : false
                            ,'pointShiftCnt' : null
                        }
                    });
                }catch(e){
                    $("#heatmapLoading").removeClass("on");
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
                $("<tr/>",{label:$(this).attr("label")}).append(
                    $("<td/>").text($(this).contents().get(0).nodeValue)
                ).append(
                    $("<td/>").text($(this).find("b").text())
                )
            )
        });

        // 요소
        excelTag.find(">div span").each(function(){
            excelDownloadHtml.find("tbody tr[label='"+$(this).attr("label")+"']").append(
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

    function validate(){
        var start = new Date($("input[name='startDatetimeStr']").val() + " " + $("#startDatetimeHourSelect").val() + ":00:00");
        var end = new Date($("input[name='endDatetimeStr']").val() + " " + $("#endDatetimeHourSelect").val() + ":00:00");

        if(start>end){
            alertMessage("earlyDatetime");
            return false;
        }
        return true;
    }

    function searchHeatMap(startDatetime){
        if(validate()){
            let areaId = $("select[name='areaId']").val();
            if(areaId==null || areaId==''){
                alertMessage("emptyArea");
                return false;
            }

            let startDatetimeStr = $("input[name='startDatetimeStr']").val();
            if(startDatetime!=null){
                startDatetimeStr = startDatetime.format("yyyy-MM-dd HH:00:00");
            }else if(startDatetimeStr!=null && startDatetimeStr!=''){
                startDatetimeStr += " " + $("#startDatetimeHourSelect").val() + ":00:00";
            }

            let endDatetimeStr = $("input[name='endDatetimeStr']").val();
            if(endDatetimeStr!=null && endDatetimeStr!=''){
                endDatetimeStr += " " + $("#endDatetimeHourSelect").val() + ":59:59";
            }

            let param = {
                'areaId' : areaId
                ,'startDatetimeStr' : startDatetimeStr
                ,'endDatetimeStr' : endDatetimeStr
                ,'startSpeed' : $("input[name='startSpeed']").val()
                ,'endSpeed' : $("input[name='endSpeed']").val()
            };
            callAjax('heatMap',param);
        }
    }

    /*
     open 히트맵 popup
     @author psb
     */
    function openHeatMapPopup(_this){
        $(".map_pop").fadeIn();
    }

    /*
     close HeatMap popup
     @author psb
     */
    function closeHeatMapPopup(){
        $(".map_pop").fadeOut();
    }
</script>