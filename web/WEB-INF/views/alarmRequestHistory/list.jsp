<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<c:set value="G00000" var="subMenuId"/>
<c:set value="G00040" var="menuId"/>
<isaver:pageRoleCheck menuId="${menuId}" />
<script type="text/javascript" src="${rootPath}/assets/js/util/page-navigater.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/elements-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/data-util.js"></script>

<!-- 알림 장치 맵핑 팝업-->
<aside class="admin_popup ipop_type01 code_select_popup" style="display: none;">
    <section class="layer_wrap i_type04">
        <article class="layer_area">
            <div class="layer_header">
                알림 전송 이력 상세
            </div>
            <div class="layer_contents">
                <article class="table_area">
                    <div class="table_contents">
                        <!-- 입력 테이블 Start -->
                        <table id="actionList" class="t_defalut t_type01 t_style02">
                            <colgroup>
                                <col style="width: 20%;">
                                <col style="width: 15%;">
                                <col style="width: 20%;">
                                <col style="width: *%;">
                            </colgroup>
                            <thead>
                            <tr>
                                <th><spring:message code="alarmRequestHistory.column.deviceName"/></th>
                                <th><spring:message code="alarmRequestHistory.column.areaName"/></th>
                                <th><spring:message code="device.column.provisionFlag"/></th>
                                <th><spring:message code="alarmRequestHistory.column.receiveApplyFlag"/></th>
                                <th><spring:message code="alarmRequestHistory.column.receiveApplyDetail"/></th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr>
                                <td colspan="5"><spring:message code="common.message.emptyData"/></td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </article>
                <div class="table_title_area">
                    <div class="table_btn_set">
                        <%--<button class="btn btype01 bstyle03 c_ok" name="" onclick="javascript:deviceCtrl.appendAlarmDeviceFunc();return false;">저장</button>--%>
                        <button class="btn btype01 bstyle03 c_cancle" name="" onclick="javascript:popup_cancelButton(); return false;">취소</button>
                        <%--<button class="btn btype01 bstyle03 c_ok" onclick="javascript:alert(0); return false;" >확인</button>--%>
                        <%--<button class="btn btype01 bstyle03 c_cancle"  onclick="javascript:alert(1); return false;">취소</button>--%>
                    </div>
                </div>
            </div>
        </article>
    </section>
    <div class="layer_popupbg ipop_close"></div>
</aside>

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.alarmRequestHistory"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><isaver:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <form id="eventLogForm" method="POST">
        <input type="hidden" name="pageNumber"/>

        <article class="search_area">
            <div class="search_contents">
                <!-- 일반 input 폼 공통 -->
                <p class="itype_01">
                    <span><spring:message code="eventlog.column.areaName" /></span>
                    <span>
                        <isaver:areaSelectBox htmlTagName="areaId" allModel="true" areaId="${paramBean.areaId}"/>
                        <%--<input type="text" name="areaName" value="${paramBean.areaName}"/>--%>
                    </span>
                </p>

                <p class="itype_01">
                    <span><spring:message code="eventlog.column.eventFlag" /></span>
                    <isaver:codeSelectBox groupCodeId="EVT" codeId="${paramBean.eventFlag}" htmlTagName="eventFlag" allModel="true"/>
                </p>

                <p class="itype_01">
                    <span><spring:message code="eventlog.column.deviceCode" /></span>
                    <isaver:codeSelectBox groupCodeId="DEV" codeId="${paramBean.deviceCode}" htmlTagName="deviceCode" allModel="true"/>
                </p>
                <p class="itype_04">
                    <span><spring:message code="alarmRequestHistory.column.alarmRequestDatetime" /></span>
                    <span class="plable04">
                        <input type="text" name="startDatetimeStr" value="${paramBean.startDatetimeStr}" />
                        <select id="startDatetimeHourSelect" name="startDatetimeHour"></select>
                        <em>~</em>
                        <input type="text" name="endDatetimeStr" value="${paramBean.endDatetimeStr}" />
                        <select id="endDatetimeHourSelect" name="endDatetimeHour"></select>
                    </span>
                </p>
            </div>
            <div class="search_btn">
                <button onclick="javascript:search(); return false;" class="btn bstyle01 btype01"><spring:message code="common.button.search"/></button>
            </div>
        </article>
    </form>

    <article class="table_area">
        <div class="table_title_area">
            <h4></h4>
            <div class="table_btn_set">
                <p><span>총<em>${paramBean.totalCount}</em>건</span></p>
                <%--<button class="btn btype01 bstyle03" onclick="javascript:moveDetail(); return false;"><spring:message code="common.button.add"/> </button>--%>
            </div>
        </div>

        <div class="table_contents">
            <!-- 입력 테이블 Start -->
            <table class="t_defalut t_type01 t_style02">
                <colgroup>
                    <col style="width: *;" />
                    <col style="width: 20%;" />
                    <col style="width: 20%;" />
                    <col style="width: 20%;" />
                    <col style="width: 20%;" />
                </colgroup>
                <thead>
                    <tr>
                        <th><spring:message code="alarmRequestHistory.column.deviceName"/></th>
                        <th><spring:message code="alarmRequestHistory.column.areaName"/></th>
                        <th><spring:message code="alarmRequestHistory.column.eventName"/></th>
                        <th><spring:message code="alarmRequestHistory.column.alarmRequestDatetime"/></th>
                        <th><spring:message code="alarmRequestHistory.column.receiveApplyDatetime"/></th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${alarmRequestHistoryList != null and fn:length(alarmRequestHistoryList) > 0}">
                            <c:forEach var="alarmRequestHistory" items="${alarmRequestHistoryList}">
                                <tr onclick="loadDetail('${alarmRequestHistory.alarmRequestId}')">
                                    <td >${alarmRequestHistory.deviceCodeName} (${alarmRequestHistory.deviceId})</td>
                                    <td>${alarmRequestHistory.areaName}  (${alarmRequestHistory.areaId})</td>
                                    <td>${alarmRequestHistory.eventName} (${alarmRequestHistory.eventId})</td>
                                    <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${alarmRequestHistory.alarmRequestDatetime}" /></td>
                                    <td>${alarmRequestHistory.receiveApplyFlag}
                                        <c:if test="${alarmRequestHistory.receiveApplyFlag == 'Y'}">
                                            (<fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${alarmRequestHistory.recviveApplyDatetime}" />)
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="5"><spring:message code="common.message.emptyData"/></td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>

            <!-- 테이블 공통 페이징 Start -->
            <div id="pageContainer" class="page" />
        </div>
    </article>
</section>
<!-- END : contents -->

<script type="text/javascript">
    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');
    var form = $('#eventLogForm');

    var METHOD = {
        ADD:'add',
        SAVE:'save',
        REMOVE:'remove',
        DETAIL:'detail'
    };


    var urlConfig = {
        'listUrl':'${rootPath}/alarmRequestHistory/list.html'
    };

    var pageConfig = {
        pageSize     : Number(<c:out value="${paramBean.pageRowNumber}" />)
        ,pageNumber  : Number(<c:out value="${paramBean.pageNumber}" />)
        ,totalCount  : Number(<c:out value="${paramBean.totalCount}" />)
    };


    var searchConfig = {
        'startDatetimeHour':'${paramBean.startDatetimeHour}'
        ,'endDatetimeHour':'${paramBean.endDatetimeHour}'
    };

    $(document).ready(function(){

        calendarHelper.load(form.find('input[name=startDatetimeStr]'));
        calendarHelper.load(form.find('input[name=endDatetimeStr]'));

        setHourDataToSelect($('#startDatetimeHourSelect'),searchConfig['startDatetimeHour'],false);
        setHourDataToSelect($('#endDatetimeHourSelect'),searchConfig['endDatetimeHour'],true);

        drawPageNavigater(pageConfig['pageSize'],pageConfig['pageNumber'],pageConfig['totalCount']);

        $("input:text").keypress(function(e) {
            if(e.which == 13) {
                search();
            }
        });
    });

    function getRequestUrl(type, method) {
        var rootUrl = String();
        try {
            rootUrl = String('${rootPath}');
        }catch(e) {rootUrl = '';}

        return {
            detail: rootUrl + "/" + type + "/detail.html",
            list: rootUrl + "/" + type + "/list.html"
        }[method];
    };

    /*
     조회
     @author kst
     */
    function search(){
        form.attr('action',urlConfig['listUrl']);
        form.submit();
    }

    /*
     페이지 네이게이터를 그린다.
     @author kst
     */
    function drawPageNavigater(pageSize,pageNumber,totalCount){
        var pageNavigater = new PageNavigator(pageSize,pageNumber,totalCount);
        pageNavigater.setClass('paging','p_arrow pll','p_arrow pl','','page_select','');
        pageNavigater.setGroupTag('《','〈','〉','》');
        pageNavigater.showInfo(false);
        $('#pageContainer').append(pageNavigater.getHtml());
    }

    /*
     페이지 이동
     @author kst
     */
    function goPage(pageNumber){
        form.find('input[name=pageNumber]').val(pageNumber);
        search();
    }


    function loadDetail(alarmRequestId){
        popup_openButton();

        var data = {
            "alarmRequestId" : alarmRequestId
        };

        /*  테이블 목록 - 내용 */
        $("#actionList > tbody").empty();

        var _url = "${rootPath}/alarmRequestHistory/detail.json";
        sendAjaxPostRequest(_url, data, alarmListLoadSuccessHandler, this. alarmListLoadErrorHandler, null);

    }

    function makeAlarmDeviceListFunc(alarmRequestHistoryDetails) {
        if (alarmRequestHistoryDetails == null && alarmRequestHistoryDetails.length == 0) {
            return;
        }

        for (var i=0; i< alarmRequestHistoryDetails.length; i++) {
            var alarmRequestHistoryDetail = alarmRequestHistoryDetails[i];

            var deviceId = alarmRequestHistoryDetail['deviceId'];
            var deviceCodeName = alarmRequestHistoryDetail['deviceCodeName'];
            var areaName = alarmRequestHistoryDetail['areaName'] != "" && alarmRequestHistoryDetail['areaName'] !=null ? alarmRequestHistoryDetail['areaName'] : "";
            var alarmRequestFlag = alarmRequestHistoryDetail['alarmRequestFlag'];
            var alarmRequestDetail = alarmRequestHistoryDetail['alarmRequestDetail'];
            var provisionFlag = alarmRequestHistoryDetail['provisionFlag'];

            if (alarmRequestDetail == "null" || alarmRequestDetail == null || alarmRequestDetail == undefined) {
                alarmRequestDetail = "";
            }

            var html_item= "<tr>\n" +
                    "<td title=\"\">" +deviceCodeName + " (" + deviceId +")</td>\n" +
                    "<td title=\"\">" + areaName + "</td>" +
                    "<td title=\"\">" + provisionFlag + "</td>" +
                    "<td title=\"\">" + alarmRequestFlag + "</td>" +
                    "<td title=\"\">" + alarmRequestDetail + "</td>" +
                    "</tr>";

            var itemObject = $(html_item);
            $("#actionList > tbody").append(itemObject);
        }
    }

    /**
     * [SUCCESS][RES] 알림 장치 목록 불러오기 성공 시 이벤트
     */
    function alarmListLoadSuccessHandler(data, dataType, actionType) {

        if (typeof data == "object" && data.hasOwnProperty("alarmRequestHistoryDetail") && data['alarmRequestHistoryDetail']!=null) {
            makeAlarmDeviceListFunc(data['alarmRequestHistoryDetail']);
        }

    };

    /**
     * [FAIL][RES] 알림 장치 목록 불러오기 실패 시 이벤트
     */
    function alarmListLoadErrorHandler(XMLHttpRequest, textStatus, errorThrown, actionType) {
        console.error("[Error][DeviceEvent.alarmListLoadErrorHandler] " + errorThrown);
        alert(messageConfig[DeviceEvent._model.getViewStatus() + 'Failure']);

    };

    /* 팝업 보이기 버튼 */
    function popup_openButton() {
        var code_openTarget = $(".code_select_popup");
        code_openTarget.css("display", "block");
//        actionListLoad();
    }


    /* 팝업 취소 버튼 */
    function popup_cancelButton() {
        var code_openTarget = $(".code_select_popup");
        code_openTarget.css("display", "none");
        return false;
    }

</script>