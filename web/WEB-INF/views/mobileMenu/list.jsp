<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="jabber" uri="/WEB-INF/views/common/tags/jabber.tld"%>
<c:set value="MN000000-A000-0000-0000-000000000000" var="subMenuId"/>
<c:set value="MN000000-A000-0000-0000-000000000026" var="menuId"/>
<script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/page-navigater.js"></script>
<jabber:pageRoleCheck menuId="${menuId}" />

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.mobileMenu"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><jabber:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <form id="mobileMenuForm" method="POST">
        <input type="hidden" name="pageNumber"/>

        <article class="search_area">
            <div class="search_contents">
                <!-- 일반 input 폼 공통 -->
                <p class="itype_01">
                    <span><spring:message code="mobileMenu.column.menuName"/></span>
                    <span><input type="text" name="menuName" value="${paramBean.menuName}"/></span>
                </p>
            </div>
            <div class="search_btn">
                <button onclick="javascript:search(); return false;" class="btn bstyle01 btype01"><spring:message code="common.button.search"/></button>
            </div>
        </article>
    </form>

    <article class="table_area">
        <div class="table_title_area">
            <%--<h4>테이블 타이틀</h4>--%>
            <div class="table_btn_set">
                <button class="btn btype01 bstyle03" onclick="javascript:moveDetail(''); return false;"><spring:message code="common.button.add"/> </button>
            </div>
        </div>

        <div class="table_contents">
            <!-- 조회 테이블 Start -->
            <table class="t_defalut t_type01 t_style02">
                <colgroup>
                    <col style="width: 10%;" />
                    <col style="width: *%;" />
                    <col style="width: 10%;" />
                    <col style="width: 10%;" />
                    <col style="width: 10%;" />
                    <col style="width: 10%;" />
                    <col style="width: 10%;" />
                    <col style="width: 15%;" />
                </colgroup>
                <thead>
                    <tr>
                        <th><spring:message code="mobileMenu.column.device"/></th>
                        <th><spring:message code="mobileMenu.column.menuName"/></th>
                        <th><spring:message code="mobileMenu.column.menuType"/></th>
                        <th><spring:message code="common.column.useYn"/></th>
                        <th><spring:message code="common.column.postion"/></th>
                        <th><spring:message code="common.column.sortOrder"/></th>
                        <th><spring:message code="common.column.insertUser"/></th>
                        <th><spring:message code="common.column.insertDatetime"/></th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${mobileMenuList != null and fn:length(mobileMenuList) > 0}">
                            <c:forEach var="mobileMenu" items="${mobileMenuList}">
                                <tr onclick="javascript:moveDetail('${mobileMenu.menuId}');">
                                    <td>${mobileMenu.deviceName}</td>
                                    <td>${mobileMenu.menuName}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${mobileMenu.menuType == 'main'}">
                                                <spring:message code="mobileMenu.selectbox.menuTypeMain"/>
                                            </c:when>
                                            <c:when test="${mobileMenu.menuType == 'sub'}">
                                                <spring:message code="mobileMenu.selectbox.menuTypeSub"/>
                                            </c:when>
                                            <c:when test="${mobileMenu.menuType == 'web'}">
                                                <spring:message code="mobileMenu.selectbox.menuTypeWeb"/>
                                            </c:when>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${mobileMenu.useYn == 'Y'}">
                                                <spring:message code="common.column.useYes"/>
                                            </c:when>
                                            <c:otherwise>
                                                <spring:message code="common.column.useNo"/>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${mobileMenu.position == 'top'}">
                                                <spring:message code="mobileMenu.selectbox.showTop" />
                                            </c:when>
                                            <c:otherwise>
                                                <spring:message code="mobileMenu.selectbox.showBottom" />
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${mobileMenu.menuSort}</td>
                                    <td>${mobileMenu.insertUserName}</td>
                                    <td>
                                        <fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${mobileMenu.insertDatetime}" />
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
<!-- section End -->

<script type="text/javascript">

    var form = $('#mobileMenuForm');
    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');

    var urlConfig = {
        'searchUrl':'${rootPath}/mobileMenu/list.html'
        ,'detailUrl':'${rootPath}/mobileMenu/detail.html'
    };

    var pageConfig = {
        'pageSize':${paramBean.pageRowNumber}
        ,'pageNumber':${paramBean.pageNumber}
        ,'totalCount':${paramBean.totalCount}
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
     조회
     @author psb
     */
    function search(){
        form.attr('action',urlConfig['searchUrl']);
        form.submit();
    }

    /*
     상세페이지 이동
     @author psb
     */
    function moveDetail(menuId){
        var detailForm = $('<FORM>').attr('action',urlConfig['detailUrl']).attr('method','POST');
        detailForm.append($('<INPUT>').attr('type','hidden').attr('name','menuId').attr('value',menuId));
        document.body.appendChild(detailForm.get(0));
        detailForm.submit();
    }
</script>