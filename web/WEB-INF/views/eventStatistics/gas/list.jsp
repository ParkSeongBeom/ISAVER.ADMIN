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
                <isaver:areaSelectBox htmlTagId="gasAreaId" allModel="true"/>
            </span>
        </p>
        <p class="itype_01">
            <span><spring:message code="statistics.column.gubn"/></span>
            <span>
                <select id="gasChartGubn">
                    <option value="state">상태 변화 추이</option>
                    <option value="cnt">알림 발생 건수</option>
                </select>
            </span>
        </p>
        <p class="itype_01">
            <span><spring:message code="statistics.column.datetime"/></span>
            <span>
                <select id="gasDateGubn">
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

<article id="gasArticle" class="chart_table_area type02">
    <div class="table_title_area">
        <div class="month_btn_set">
            <button onclick="javascript:search('before'); return false;"></button>
            <p id="gasSearchDatetime"></p>
            <button onclick="javascript:search('after'); return false;"></button>
        </div>
        <div class="depthtabs_btn_set">
            <button rel="chartView"><spring:message code="statistics.tab.graph"/></button>
            <button rel="tableView"><spring:message code="statistics.tab.table"/></button>
        </div>
    </div>

    <div id="gasEventStatisticsList" class="depthtabs_set"></div>
    <!-- 차트 1SET End-->
</article>

<script type="text/javascript">
    var urlConfig = {
        'listUrl':'${rootPath}/eventStatistics/gas.json'
    };

    var messageConfig = {
        'searchFailure':'<spring:message code="statistics.message.searchFailure"/>'
    };

    var gasSearchParam = {
        'searchDatetime' : null
        ,'areaId' : ''
        ,'chartGubn' : ''
        ,'dateGubn' : ''
        ,'chartData' : null
    };

    var tempData = {
        'oxygen' : [63, 72, 59, 60, 51, 76, 72, 55, 51, 52, 55, 54, 62, 76, 58, 71, 70, 59, 68, 55, 51, 73, 66, 60]
        ,'carbonMonoxide' : [35, 20, 10, 15, 20, 25, 32, 15, 17, 16, 22, 29, 19, 18, 25, 28, 29, 13, 19, 16, 28, 27, 33, 32]
        ,'hydrogenSulfide' : [1, 5, 2, 5, 3, 1, 0, 3, 6, 7, 2, 7, 3, 6, 8, 9, 1, 3, 1, 2, 6, 3, 6, 7]
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
                    $("<span/>").text('<spring:message code="statistics.column.gubn"/>')
                )
            )
        ).append(
            $("<div/>",{class:'d_tbody'}).append(
                $("<div/>",{id:"gubnBody"})
            )
        )
    );

    $(document).ready(function(){
        $("#gasChartGubn").on("change",function(){
            if($(this).val()=="state"){
                $("#gasDateGubn option:not([value='day'])").prop('disabled', true);
                $("#gasDateGubn").val('day');
            }else{
                $("#gasDateGubn option").prop('disabled', false);
            }
        });

        $("#gasArticle .depthtabs_btn_set > button").on('click',function(){
           if(!$(this).hasClass("tabs_on")){
               tabShowHide(this);
           }
        });

        $("#gasArticle .depthtabs_btn_set > button:eq(0)").trigger('click');
        search();
    });

    /*
     tab Show Hide
     @author psb
     */
    function tabShowHide(_this){
        var rel = $(_this).attr("rel");
        $("#gasArticle .depthtabs_btn_set > button").removeClass("tabs_on");
        $(_this).addClass("tabs_on");

        $("#gasArticle .depthTabsChild").hide();
        $("#gasArticle ."+rel).show();

        if(rel=="chartView" && gasSearchParam['chartData']!=null){
            chartRender(gasSearchParam['chartData']);
        }
    }

    /*
     set datetime
     @author psb
     */
    function setDatetimeText(){
        var searchDatetimeText;

        switch (gasSearchParam['dateGubn']){
            case 'day':
                searchDatetimeText = gasSearchParam['searchDatetime'].format("yyyy.MM.dd");
                break;
            case 'week':
                searchDatetimeText = gasSearchParam['searchDatetime'].format("yyyy.MM") + "." + gasSearchParam['searchDatetime'].getWeekOfMonth() + "주차";
                break;
            case 'month':
                searchDatetimeText = gasSearchParam['searchDatetime'].format("yyyy.MM");
                break;
            case 'year':
                searchDatetimeText = gasSearchParam['searchDatetime'].format("yyyy");
                break;
        }

        $("#gasSearchDatetime").text(searchDatetimeText);
    }

    /*
     search
     @author psb
     */
    function search(type){
        switch (type){
            case 'before':
                switch (gasSearchParam['dateGubn']){
                    case 'day':
                        gasSearchParam['searchDatetime'].setDate(gasSearchParam['searchDatetime'].getDate()-1);
                        break;
                    case 'week':
                        gasSearchParam['searchDatetime'].setDate(gasSearchParam['searchDatetime'].getDate()-7);
                        break;
                    case 'month':
                        gasSearchParam['searchDatetime'].setMonth(gasSearchParam['searchDatetime'].getMonth()-1);
                        break;
                    case 'year':
                        gasSearchParam['searchDatetime'].setFullYear(gasSearchParam['searchDatetime'].getFullYear()-1);
                        break;
                }
                break;
            case 'after':
                switch (gasSearchParam['dateGubn']){
                    case 'day':
                        gasSearchParam['searchDatetime'].setDate(gasSearchParam['searchDatetime'].getDate()+1);
                        break;
                    case 'week':
                        gasSearchParam['searchDatetime'].setDate(gasSearchParam['searchDatetime'].getDate()+7);
                        break;
                    case 'month':
                        gasSearchParam['searchDatetime'].setMonth(gasSearchParam['searchDatetime'].getMonth()+1);
                        break;
                    case 'year':
                        gasSearchParam['searchDatetime'].setFullYear(gasSearchParam['searchDatetime'].getFullYear()+1);
                        break;
                }
                break;
            default :
                gasSearchParam['searchDatetime'] = new Date();
                gasSearchParam['areaId'] = $("#gasAreaId option:selected").val();
                gasSearchParam['chartGubn'] = $("#gasChartGubn option:selected").val();
                gasSearchParam['dateGubn'] = $("#gasDateGubn option:selected").val();
                break;
        }

        setDatetimeText();

        var param = {
            'mode' : 'search'
            ,'areaId' : gasSearchParam['areaId']
            ,'chartGubn' : gasSearchParam['chartGubn']
            ,'dateGubn' : gasSearchParam['dateGubn']
            ,'searchDatetime' : gasSearchParam['searchDatetime'].format("yyyy-MM-dd")
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
        $("#gasEventStatisticsList").empty();

        var chartDivHtml = chartDivTag.clone();
        var tableDivHtml = tableDivTag.clone();
        gasSearchParam['chartData'] = {
            labels: []
            ,series: []
        };

        var dateLists = data['dateLists'];

        for(var index in dateLists){
            var datetimeText;
            switch (gasSearchParam['dateGubn']){
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
            gasSearchParam['chartData']['labels'].push(datetimeText);
        }

        if(gasSearchParam['chartGubn']=="state"){
            chartDivHtml.find(".chart_label").append(
                $("<span/>").text('산소(%)')
            ).append(
                $("<span/>").text('일산화탄소(ppm)')
            ).append(
                $("<span/>").text('황하수소(ppm)')
            );
        }else{
            chartDivHtml.find(".chart_label").append(
                $("<span/>").text('산소 결핍')
            ).append(
                $("<span/>").text('산소 경고')
            ).append(
                $("<span/>").text('일산화탄소 과다')
            ).append(
                $("<span/>").text('일산화탄소 경고')
            ).append(
                $("<span/>").text('황하수소 과다')
            ).append(
                $("<span/>").text('황하수소 경고')
            );
        }

        tableDivHtml.find(".theadDiv").append(
            $("<span/>").text('산소(%)')
        ).append(
            $("<span/>").text('일산화탄소(ppm)')
        ).append(
            $("<span/>").text('황하수소(ppm)')
        );

        tableDivHtml.find(".d_tbody").append(
            $("<div/>",{id:'oxygen'})
        ).append(
            $("<div/>",{id:'carbonMonoxide'})
        ).append(
            $("<div/>",{id:'hydrogenSulfide'})
        );

        var oxygenSeries = [];
        var carbonMonoxideSeries = [];
        var hydrogenSulfideSeries = [];
        for(var index=0; index<dateLists.length; index++){
            tableDivHtml.find("#oxygen").append(
                $("<span/>").text(tempData['oxygen'][index])
            );
            oxygenSeries.push(tempData['oxygen'][index]);
            tableDivHtml.find("#carbonMonoxide").append(
                $("<span/>").text(tempData['carbonMonoxide'][index])
            );
            carbonMonoxideSeries.push(tempData['carbonMonoxide'][index]);
            tableDivHtml.find("#hydrogenSulfide").append(
                $("<span/>").text(tempData['hydrogenSulfide'][index])
            );
            hydrogenSulfideSeries.push(tempData['hydrogenSulfide'][index]);
        }
        gasSearchParam['chartData']['series'].push(oxygenSeries);
        gasSearchParam['chartData']['series'].push(carbonMonoxideSeries);
        gasSearchParam['chartData']['series'].push(hydrogenSulfideSeries);

        $("#gasEventStatisticsList").append(chartDivHtml).append(tableDivHtml);

        tabShowHide($("#gasArticle .depthtabs_btn_set > button.tabs_on"));
    }

    /*
     chart Render
     @author psb
     */
    function chartRender(data){
        if(gasSearchParam['chartGubn']=="state"){
            new Chartist.Line('#gasArticle .chartDiv', data, {
                low: 0,
                fullWidth : false,
                axisY: {
                    onlyInteger: true,
                    offset: 20
                },
                plugins: [
                    Chartist.plugins.tooltip()
                ]
            });
        }else{
            new Chartist.Bar('#gasArticle .chartDiv', data, {
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