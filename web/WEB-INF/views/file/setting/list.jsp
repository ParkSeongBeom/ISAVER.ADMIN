<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="jabber" uri="/WEB-INF/views/common/tags/jabber.tld"%>
<c:set value="MN000000-J000-0000-0000-000000000000" var="subMenuId"/>
<c:set value="MN000000-U000-0000-0000-000000000002" var="menuId"/>
<jabber:pageRoleCheck menuId="${menuId}" />
<link rel="stylesheet" href="${rootPath}/assets/css/jqueryui/jquery-ui-1.10.4.min.css">
<script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/common-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/common/jquery-ui-1.10.4.min.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/elements-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/data-util.js"></script>

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.setting"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><jabber:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <article class="table_area">
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
                    <col style="width: 33%;" />
                    <col style="width: *%;" />
                    <col style="width: 33%;" />
                </colgroup>
                <thead>
                    <tr>
                        <th><spring:message code="target.column.limitFileSize"/></th>
                        <th><spring:message code="target.column.limitFileExtension"/></th>
                        <th><spring:message code="target.column.limitFileKeeptime"/></th>
                    </tr>
                </thead>
                <tbody>
                    <tr onclick="moveDetail('${target.targetId}')">
                        <td>${target.limitFileSize}</td>
                        <td>${target.limitFileExtension}</td>
                        <td>${target.limitFileKeeptime}</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </article>
</section>

<script type="text/javascript">
    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');

    var urlConfig = {
        'detailUrl':'${rootPath}/file/settingDetail.html'
        ,'resetUrl':'${rootPath}/target/reset.json'
    };

    var messageConfig = {
        'resetConfirm'       :'<spring:message code="file.message.resetConfirm"/>'
        ,'resetFailure'      :'<spring:message code="file.message.resetFailure"/>'
        ,'resetComplete'     :'<spring:message code="file.message.resetComplete"/>'
    };

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