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
    </div>
</div>

<div class="table_contents">
    <!-- 입력 테이블 Start -->
    <table class="t_defalut t_type01 t_style02">
        <colgroup>
            <col style="width: 25%;" />
            <col style="width: 25%;" />
            <col style="width: *%;" />
            <col style="width: 10%;" />
        </colgroup>
        <thead>
            <tr>
                <th><spring:message code="function.column.funcId"/></th>
                <th><spring:message code="function.column.funcName"/></th>
                <th><spring:message code="function.column.description"/></th>
                <th><spring:message code="common.column.useYn"/></th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${functions != null and fn:length(functions) > 0}">
                    <c:forEach var="function" items="${functions}">
                        <tr onclick="moveDetail('${function.funcId}')">
                            <td>${function.funcId}</td>
                            <td>${function.funcName}</td>
                            <td>${function.description}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${function.useYn == 'Y'}">
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
                        <td colspan="4"><spring:message code="common.message.emptyData"/></td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
</div>

<script type="text/javascript">
    var urlConfig = {
        'detailUrl':'${rootPath}/function/detail.html'
        ,'resetUrl':'${rootPath}/function/reset.json'
    };

    var messageConfig = {
        'resetConfirm'       :'<spring:message code="function.message.resetConfirm"/>'
        ,'resetFailure'      :'<spring:message code="function.message.resetFailure"/>'
        ,'resetComplete'     :'<spring:message code="function.message.resetComplete"/>'
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
        detailForm.append($('<INPUT>').attr('type','hidden').attr('name','funcId').attr('value',id));
        document.body.appendChild(detailForm.get(0));
        detailForm.submit();
    }
</script>