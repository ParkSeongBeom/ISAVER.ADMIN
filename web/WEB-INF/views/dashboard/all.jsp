<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<c:set value="H00010" var="menuId"/>
<c:set value="H00000" var="subMenuId"/>
<isaver:pageRoleCheck menuId="${menuId}" />

<link rel="stylesheet" type="text/css" href="${rootPath}/assets/library/chartist/chartist.min.css" >
<script type="text/javascript" src="${rootPath}/assets/library/chartist/chartist.min.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/jquery.marquee.js"></script>

<!-- section Start -->
<section  class="container">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="main_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title">All</h3>
        <!-- 마키 영역 Start -->
        <div id="marqueeList" class="marquee" onclick="javascript:alramShowHide('list', 'show');"></div>
        <!-- 마키 영역 End -->
    </article>

    <!-- 2depth 타이틀 영역 End -->
    <article class="dash_contents_area nano">
        <div class="nano-content">
            <div class="metro_root mr_h70">
                <div class="metro_parent">
                    <div id="workerDiv" title="<spring:message code="dashboard.title.worker"/>">
                        <div class="mp_header">
                            <h2><spring:message code="dashboard.title.worker"/></h2>
                            <div>
                                <button class="alra_btn"></button>
                            </div>
                        </div>
                        <div class="mp_contents">
                            <div class="mc_bico type01 worker"></div>
                            <div class="mc_element nano">
                                <div class="mce_btn_area nano-content">
                                    <c:choose>
                                        <c:when test="${areas != null and fn:length(areas) > 0}">
                                            <c:forEach var="area" items="${areas}">
                                                <button href="#" onclick="javascript:moveDashBoardDetail('${area.areaId}')"><span>${area.areaName}</span></button>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="inoutDiv" title="<spring:message code="dashboard.title.inout"/>">
                        <div class="mp_header">
                            <h2><spring:message code="dashboard.title.inout"/></h2>
                        </div>
                        <div class="mp_contents">
                            <div class="mc_bico type01 going"></div>
                            <div class="mc_element nano">
                                <div class="mce_btn_area nano-content">
                                    <c:choose>
                                        <c:when test="${areas != null and fn:length(areas) > 0}">
                                            <c:forEach var="area" items="${areas}">
                                                <!-- level02 클래스, <span>54<em>-02</em> 삽입 -->
                                                <button href="#" onclick="javascript:moveDashBoardDetail('${area.areaId}')"><span>${area.areaName}</span></button>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="metro_parent">
                    <div id="craneDiv" title="<spring:message code="dashboard.title.crane"/>">
                        <div class="mp_header">
                            <h2><spring:message code="dashboard.title.crane"/></h2>
                            <div>
                                <button class="alra_btn"></button>
                            </div>
                        </div>
                        <div class="mp_contents">
                            <div class="mc_bico type01 crane"></div>
                            <div class="mc_element nano">
                                <div class="mce_btn_area nano-content">
                                    <c:choose>
                                        <c:when test="${areas != null and fn:length(areas) > 0}">
                                            <c:forEach var="area" items="${areas}">
                                                <!-- level03 클래스, <span>001</em> 삽입 -->
                                                <button href="#" onclick="javascript:moveDashBoardDetail('${area.areaId}')"><span>${area.areaName}</span></button>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="gasDiv" title="<spring:message code="dashboard.title.gas"/>">
                        <div class="mp_header">
                            <h2><spring:message code="dashboard.title.gas"/></h2>
                            <div>
                                <button class="alra_btn"></button>
                            </div>
                        </div>
                        <div class="mp_contents">
                            <div class="mc_bico type01 gas"></div>
                            <div class="mc_element nano">
                                <div class="mce_btn_area nano-content">
                                    <c:choose>
                                        <c:when test="${areas != null and fn:length(areas) > 0}">
                                            <c:forEach var="area" items="${areas}">
                                                <!-- level02, level03 클래스, <span>001</em> 삽입 -->
                                                <button href="#" onclick="javascript:moveDashBoardDetail('${area.areaId}')"><span>${area.areaName}</span></button>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="metro_root mr_h30">
                <div class="metro_parent">
                    <div>
                        <div class="mp_header">
                            <h2><spring:message code="dashboard.title.issue"/></h2>
                            <div>
                                <span class="ch_name co_gren"><spring:message code="dashboard.column.worker"/></span>
                                <span class="ch_name co_purp"><spring:message code="dashboard.column.crane"/></span>
                                <span class="ch_name co_yell"><spring:message code="dashboard.column.gas"/></span>
                                <select id="chartRefreshTime">
                                    <option value="30">30 min</option>
                                    <option value="60">60 min</option>
                                    <option value="90">90 min</option>
                                    <option value="120">120 min</option>
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
    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');

    /*
     url defind
     @author kst
     */
    var urlConfig = {
        workerUrl  :   "${rootPath}/eventLog/worker.json"
        ,craneUrl  :   "${rootPath}/eventLog/crane.json"
        ,inoutUrl  :   "${rootPath}/eventLog/inout.json"
    };

    var messageConfig = {
        workerFailure    :'<spring:message code="dashboard.message.workerFailure"/>'
        ,   craneFailure :'<spring:message code="dashboard.message.craneFailure"/>'
        ,   inoutFailure :'<spring:message code="dashboard.message.inoutFailure"/>'
    };

    $(document).ready(function(){
//        //마키 플러그인 호출
//        $('.marquee').marquee({
//            duration: 20000,
//            direction: 'left',
//            gap: 20,
//            duplicated: true,
//            pauseOnHover: true,
//            startVisible: true
//        });

        dashBoardHelper.addRequestData('worker', urlConfig['workerUrl'], null, dashBoardAllSuccessHandler, dashBoardAllFailureHandler);
        dashBoardHelper.addRequestData('crane', urlConfig['craneUrl'], null, dashBoardAllSuccessHandler, dashBoardAllFailureHandler);
        dashBoardHelper.addRequestData('inout', urlConfig['inoutUrl'], null, dashBoardAllSuccessHandler, dashBoardAllFailureHandler);
    });

    /**
     * alram success handler
     * @author psb
     * @private
     */
    function dashBoardAllSuccessHandler(data, dataType, actionType){
        switch(actionType){
            case 'worker':
                console.log(data);
                break;
            case 'crane':
                console.log(data);
                break;
            case 'inout':
                console.log(data);
                break;
        }
    }

    /*
     ajax error handler
     @author psb
     */
    function dashBoardAllFailureHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        alertMessage(actionType + 'Failure');
    }

    /*
     alert message method
     @author psb
     */
    function alertMessage(type){
        alert(messageConfig[type]);
    }

//
//    var mychart = new Chartist.Line('#chart', {
//        labels: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20],
//        series: [
//            [1, 2, 3, 1, 4, 0, 1, 0, 2,  0,  1,  2,  1,  1,  2,  0,  1,  0,  2,  0],
//            [1, 2, 3, 1, 4, 0, 1, 0, 2,  0,  1,  2,  1,  1,  2,  0,  1,  0,  2,  0],
//            [1, 2, 3, 1, 4, 0, 1, 0, 2,  0,  1,  2,  1,  1,  2,  0,  1,  0,  2,  0]
//        ]
//    }, {
//        low: 0,
//        showArea: true,
//        lineSmooth: Chartist.Interpolation.simple({
//            divisor: 100
//        })
//    });
//    mychart.on('draw', function(data) {
//        if(data.type === 'slice') {
//            if (data.index == 0) {
//                data.element.attr({
//                    'style': 'stroke: rgba(193, 0, 104, 1)'
//                });
//                data.element.animate ({
//                    'stroke-dashoffset': {
//                        begin: '1s',
//                        dur: '21s',
//                        from: '0',
//                        to: '600',
//                        easing: 'easeOutQuart',
//                        d:"part1"
//                    },
//                    'stroke-dasharray': {
//                        from: '0',
//                        to: '1000'
//                    }
//                }, false);
//            } else {
//                data.element.attr({
//                    'style': 'stroke: rgba(102, 102, 102, 1)'
//                });
//                data.element.animate ({
//                    'stroke-dashoffset': {
//                        begin: "part1.end",
//                        dur: 1000,
//                        from: '0 250 150',
//                        to: '360 250 150',
//                        easing: 'easeOutQuart'
//                    }
//                });
//            }
//        }
//    });
//    var randomScalingFactor = function() {
//        return Math.round(Math.random() * 100);
//        //return 0;
//    };
//    setInterval(function() {
//        var value1 = randomScalingFactor();
//        var value2 = randomScalingFactor();
//        var value3 = randomScalingFactor();
//        mychart.data.series[0].push(value1);
//        mychart.data.series[0].shift();
//        mychart.data.series[1].push(value2);
//        mychart.data.series[1].shift();
//        mychart.data.series[2].push(value3);
//        mychart.data.series[2].shift();
//        mychart.data.labels.push(value1);
//        mychart.data.labels.shift();
//        mychart.update()
//    }, 500);
</script>