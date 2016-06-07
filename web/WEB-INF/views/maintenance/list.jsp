<%--
  Created by IntelliJ IDEA.
  User: dhj
  Date: 2014. 6. 11.
  Time: 오후 12:22
  의뢰 사항 관리 페이지
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="jabber" uri="/WEB-INF/views/common/tags/jabber.tld"%>
<c:set value="MN000000-C000-0000-0000-000000000000" var="subMenuId"/>
<c:set value="MN000000-C000-0000-0000-000000000002" var="menuId"/>
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
        <h3 class="1depth_title"><spring:message code="common.title.maintenance"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><jabber:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <form id="maintenanceForm" method="POST">
        <input type="hidden" name="pageNumber"/>

        <article class="search_area">
            <div class="search_contents">
                <!-- 일반 input 폼 공통 -->
                <p class="itype_01">
                    <span><spring:message code="maintenance.column.title" /></span>
                    <span>
                        <input type="text" name="title" value="${paramBean.title}"/>
                    </span>
                </p>
                <p class="itype_01">
                    <span><spring:message code="maintenance.column.clientName" /></span>
                    <span>
                        <input type="text" name="requestUserId" value="${paramBean.requestUserId}" />
                    </span>
                </p>
                <p class="itype_01">
                    <span><spring:message code="maintenance.column.sysCode" /></span>
                    <span>
                        <jabber:codeSelectBox groupCodeId="C001" htmlTagName="sysCode" allModel="true" codeId="${paramBean.sysCode}"/>
                    </span>
                </p>
                <p class="itype_01">
                    <span><spring:message code="maintenance.column.typeCode" /></span>
                    <span>
                        <jabber:codeSelectBox groupCodeId="C002" htmlTagName="typeCode" allModel="true" codeId="${paramBean.typeCode}"/>
                    </span>
                </p>
                <p class="itype_04">
                    <span><spring:message code="maintenance.column.requestDate" /></span>
                    <span class="plable04">
                        <input type="text" name="startDatetimeStr" value="${paramBean.startDatetimeStr}" />
                        <select id="startDatetimeHourSelect" name="startDatetimeHour"></select>
                        <em>~</em>
                        <input type="text" name="endDatetimeStr" value="${paramBean.endDatetimeStr}" />
                        <select id="endDatetimeHourSelect" name="endDatetimeHour"></select>
                    </span>
                </p>
                <p class="itype_01">
                    <span><spring:message code="maintenance.column.status" /></span>
                    <span>
                        <jabber:codeSelectBox groupCodeId="C003" htmlTagName="status" allModel="true" codeId="${paramBean.status}"/>
                    </span>
                </p>
            </div>
            <div class="search_btn">
                <button onclick="javascript:search(); return false;" class="btn bstyle01 btype01"><spring:message code="common.button.search"/></button>
            </div>
        </article>
    </form>

    <article class="table_area">
        <div class="table_contents">
            <!-- 입력 테이블 Start -->
            <table class="t_defalut t_type01 t_style02">
                <colgroup>
                    <col style="width: 90px;" />
                    <col style="width: 20px;" />
                    <col style="width: *;" />
                    <col style="width: 10%;" />
                    <col style="width: 10%;" />
                    <col style="width: 10%;" />
                    <col style="width: 120px;" />
                    <col style="width: 10%;" />
                    <col style="width: 120px;" />
                </colgroup>
                <thead>
                    <tr>
                        <th><spring:message code="maintenance.column.status"/></th>
                        <th colspan="2"><spring:message code="maintenance.column.title"/></th>
                        <th><spring:message code="maintenance.column.sysCode"/></th>
                        <th><spring:message code="maintenance.column.typeCode"/></th>
                        <th><spring:message code="maintenance.column.reqName"/></th>
                        <th><spring:message code="maintenance.column.requestDate"/></th>
                        <th><spring:message code="maintenance.column.reviewName"/></th>
                        <th><spring:message code="maintenance.column.reviewEndDate"/></th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${maintenances != null and fn:length(maintenances) > 0}">
                            <c:forEach var="maintenance" items="${maintenances}">
                                <tr onclick="moveDetail('${maintenance.maintenanceId}')">
                                    <td>[<c:out value="${maintenance.statusName}" />]</td>
                                    <td <c:if test="${!empty maintenance.logicalFileName}">class="fplus" onclick="fileDownload('${maintenance.maintenanceId}',event);"</c:if>></td>
                                    <td><c:out value="${maintenance.title}" /></td>
                                    <td><c:out value="${maintenance.sysCode}" /></td>
                                    <td><c:out value="${maintenance.typeCode}" /></td>
                                    <td><c:out value="${maintenance.requestUserId}" /></td>
                                    <td>
                                        <c:if test="${!empty maintenance.requestDate}">
                                            <fmt:formatDate pattern="yyyy.MM.dd HH:mm" value="${maintenance.requestDate}" />
                                        </c:if>
                                    </td>
                                    <td><c:out value="${maintenance.reviewUserId}" /></td>
                                    <td>
                                        <c:if test="${!empty maintenance.reviewEndDate}">
                                            <fmt:formatDate pattern="yyyy.MM.dd" value="${maintenance.reviewEndDate}" />
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="8"><spring:message code="common.message.emptyData"/></td>
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

<script type="text/javascript" charset="utf-8">

    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');
    var form = $('#maintenanceForm');

    var urlConfig = {
        listUrl    : '${rootPath}/maintenance/list.html'
        ,detailUrl : '${rootPath}/maintenance/detail.html'
        ,downloadUrl:'${rootPath}/maintenance/download.html'
    };

    var searchConfig = {
        'startDatetimeHour':'${paramBean.startDatetimeHour}'
        ,'endDatetimeHour':'${paramBean.endDatetimeHour}'
    };

    var pageConfig = {
        pageSize     : Number(<c:out value="${paramBean.pageRowNumber}" />)
        ,pageNumber  : Number(<c:out value="${paramBean.pageNumber}" />)
        ,totalCount  : Number(<c:out value="${paramBean.totalCount}" />)
    };

    var messageConfig = {
        'confirmStartDatetime':'<spring:message code="maintenance.message.confirmStartDatetime"/>'
        ,'confirmEndDatetime':'<spring:message code="maintenance.message.confirmEndDatetime"/>'
    };

    $(document).ready(function(){
        drawPageNavigater(pageConfig['pageSize'],pageConfig['pageNumber'],pageConfig['totalCount']);

        calendarHelper.load(form.find('input[name=startDatetimeStr]'));
        calendarHelper.load(form.find('input[name=endDatetimeStr]'));

        setHourDataToSelect($('#startDatetimeHourSelect'),searchConfig['startDatetimeHour'],false);
        setHourDataToSelect($('#endDatetimeHourSelect'),searchConfig['endDatetimeHour'],true);

        $("input:text").keypress(function(e) {
            if(e.which == 13) {
                search();
            }
        });
    });

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
     @author kst
     */
    function search(){
        if(validateSearch()){
            form.attr('action',urlConfig['listUrl']);
            form.submit();
        }
    }

    /*
     상세화면 이동
     @author kst
     */
    function moveDetail(maintenanceId){
        var detailForm = $('<FORM>').attr('action',urlConfig['detailUrl']).attr('method','POST');
        detailForm.append($('<INPUT>').attr('type','hidden').attr('name','id').attr('value', maintenanceId));
        document.body.appendChild(detailForm.get(0));
        detailForm.submit();
    }

    /*
     alert message
     @author kst
     */
    function alertMessage(type){
        alert(messageConfig[type]);
    }

    function fileDownload(maintenanceId, event){
        var link = document.createElement("a");
        link.href = urlConfig['downloadUrl'] + "?id=" + maintenanceId;
        link.click();

        event.stopPropagation();
    }
</script>