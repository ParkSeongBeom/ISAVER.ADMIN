<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="jabber" uri="/WEB-INF/views/common/tags/jabber.tld"%>
<c:set value="MN000000-B000-0000-0000-000000000000" var="subMenuId"/>
<c:set value="MN000000-B000-0000-0000-000000000006" var="menuId"/>
<jabber:pageRoleCheck menuId="${menuId}" />
<link rel="stylesheet" href="${rootPath}/assets/css/jqueryui/jquery-ui-1.10.4.min.css">
<script type="text/javascript" src="${rootPath}/assets/js/common/jquery-ui-1.10.4.min.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/common-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/page-navigater.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/elements-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/data-util.js"></script>

<aside class="layer_popup">
    <section class="layer_wrap">
        <div class="layer_header">
            <spring:message code="synchronize.title.userDetail"/>
            <button class="ipop_x" onclick="javascript:closeLayer(); return false;"></button>
        </div>
        <div class="layer_contents">
            <table class="t_defalut t_type01 t_style03">
                <colgroup>
                    <col style="width:15%">  <!-- 01 -->
                    <col style="width:15%">  <!-- 02 -->
                    <col style="width:15%">  <!-- 03 -->
                    <col style="width:30%">  <!-- 04 -->
                    <col style="width:25%">  <!-- 05 -->
                </colgroup>
                <thead>
                    <tr>
                        <th><spring:message code="synchronize.column.syncTarget"/></th>
                        <th><spring:message code="synchronize.column.syncType"/></th>
                        <th><spring:message code="synchronize.column.syncState"/></th>
                        <th><spring:message code="synchronize.column.description"/></th>
                        <th><spring:message code="synchronize.column.syncDatetime"/></th>
                    </tr>
                </thead>
                <tbody id="layerTbData"></tbody>
            </table>
        </div>
    </section>
    <div class="layer_popupbg ipop_close"></div>
</aside>

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.requestSynchronize"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><jabber:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <article class="table_area">
        <div class="table_title_area">
            <h4><spring:message code="synchronize.title.request" /></h4>
        </div>

        <div class="table_contents">
            <!-- 입력 테이블 Start -->
            <table class="t_defalut t_type02 t_style03">
                <colgroup>
                    <col style="width:16%">  <!-- 01 -->
                    <col style="width:34%">  <!-- 02 -->
                    <col style="width:16%">  <!-- 03 -->
                    <col style="width:*">    <!-- 04 -->
                </colgroup>
                <tbody>
                    <tr>
                        <th><spring:message code="synchronize.column.requestMethod"/></th>
                        <td>${requestSynchronize.method}</td>
                        <th><spring:message code="synchronize.column.requestType"/></th>
                        <td>${requestSynchronize.type}</td>
                    </tr>
                    <tr>
                        <th><spring:message code="synchronize.column.requestResult"/></th>
                        <td>
                            <spring:message code="synchronize.column.totalCnt"/> ${requestSynchronize.totalCnt}<spring:message code="synchronize.column.cnt"/>
                            (<spring:message code="synchronize.column.successCnt"/> : ${requestSynchronize.successCnt}<spring:message code="synchronize.column.cnt"/> /
                            <spring:message code="synchronize.column.failureCnt"/> : ${requestSynchronize.failureCnt}<spring:message code="synchronize.column.cnt"/>)
                        </td>
                        <th></th>
                        <td></td>
                    </tr>
                </tbody>
            </table>
            <!-- 입력 테이블 End -->
        </div>
    </article>

    <article class="table_area">
        <div class="table_title_area">
            <h4><spring:message code="synchronize.title.user" /></h4>
        </div>

        <div class="table_contents">
            <!-- 입력 테이블 Start -->
            <table class="t_defalut t_type01 t_style02">
                <colgroup>
                    <col style="width:25%">  <!-- 01 -->
                    <col style="width:25%">  <!-- 02 -->
                    <col style="width:25%">  <!-- 03 -->
                    <col style="width:25%">  <!-- 04 -->
                </colgroup>
                <thead>
                    <tr>
                        <th><spring:message code="synchronize.column.userId"/></th>
                        <th><spring:message code="synchronize.column.requestResult"/></th>
                        <th><spring:message code="synchronize.column.syncStartDatetime"/></th>
                        <th><spring:message code="synchronize.column.syncEndDatetime"/></th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${synchronizeUserList != null and fn:length(synchronizeUserList) > 0}">
                            <c:forEach var="synchronizeUser" items="${synchronizeUserList}">
                                <tr onclick="javascript:userDetailPopup('${synchronizeUser.syncUserId}');">
                                    <td>${synchronizeUser.userId}</td>
                                    <td>${synchronizeUser.totalCnt}(${synchronizeUser.successCnt}/${synchronizeUser.failureCnt})</td>
                                    <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${synchronizeUser.startDatetime}" /></td>
                                    <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${synchronizeUser.endDatetime}" /></td>
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
            <!-- 입력 테이블 End -->
        </div>

        <div class="table_title_area">
            <div class="table_btn_set">
                <button class="btn btype01 bstyle03" onclick="javascript:cancel(); return false;"><spring:message code="common.button.cancel"/> </button>
            </div>
        </div>
    </article>
    <!-- 테이블 입력 / 조회 영역 End -->
</section>
<!-- END : contents -->

<script type="text/javascript">
    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');

    /*
     url defind
     @author psb
     */
    var urlConfig = {
        listUrl : "${rootPath}/synchronize/list.html"
        ,userDetailPopupUrl : "${rootPath}/synchronize/userDetail.json"
    };

    /*
     message define
     @author psb
     */
    var messageConfig = {
        'userDetailPopupFailure':'<spring:message code="synchronize.message.userDetailPopupFailure"/>'
    };

    var layerPopupTag = $("<tr/>")
        .append( $("<td/>").attr("id","syncTarget") )
        .append( $("<td/>").attr("id","syncType") )
        .append( $("<td/>").attr("id","syncState") )
        .append( $("<td/>").attr("id","description") )
        .append( $("<td/>").attr("id","syncDatetime") );

    var emptyPopupTag = $("<tr/>").append(
        $("<td/>").attr("colspan","5").text('<spring:message code="common.message.emptyData"/>')
    );

    $(document).ready(function(){
    });
    
    /*
     add method
     @author psb
     */
    function userDetailPopup(syncUserId){
        callAjax('userDetailPopup', {"syncUserId" : syncUserId});
    }

    /*
     ajax call
     @author psb
     */
    function callAjax(actionType, data){
        sendAjaxPostRequest(urlConfig[actionType + 'Url'],data,successHandler,errorHandler,actionType);
    }

    /*
     ajax success handler
     @author psb
     */
    function successHandler(data, dataType, actionType){
        switch(actionType){
            case 'userDetailPopup':
                userDetailRender(data);
                break;
        }
    }

    /*
     ajax error handler
     @author psb
     */
    function errorHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        alertMessage(actionType + 'Failure');
    }

    function closeLayer(){
        $('.layer_popup').fadeOut(200);
        setTimeout(function () {
            $('.layer_popup').removeClass("ipop_type01");
            $('.layer_popup').removeClass("ipop_type02");
            $('.layer_popup').removeClass("ipop_type03");
            $('.layer_wrap').removeClass("i_type01");
            $('.layer_wrap').removeClass("i_type02");
            $('.layer_wrap').removeClass("i_type03");
        }, 300);
    }

    function userDetailRender(data){
        var userDetail = data['synchronizeUserDetailList'];
        $("#layerTbData").empty();

        if(userDetail!=null && userDetail.length>0){
            var _layerTag = layerPopupTag.clone();
            for(var index in userDetail){
                var _layerTag = layerPopupTag.clone();
                _layerTag.find("#syncTarget").text(userDetail[index]['target']);
                _layerTag.find("#syncType").text(userDetail[index]['type']);
                _layerTag.find("#syncState").text(userDetail[index]['state']);
                if(userDetail[index]['description']!=null){
                    _layerTag.find("#description").text(userDetail[index]['description']);
                }
                if(userDetail[index]['endDatetime']!=null){
                    _layerTag.find("#syncDatetime").text(new Date(userDetail[index]['endDatetime']).format("yyyy-MM-dd hh:mm"));
                }
                $("#layerTbData").append(_layerTag);
            }
        }else{
            $("#layerTbData").html(emptyPopupTag.clone());
        }

        $('.layer_popup').addClass("ipop_type03");
        $('.layer_wrap').addClass("i_type03");
        $('.ipop_type03').fadeIn(200);
    }

    /*
     alert message method
     @author psb
     */
    function alertMessage(type){
        alert(messageConfig[type]);
    }

    /*
     cancel method
     @author psb
     */
    function cancel(){
        var listForm = $('<FORM>').attr('method','POST').attr('action',urlConfig['listUrl']);
        listForm.append($('<INPUT>').attr('name','reloadList').attr('value','true'));
        listForm.appendTo(document.body);
        listForm.submit();
    }
</script>