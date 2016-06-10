<!-- 라이센스 목록, @author dhj -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<c:set value="E00000" var="menuId"/>
<c:set value="E00000" var="subMenuId"/>
<%--<jabber:pageRoleCheck menuId="${menuId}" />--%>
<script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/page-navigater.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/common/jquery-ui-1.10.4.min.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/data-util.js"></script>
<link rel="stylesheet" href="${rootPath}/assets/css/jqueryui/jquery-ui-1.10.4.min.css">

<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.license"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><isaver:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <form id="licenseForm" method="POST">
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
                <button class="btn btype01 bstyle03" onclick="javascript:moveDetail(); return false;"><spring:message code="common.button.add"/> </button>
            </div>
        </div>

        <div class="table_contents">
            <!-- 입력 테이블 Start -->
            <table class="t_defalut t_type01 t_style02">
                <colgroup>
                    <col style="width: 20%;" />
                    <col style="width: 20%;" />
                    <col style="width: 15%;" />
                    <col style="width: 10%;" />
                    <col style="width: 15%;" />
                </colgroup>
                <thead>
                <tr>
                    <th><spring:message code="common.column.insertDatetime"/></th>
                    <th><spring:message code="license.column.licenseKey"/></th>
                    <th><spring:message code="license.column.deviceType"/></th>
                    <th><spring:message code="license.column.licenseCount"/></th>
                    <th><spring:message code="license.column.expireDate"/></th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${licenses != null and fn:length(licenses) > 0}">
                        <c:forEach var="license" items="${licenses}">
                            <tr onclick="moveDetail(String('${license.licenseKey}'));">
                                <td>
                                    <fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${license.insertDatetime}" />
                                </td>
                                <td>${license.licenseKey}</td>
                                <td>${license.deviceCode}</td>
                                <td>${license.licenseCount}</td>
                                <td>${license.expireDate}</td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="6"><spring:message code="common.message.emptyData"/></td>
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
    var form = $('#licenseForm');

    var urlConfig = {
        'listUrl':'${rootPath}/license/list.html'
        ,'detailUrl':'${rootPath}/license/detail.html'
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

    /*
     상세화면 이동
     @author kst
     */
    function moveDetail(id){
        var detailForm = $('<FORM>').attr('action',urlConfig['detailUrl']).attr('method','POST');
        detailForm.append($('<INPUT>').attr('type','hidden').attr('name','licenseKey').attr('value',id));
        document.body.appendChild(detailForm.get(0));
        detailForm.submit();
    }
</script>