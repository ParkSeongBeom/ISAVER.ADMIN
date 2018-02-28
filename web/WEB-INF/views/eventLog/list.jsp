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

<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.eventLog"/></h3>
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
                            <tr event_log_id="${eventLog.eventLogId}">
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

<script type="text/javascript">
    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');
    var form = $('#eventLogForm');

    var urlConfig = {
        'listUrl':'${rootPath}/eventLog/list.html'
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

    /* Excel File Download*/
    function excelFileDownloadFunc() {
        form.attr('action',urlConfig['excelUrl']);
        form.submit();
    }
</script>