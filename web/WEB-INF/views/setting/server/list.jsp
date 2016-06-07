<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>

<div class="table_title_area">
    <h4></h4>
    <div class="table_btn_set">
        <button class="btn btype01 bstyle03" onclick="javascript:reset(); return false;"><spring:message code="common.button.setting"/> </button>
        <button class="btn btype01 bstyle03" onclick="javascript:moveDetail(); return false;"><spring:message code="common.button.add"/> </button>
    </div>
</div>

<div class="table_contents">
    <!-- 입력 테이블 Start -->
    <table class="t_defalut t_type01 t_style02">
        <colgroup>
            <col style="width: 15%;" />
            <col style="width: 15%;" />
            <%--<col style="width: 7%;" />--%>
            <col style="width: *;" />
            <col style="width: 15%;" />
            <%--<col style="width: 40%;" />--%>
            <%--<col style="width: 10%;" />--%>
            <%--<col style="width: 7%;" />--%>
            <%--<col style="width: 7%;" />--%>
            <col style="width: 15%;" />
            <%--<col style="width: 7%;" />--%>
            <%--<col style="width: 7%;" />--%>
            <%--<col style="width: 7%;" />--%>
        </colgroup>
        <thead>
            <tr>
                <th><spring:message code="server.column.name"/></th>
                <th><spring:message code="server.column.type"/></th>
                <%--<th><spring:message code="server.column.protocol"/></th>--%>
                <th><spring:message code="server.column.ip"/></th>
                <th><spring:message code="server.column.port"/></th>
                <%--<th><spring:message code="server.column.url"/></th>--%>
                <%--<th><spring:message code="server.column.conference"/></th>--%>
                <%--<th><spring:message code="server.column.id"/></th>--%>
                <%--<th><spring:message code="server.column.password"/></th>--%>
                <th><spring:message code="common.column.useYn"/></th>
                <%--<th><spring:message code="server.column.description"/></th>--%>
                <%--<th><spring:message code="server.column.version"/></th>--%>
                <%--<th><spring:message code="server.column.extendPort"/></th>--%>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${servers != null and fn:length(servers) > 0}">
                    <c:forEach var="server" items="${servers}">
                        <tr onclick="moveDetail('${server.serverId}')">
                            <td>${server.name}</td>
                            <td>${server.type}</td>
                            <%--<td>${server.protocol}</td>--%>
                            <td>${server.ip}</td>
                            <td>${server.port}</td>
                            <%--<td>${server.url}</td>--%>
                            <%--<td>${server.conference}</td>--%>
                            <%--<td>${server.id}</td>--%>
                            <%--<td>${server.password}</td>--%>
                            <td>
                                <c:choose>
                                    <c:when test="${server.useYn == 'Y'}">
                                        <spring:message code="common.column.useYes"/>
                                    </c:when>
                                    <c:otherwise>
                                        <spring:message code="common.column.useNo"/>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <%--<td>${server.description}</td>--%>
                            <%--<td>${server.version}</td>--%>
                            <%--<td>${server.extendPort}</td>--%>
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
        'detailUrl':'${rootPath}/server/detail.html'
        ,'resetUrl':'${rootPath}/server/reset.json'
    };

    var messageConfig = {
        'resetConfirm'       :'<spring:message code="server.message.resetConfirm"/>'
        ,'resetFailure'      :'<spring:message code="server.message.resetFailure"/>'
        ,'resetComplete'     :'<spring:message code="server.message.resetComplete"/>'
    };

    $(document).ready(function(){
        $.each($("table.t_type01 > tbody > tr > td"),function(){
            $(this).attr("title",$(this).text().trim());
        });
    });

    function reset(){
        if(!confirm(messageConfig['resetConfirm'])) {
            return false;
        }

        sendAjaxPostRequest(urlConfig['resetUrl'],[],successHandler,errorHandler);
    }

    function successHandler(data, dataType, actionType){
        if(data.resFlag){
            alert(messageConfig['resetComplete']);
        }
    }

    function errorHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        alert(messageConfig['resetFailure']);
    }
    /*
     상세화면 이동
     @author psb
     */
    function moveDetail(id){
        var detailForm = $('<FORM>').attr('action',urlConfig['detailUrl']).attr('method','POST');
        detailForm.append($('<INPUT>').attr('type','hidden').attr('name','serverId').attr('value',id));
        document.body.appendChild(detailForm.get(0));
        detailForm.submit();
    }
</script>