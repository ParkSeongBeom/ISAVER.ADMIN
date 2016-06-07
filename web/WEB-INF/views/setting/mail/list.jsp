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
            <col style="width: *%;" />
            <col style="width: 15%;" />
            <col style="width: 10%;" />
            <col style="width: 15%;" />
            <col style="width: 10%;" />
            <col style="width: 15%;" />
            <col style="width: 10%;" />
        </colgroup>
        <thead>
            <tr>
                <th><spring:message code="mail.column.mailType"/></th>
                <th><spring:message code="mail.column.name"/></th>
                <th><spring:message code="mail.column.sendType"/></th>
                <th><spring:message code="mail.column.sendValue"/></th>
                <th><spring:message code="mail.column.receiveType"/></th>
                <th><spring:message code="mail.column.receiveValue"/></th>
                <th><spring:message code="common.column.useYn"/></th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${mails != null and fn:length(mails) > 0}">
                    <c:forEach var="mail" items="${mails}">
                        <tr onclick="moveDetail('${mail.mailType}')">
                            <td>${mail.mailType}</td>
                            <td>${mail.name}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${mail.sendType == '0001'}">
                                        <spring:message code="mail.column.autoSelect"/>
                                    </c:when>
                                    <c:when test="${mail.sendType == '0002'}">
                                        <spring:message code="mail.column.direct"/>
                                    </c:when>
                                </c:choose>
                            </td>
                            <td>${mail.sendValue}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${mail.receiveType == '0001'}">
                                        <spring:message code="mail.column.autoSelect"/>
                                    </c:when>
                                    <c:when test="${mail.receiveType == '0002'}">
                                        <spring:message code="mail.column.direct"/>
                                    </c:when>
                                </c:choose>
                            </td>
                            <td>${mail.receiveValue}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${mail.useYn == 'Y'}">
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
                        <td colspan="7"><spring:message code="common.message.emptyData"/></td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
</div>

<script type="text/javascript">
    var urlConfig = {
        'detailUrl':'${rootPath}/mail/detail.html'
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
        detailForm.append($('<INPUT>').attr('type','hidden').attr('name','mailType').attr('value',id));
        document.body.appendChild(detailForm.get(0));
        detailForm.submit();
    }
</script>