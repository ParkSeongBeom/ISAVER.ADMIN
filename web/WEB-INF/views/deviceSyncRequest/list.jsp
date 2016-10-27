<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<c:set value="D00020" var="menuId"/>
<c:set value="D00000" var="subMenuId"/>
<%--<isaver:pageRoleCheck menuId="${menuId}" />--%>
<script type="text/javascript" src="${rootPath}/assets/js/util/page-navigater.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/common/jquery-ui-1.10.4.min.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/data-util.js"></script>
<link rel="stylesheet" href="${rootPath}/assets/css/jqueryui/jquery-ui-1.10.4.min.css">

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.deviceSyncRequest"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><isaver:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <form id="deviceSyncRequestForm" method="POST">
        <input type="hidden" name="pageNumber"/>

        <article class="search_area">
            <div class="search_contents">
                <!-- 일반 input 폼 공통 -->
                <p class="itype_01">
                    <span><spring:message code="deviceSyncRequest.column.type" /></span>
                    <isaver:codeSelectBox groupCodeId="T01" codeId="${paramBean.type}" htmlTagName="type" allModel="true"/>
                </p>
                <p class="itype_01">
                    <span><spring:message code="deviceSyncRequest.column.status" /></span>
                    <isaver:codeSelectBox groupCodeId="S01" codeId="${paramBean.status}" htmlTagName="status" allModel="true"/>
                </p>
                <p class="itype_04">
                    <span><spring:message code="deviceSyncRequest.column.requestDatetime" /></span>
                    <span class="plable04">
                        <input type="text" name="startDatetimeStr" value="${paramBean.startDatetimeStr}" />
                        <em>~</em>
                        <input type="text" name="endDatetimeStr" value="${paramBean.endDatetimeStr}" />
                    </span>
                </p>
            </div>
            <div class="search_btn">
                <button onclick="javascript:search(); return false;" class="btn bstyle01 btype01"><spring:message code="common.button.search"/></button>
            </div>
        </article>
    </form>

    <article class="table_area">
        <div class="table_title_area">
            <h4></h4>
            <div class="table_btn_set">
                <p><span>총<em>${paramBean.totalCount}</em>건</span></p>
                <button class="btn btype01 bstyle03" onclick="javascript:saveDeviceSyncRequest(); return false;"><spring:message code="deviceSyncRequest.button.request"/> </button>
            </div>
        </div>

        <div class="table_contents">
            <!-- 입력 테이블 Start -->
            <table class="t_defalut t_type01 t_style02">
                <colgroup>
                    <col style="width: 5%;" />
                    <col style="width: *;" />
                    <%--<col style="width: 15%;" />--%>
                    <col style="width: 10%;" />
                    <col style="width: 10%;" />
                    <col style="width: 15%;" />
                    <col style="width: 20%;" />
                    <col style="width: 20%;" />
                </colgroup>
                <thead>
                    <tr>
                        <th><input type="checkbox" id="mainCheck" value=""></th>
                        <%--<th><spring:message code="deviceSyncRequest.column.deviceSyncRequestId"/></th>--%>
                        <th><spring:message code="deviceSyncRequest.column.deviceName"/></th>
                        <th><spring:message code="deviceSyncRequest.column.type"/></th>
                        <th><spring:message code="deviceSyncRequest.column.status"/></th>
                        <th><spring:message code="deviceSyncRequest.column.insertUserName"/></th>
                        <th><spring:message code="deviceSyncRequest.column.startDatetime"/></th>
                        <th><spring:message code="deviceSyncRequest.column.endDatetime"/></th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${deviceSyncRequestList != null and fn:length(deviceSyncRequestList) > 0}">
                            <c:forEach var="deviceSyncRequest" items="${deviceSyncRequestList}">
                                <tr>
                                    <td><input type="checkbox" name="subCheck" value="${deviceSyncRequest.deviceSyncRequestId}"></td>
                                    <%--<td>${deviceSyncRequest.deviceSyncRequestId}</td>--%>
                                    <td>${deviceSyncRequest.deviceName}</td>
                                    <td>${deviceSyncRequest.type}</td>
                                    <td>${deviceSyncRequest.status}</td>
                                    <td>${deviceSyncRequest.insertUserName}</td>
                                    <td>
                                        <fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${deviceSyncRequest.startDatetime}" />
                                    </td>
                                    <td>
                                        <fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${deviceSyncRequest.endDatetime}" />
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

            <!-- 테이블 공통 페이징 Start -->
            <div id="pageContainer" class="page" />
        </div>
    </article>
</section>
<!-- END : contents -->

<script type="text/javascript">
    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');
    var form = $('#deviceSyncRequestForm');

    var urlConfig = {
        'listUrl':'${rootPath}/deviceSyncRequest/list.html'
        ,'saveUrl':'${rootPath}/deviceSyncRequest/save.json'
    };

    var pageConfig = {
        pageSize     : Number(<c:out value="${paramBean.pageRowNumber}" />)
        ,pageNumber  : Number(<c:out value="${paramBean.pageNumber}" />)
        ,totalCount  : Number(<c:out value="${paramBean.totalCount}" />)
    };

    var messageConfig = {
        'saveComplete':'<spring:message code="deviceSyncRequest.message.saveComplete"/>'
        ,'saveConfirm':'<spring:message code="deviceSyncRequest.message.saveConfirm"/>'
        ,'saveEmpty':'<spring:message code="deviceSyncRequest.message.saveEmpty"/>'
    };

    $(document).ready(function(){
        drawPageNavigater(pageConfig['pageSize'],pageConfig['pageNumber'],pageConfig['totalCount']);

        $('#mainCheck').click(function(){
            if($(this).is(':checked')){
                $("input[name=subCheck]").prop("checked",true);
            }else{
                $("input[name=subCheck]").prop("checked",false);
            }
        });

        $("input:text").keypress(function(e) {
            if(e.which == 13) {
                search();
            }
        });
    });

    /*
     조회
     @author psb
     */
    function search(){
        form.attr('action',urlConfig['listUrl']);
        form.submit();
    }

    /*
     페이지 네이게이터를 그린다.
     @author psb
     */
    function drawPageNavigater(pageSize,pageNumber,totalCount){
        var pageNavigater = new PageNavigator(pageSize,pageNumber,totalCount);
        pageNavigater.setClass('paging','p_arrow pll','p_arrow pl','','page_select','');
        pageNavigater.setGroupTag('《','〈','〉','》');
        pageNavigater.showInfo(false);
        $('#pageContainer').append(pageNavigater.getHtml());
    }

    /*
     재요청
     @author psb
     */
    function saveDeviceSyncRequest(){
        var checkList = $("input[name=subCheck]:checked");
        var deviceSyncRequestIds = "";

        if(checkList.length>0){
            if(!confirm(messageConfig['saveConfirm'])) {
                return false;
            }

            for (var i = 0; i < checkList.length; i++) {
                if (i>0){
                    deviceSyncRequestIds += ",";
                }
                deviceSyncRequestIds += checkList[i].value;
            }

            var data = {
                "deviceSyncRequestIds" : deviceSyncRequestIds
            };

            callAjax('save', data);
        }else{
            alert(messageConfig['saveEmpty']);
        }
    }

    /*
     페이지 이동
     @author psb
     */
    function callAjax(actionType, data){
        sendAjaxPostRequest(urlConfig[actionType + 'Url'],data,requestCode_successHandler,requestCode_errorHandler,actionType);
    }

    /*
     Success Handler
     @author psb
     */
    function requestCode_successHandler(data, dataType, actionType){
        alert(messageConfig[actionType + 'Complete']);
        switch(actionType){
            case 'save':
                search();
                break;
        }
    }

    /*
     Error Handler
     @author psb
     */
    function requestCode_errorHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        alert(messageConfig[actionType + 'Failure']);
    }

    /*
     페이지 이동
     @author psb
     */
    function goPage(pageNumber){
        form.find('input[name=pageNumber]').val(pageNumber);
        search();
    }
</script>