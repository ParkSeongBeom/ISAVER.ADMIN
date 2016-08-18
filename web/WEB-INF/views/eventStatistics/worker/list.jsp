<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<link rel="stylesheet" type="text/css" href="${rootPath}/assets/library/chartist/chartist.min.css" >
<link rel="stylesheet" type="text/css" href="${rootPath}/assets/library/chartist/chartist-plugin-tooltip.css" >
<script type="text/javascript" src="${rootPath}/assets/library/chartist/chartist.min.js"></script>
<script type="text/javascript" src="${rootPath}/assets/library/chartist/chartist-plugin-tooltip.js"></script>

<article class="search_area">
    <div class="search_contents">
        <p class="itype_01">
            <span><spring:message code="statistics.column.area"/></span>
            <span>
                <isaver:areaSelectBox htmlTagId="workerAreaId" allModel="true"/>
            </span>
        </p>
        <p class="itype_01">
            <span><spring:message code="statistics.column.datetime"/></span>
            <span>
                <select id="workerDateGubn">
                    <option value="day">일간</option>
                    <option value="week">주간</option>
                    <option value="month">월간</option>
                    <option value="year">년간</option>
                </select>
            </span>
        </p>
    </div>
    <div class="search_btn">
        <button onclick="javascript:search(); return false;" class="btn bstyle01 btype01"><spring:message code="common.button.search"/></button>
    </div>
</article>

<article id="workerArticle" class="chart_table_area type02">
    <div class="table_title_area">
        <div class="month_btn_set">
            <button onclick="javascript:search('before'); return false;"></button>
            <p id="workerSearchDatetime"></p>
            <button onclick="javascript:search('after'); return false;"></button>
        </div>
        <div class="depthtabs_btn_set">
            <button rel="chartView"><spring:message code="statistics.tab.graph"/></button>
            <button rel="tableView"><spring:message code="statistics.tab.table"/></button>
        </div>
    </div>

    <div id="workerEventStatisticsList" class="depthtabs_set"></div>
    <!-- 차트 1SET End-->
</article>

<script type="text/javascript">
    var urlConfig = {
        'listUrl':'${rootPath}/eventStatistics/worker.json'
    };

    var messageConfig = {
        'searchFailure':'<spring:message code="statistics.message.searchFailure"/>'
    };

    var workerSearchParam = {
        'searchDatetime' : null
        ,'areaId' : ''
        ,'dateGubn' : ''
        ,'chartData' : null
    };

    var chartDivTag = $("<div/>",{class:'depthTabsChild chartView'}).append(
        $("<div/>",{class:'chart_box type01'}).append(
            $("<div/>",{class:'chartDiv'})
        )
    ).append(
        $("<div/>",{class:'chart_label'})
    );

    var tableDivTag = $("<div/>",{class:'depthTabsChild tableView'}).append(
        $("<div/>",{class:'table_title_area'}).append(
            $("<div/>",{class:'table_btn_set'}).append(
                $("<button/>",{class:'btn btype01 bstyle03'}).text("<spring:message code="common.button.excelDownload"/>")
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
        $("#workerArticle .depthtabs_btn_set > button").on('click',function(){
           if(!$(this).hasClass("tabs_on")){
               tabShowHide(this);
           }
        });

        $("#workerArticle .depthtabs_btn_set > button:eq(0)").trigger('click');
        search();
    });

    /*
     tab Show Hide
     @author psb
     */
    function tabShowHide(_this){
        var rel = $(_this).attr("rel");
        $("#workerArticle .depthtabs_btn_set > button").removeClass("tabs_on");
        $(_this).addClass("tabs_on");

        $("#workerArticle .depthTabsChild").hide();
        $("#workerArticle ."+rel).show();

        if(rel=="chartView" && workerSearchParam['chartData']!=null){
            chartRender(workerSearchParam['chartData']);
        }
    }

    /*
     set datetime
     @author psb
     */
    function setDatetimeText(){
        var searchDatetimeText;

        switch (workerSearchParam['dateGubn']){
            case 'day':
                searchDatetimeText = workerSearchParam['searchDatetime'].format("yyyy.MM.dd");
                break;
            case 'week':
                searchDatetimeText = workerSearchParam['searchDatetime'].format("yyyy.MM") + "." + workerSearchParam['searchDatetime'].getWeekOfMonth() + "주차";
                break;
            case 'month':
                searchDatetimeText = workerSearchParam['searchDatetime'].format("yyyy.MM");
                break;
            case 'year':
                searchDatetimeText = workerSearchParam['searchDatetime'].format("yyyy");
                break;
        }

        $("#workerSearchDatetime").text(searchDatetimeText);
    }

    /*
     search
     @author psb
     */
    function search(type){
        switch (type){
            case 'before':
                switch (workerSearchParam['dateGubn']){
                    case 'day':
                        workerSearchParam['searchDatetime'].setDate(workerSearchParam['searchDatetime'].getDate()-1);
                        break;
                    case 'week':
                        workerSearchParam['searchDatetime'].setDate(workerSearchParam['searchDatetime'].getDate()-7);
                        break;
                    case 'month':
                        workerSearchParam['searchDatetime'].setMonth(workerSearchParam['searchDatetime'].getMonth()-1);
                        break;
                    case 'year':
                        workerSearchParam['searchDatetime'].setFullYear(workerSearchParam['searchDatetime'].getFullYear()-1);
                        break;
                }
                break;
            case 'after':
                switch (workerSearchParam['dateGubn']){
                    case 'day':
                        workerSearchParam['searchDatetime'].setDate(workerSearchParam['searchDatetime'].getDate()+1);
                        break;
                    case 'week':
                        workerSearchParam['searchDatetime'].setDate(workerSearchParam['searchDatetime'].getDate()+7);
                        break;
                    case 'month':
                        workerSearchParam['searchDatetime'].setMonth(workerSearchParam['searchDatetime'].getMonth()+1);
                        break;
                    case 'year':
                        workerSearchParam['searchDatetime'].setFullYear(workerSearchParam['searchDatetime'].getFullYear()+1);
                        break;
                }
                break;
            default :
                workerSearchParam['searchDatetime'] = new Date();
                workerSearchParam['areaId'] = $("#workerAreaId option:selected").val();
                workerSearchParam['dateGubn'] = $("#workerDateGubn option:selected").val();
                break;
        }

        setDatetimeText();

        var param = {
            'mode' : 'search'
            ,'areaId' : workerSearchParam['areaId']
            ,'dateGubn' : workerSearchParam['dateGubn']
            ,'searchDatetime' : workerSearchParam['searchDatetime'].format("yyyy-MM-dd")
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
        $("#workerEventStatisticsList").empty();

        var chartDivHtml = chartDivTag.clone();
        var tableDivHtml = tableDivTag.clone();

        workerSearchParam['chartData'] = {
            labels: []
            ,series: []
        };

        var dateLists = data['dateLists'];
        for(var index in dateLists){
            var datetimeText;
            switch (workerSearchParam['dateGubn']){
                case 'day':
                    datetimeText = new Date(dateLists[index]).format("HH") + "시";
                    break;
                case 'week':
                    datetimeText = new Date(dateLists[index]).format("e");
                    break;
                case 'month':
                    datetimeText = new Date(dateLists[index]).format("dd") + "일";
                    break;
                case 'year':
                    datetimeText = new Date(dateLists[index]).format("MM") + "월";
                    break;
            }

            tableDivHtml.find("#gubnBody").append(
                $("<span/>").text(datetimeText)
            );
            workerSearchParam['chartData']['labels'].push(datetimeText);
        }

        var resultList = data['resultList'];

        for(var index in resultList){
            var series = [];
            var resultMap = resultList[index];
            var eventId = resultMap['eventId'];
            delete resultMap['eventid'];
            var eventName = resultMap['eventname'];
            delete resultMap['eventname'];

            tableDivHtml.find(".theadDiv").append(
                $("<span/>").text(eventName)
            );

            chartDivHtml.find(".chart_label").append(
                $("<span/>").text(eventName)
            );

            tableDivHtml.find(".d_tbody").append(
                $("<div/>",{id:"body"+index})
            );

            Object.keys(resultMap).sort(function keyOrder(a, b) {
                var k1 = Number(a.split("date")[1]);
                var k2 = Number(b.split("date")[1]);
                if (k1 < k2) return -1;
                else if (k1 > k2) return +1;
                else return 0;
            }).forEach(function (key) {
                tableDivHtml.find("#body"+index).append(
                    $("<span/>").text(resultMap[key])
                );
                series.push(resultMap[key]);
            });

            workerSearchParam['chartData']['series'].push(series);
        }

        $("#workerEventStatisticsList").append(chartDivHtml).append(tableDivHtml);

        tabShowHide($("#workerArticle .depthtabs_btn_set > button.tabs_on"));
    }

    /*
     chart Render
     @author psb
     */
    function chartRender(data){
        new Chartist.Bar('#workerArticle .chartDiv', data, {
            seriesBarDistance: 10,
            axisX: {
                offset: 60
            },
            axisY: {
                onlyInteger: true,
                offset: 80,
                scaleMinSpace: 15
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