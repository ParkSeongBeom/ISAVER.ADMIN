<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="table_title_area">
    <h4><spring:message code="main.title.logBatch"/></h4>
    <div class="table_btn_set">
        <button class="btn main_btn fa more" onclick="javascript:moveView('logBatch','',''); return false;"></button>
        <button class="btn main_btn fa refresh" onclick="javascript:reloadMenu('logBatch'); return false;"></button>
    </div>
</div>

<div class="table_contents">
    <!-- 조회 테이블 Start -->
    <table class="t_defalut t_type01 t_style02 ">
        <colgroup>
            <col style="width:*">      <!-- 01 -->
            <col style="width:100px">  <!-- 02 -->
            <col style="width:25%">    <!-- 03 -->
            <col style="width:25%">    <!-- 04 -->
        </colgroup>
        <thead>
            <tr>
                <th><spring:message code="logbatch.column.logType"/></th>
                <th><spring:message code="logbatch.column.status"/></th>
                <th><spring:message code="logbatch.column.startDatetime"/></th>
                <th><spring:message code="logbatch.column.endDatetime"/></th>
            </tr>
        </thead>
    </table>

    <div id="content-1" class="t_scroll t_height01" data-mcs-theme="minimal-dark">
        <table class="t_defalut t_type01 t_style02 cursor_no">
            <colgroup>
                <col style="width:*">      <!-- 01 -->
                <col style="width:100px">  <!-- 02 -->
                <col style="width:25%">    <!-- 03 -->
                <col style="width:25%">    <!-- 04 -->
            </colgroup>
            <tbody>
                <c:choose>
                    <c:when test="${logBatchs != null and fn:length(logBatchs) > 0}">
                        <c:forEach var="logBatch" items="${logBatchs}">
                            <tr>
                                <td>${logBatch.typeName}</td>
                                <td>
                                    <c:if test="${logBatch.status=='SUCCESS'}">
                                        <span class="stion_btn con_on"><spring:message code="logbatch.common.success"/></span>
                                    </c:if>
                                    <c:if test="${logBatch.status=='FAILURE'}">
                                        <span class="stion_btn con_off"><spring:message code="logbatch.common.failure"/></span>
                                    </c:if>
                                </td>
                                <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${logBatch.startDatetime}" /></td>
                                <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${logBatch.endDatetime}" /></td>
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
    </div>
</div>

<script type="text/javascript">

    $(document).ready(function(){
        $.each($("table.t_type01 > tbody > tr > td"),function(){
            $(this).attr("title",$(this).text().trim());
        });
    });
</script>