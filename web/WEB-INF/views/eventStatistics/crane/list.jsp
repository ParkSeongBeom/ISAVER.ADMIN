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
                <isaver:areaSelectBox htmlTagId="craneAreaId" allModel="true"/>
            </span>
        </p>
        <p class="itype_01">
            <span><spring:message code="statistics.column.datetime"/></span>
            <span>
                <select id="craneDateGubn">
                    <option value="day"><spring:message code="statistics.selectbox.daily"/></option>
                    <option value="week"><spring:message code="statistics.selectbox.weekly"/></option>
                    <option value="month"><spring:message code="statistics.selectbox.monthly"/></option>
                    <option value="year"><spring:message code="statistics.selectbox.year"/></option>
                </select>
            </span>
        </p>
    </div>
    <div class="search_btn">
        <button onclick="javascript:craneSearch(); return false;" class="btn bstyle01 btype01"><spring:message code="common.button.search"/></button>
    </div>
</article>

<article id="craneArticle" class="chart_table_area type02">
    <div class="table_title_area">
        <div class="month_btn_set">
            <button onclick="javascript:craneSearch('before'); return false;"></button>
            <p id="craneSearchDatetime"></p>
            <button onclick="javascript:craneSearch('after'); return false;"></button>
        </div>
        <div class="depthtabs_btn_set">
            <button rel="chartView"><spring:message code="statistics.tab.graph"/></button>
            <button rel="tableView"><spring:message code="statistics.tab.table"/></button>
        </div>
    </div>

    <div id="craneEventStatisticsList" class="depthtabs_set"></div>
    <!-- 차트 1SET End-->
</article>

<script type="text/javascript">
    var craneUrlConfig = {
        'listUrl':'${rootPath}/eventStatistics/crane.json'
    };

    var craneMessageConfig = {
        'searchFailure':'<spring:message code="statistics.message.searchFailure"/>'
    };

    var craneSearchParam = {
        'searchDatetime' : null
        ,'areaId' : ''
        ,'dateGubn' : ''
        ,'chartData' : null
    };

    var craneChartDivTag = $("<div/>",{class:'depthTabsChild chartView'}).append(
        $("<div/>",{class:'chart_box type01'}).append(
            $("<div/>",{class:'chartDiv'})
        )
    ).append(
        $("<div/>",{class:'chart_label'})
    );

    var craneTableDivTag = $("<div/>",{class:'depthTabsChild tableView'}).append(
        $("<div/>",{class:'table_title_area'}).append(
            $("<div/>",{class:'table_btn_set'}).append(
                $("<button/>",{class:'btn btype01 bstyle03', onclick:"javascript:excelDownload('crane'); return false;"}).text("<spring:message code="common.button.excelDownload"/>")
            )
        )
    ).append(
        $("<div/>",{class:'d_defalut d_type01 craneExcelDownload'}).append(
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
        $("#craneArticle .depthtabs_btn_set > button").on('click',function(){
           if(!$(this).hasClass("tabs_on")){
               craneTabShowHide(this);
           }
        });

        $("#craneArticle .depthtabs_btn_set > button:eq(0)").trigger('click');
        craneSearch();
    });

    /*
     tab Show Hide
     @author psb
     */
    function craneTabShowHide(_this){
        var rel = $(_this).attr("rel");
        $("#craneArticle .depthtabs_btn_set > button").removeClass("tabs_on");
        $(_this).addClass("tabs_on");

        $("#craneArticle .depthTabsChild").hide();
        $("#craneArticle ."+rel).show();

        if(rel=="chartView" && craneSearchParam['chartData']!=null){
            craneChartRender(craneSearchParam['chartData']);
        }
    }

    /*
     set datetime
     @author psb
     */
    function craneSetDatetimeText(){
        var searchDatetimeText;

        switch (craneSearchParam['dateGubn']){
            case 'day':
                searchDatetimeText = craneSearchParam['searchDatetime'].format("yyyy.MM.dd");
                break;
            case 'week':
                searchDatetimeText = craneSearchParam['searchDatetime'].format("yyyy.MM") + "." + craneSearchParam['searchDatetime'].getWeekOfMonth() + "주차";
                break;
            case 'month':
                searchDatetimeText = craneSearchParam['searchDatetime'].format("yyyy.MM");
                break;
            case 'year':
                searchDatetimeText = craneSearchParam['searchDatetime'].format("yyyy");
                break;
        }

        $("#craneSearchDatetime").text(searchDatetimeText);
    }

    /*
     search
     @author psb
     */
    function craneSearch(type){
        switch (type){
            case 'before':
                switch (craneSearchParam['dateGubn']){
                    case 'day':
                        craneSearchParam['searchDatetime'].setDate(craneSearchParam['searchDatetime'].getDate()-1);
                        break;
                    case 'week':
                        craneSearchParam['searchDatetime'].setDate(craneSearchParam['searchDatetime'].getDate()-7);
                        break;
                    case 'month':
                        craneSearchParam['searchDatetime'].setMonth(craneSearchParam['searchDatetime'].getMonth()-1);
                        break;
                    case 'year':
                        craneSearchParam['searchDatetime'].setFullYear(craneSearchParam['searchDatetime'].getFullYear()-1);
                        break;
                }
                break;
            case 'after':
                switch (craneSearchParam['dateGubn']){
                    case 'day':
                        craneSearchParam['searchDatetime'].setDate(craneSearchParam['searchDatetime'].getDate()+1);
                        break;
                    case 'week':
                        craneSearchParam['searchDatetime'].setDate(craneSearchParam['searchDatetime'].getDate()+7);
                        break;
                    case 'month':
                        craneSearchParam['searchDatetime'].setMonth(craneSearchParam['searchDatetime'].getMonth()+1);
                        break;
                    case 'year':
                        craneSearchParam['searchDatetime'].setFullYear(craneSearchParam['searchDatetime'].getFullYear()+1);
                        break;
                }
                break;
            default :
                craneSearchParam['searchDatetime'] = new Date();
                craneSearchParam['areaId'] = $("#craneAreaId option:selected").val();
                craneSearchParam['dateGubn'] = $("#craneDateGubn option:selected").val();
                break;
        }

        craneSetDatetimeText();

        var param = {
            'mode' : 'search'
            ,'areaId' : craneSearchParam['areaId']
            ,'dateGubn' : craneSearchParam['dateGubn']
            ,'searchDatetime' : craneSearchParam['searchDatetime'].format("yyyy-MM-dd")
        };

        craneCallAjax('list',param);
    }

    /*
     ajax call
     @author psb
     */
    function craneCallAjax(actionType, data){
        sendAjaxPostRequest(craneUrlConfig[actionType + 'Url'],data,craneSuccessHandler,craneFailureHandler,actionType);
    }

    /*
     ajax success handler
     @author psb
     */
    function craneSuccessHandler(data, dataType, actionType){
        craneListRender(data);
    }

    /*
     list Render
     @author psb
     */
    function craneListRender(data){
        $("#craneEventStatisticsList").empty();

        var chartDivHtml = craneChartDivTag.clone();
        var tableDivHtml = craneTableDivTag.clone();
        craneSearchParam['chartData'] = {
            labels: []
            ,series: []
        };

        var dateLists = data['dateLists'];
        for(var index in dateLists){
            var datetimeText;
            switch (craneSearchParam['dateGubn']){
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
            craneSearchParam['chartData']['labels'].push(datetimeText);
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

            craneSearchParam['chartData']['series'].push(series);
        }

        $("#craneEventStatisticsList").append(chartDivHtml).append(tableDivHtml);

        craneTabShowHide($("#craneArticle .depthtabs_btn_set > button.tabs_on"));
    }

    /*
     chart Render
     @author psb
     */
    function craneChartRender(data){
        new Chartist.Bar('#craneArticle .chartDiv', data, {
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
    function craneFailureHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        console.error(craneMessageConfig['searchFailure']);
//        craneAlertMessage('searchFailure');
    }

    /*
     alert message method
     @author psb
     */
    function craneAlertMessage(type){
        alert(craneMessageConfig[type]);
    }
</script>