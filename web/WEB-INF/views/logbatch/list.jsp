<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="jabber" uri="/WEB-INF/views/common/tags/jabber.tld"%>
<c:set value="MN000000-D000-0000-0000-000000000000" var="subMenuId"/>
<c:set value="MN000000-D000-0000-0000-000000000001" var="menuId"/>
<jabber:pageRoleCheck menuId="${menuId}" />

<script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/page-navigater.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/common/jquery-ui-1.10.4.min.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/page-navigater.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/data-util.js"></script>
<link rel="stylesheet" href="${rootPath}/assets/css/jqueryui/jquery-ui-1.10.4.min.css">

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.logbatch"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><jabber:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <form id="logBatchForm" method="POST">
        <input type="hidden" name="pageNumber"/>

        <article class="search_area">
            <div class="search_contents">
                <!-- 일반 input 폼 공통 -->
                <p class="itype_03">
                    <span><spring:message code="logbatch.message.searchDate" /></span>
                    <span>
                        <input type="text" name="startDatetimeStr" value="${paramBean.startDatetimeStr}" />
                        <em>~</em>
                        <input type="text" name="endDatetimeStr" value="${paramBean.endDatetimeStr}" />
                    </span>
                </p>
                <p class="itype_01">
                    <span><spring:message code="logbatch.column.status"/></span>
                    <span>
                        <jabber:codeSelectBox groupCodeId="C010" htmlTagName="status" allModel="true" codeId="${paramBean.status}"/>
                    </span>
                </p>
                <p class="itype_01">
                    <span><spring:message code="logbatch.column.logType"/></span>
                    <span>
                        <jabber:codeSelectBox groupCodeId="BAT001" htmlTagName="type" allModel="true" codeId="${paramBean.type}"/>
                    </span>
                </p>
            </div>
            <div class="search_btn">
                <button onclick="javascript:search(); return false;" class="btn bstyle01 btype01"><spring:message code="common.button.search"/></button>
            </div>
        </article>
    </form>

    <article class="table_area">
        <div class="table_contents">
            <!-- 입력 테이블 Start -->
            <table class="t_defalut t_type01 t_style02 cursor_no">
                <colgroup>
                    <col style="width: *%;" />
                    <col style="width: 10%;" />
                    <col style="width: 23%;" />
                    <col style="width: 23%;" />
                    <col style="width: 23%;" />
                </colgroup>
                <thead>
                    <tr>
                        <th><spring:message code="logbatch.column.logType"/></th>
                        <th><spring:message code="logbatch.column.status"/></th>
                        <th><spring:message code="logbatch.column.startDatetime"/></th>
                        <th><spring:message code="logbatch.column.endDatetime"/></th>
                        <th><spring:message code="logbatch.column.logDatetime"/></th>
                        <th style="display:none;"></th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${logBatchs != null and fn:length(logBatchs) > 0}">
                            <c:forEach var="logBatch" items="${logBatchs}">
                                <tr onclick="moveDetail($(this).find('textarea').val());">
                                    <td>${logBatch.typeName}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${logBatch.status == 'SUCCESS'}">
                                                <spring:message code="logbatch.common.success"/>
                                            </c:when>
                                            <c:otherwise>
                                                <spring:message code="logbatch.common.failure"/>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${logBatch.startDatetime}" /></td>
                                    <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${logBatch.endDatetime}" /></td>
                                    <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${logBatch.logDatetime}" /></td>
                                    <td style="display:none;">
                                        <textarea name="description"><c:out value="${logBatch.description}"></c:out></textarea>
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

<script type="text/javascript">

    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');
    var form = $('#logBatchForm');

    var urlConfig = {
        'listUrl':'${rootPath}/logbatch/list.html'
    };
    <%--moveDetail('${logBatch.description}');--%>
    var messageConfig = {
        'detailTitle':'<spring:message code="logbatch.message.logDetailTitle"/>'
        ,'confirmStartDatetime':'<spring:message code="logbatch.message.confirmStartDatetime"/>'
        ,'confirmEndDatetime':'<spring:message code="logbatch.message.confirmEndDatetime"/>'
    };

    var pageConfig = {
        'pageSize':${paramBean.pageRowNumber}
        ,'pageNumber':${paramBean.pageNumber}
        ,'totalCount':${paramBean.totalCount}
    };

    $(document).ready(function(){
        drawPageNavigater(pageConfig['pageSize'],pageConfig['pageNumber'],pageConfig['totalCount']);

        calendarHelper.load(form.find('input[name=startDatetimeStr]'));
        calendarHelper.load(form.find('input[name=endDatetimeStr]'));
    });

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


    /*
        조회유효성 검사
        @author kst
    */
    function validateSearch(){
        var startDatetiemStr = form.find('input[name=startDatetimeStr]').val();
        if(startDatetiemStr.length != 0 && !startDatetiemStr.checkDatePattern('-')){
            alertMessage('confirmStartDatetime');
            return false;
        }

        var endDatetimeStr = form.find('input[name=endDatetimeStr]').val();
        if(endDatetimeStr.length != 0 && !endDatetimeStr.checkDatePattern('-')){
            alertMessage('confirmEndDatetime');
            return false;
        }

        return true;
    }

    /*
        조회
        @author kst
     */
    function search(){
        if(validateSearch()){
            form.attr('action',urlConfig['listUrl']);
            form.submit();
        }
    }

    /*
        로그상세
        @author kst
     */
    function moveDetail(description){
        var popup = $('<DIV>').attr('title',messageConfig['detailTitle']);
        popup.append($('<p>').append(description));
        popup.dialog({
            width:500,
            height:600,
            modal: true
        });
    }

    function alertMessage(type){
        alert(messageConfig[type]);
    }
</script>