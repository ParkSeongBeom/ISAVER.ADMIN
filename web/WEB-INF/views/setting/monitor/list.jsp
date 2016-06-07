<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>

<div class="table_title_area">
    <h4></h4>
    <div class="table_btn_set">
        <button class="btn btype01 bstyle03" onclick="javascript:moveDetail(''); return false;"><spring:message code="common.button.add"/> </button>
    </div>
</div>

<div class="table_contents">
    <!-- 입력 테이블 Start -->
    <table class="t_defalut t_type01 t_style02">
        <colgroup>
            <col style="width: 30%;" />
            <col style="width: 30%;" />
            <col style="width: 15%;" />
            <col style="width: 15%;" />
            <col style="width: 10%;" />
        </colgroup>
        <thead>
            <tr>
                <th><spring:message code="monitor.column.name"/></th>
                <th><spring:message code="monitor.column.ip"/></th>
                <th><spring:message code="monitor.column.id"/></th>
                <th><spring:message code="monitor.column.password"/></th>
                <th><spring:message code="common.column.useYn"/></th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${monitors != null and fn:length(monitors) > 0}">
                    <c:forEach var="monitor" items="${monitors}">
                        <tr onclick="moveDetail('${monitor.monitorId}')">
                            <td>${monitor.name}</td>
                            <td>${monitor.ip}</td>
                            <td>${monitor.id}</td>
                            <td>${monitor.password}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${monitor.useYn == 'Y'}">
                                        <spring:message code="common.column.useYes"/>
                                    </c:when>
                                    <c:otherwise>
                                        <spring:message code="common.column.useNo"/>
                                    </c:otherwise>
                                </c:choose>
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
</div>

<script type="text/javascript">
    var urlConfig = {
        'detailUrl':'${rootPath}/monitor/detail.html'
    };

    $(document).ready(function(){
        $.each($("table.t_type01 > tbody > tr > td"),function(){
            $(this).attr("title",$(this).text().trim());
        });
    });

    /*
     상세화면 이동
     @author psb
     */
    function moveDetail(id){
        var detailForm = $('<FORM>').attr('action',urlConfig['detailUrl']).attr('method','POST');
        detailForm.append($('<INPUT>').attr('type','hidden').attr('name','monitorId').attr('value',id));
        document.body.appendChild(detailForm.get(0));
        detailForm.submit();
    }
</script>