<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="table_title_area">
    <h4><spring:message code="main.title.logAdmin"/></h4>
    <div class="table_btn_set">
        <button class="btn main_btn fa more" onclick="javascript:moveView('logAuthAdminUser','',''); return false;"></button>
        <button class="btn main_btn fa refresh" onclick="javascript:reloadMenu('logAuthAdminUser'); return false;"></button>
    </div>
</div>

<div class="table_contents">
    <!-- 조회 테이블 Start -->
    <table class="t_defalut t_type01 t_style02 cursor_no">
        <colgroup>
            <col style="width:25%">  <!-- 01 -->
            <col style="width:25%">  <!-- 02 -->
            <col style="width:*">  <!-- 03 -->
        </colgroup>
        <thead>
            <tr>
                <th><spring:message code="logauthadminuser.column.adminId"/></th>
                <th><spring:message code="logauthadminuser.column.ipAddress"/></th>
                <th><spring:message code="logauthadminuser.column.logDatetime"/></th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${logAuthAdminUsers != null and fn:length(logAuthAdminUsers) > 0}">
                    <c:forEach var="logAuthAdminUser" items="${logAuthAdminUsers}">
                        <tr>
                            <td>${logAuthAdminUser.adminUserId}</td>
                            <td>${logAuthAdminUser.ipAddress}</td>
                            <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${logAuthAdminUser.logDatetime}" /></td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="3"><spring:message code="common.message.emptyData"/></td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
</div>
<!-- END : contents -->

<script type="text/javascript">

    $(document).ready(function(){
        $.each($("table.t_type01 > tbody > tr > td"),function(){
            $(this).attr("title",$(this).text().trim());
        });
    });
</script>