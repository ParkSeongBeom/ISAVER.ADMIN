<!-- 이벤트 관리, @author dhj -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<c:set value="B00030" var="menuId"/>
<c:set value="B00000" var="subMenuId"/>
<isaver:pageRoleCheck menuId="${menuId}" locale="${pageContext.response.locale}"/>
<script type="text/javascript" src="${rootPath}/assets/js/util/page-navigater.js"></script>

<div class="popupbase admin_popup code_select_popup">
    <div>
        <div>
            <header>
                <h2>대응목록</h2>
                <button onclick="javascript:popup_cancelButton(); return false;"></button>
            </header>
            <article>
                <div class="table_area">
                    <div class="table_contents">
                        <!-- 입력 테이블 Start -->
                        <table id="codeTable" class="t_defalut t_type01 t_style02">
                            <colgroup>
                                <col style="width: 15%;">
                                <col style="width: 20%;">
                                <col style="width: *%;">
                            </colgroup>
                            <thead>
                            <tr>
                                <th><spring:message code="event.column.eventActionId"/></th>
                                <th><spring:message code="event.column.eventActionDivision"/></th>
                                <th><spring:message code="event.column.eventActionType"/></th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr>
                                <td title="" name="action_id"></td>
                                <td title="" name="action_code"></td>
                                <td title="">
                                    <p class="editable01" name="action_desc"></p>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </article>
            <footer>
                <button class="btn" id="actionDetailMoveButton"><spring:message code="device.button.learnMore"/></button>
            </footer>
        </div>
    </div>
    <div class="bg ipop_close" onclick="popup_cancelButton();"></div>
</div>

<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.event"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><isaver:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <form id="eventForm" method="POST">
        <input type="hidden" name="pageNumber"/>

        <article class="search_area">
            <div class="search_contents">
                <!-- 일반 input 폼 공통 -->
                <p class="itype_01">
                    <span><spring:message code="event.column.eventId" /></span>
                    <span>
                        <input type="text" name="eventId" value="${paramBean.eventId}"/>
                    </span>
                </p>
                <p class="itype_01">
                    <span><spring:message code="event.column.eventName" /></span>
                    <span>
                        <input type="text" name="eventName" value="${paramBean.eventName}"/>
                    </span>
                </p>
                <p class="itype_01">
                    <span><spring:message code="event.column.eventFlag" /></span>
                    <spring:message code="common.selectbox.select" var="allSelectText"/>
                    <span><isaver:codeSelectBox groupCodeId="EVT" codeId="${paramBean.eventFlag}" htmlTagName="eventFlag" allModel="true" allText="${allSelectText}"/></span>
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
                <p><span><spring:message code="common.message.total"/><em>${paramBean.totalCount}</em><spring:message code="common.message.number01"/></span></p>
                <%--<button class="btn btype01 bstyle03" onclick="javascript:moveDetail(); return false;"><spring:message code="common.button.add"/> </button>--%>
            </div>
        </div>

        <div class="table_contents">
            <!-- 입력 테이블 Start -->
            <table class="t_defalut t_type01 t_style02">
                <colgroup>
                    <col style="width: 10%;" />
                    <col style="width: 10%;" />
                    <col style="width: 30%;" />
                    <col style="width: *%;" />
                </colgroup>
                <thead>
                <tr>
                    <th><spring:message code="event.column.eventId"/></th>
                    <th><spring:message code="event.column.eventFlag"/></th>
                    <th><spring:message code="event.column.eventName"/></th>
                    <th><spring:message code="event.column.eventDesc"/></th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${events != null and fn:length(events) > 0}">
                        <c:forEach var="event" items="${events}">
                            <tr event_id="${event.eventId}">
                            <%--<tr onclick="moveDetail(String('${event.eventId}'));">--%>
                                <td>${event.eventId}</td>
                                <td>${event.eventFlag}</td>
                                <td>${event.eventName}</td>
                                <td>${event.eventDesc}</td>
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

            <!-- 테이블 공통 페이징 Start -->
            <div id="pageContainer" class="page" />
        </div>
    </article>
</section>

<script type="text/javascript">
    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');
    var form = $('#eventForm');

    var messageConfig = {
        'actionDetailFailure':'<spring:message code="action.message.actionListFailure"/>'
    };

    var urlConfig = {
        'listUrl':'${rootPath}/event/list.html'
        ,'detailUrl':'${rootPath}/event/detail.html'
        ,'actionDetailUrl':'${rootPath}/action/detail.html'
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
            var event_id = new String($(this).parent().attr("event_id"));
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