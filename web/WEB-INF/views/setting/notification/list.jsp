<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>

<div class="table_contents">
    <!-- 입력 테이블 Start -->
    <table class="t_defalut t_type01 t_style02">
        <colgroup>
            <col style="width: 8%;" />
            <col style="width: 17%;" />
            <col style="width: 8%;" />
            <col style="width: *%;" />
            <col style="width: 18%;" />
            <col style="width: 8%;" />
            <col style="width: 8%;" />
            <col style="width: 8%;" />
        </colgroup>
        <thead>
            <tr>
                <th><spring:message code="notification.column.sortOrder"/></th>
                <th><spring:message code="notification.column.notiName"/></th>
                <th><spring:message code="notification.column.type"/></th>
                <th><spring:message code="notification.column.url"/></th>
                <th><spring:message code="notification.column.imageUrl"/></th>
                <th><spring:message code="notification.column.width"/></th>
                <th><spring:message code="notification.column.height"/></th>
                <th><spring:message code="common.column.useYn"/></th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${notifications != null and fn:length(notifications) > 0}">
                    <c:forEach var="notification" items="${notifications}">
                        <tr onclick="moveDetail('${notification.notiId}')">
                            <td>${notification.sortOrder}</td>
                            <td>${notification.notiName}</td>
                            <td>${notification.type}</td>
                            <td>${notification.url}</td>
                            <td>${notification.imageUrl}</td>
                            <td>${notification.width}</td>
                            <td>${notification.height}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${notification.useYn == 'Y'}">
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
                        <td colspan="8"><spring:message code="common.message.emptyData"/></td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
</div>

<script type="text/javascript">
    var urlConfig = {
        'detailUrl':'${rootPath}/notification/detail.html'
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
        detailForm.append($('<INPUT>').attr('type','hidden').attr('name','notiId').attr('value',id));
        document.body.appendChild(detailForm.get(0));
        detailForm.submit();
    }
</script>