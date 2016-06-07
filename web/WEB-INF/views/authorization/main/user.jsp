<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="table_title_area">
    <h4><spring:message code="main.title.person"/></h4>
    <div class="table_btn_set">
        <button class="btn main_btn fa more" onclick="javascript:moveView('user','',''); return false;"></button>
        <button class="btn main_btn fa refresh" onclick="javascript:reloadMenu('user'); return false;"></button>
    </div>
</div>

<div class="table_contents ">
    <div class="m_human"></div>
    <div class="m_ttable">
        <p>
            <span><spring:message code="main.column.newCount"/></span>
            <span><fmt:formatNumber value="${newCnt}" groupingUsed="true"/></span>
        </p>
        <p>
            <span><spring:message code="main.column.useCount"/></span>
            <span><fmt:formatNumber value="${useCnt}" groupingUsed="true"/></span>
        </p>
        <p>
            <span><spring:message code="main.column.license"/></span>
            <span><fmt:formatNumber value="${license}" groupingUsed="true"/></span>
        </p>
    </div>
</div>

<script type="text/javascript">
</script>