<!-- 이벤트 로그 관리, @author dhj -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<c:set value="2A0010" var="menuId"/>
<c:set value="2A0000" var="subMenuId"/>
<%--<isaver:pageRoleCheck menuId="${menuId}" locale="${pageContext.response.locale}"/>--%>
<script type="text/javascript" src="${rootPath}/assets/js/util/page-navigater.js"></script>

<div class="sub_title_area">
    <h3 class="1depth_title"><spring:message code="common.title.eventLog"/></h3>
    <div class="navigation">
        <span><isaver:menu menuId="${menuId}" /></span>
    </div>
</div>

<section class="container sub_area">
    <form id="eventLogForm" method="POST">
        <input type="hidden" name="pageNumber"/>

        <article class="search_area">
            <div class="search_contents">
                <spring:message code="common.selectbox.select" var="allSelectText"/>
                <!-- 일반 input 폼 공통 -->
                <p class="itype_01">
                    <span><spring:message code="eventlog.column.areaName" /></span>
                    <span><isaver:areaSelectBox htmlTagName="areaId" allModel="true" areaId="${paramBean.areaId}" allText="${allSelectText}"/></span>
                </p>
                <p class="itype_01">
                    <span><spring:message code="eventlog.column.deviceCode" /></span>
                    <isaver:codeSelectBox groupCodeId="DEV" codeId="${paramBean.deviceCode}" htmlTagName="deviceCode" allModel="true" allText="${allSelectText}"/>
                </p>
                <p class="itype_04">
                    <span><spring:message code="eventlog.column.eventDatetime" /></span>
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
                <p><span><spring:message code="common.message.total"/><em>${paramBean.totalCount}</em><spring:message code="common.message.number01"/></span></p>
                <button class="btn btype01 bstyle03" onclick="javascript:excelFileDownloadFunc(); return false;"><spring:message code="common.button.excelDownload"/> </button>
            </div>
        </div>

        <div class="table_contents">
            <!-- 입력 테이블 Start -->
            <table class="t_defalut t_type01 t_style02">
                <colgroup>
                    <col> <!-- 1 구역명 -->
                    <col> <!-- 2 장치유형 -->
                    <col> <!-- 3 이벤트명 -->
                    <col> <!-- 4 이벤트발생일시 -->
                </colgroup>
                <thead>
                <tr>
                    <th><spring:message code="eventlog.column.areaName"/></th>
                    <th><spring:message code="eventlog.column.deviceCode"/></th>
                    <th><spring:message code="eventlog.column.eventName"/></th>
                    <th><spring:message code="eventlog.column.eventDatetime"/></th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${eventLogs != null and fn:length(eventLogs) > 0}">
                        <c:forEach var="eventLog" items="${eventLogs}">
                            <tr onclick="javascript:getDetail('${eventLog.eventLogId}');">
                                <td>${eventLog.areaName}</td>
                                <td>${eventLog.deviceName}</td>
                                <td>${eventLog.eventName}</td>
                                <td><fmt:formatDate value="${eventLog.eventDatetime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="4"><spring:message code="common.message.emptyData"/></td>
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

<section class="popup-layer">
    <div class="popupbase admin_popup eventdetail_popup">
        <div>
            <div>
                <header>
                    <h2><spring:message code="eventlog.title.eventDetail"/></h2>
                    <button onclick="closeDetailPopup();"></button>
                </header>
                <article>
                    <textarea class="textboard" readOnly="readonly" style="resize:none; height: 100%;" id="detailText"></textarea>
                </article>
            </div>
        </div>
        <div class="bg ipop_close" onclick="closeDetailPopup();"></div>
    </div>
</section>

<script type="text/javascript">
    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');
    var form = $('#eventLogForm');

    var messageConfig = {
        'earlyDatetime':'<spring:message code="eventlog.message.earlyDatetime"/>'
        ,'detailFailure':'<spring:message code="eventlog.message.detailFailure"/>'
    };

    var urlConfig = {
        'listUrl':'${rootPath}/eventLog/list.html'
        ,'detailUrl':'${rootPath}/eventLog/detail.json'
        ,'excelUrl':'${rootPath}/eventLog/excel.html'
    };

    var searchConfig = {
        'startDatetimeHour':'${paramBean.startDatetimeHour}'
        ,'endDatetimeHour':'${paramBean.endDatetimeHour}'
    };

    var pageConfig = {
        pageSize     : Number(<c:out value="${paramBean.pageRowNumber}" />)
        ,pageNumber  : Number(<c:out value="${paramBean.pageNumber}" />)
        ,totalCount  : Number(<c:out value="${paramBean.totalCount}" />)
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

    function validate(){
        var start = new Date($("input[name='startDatetimeStr']").val() + " " + $("#startDatetimeHourSelect").val() + ":00:00");
        var end = new Date($("input[name='endDatetimeStr']").val() + " " + $("#endDatetimeHourSelect").val() + ":00:00");

        if(start>end){
            alertMessage("earlyDatetime");
            return false;
        }
        return true;
    }

    /*
     조회
     @author kst
     */
    function search(){
        if(validate()){
            form.attr('action',urlConfig['listUrl']);
            form.submit();
        }
    }

    /*
     open 이벤트 상세 popup
     @author psb
     */
    function getDetail(eventLogId){
        callAjax('detail',{'eventLogId':eventLogId});
    }

    /*
     close 이벤트 상세 popup
     @author psb
     */
    function closeDetailPopup(){
        $("#detailText").empty();
        $(".eventdetail_popup").fadeOut();
    }

    /*
     ajax call
     @author psb
     */
    function callAjax(actionType, data){
        sendAjaxPostRequest(urlConfig[actionType + 'Url'],data,eventLogSuccessHandler,eventLogErrorHandler,actionType);
    }

    /*
     ajax success handler
     @author psb
     */
    function eventLogSuccessHandler(data, dataType, actionType){
        switch(actionType){
            case 'detail':
                $("#detailText").text(JSON.stringify(data['eventLog'],undefined,2));
                $(".eventdetail_popup").fadeIn();
                break;
        }
    }

    /*
     ajax error handler
     @author psb
     */
    function eventLogErrorHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        alertMessage(actionType + 'Failure');
    }

    /*
     페이지 네이게이터를 그린다.
     @author kst
     */
    function drawPageNavigater(pageSize,pageNumber,totalCount){
        var pageNavigater = new PageNavigator(pageSize,pageNumber,totalCount);
        pageNavigater.setClass('paging','pll','pl','','on','');
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

    /* Excel File Download*/
    function excelFileDownloadFunc() {
        form.attr('action',urlConfig['excelUrl']);
        form.submit();
    }

    /*
     alert message method
     @author psb
     */
    function alertMessage(type){
        alert(messageConfig[type]);
    }
</script>