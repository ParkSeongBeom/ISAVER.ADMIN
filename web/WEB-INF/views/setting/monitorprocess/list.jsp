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
            <col style="width: 25%;" />
            <col style="width: 25%;" />
            <col style="width: 25%;" />
            <col style="width: 25%;" />
        </colgroup>
        <thead>
            <tr>
                <th><spring:message code="monitorprocess.column.monitorName"/></th>
                <th><spring:message code="monitorprocess.column.processName"/></th>
                <th><spring:message code="monitorprocess.column.serviceName"/></th>
                <th><spring:message code="monitorprocess.column.description"/></th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${monitorProcesses != null and fn:length(monitorProcesses) > 0}">
                    <c:forEach var="monitorProcess" items="${monitorProcesses}">
                        <tr onclick="moveDetail('${monitorProcess.processId}')">
                            <td>${monitorProcess.monitorName}</td>
                            <td>${monitorProcess.processCode}</td>
                            <td>${monitorProcess.serviceName}</td>
                            <td>${monitorProcess.description}</td>
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

<script type="text/javascript">
    var urlConfig = {
        'detailUrl':'${rootPath}/monitorProcess/detail.html'
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
        detailForm.append($('<INPUT>').attr('type','hidden').attr('name','processId').attr('value',id));
        document.body.appendChild(detailForm.get(0));
        detailForm.submit();
    }
</script>