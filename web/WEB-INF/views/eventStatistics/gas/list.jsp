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
                    <option value="week" disabled="disabled">주간</option>
                    <option value="month" disabled="disabled">월간</option>
                    <option value="year" disabled="disabled">년간</option>
                </select>
            </span>
        </p>
    </div>
    <div class="search_btn">
        <button onclick="javascript:gasSearch(); return false;" class="btn bstyle01 btype01"><spring:message code="common.button.search"/></button>
    </div>
</article>

<article id="gasArticle" class="chart_table_area type02">
    <div class="table_title_area">
        <div class="month_btn_set">
            <button onclick="javascript:gasSearch('before'); return false;"></button>
            <p id="gasSearchDatetime"></p>
            <button onclick="javascript:gasSearch('after'); return false;"></button>
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
    var gasUrlConfig = {
        'listUrl':'${rootPath}/eventStatistics/gas.json'
    };

    var gasMessageConfig = {
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
        'oxygen' : [63, 72, 59, 60, 51, 76, 72, 55, 51, 52, 55, 54, 62, 76, 58, 71, 70, 59, 68, 55, 51, 73, 66, 60, 76, 72, 55, 51, 52, 55, 54]
        ,'oxygenMin' : [51, 52, 55, 54, 62, 76, 58, 71, 70, 59, 68, 55, 51, 73, 66, 60, 63, 72, 59, 60, 51, 76, 72, 55, 76, 72, 55, 51, 52, 55, 54]
        ,'oxygenMax' : [51, 76, 72, 55, 51, 52, 55, 54, 62, 76, 58, 71, 63, 72, 59, 60, 70, 59, 68, 55, 51, 73, 66, 60, 76, 72, 55, 51, 52, 55, 54]
        ,'carbonMonoxide' : [35, 20, 10, 15, 20, 25, 32, 15, 17, 16, 22, 29, 19, 18, 25, 28, 29, 13, 19, 16, 28, 27, 33, 32, 15, 17, 16, 22, 29, 19, 18]
        ,'carbonMonoxideMin' : [29, 13, 19, 16, 28, 27, 33, 32, 15, 17, 16, 35, 20, 10, 15, 20, 25, 32, 15, 17, 16, 22, 29, 19, 18, 25, 28, 22, 29, 19, 18]
        ,'carbonMonoxideMax' : [15, 17, 16, 22, 29, 19, 18, 25, 28, 29, 13, 19, 16, 28, 27, 33, 32, 35, 20, 10, 15, 20, 25, 32, 15, 17, 16, 22, 29, 19, 18]
        ,'hydrogenSulfide' : [1, 5, 2, 5, 3, 1, 0, 3, 6, 7, 2, 7, 3, 6, 8, 9, 1, 3, 1, 2, 6, 3, 6, 7, 3, 6, 7, 2, 7, 3, 6]
        ,'hydrogenSulfideMin' : [2, 7, 3, 6, 8, 1, 5, 2, 5, 3, 1, 0, 3, 9, 1, 3, 1, 2, 6, 3, 6, 7, 6, 7, 3, 6, 7, 2, 7, 3, 6]
        ,'hydrogenSulfideMax' : [9, 1, 3, 1, 2, 6, 3, 1, 5, 2, 5, 3, 1, 0, 3, 6, 7, 2, 7, 6, 7, 3, 6, 7, 2, 7, 3, 6, 3, 6, 8]
    };

    var gasChartDivTag = $("<div/>",{class:'depthTabsChild chartView'}).append(
        $("<div/>",{class:'chart_box type01'}).append(
            $("<div/>",{class:'chartDiv'})
        )
    ).append(
        $("<div/>",{class:'chart_label'})
    );

    var gasTableDivTag = $("<div/>",{class:'depthTabsChild tableView'}).append(
        $("<div/>",{class:'table_title_area'}).append(
            $("<div/>",{class:'table_btn_set'}).append(
                $("<button/>",{class:'btn btype01 bstyle03', onclick:"javascript:excelDownload('gas'); return false;"}).text("<spring:message code="common.button.excelDownload"/>")
            )
        )
    ).append(
        $("<div/>",{class:'d_defalut d_type01 gasExcelDownload'}).append(
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
               gasTabShowHide(this);
           }
        });

        $("#gasArticle .depthtabs_btn_set > button:eq(0)").trigger('click');
        gasSearch();
    });

    /*
     tab Show Hide
     @author psb
     */
    function gasTabShowHide(_this){
        var rel = $(_this).attr("rel");
        $("#gasArticle .depthtabs_btn_set > button").removeClass("tabs_on");
        $(_this).addClass("tabs_on");

        $("#gasArticle .depthTabsChild").hide();
        $("#gasArticle ."+rel).show();

        if(rel=="chartView" && gasSearchParam['chartData']!=null){
            gasChartRender(gasSearchParam['chartData']);
        }
    }

    /*
     set datetime
     @author psb
     */
    function gasSetDatetimeText(){
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
    function gasSearch(type){
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

        gasSetDatetimeText();

        var param = {
            'mode' : 'search'
            ,'areaId' : gasSearchParam['areaId']
            ,'chartGubn' : gasSearchParam['chartGubn']
            ,'dateGubn' : gasSearchParam['dateGubn']
            ,'searchDatetime' : gasSearchParam['searchDatetime'].format("yyyy-MM-dd")
        };

        gasCallAjax('list',param);
    }

    /*
     ajax call
     @author psb
     */
    function gasCallAjax(actionType, data){
        sendAjaxPostRequest(gasUrlConfig[actionType + 'Url'],data,gasSuccessHandler,gasFailureHandler,actionType);
    }

    /*
     ajax success handler
     @author psb
     */
    function gasSuccessHandler(data, dataType, actionType){
        gasListRender(data);
    }

    /*
     list Render
     @author psb
     */
    function gasListRender(data){
        $("#gasEventStatisticsList").empty();

        var chartDivHtml = gasChartDivTag.clone();
        var tableDivHtml = gasTableDivTag.clone();
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

            tableDivHtml.find(".theadDiv").append(
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

            tableDivHtml.find(".d_tbody").append(
                $("<div/>",{id:'oxygenMin'})
            ).append(
                $("<div/>",{id:'oxygenMax'})
            ).append(
                $("<div/>",{id:'carbonMonoxideMin'})
            ).append(
                $("<div/>",{id:'carbonMonoxideMax'})
            ).append(
                $("<div/>",{id:'hydrogenSulfideMin'})
            ).append(
                $("<div/>",{id:'hydrogenSulfideMax'})
            );

            var oxygenMinSeries = [];
            var oxygenMaxSeries = [];
            var carbonMonoxideMinSeries = [];
            var carbonMonoxideMaxSeries = [];
            var hydrogenSulfideMinSeries = [];
            var hydrogenSulfideMaxSeries = [];
            for(var index=0; index<dateLists.length; index++){
                tableDivHtml.find("#oxygenMin").append(
                    $("<span/>").text(tempData['oxygenMin'][index])
                );
                oxygenMinSeries.push(tempData['oxygenMin'][index]);
                tableDivHtml.find("#oxygenMax").append(
                    $("<span/>").text(tempData['oxygenMax'][index])
                );
                oxygenMaxSeries.push(tempData['oxygenMax'][index]);

                tableDivHtml.find("#carbonMonoxideMin").append(
                    $("<span/>").text(tempData['carbonMonoxideMin'][index])
                );
                carbonMonoxideMinSeries.push(tempData['carbonMonoxideMin'][index]);
                tableDivHtml.find("#carbonMonoxideMax").append(
                    $("<span/>").text(tempData['carbonMonoxideMax'][index])
                );
                carbonMonoxideMaxSeries.push(tempData['carbonMonoxideMax'][index]);

                tableDivHtml.find("#hydrogenSulfideMin").append(
                    $("<span/>").text(tempData['hydrogenSulfideMin'][index])
                );
                hydrogenSulfideMinSeries.push(tempData['hydrogenSulfideMin'][index]);
                tableDivHtml.find("#hydrogenSulfideMax").append(
                    $("<span/>").text(tempData['hydrogenSulfideMax'][index])
                );
                hydrogenSulfideMaxSeries.push(tempData['hydrogenSulfideMax'][index]);
            }
            gasSearchParam['chartData']['series'].push(oxygenMinSeries);
            gasSearchParam['chartData']['series'].push(oxygenMaxSeries);
            gasSearchParam['chartData']['series'].push(carbonMonoxideMinSeries);
            gasSearchParam['chartData']['series'].push(carbonMonoxideMaxSeries);
            gasSearchParam['chartData']['series'].push(hydrogenSulfideMinSeries);
            gasSearchParam['chartData']['series'].push(hydrogenSulfideMaxSeries);
        }

        $("#gasEventStatisticsList").append(chartDivHtml).append(tableDivHtml);

        gasTabShowHide($("#gasArticle .depthtabs_btn_set > button.tabs_on"));
    }

    /*
     chart Render
     @author psb
     */
    function gasChartRender(data){
        if(gasSearchParam['chartGubn']=="state"){
            new Chartist.Line('#gasArticle .chartDiv', data, {
                height: 400,
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
    }

    /*
     ajax error handler
     @author psb
     */
    function gasFailureHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        console.error(gasMessageConfig['searchFailure']);
//        gasAlertMessage('searchFailure');
    }

    /*
     alert message method
     @author psb
     */
    function gasAlertMessage(type){
        alert(gasMessageConfig[type]);
    }
</script>