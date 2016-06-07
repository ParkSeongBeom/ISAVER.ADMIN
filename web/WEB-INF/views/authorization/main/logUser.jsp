<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:useBean id="now" class="java.util.Date" />
<fmt:formatDate value="${now}" pattern="yyyy-MM-dd" var="today"/>

<div class="table_title_area">
    <h4><spring:message code="main.title.accessReport"/></h4>
    <div class="table_btn_set">
        <button class="btn main_btn fa more" onclick="javascript:moveView('logUser','',''); return false;"></button>
        <button class="btn main_btn fa refresh" onclick="javascript:reloadMenu('logUser'); return false;"></button>
    </div>
</div>

<div class="table_contents">
    <!-- 조회 테이블 Start -->
    <table class="t_defalut t_type01 t_style02 cursor_no">
        <colgroup>
            <col style="width:*">    <!-- 01 -->
            <c:forEach var="accountDate" items="${accountDateList}">
                <col style="width: 12.5%;" />
            </c:forEach>
        </colgroup>
        <thead>
            <tr>
                <th><spring:message code="logauthclientuser.column.device"/></td>
                <c:forEach var="accountDate" items="${accountDateList}">
                    <th>
                        <c:if test="${accountDate==today}">
                            Today
                        </c:if>
                        <c:if test="${accountDate!=today}">
                            ${accountDate}
                        </c:if>
                    </th>
                </c:forEach>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${accounts != null and fn:length(accounts) > 0}">
                    <c:forEach var="account" items="${accounts}">
                        <tr>
                            <td>${account.deviceName}</td>
                            <c:forEach var="accountDate" items="${accountDateList}">
                                <c:set var="flag" value="0"/>
                                <c:forEach var="loginCntData" items="${fn:substring(account.loginCntArray,1,fn:length(account.loginCntArray)-1)}">
                                    <c:if test="${fn:split(loginCntData,'|')[0] == accountDate}">
                                        <td <c:if test="${accountDate==today}">class="t_bolred"</c:if>><fmt:formatNumber value="${fn:split(loginCntData,'|')[1]}" groupingUsed="true"/></td>
                                        <c:set var="flag" value="1"/>
                                    </c:if>
                                </c:forEach>
                                <c:if test="${flag==0}">
                                    <td <c:if test="${accountDate==today}">class="t_bolred"</c:if>>0</td>
                                </c:if>
                            </c:forEach>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="${fn:length(accountDateList)+1}"><spring:message code="common.message.emptyData"/></td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
</div>

<script type="text/javascript">

    $(document).ready(function(){
        $.each($("table.t_type01 > tbody > tr > td"),function(){
            $(this).attr("title",$(this).text().trim());
        });
    });
</script>