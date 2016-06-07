<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="table_title_area">
    <h4><spring:message code="main.title.maintenance"/></h4>
    <div class="table_btn_set">
        <button class="btn main_btn fa more" onclick="javascript:moveView('maintenance','',''); return false;"></button>
        <button class="btn main_btn fa refresh" onclick="javascript:reloadMenu('maintenance'); return false;"></button>
    </div>
</div>

<div class="table_contents">
    <!-- 조회 테이블 Start -->
    <table class="t_defalut t_type01 t_style02">
        <colgroup>
            <col style="width:*">  <!-- 01 -->
            <col style="width:200px">  <!-- 02 -->
        </colgroup>
        <thead>
            <tr>
                <th><spring:message code="maintenance.column.title"/></th>
                <th><spring:message code="maintenance.column.status"/></th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${maintenances != null and fn:length(maintenances) > 0}">
                    <c:forEach var="maintenance" items="${maintenances}">
                        <tr onclick="parent.moveView('maintenanceDetail','id','${maintenance.maintenanceId}');">
                            <td>${maintenance.title}</td>
                            <td><span class="stion_btn con_${maintenance.status}">${maintenance.statusName}</span></td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="2"><spring:message code="common.message.emptyData"/></td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
</div>

<script type="text/javascript">
    var cssClass = {
        "2000" : 'con_2000' /* 접수 */
        ,"3000" : 'con_3000' /* 검토중 */
        ,"4000" : 'con_4000' /* 개발중 */
        ,"5000" : 'con_5000' /* 처리완료 */
        ,"9000" : 'con_9000' /* 반려 */
    };

    $(document).ready(function(){
        $.each($("table.t_type01 > tbody > tr > td"),function(){
            $(this).attr("title",$(this).text().trim());
        });
    });
//    .con_on {background:#0d97d1;}
//    .con_off {background:#878989;}
//    .con_failure {background:#ff8543;}
//    .con_08 {background:#0d97d1;}
//    .con_09 {background:#ff8543;}

</script>