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
<script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/common-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/common/jquery-ui-1.10.4.min.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/page-navigater.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/elements-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/data-util.js"></script>

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

    <form id="requestSynchonizeForm" method="POST">
        <input type="hidden" name="pageNumber"/>

        <article class="search_area">
            <div class="search_contents">
                <!-- 일반 input 폼 공통 -->
                <p class="itype_01">
                    <span><spring:message code="synchronize.column.requestMethod" /></span>
                    <span>
                        <jabber:codeSelectBox groupCodeId="SYNC001" codeId="${paramBean.method}" htmlTagName="method" allModel="true" allText="선택"/>
                    </span>
                </p>
                <p class="itype_01">
                    <span><spring:message code="synchronize.column.requestType" /></span>
                    <span>
                        <jabber:codeSelectBox groupCodeId="SYNC002" codeId="${paramBean.type}" htmlTagName="type" allModel="true" allText="선택"/>
                    </span>
                </p>
                <p class="itype_01">
                    <span><spring:message code="synchronize.column.requestState" /></span>
                    <span>
                        <jabber:codeSelectBox groupCodeId="SYNC003" codeId="${paramBean.state}" htmlTagName="state" allModel="true" allText="선택"/>
                    </span>
                </p>
                <p class="itype_03">
                    <span><spring:message code="synchronize.column.synchronizeDate" /></span>
                    <span>
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
                <button class="btn btype01 bstyle03" onclick="javascript:synchronizeAll(); return false;"><spring:message code="synchronize.button.allSync"/> </button>
            </div>
        </div>

        <div class="table_contents">
            <!-- 입력 테이블 Start -->
            <table class="t_defalut t_type01 t_style02">
                <colgroup>
                    <col style="width:15%" />
                    <col style="width:13%" />
                    <col style="width:10%" />
                    <col style="width:10%" />
                    <col style="width:14%" />
                    <col style="width:10%" />
                    <col style="width:13%;" />
                    <col style="width:13%;" />
                    <col style="width:80px;" />
                </colgroup>
                <thead>
                    <tr>
                        <th><spring:message code="synchronize.column.requestId"/></th>
                        <th><spring:message code="synchronize.column.requestMethod"/></th>
                        <th><spring:message code="synchronize.column.requestType"/></th>
                        <th><spring:message code="synchronize.column.requestState"/></th>
                        <th><spring:message code="synchronize.column.requestResult"/></th>
                        <th><spring:message code="synchronize.column.requestUserId"/></th>
                        <th><spring:message code="synchronize.column.requestStartDatetime"/></th>
                        <th><spring:message code="synchronize.column.requestEndDatetime"/></th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${requestSynchronizeList != null and fn:length(requestSynchronizeList) > 0}">
                            <c:forEach var="requestSynchronize" items="${requestSynchronizeList}">
                                <tr onclick="moveDetail('${requestSynchronize.requestId}')">
                                    <td>${requestSynchronize.requestId}</td>
                                    <td>${requestSynchronize.method}</td>
                                    <td>${requestSynchronize.type}</td>
                                    <td>${requestSynchronize.state}</td>
                                    <td>${requestSynchronize.totalCnt}(${requestSynchronize.successCnt}/${requestSynchronize.failureCnt})</td>
                                    <td>${requestSynchronize.requestUserId}</td>
                                    <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${requestSynchronize.startDatetime}" /></td>
                                    <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${requestSynchronize.endDatetime}" /></td>
                                    <td><button class="btn btype02 bstyle03" onclick="javascript:return false;"><spring:message code="synchronize.button.requestSync"/></button></td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="9"><spring:message code="common.message.emptyData"/></td>
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

<script type="text/javascript">
    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');
    var form = $('#requestSynchonizeForm');

    var urlConfig = {
        'listUrl':'${rootPath}/synchronize/list.html'
        ,'detailUrl':'${rootPath}/synchronize/detail.html'
        ,'synchronizeAllUrl':'${rootPath}/synchronize/addAll.json'
    };

    var messageConfig = {
        'allSyncConfirm'        : '<spring:message code="synchronize.message.allSyncConfirm"/>'
        ,'allSyncReConfirm'     : '<spring:message code="synchronize.message.allSyncReConfirm"/>'
        ,'allSyncFailure'       : '<spring:message code="synchronize.message.allSyncFailure"/>'
        ,'allSyncComplete'      : '<spring:message code="synchronize.message.allSyncComplete"/>'
        ,'requestConfirm'       : '<spring:message code="synchronize.message.requestConfirm"/>'
        ,'requestFailure'       : '<spring:message code="synchronize.message.requestFailure"/>'
        ,'requestComplete'      : '<spring:message code="synchronize.message.requestComplete"/>'
        ,'synchronizeAllConfirm' : '<spring:message code="synchronize.message.synchronizeAllConfirm"/>'
        ,'synchronizeAllFailure' : '<spring:message code="synchronize.message.synchronizeAllFailure"/>'
        ,'synchronizeAllComplete': '<spring:message code="synchronize.message.synchronizeAllComplete"/>'
        ,'confirmStartDatetime' : '<spring:message code="synchronize.message.confirmStartDatetime"/>'
        ,'confirmEndDatetime'   : '<spring:message code="synchronize.message.confirmEndDatetime"/>'
    };

    var pageConfig = {
        pageSize     : Number(<c:out value="${paramBean.pageRowNumber}" />)
        ,pageNumber  : Number(<c:out value="${paramBean.pageNumber}" />)
        ,totalCount  : Number(<c:out value="${paramBean.totalCount}" />)
    };

    $(document).ready(function(){
        drawPageNavigater(pageConfig['pageSize'],pageConfig['pageNumber'],pageConfig['totalCount']);

        calendarHelper.load(form.find('input[name=startDatetimeStr]'));
        calendarHelper.load(form.find('input[name=endDatetimeStr]'));
    });

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
     페이지 이동
     @author psb
     */
    function goPage(pageNumber){
        form.find('input[name=pageNumber]').val(pageNumber);
        search();
    }

    /*
     조회유효성 검사
     @author kst
     */
    function validateSearch(){
        var startDatetiemStr = form.find('input[name=startDatetimeStr]').val();
        if(startDatetiemStr.length != 0 && !startDatetiemStr.checkDatePattern('-')){
            alertMessage('confirmStartDatetime');
            return false;
        }

        var endDatetimeStr = form.find('input[name=endDatetimeStr]').val();
        if(endDatetimeStr.length != 0 && !endDatetimeStr.checkDatePattern('-')){
            alertMessage('confirmEndDatetime');
            return false;
        }

        return true;
    }

    /*
     조회
     @author psb
     */
    function search(){
        if(validateSearch()){
            form.attr('action',urlConfig['listUrl']);
            form.submit();
        }
    }

    /*
     remove method
     @author kst
     */
    function synchronizeAll(){
        if(!confirm(messageConfig['synchronizeAllConfirm'])){
            return false;
        }

        callAjax('synchronizeAll');
    }

    /*
     ajax call
     @author kst
     */
    function callAjax(actionType, data){
        sendAjaxPostRequest(urlConfig[actionType + 'Url'],data,successHandler,errorHandler,actionType);
    }

    /*
     ajax success handler
     @author kst
     */
    function successHandler(data, dataType, actionType){
        switch(actionType){
            case 'synchronizeAll':
                alertMessage(actionType + 'Complete');
                location.reload();
                break;
        }
    }

    /*
     ajax error handler
     @author kst
     */
    function errorHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        alertMessage(actionType + 'Failure');
    }

    /*
     alert message method
     @author kst
     */
    function alertMessage(type){
        alert(messageConfig[type]);
    }

    /*
     상세화면 이동
     @author psb
     */
    function moveDetail(id){
        var detailForm = $('<FORM>').attr('action',urlConfig['detailUrl']).attr('method','POST');
        detailForm.append($('<INPUT>').attr('type','hidden').attr('name','requestId').attr('value',id));
        document.body.appendChild(detailForm.get(0));
        detailForm.submit();
    }
</script>