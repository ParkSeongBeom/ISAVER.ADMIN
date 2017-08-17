<!-- 임계치 관리, @author dhj -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<c:set value="J00000" var="menuId"/>
<c:set value="J00000" var="subMenuId"/>
<%--<jabber:pageRoleCheck menuId="${menuId}" />--%>
<script type="text/javascript" src="${rootPath}/assets/js/util/page-navigater.js"></script>

<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.critical"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><isaver:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <form id="criticalForm" method="POST">
        <input type="hidden" name="pageNumber"/>

        <article class="search_area">
            <div class="search_contents">
                <!-- 일반 input 폼 공통 -->
                <p class="itype_01">
                    <span><spring:message code="critical.column.criticalName" /></span>
                    <span>
                        <input type="text" name="criticalName" value="${paramBean.criticalName}"/>
                    </span>
                </p>
                <p class="itype_01">
                    <span><spring:message code="critical.column.eventId" /></span>
                    <span>
                        <input type="text" name="eventId" value="${paramBean.eventId}"/>
                    </span>
                </p>
                <p class="itype_01">
                    <span><spring:message code="common.column.useYn" /></span>
                    <span>
                        <select name="useYn">
                            <option value="ALL" <c:if test="${paramBean.useYn == ''}">selected</c:if>><spring:message code="common.column.useAll"/></option>
                            <option value="Y" <c:if test="${paramBean.useYn == 'Y'}">selected</c:if>><spring:message code="common.column.useYes"/></option>
                            <option value="N" <c:if test="${paramBean.useYn == 'N'}">selected</c:if>><spring:message code="common.column.useNo"/></option>
                        </select>
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
                <button class="btn btype01 bstyle03" onclick="javascript:moveDetail(); return false;"><spring:message code="common.button.add"/> </button>
            </div>
        </div>

        <div class="table_contents">
            <!-- 입력 테이블 Start -->
            <table class="t_defalut t_type01 t_style02">
                <colgroup>
                    <col style="width: 20%;" />
                    <col style="width: 25%;" />
                    <col style="width: 10%;" />
                    <col style="width: 30%;" />
                    <col style="width: *%;" />
                </colgroup>
                <thead>
                <tr>
                    <th><spring:message code="critical.column.criticalName"/></th>
                    <th><spring:message code="critical.column.eventId"/></th>
                    <th><spring:message code="common.column.useYn"/></th>
                    <th><spring:message code="common.column.insertDatetime"/></th>
                    <th><spring:message code="common.column.updateDatetime"/></th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${criticals != null and fn:length(criticals) > 0}">
                        <c:forEach var="critical" items="${criticals}">
                            <tr eventid="${critical.eventId}">
                            <%--<tr onclick="moveDetail(String('${event.eventId}'));">--%>
                                <td>${critical.criticalName}</td>
                                <td>${critical.eventName}(${critical.eventId})</td>
                                <c:if test="${critical.useYn == 'Y'}">
                                    <td><spring:message code="common.column.useYes"/></td>
                                </c:if>
                                <c:if test="${critical.useYn == 'N'}">
                                    <td><spring:message code="common.column.useNo"/></td>
                                </c:if>
                                <td><fmt:formatDate value="${critical.insertDatetime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                                <td><fmt:formatDate value="${critical.updateDatetime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
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

            <!-- 테이블 공통 페이징 Start -->
            <div id="pageContainer" class="page" />
        </div>
    </article>
</section>

<script type="text/javascript">
    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');
    var form = $('#criticalForm');

    var messageConfig = {
        'actionDetailFailure':'<spring:message code="action.message.actionListFailure"/>'
    };

    var urlConfig = {
        'listUrl':'${rootPath}/critical/list.html'
        ,'detailUrl':'${rootPath}/critical/detail.html'
    };

    var pageConfig = {
        pageSize     : Number(<c:out value="${paramBean.pageRowNumber}" />)
        ,pageNumber  : Number(<c:out value="${paramBean.pageNumber}" />)
        ,totalCount  : Number(<c:out value="${paramBean.totalCount}" />)
    };

    $(document).ready(function(){
        drawPageNavigater(pageConfig['pageSize'],pageConfig['pageNumber'],pageConfig['totalCount']);

        $("input:text").keypress(function(e) {
            if(e.which == 13) {
                search();
            }
        });
        addEventTableEventListenerFunc();
    });

    /*
     조회
     @author kst
     */
    function search(){

        if(form.find('select[name=useYn]').val() == "ALL") {
            form.find('select[name=useYn]').val("")
        }
        form.attr('action',urlConfig['listUrl']);
        form.submit();
    }

    /*
     페이지 네이게이터를 그린다.
     @author kst
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
     @author kst
     */
    function goPage(pageNumber){
        form.find('input[name=pageNumber]').val(pageNumber);
        search();
    }

    /* 팝업 보이기 버튼 */
    function popup_openButton(_actionId) {
        $(".code_select_popup").fadeIn();
        actionDetailLoad(_actionId);
    }


    /* 팝업 취소 버튼 */
    function popup_cancelButton() {
        $(".code_select_popup").fadeOut();
        return false;
    }

    /*
     상세화면 이동
     @author kst
     */
    function moveDetail(id){
        var detailForm = $('<FORM>').attr('action',urlConfig['detailUrl']).attr('method','POST');
        detailForm.append($('<INPUT>').attr('type','hidden').attr('name','eventId').attr('value',id));
        document.body.appendChild(detailForm.get(0));
        detailForm.submit();
    }

    /**
     * 컴포넌트 이벤트 추가
     * @author dhj
     */
    function addEventTableEventListenerFunc() {

        $(".table_contents > table tbody td:not(td:last-of-type)").click(function() {
            var event_id = new String($(this).parent().attr("eventId"));
            /* 상세 이동 */
            moveDetail(event_id);
        })
    }

    /* 대응 상세 조회*/
    function actionDetailLoad(_actionId) {
        var actionType = "actionDetail";

        var data = {
            'actionId' : _actionId
        };

        /* 대응 상세 - 내용 */
//        $("#actionList > tbody").empty();

        sendAjaxPostRequest(urlConfig[actionType + 'Url'], data, requestAction_successHandler,requestAction_errorHandler,actionType);
    }

    function requestAction_successHandler(data, dataType, actionType){

        switch(actionType){
            case 'actionDetail':
                makeActionListFunc(data['action']);
                break;
        }
    }

    function requestAction_errorHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        alert(actionType + 'Failure');
    }

    function makeActionListFunc(action) {
        var actionId = action['actionId'];
        var actionCode = action['actionCode'];
        var actionDesc = action['actionDesc'];

        $("#codeTable td[name=action_id]").text(actionId);
        $("#codeTable td[name=action_code]").text(actionCode);
        $("#codeTable p[name=action_desc]").text(actionDesc);

        $("#actionDetailMoveButton").unbind("click");
        $("#actionDetailMoveButton").click(function() {
            var detailForm = $('<FORM>').attr('action',urlConfig['actionDetailUrl']).attr('method','POST');
            detailForm.append($('<INPUT>').attr('type','hidden').attr('name','actionId').attr('value', actionId));
            document.body.appendChild(detailForm.get(0));
            detailForm.submit();
        });
    }

</script>