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
            <col style="width: 15%;" />
            <col style="width: 10%;" />
            <col style="width: *%;" />
            <col style="width: 10%;" />
            <%--<col style="width: 15%;" />--%>
        </colgroup>
        <thead>
            <tr>
                <th><spring:message code="target.column.name"/></th>
                <th><spring:message code="target.column.code"/></th>
                <th><spring:message code="target.column.logoUrl"/></th>
                <th><spring:message code="target.column.licenseCount"/></th>
                <%--<th><spring:message code="target.column.domain"/></th>--%>
            </tr>
        </thead>
        <tbody>
            <tr onclick="moveDetail('${target.targetId}');">
                <td>${target.name}</td>
                <td>${target.code}</td>
                <td>${target.logoUrl}</td>
                <td>${target.licenseCount}</td>
                <%--<td>${target.domain}</td>--%>
            </tr>
        </tbody>
    </table>
</div>

<script type="text/javascript">
    var urlConfig = {
        'detailUrl':'${rootPath}/target/detail.html'
        ,'resetUrl':'${rootPath}/target/reset.json'
    };

    var messageConfig = {
        'resetConfirm'       :'<spring:message code="target.message.resetConfirm"/>'
        ,'resetFailure'      :'<spring:message code="target.message.resetFailure"/>'
        ,'resetComplete'     :'<spring:message code="target.message.resetComplete"/>'
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
        detailForm.append($('<INPUT>').attr('type','hidden').attr('name','targetId').attr('value',id));
        document.body.appendChild(detailForm.get(0));
        detailForm.submit();
    }
</script>