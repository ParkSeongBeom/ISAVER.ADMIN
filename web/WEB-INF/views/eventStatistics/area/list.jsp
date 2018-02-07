<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<link rel="stylesheet" type="text/css" href="${rootPath}/assets/library/chartist/chartist.min.css" >
<link rel="stylesheet" type="text/css" href="${rootPath}/assets/library/chartist/chartist-plugin-tooltip.css" >
<script type="text/javascript" src="${rootPath}/assets/library/chartist/chartist.min.js"></script>
<script type="text/javascript" src="${rootPath}/assets/library/chartist/chartist-plugin-tooltip.js"></script>

<article class="search_area">
    <div class="search_contents">
        <p class="itype_01">
            <span><spring:message code="statistics.column.gubn"/></span>
            <span>
                <select id="eventGubn">
                    <option value="worker"><spring:message code="statistics.selectbox.worker"/></option>
                    <option value="crane"><spring:message code="statistics.selectbox.crane"/></option>
                    <option value="gas"><spring:message code="statistics.selectbox.gas"/></option>
                    <option value="inout"><spring:message code="statistics.selectbox.inout"/></option>
                </select>
            </span>
        </p>
        <p class="itype_04">
            <span><spring:message code="statistics.column.eventDatetime"/></span>
            <span class="plable04">
                <input type="text" id="startDatetimeStr" class="month-picker">
                <select id="startDatetimeHour"></select>
                <em>~</em>
                <input type="text" id="endDatetimeStr" class="month-picker">
                <select id="endDatetimeHour"></select>
            </span>
        </p>
    </div>
    <div class="search_btn">
        <button onclick="javascript:search(); return false;" class="btn bstyle01 btype01"><spring:message code="common.button.search"/></button>
    </div>
</article>

<article class="chart_table_area type01" id="areaEventStatisticsList"></article>

<script type="text/javascript">
    var urlConfig = {
        'listUrl':'${rootPath}/eventStatistics/area.json'
    };

    var messageConfig = {
        'searchFailure':'<spring:message code="statistics.message.searchFailure"/>'
    };

    var addTag = $("<div/>").append(
        $("<div/>",{class:'chartDiv'})
    ).append(
        $("<div/>").append(
            $("<div/>",{class:'table_title_area'}).append(
                $("<h4/>")
            )
        ).append(
            $("<table/>",{class:'t_defalut t_type01 t_style02 check_th'}).append(
                $("<thead/>").append(
                    $("<tr/>").append(
                        $("<th/>").text("<spring:message code="statistics.message.areaName"/>")
                    ).append(
                        $("<th/>").text("<spring:message code="common.message.number02"/>")
                    )
                )
            ).append(
                $("<tbody/>")
            )
        )
    );

    var trTag = $("<tr/>").append(
        $("<td/>",{id:'areaName'})
    ).append(
        $("<td/>",{id:'cnt'})
    );

    $(document).ready(function(){
        calendarHelper.load($("#startDatetimeStr"));
        calendarHelper.load($("#endDatetimeStr"));

        setHourDataToSelect($('#startDatetimeHour'),null,false);
        setHourDataToSelect($('#endDatetimeHour'),null,true);

        search();
    });

    /*
     search
     @author psb
     */
    function search(){
        var param = {
            'mode' : 'search'
            ,'eventGubn' : $("#eventGubn option:selected").val()
            ,'startDatetimeStr' : $("#startDatetimeStr").val()
            ,'startDatetimeHour' : $("#startDatetimeHour option:selected").val()
            ,'endDatetimeStr' : $("#endDatetimeStr").val()
            ,'endDatetimeHour' : $("#endDatetimeHour option:selected").val()
        };

        callAjax('list',param);
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
     list Render
     @author psb
     */
    function listRender(data){
        $("#areaEventStatisticsList").empty();

        var resultList = data['resultList'];

        for(var index in resultList){
            var event = resultList[index]['event'];
            var areaList = resultList[index]['list'];

            var tagHtml = addTag.clone();
            tagHtml.find(".chartDiv").addClass(event['eventId'])
            tagHtml.find("h4").text(event['eventName']);

            var chartData = {
                labels: []
                ,series: []
            };

            for(var i in areaList){
                var area = areaList[i];
                var trHtml = trTag.clone();
                var rank = Number(i)+1;
                if(rank<10){
                    trHtml.addClass("top0"+rank);
                    chartData['series'].push(area['eventCnt']);
                }else if(rank==10){
                    trHtml.addClass("top10");
                    chartData['series'].push(area['eventCnt']);
                }else{
                    trHtml.addClass("top00");
                }

                trHtml.find("#areaName").text(area['areaName']);
                trHtml.find("#cnt").text(area['eventCnt']);

                tagHtml.find("tbody").append(trHtml);
            }

            $("#areaEventStatisticsList").append(tagHtml);

            chartRender(chartData, event['eventId']);
        }
    }

    /*
     chart Render
     @author psb
     */
    function chartRender(data, eventId){
        var sum = function(a, b) { return a + b };

        new Chartist.Pie('.'+eventId, data, {
            labelInterpolationFnc: function(value) {
                var returnValue = "0%";
                if(value > 0){
                    returnValue = Math.round(value / data.series.reduce(sum) * 100) + '%';
                }
                return returnValue;
            },
            plugins: [
                Chartist.plugins.tooltip()
            ]
        });
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
</script>