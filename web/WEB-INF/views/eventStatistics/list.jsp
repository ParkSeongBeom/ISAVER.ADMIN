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

<!-- section Start -->
<section class="container sub_area">
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.eventStatistics"/></h3>
        <div class="navigation">
            <span><isaver:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <!-- 트리 영역 Start -->
    <article class="table_area tree_table">
        <div class="table_title_area">
            <div class="table_btn_set">
                <button class="btn btype01 bstyle01" onclick="javascript:search(); return false;"><spring:message code="common.button.search"/></button>
            </div>
        </div>
        <div class="table_contents">
            <div class="tree_box">
                <div class="search_contents">
                    <p>
                        <span><spring:message code="statistics.column.area"/></span>
                        <span><isaver:areaSelectBox htmlTagId="areaId" allModel="true"/></span>
                    </p>
                    <p>
                        <span><spring:message code="statistics.column.datetime"/></span>
                        <span>
                            <select id="mode">
                                <option value="hour"><spring:message code="statistics.selectbox.hour"/></option>
                                <option value="day"><spring:message code="statistics.selectbox.day"/></option>
                                <option value="dow"><spring:message code="statistics.selectbox.dow"/></option>
                                <option value="week"><spring:message code="statistics.selectbox.week"/></option>
                                <option value="month"><spring:message code="statistics.selectbox.month"/></option>
                                <option value="year"><spring:message code="statistics.selectbox.year"/></option>
                            </select>
                        </span>
                    </p>

                    <!-- 기간 선택에 따라 항목 나타남 -->
                    <p>
                        <span>
                            <input type="text" name="startDt" class="datepicker dpk_normal_type" disabled placeholder='<spring:message code="statistics.placeholder.start"/>'/>
                            <select id="startDtHour"></select>
                        </span>
                        <span>
                            <input type="text" name="endDt" class="datepicker dpk_normal_type" disabled placeholder='<spring:message code="statistics.placeholder.end"/>'/>
                            <select id="endDtHour"></select>
                        </span>
                    </p>

                    <p>
                        <span><spring:message code="statistics.column.event"/></span>
                        <span>
                            <select id="eventSelect">
                                <option value=""><spring:message code="common.selectbox.select"/></option>
                                <c:forEach var="event" items="${eventList}">
                                    <option value="${event.eventId}" statisticsName="${event.statisticsName}">${event.eventName} - (${event.statisticsName})</option>
                                </c:forEach>
                            </select>
                        </span>
                    </p>

                    <!-- 이벤트 선택에 따라 항목 나타남 -->
                    <p class="add_p"></p>
                </div>
            </div>
        </div>
    </article>
    <!-- 트리 영역 End -->

    <article class="chart_table_area type02" style="display:none;">
        <div class="table_title_area">
            <div class="month_btn_set">
                <button onclick="javascript:search('before'); return false;"></button>
                <p id="searchDatetime"></p>
                <button onclick="javascript:search('after'); return false;"></button>
            </div>
            <div class="depthtabs_btn_set">
                <button rel="chartView"><spring:message code="statistics.tab.graph"/></button>
                <button rel="tableView"><spring:message code="statistics.tab.table"/></button>
            </div>
        </div>

        <div id="eventStatisticsList" class="depthtabs_set"></div>
        <!-- 차트 1SET End-->
    </article>

    <div id="excelEventStatisticsList" style="display:none;"></div>
</section>

<script type="text/javascript">
    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');

    var urlConfig = {
        'listUrl':'${rootPath}/eventStatistics/search.json'
    };

    var messageConfig = {
        'emptyArea':'<spring:message code="statistics.message.emptyArea"/>'
        ,'emptyEvent':'<spring:message code="statistics.message.emptyEvent"/>'
        ,'notExistEvent':'<spring:message code="statistics.message.notExistEvent"/>'
        ,'searchFailure':'<spring:message code="statistics.message.searchFailure"/>'
        ,'emptyStartDatetime':'<spring:message code="statistics.message.emptyStartDatetime"/>'
        ,'emptyEndDatetime':'<spring:message code="statistics.message.emptyEndDatetime"/>'
    };

    var searchParam = {
        'mode' : ''
        ,'areaId' : ''
        ,'eventIds' : ''
        ,'startDatetime' : null
        ,'endDatetime' : null
        ,'chartData' : null
    };

    var chartDivTag = $("<div/>",{class:'depthTabsChild chartView'}).append(
        $("<div/>",{class:'chart_box chart01 chartDiv'})
    ).append(
        $("<div/>",{class:'chart_label'})
    );

    var tableDivTag = $("<div/>",{class:'depthTabsChild tableView'}).append(
        $("<div/>",{class:'table_title_area'}).append(
            $("<div/>",{class:'table_btn_set'}).append(
                $("<button/>",{class:'btn btype01 bstyle03', onclick:"javascript:excelDownload(); return false;"}).text("<spring:message code="common.button.excelDownload"/>")
            )
        )
    ).append(
        $("<div/>",{class:'d_defalut d_type01'}).append(
            $("<div/>",{class:'d_thead'}).append(
                $("<div/>",{class:'theadDiv'}).append(
                    $("<span/>").text("<spring:message code="statistics.column.gubn"/>")
                )
            )
        ).append(
            $("<div/>",{class:'d_tbody'}).append(
                $("<div/>",{id:"gubnBody"})
            )
        )
    );

    $(document).ready(function(){
        modifyElementClass($("body"),'chart_mode','add');

        calendarHelper.load($('input[name=startDt]'));
        calendarHelper.load($('input[name=endDt]'));

        setHourDataToSelect($('#startDtHour'),"00");
        setHourDataToSelect($('#endDtHour'),"23");

        $("#mode").on("change",function(){
            switch ($(this).val()){
                case 'hour':
                    $("#startDtHour").prop("disabled",false);
                    $("#endDtHour").prop("disabled",false);
                    break;
                case 'day':
                case 'dow':
                case 'week':
                case 'month':
                case 'year':
                    $("#startDtHour").prop("disabled",true);
                    $("#endDtHour").prop("disabled",true);
                    break;
            }
        });

        $(".depthtabs_btn_set > button").on('click',function(){
            if(!$(this).hasClass("tabs_on")){
                tabShowHide(this);
            }
        });

        $("#eventSelect").on("change",function(){
            var eventId = $(this).val();
            var eventName = $(this).find("option:selected").text();
            var statisticsName = $(this).find("option:selected").attr("statisticsName");

            if($(".add_p input[name='eventId']").length>0 && $(".add_p input[name='eventId']:eq(0)").attr("statisticsName")!=statisticsName){
                alertMessage("notExistEvent");
            }else{
                var eventTag = templateHelper.getTemplate("statisticsEvent");
                eventTag.find("input[name='eventId']").attr("statisticsName",statisticsName);
                eventTag.find("input[name='eventId']").attr("eventId",eventId);
                eventTag.find("input[name='eventId']").val(eventName);
                $(".add_p").append(eventTag);

                $(this).find("option:selected").attr("disabled","disabled");
            }

            $(this).val("");
            event.stopPropagation();
        });

        $(".depthtabs_btn_set > button:eq(0)").trigger('click');
    });

    /*
     tab Show Hide
     @author psb
     */
    function tabShowHide(_this){
        var rel = $(_this).attr("rel");
        $(".depthtabs_btn_set > button").removeClass("tabs_on");
        $(_this).addClass("tabs_on");

        $(".depthTabsChild").hide();
        $("."+rel).show();

        if(rel=="chartView" && searchParam['chartData']!=null){
            chartRender(searchParam['chartData']);
        }
    }

    /*
     search
     @author psb
     */
    function search(type){
        switch (type){
            case 'before':
                switch (searchParam['mode']){
                    case 'hour':
                    case 'day':
                        searchParam['startDatetime'].setDate(searchParam['startDatetime'].getDate()-1);
                        searchParam['endDatetime'].setDate(searchParam['endDatetime'].getDate()-1);
                        break;
                    case 'dow':
                    case 'week':
                        searchParam['startDatetime'].setDate(searchParam['startDatetime'].getDate()-7);
                        searchParam['endDatetime'].setDate(searchParam['endDatetime'].getDate()-7);
                        break;
                    case 'month':
                        searchParam['startDatetime'].setMonth(searchParam['startDatetime'].getMonth()-1);
                        searchParam['endDatetime'].setMonth(searchParam['endDatetime'].getMonth()-1);
                        break;
                    case 'year':
                        searchParam['startDatetime'].setFullYear(searchParam['startDatetime'].getFullYear()-1);
                        searchParam['endDatetime'].setFullYear(searchParam['endDatetime'].getFullYear()-1);
                        break;
                }
                break;
            case 'after':
                switch (searchParam['mode']){
                    case 'hour':
                    case 'day':
                        searchParam['startDatetime'].setDate(searchParam['startDatetime'].getDate()+1);
                        searchParam['endDatetime'].setDate(searchParam['endDatetime'].getDate()+1);
                        break;
                    case 'dow':
                    case 'week':
                        searchParam['startDatetime'].setDate(searchParam['startDatetime'].getDate()+7);
                        searchParam['endDatetime'].setDate(searchParam['endDatetime'].getDate()+7);
                        break;
                    case 'month':
                        searchParam['startDatetime'].setMonth(searchParam['startDatetime'].getMonth()+1);
                        searchParam['endDatetime'].setMonth(searchParam['endDatetime'].getMonth()+1);
                        break;
                    case 'year':
                        searchParam['startDatetime'].setFullYear(searchParam['startDatetime'].getFullYear()+1);
                        searchParam['endDatetime'].setFullYear(searchParam['endDatetime'].getFullYear()+1);
                        break;
                }
                break;
            default :
                var eventIds =  $(".add_p input[name='eventId']").map(function(){return $(this).attr("eventId")}).get();
                var mode = $("#mode option:selected").val();
                var areaId = $("#areaId option:selected").val();
                var startDatetime = $("input[name='startDt']").val();
                var endDatetime = $("input[name='endDt']").val();
                var startDatetimeHour = " " + $("#startDtHour").val() + ":00:00";
                var endDatetimeHour = " " + $("#endDtHour").val() + ":00:00";

                if(areaId==null || areaId==""){
                    alertMessage("emptyArea");
                    return false;
                }
                if(eventIds==null || eventIds==""){
                    alertMessage("emptyEvent");
                    return false;
                }
                if(startDatetime==null || startDatetime==""){
                    alertMessage("emptyStartDatetime");
                    return false;
                }
                if(endDatetime==null || endDatetime==""){
                    alertMessage("emptyEndDatetime");
                    return false;
                }

                searchParam['mode'] = mode;
                searchParam['areaId'] = areaId;
                searchParam['eventIds'] = eventIds.join(",");
                searchParam['startDatetime'] = new Date(startDatetime+startDatetimeHour);
                searchParam['endDatetime'] = new Date(endDatetime+endDatetimeHour);
                break;
        }

        var param = {
            'mode' : searchParam['mode']
            ,'areaId' : searchParam['areaId']
            ,'eventIds' : searchParam['eventIds']
            ,'startDatetime' : searchParam['startDatetime'].format("yyyy-MM-dd HH:mm:ss")
            ,'endDatetime' : searchParam['endDatetime'].format("yyyy-MM-dd HH:mm:ss")
        };

        $("#searchDatetime").text(searchParam['startDatetime'].format("yyyy.MM.dd") + " ~ " + searchParam['endDatetime'].format("yyyy.MM.dd"));
        callAjax('list',param);
    }


    /*
     list Render
     @author psb
     */
    function listRender(data){
        $("#eventStatisticsList").empty();

        var chartDivHtml = chartDivTag.clone();
        var tableDivHtml = tableDivTag.clone();
        searchParam['chartData'] = {
            labels: []
            ,series: []
        };

        var resultList = data['eventStatisticsList'];
        var eventSeries = {};

        for(var index in resultList){
            var resultMap = resultList[index];
            var infos = resultMap['infos'];
            var datetimeText;
            switch (searchParam['mode']){
                case 'hour':
                    datetimeText = new Date(resultMap['stDt']).format("HH") + "시" ;
                    break;
                case 'day':
                    datetimeText = new Date(resultMap['stDt']).format("dd") + "일" ;
                    break;
                case 'dow':
                    datetimeText = new Date(resultMap['stDt']).format("e");
                    break;
                case 'week':
                    datetimeText = resultMap['week'] + "주" ;
                    break;
                case 'month':
                    datetimeText = resultMap['stDtStr'].split("-")[1] + "월" ;
                    break;
                case 'year':
                    datetimeText = resultMap['stDtStr'] + "년" ;
                    break;
            }

            tableDivHtml.find("#gubnBody").append(
                $("<span/>",{desc:datetimeText}).text(datetimeText)
            );

            searchParam['chartData']['labels'].push(datetimeText);

            for(var i in infos){
                var info = infos[i];
                if(tableDivHtml.find(".theadDiv span[eventId='"+info['eventId']+"']").length==0){
                    tableDivHtml.find(".theadDiv").append(
                        $("<span/>",{eventId:info['eventId']}).text(info['eventName'])
                    );
                }

                if(chartDivHtml.find(".chart_label span[eventId='"+info['eventId']+"']").length==0){
                    chartDivHtml.find(".chart_label").append(
                        $("<span/>",{eventId:info['eventId']}).text(info['eventName'])
                    );
                }

                var value = info['value']!=null?info['value']:0;

                if(tableDivHtml.find(".d_tbody div[eventId='"+info['eventId']+"']").length>0){
                    tableDivHtml.find(".d_tbody div[eventId='"+info['eventId']+"']").append(
                        $("<span/>").text(value)
                    );
                }else{
                    tableDivHtml.find(".d_tbody").append(
                        $("<div/>",{eventId:info['eventId']}).append(
                            $("<span/>").text(value)
                        )
                    );
                }

                if(eventSeries[info['eventId']]==null){
                    eventSeries[info['eventId']] = [value];
                }else{
                    eventSeries[info['eventId']].push(value);
                }
            }
        }

        for(var index in eventSeries){
            searchParam['chartData']['series'].push(eventSeries[index]);
        }

        $("#eventStatisticsList").append(chartDivHtml).append(tableDivHtml);
        $(".chart_table_area").show();
        tabShowHide($(".depthtabs_btn_set > button.tabs_on"));
    }

    /*
     chart Render
     @author psb
     */
    function chartRender(data){
        console.log(data);
        new Chartist.Bar('.chartDiv', data, {
            height: 400,
            seriesBarDistance: 10,
            axisX: {
                offset: 60
            },
            axisY: {
                onlyInteger: true,
                offset: 40,
                scaleMinSpace: 15
            },
            plugins: [
                Chartist.plugins.tooltip()
            ]
        });
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
        listRender(data);
    }

    /*
     ajax error handler
     @author psb
     */
    function failureHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        console.error(messageConfig['searchFailure']);
//        alertMessage('searchFailure');
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
    function excelDownload(type){
        $("#excelEventStatisticsList").empty();

        var excelDownloadHtml = $("<table/>",{id:"excelDownloadTb"}).append(
            $("<thead/>").append(
                $("<tr/>").append()
            )
        ).append(
            $("<tbody/>")
        );

        var excelTag = null;

        if(excelTag==null){
            console.error("[excelDownload] type error : "+ type);
            return false;
        }

        excelTag.find(".theadDiv span").each(function (key) {
            if(key==0){
                excelDownloadHtml.find("thead tr").append(
                    $("<th/>").text($(this).text())
                );

                excelTag.find("#gubnBody span").each(function () {
                    excelDownloadHtml.find("thead tr").append(
                        $("<th/>").text($(this).text())
                    );
                });
            }else{
                excelDownloadHtml.find("tbody").append(
                    $("<tr/>",{id:"excelBody"+key}).append(
                        $("<td/>").text($(this).text())
                    )
                );

                excelTag.find(".d_tbody div:eq("+key+") span").each(function () {
                    excelDownloadHtml.find("#excelBody"+key).append(
                        $("<td/>").text($(this).text())
                    );
                });
            }
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
</script>