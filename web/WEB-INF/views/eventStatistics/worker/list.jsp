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
<script type="text/javascript" src="${rootPath}/assets/library/excelexport/jquery.techbytarun.excelexportjs.js"></script>

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
                    <option value="day"><spring:message code="statistics.selectbox.daily"/></option>
                    <option value="week"><spring:message code="statistics.selectbox.weekly"/></option>
                    <option value="month"><spring:message code="statistics.selectbox.monthly"/></option>
                    <option value="year"><spring:message code="statistics.selectbox.year"/></option>
                </select>
            </span>
        </p>
    </div>
    <div class="search_btn">
        <button onclick="javascript:workerSearch(); return false;" class="btn bstyle01 btype01"><spring:message code="common.button.search"/></button>
    </div>
</article>

<article id="workerArticle" class="chart_table_area type02">
    <div class="table_title_area">
        <div class="month_btn_set">
            <button onclick="javascript:workerSearch('before'); return false;"></button>
            <p id="workerSearchDatetime"></p>
            <button onclick="javascript:workerSearch('after'); return false;"></button>
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
    var workerUrlConfig = {
        'listUrl':'${rootPath}/eventStatistics/worker.json'
    };

    var workerMessageConfig = {
        'searchFailure':'<spring:message code="statistics.message.searchFailure"/>'
    };

    var workerSearchParam = {
        'searchDatetime' : null
        ,'areaId' : ''
        ,'dateGubn' : ''
        ,'chartData' : null
    };

    var workerChartDivTag = $("<div/>",{class:'depthTabsChild chartView'}).append(
        $("<div/>",{class:'chart_box type01'}).append(
            $("<div/>",{class:'chartDiv'})
        )
    ).append(
        $("<div/>",{class:'chart_label'})
    );

    var workerTableDivTag = $("<div/>",{class:'depthTabsChild tableView'}).append(
        $("<div/>",{class:'table_title_area'}).append(
            $("<div/>",{class:'table_btn_set'}).append(
                $("<button/>",{class:'btn btype01 bstyle03', onclick:"javascript:excelDownload('worker'); return false;"}).text("<spring:message code="common.button.excelDownload"/>")
            )
        )
    ).append(
        $("<div/>",{class:'d_defalut d_type01 workerExcelDownload'}).append(
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
               workerTabShowHide(this);
           }
        });

        $("#workerArticle .depthtabs_btn_set > button:eq(0)").trigger('click');
        workerSearch();
    });

    /*
     tab Show Hide
     @author psb
     */
    function workerTabShowHide(_this){
        var rel = $(_this).attr("rel");
        $("#workerArticle .depthtabs_btn_set > button").removeClass("tabs_on");
        $(_this).addClass("tabs_on");

        $("#workerArticle .depthTabsChild").hide();
        $("#workerArticle ."+rel).show();

        if(rel=="chartView" && workerSearchParam['chartData']!=null){
            workerChartRender(workerSearchParam['chartData']);
        }
    }

    /*
     set datetime
     @author psb
     */
    function workerSetDatetimeText(){
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
    function workerSearch(type){
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

        workerSetDatetimeText();

        var param = {
            'mode' : 'search'
            ,'areaId' : workerSearchParam['areaId']
            ,'dateGubn' : workerSearchParam['dateGubn']
            ,'searchDatetime' : workerSearchParam['searchDatetime'].format("yyyy-MM-dd")
        };

        workerCallAjax('list',param);
    }

    /*
     ajax call
     @author psb
     */
    function workerCallAjax(actionType, data){
        sendAjaxPostRequest(workerUrlConfig[actionType + 'Url'],data,workerSuccessHandler,workerFailureHandler,actionType);
    }

    /*
     ajax success handler
     @author psb
     */
    function workerSuccessHandler(data, dataType, actionType){
        workerListRender(data);
    }

    /*
     list Render
     @author psb
     */
    function workerListRender(data){
        $("#workerEventStatisticsList").empty();

        var chartDivHtml = workerChartDivTag.clone();
        var tableDivHtml = workerTableDivTag.clone();

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

        workerTabShowHide($("#workerArticle .depthtabs_btn_set > button.tabs_on"));
    }

    /*
     chart Render
     @author psb
     */
    function workerChartRender(data){
        new Chartist.Bar('#workerArticle .chartDiv', data, {
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
     ajax error handler
     @author psb
     */
    function workerFailureHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        console.error(workerMessageConfig['searchFailure']);
//        workerAlertMessage('searchFailure');
    }

    /*
     alert message method
     @author psb
     */
    function workerAlertMessage(type){
        alert(workerMessageConfig[type]);
    }
</script>