<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<c:set value="A00000" var="menuId"/>
<c:set value="A00000" var="subMenuId"/>
<isaver:pageRoleCheck menuId="${menuId}" />
<script type="text/javascript" src="${rootPath}/assets/js/util/page-navigater.js"></script>

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.user"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><isaver:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <form id="userForm" method="POST">
        <input type="hidden" name="pageNumber">
        <article class="search_area">
            <div class="search_contents">
                <!-- 일반 input 폼 공통 -->
                <p class="itype_01">
                    <span><spring:message code="user.column.userId" /></span>
                        <span>
                            <input type="text" name="userId" value="${paramBean.userId}"/>
                        </span>
                </p>
                <p class="itype_01">
                    <span><spring:message code="user.column.userName" /></span>
                        <span>
                            <input type="text" name="userName" value="${paramBean.userName}"/>
                        </span>
                </p>
                <p class="itype_01">
                    <span><spring:message code="role.column.roleName" /></span>
                    <select name="roleName">
                        <option value=""><spring:message code="common.button.select"/> </option>
                        <c:forEach items="${roles}" var="role">
                            <option value="${role.roleId}" ${paramBean.roleName == role.roleId ? 'selected' : ''}>${role.roleName}</option>
                        </c:forEach>
                    </select>
                        <span>
                            <%--<input type="text" name="roleName" value="${paramBean.roleName}"/>--%>
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
                    <col style="width: 15%;" />
                    <col style="width: 15%;" />
                    <col style="width: 15%;" />
                    <col style="width: *;" />
                </colgroup>
                <thead>
                    <tr>
                        <th><spring:message code="user.column.userId"/></th>
                        <th><spring:message code="user.column.userName"/></th>
                        <th><spring:message code="role.column.roleName"/></th>
                        <th><spring:message code="user.column.telephone"/></th>
                        <th><spring:message code="user.column.email"/></th>
                        <th><spring:message code="common.column.insertDatetime"/></th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${users != null and fn:length(users) > 0}">
                            <c:forEach var="user" items="${users}">
                                <tr onclick="moveDetail(String('${user.userId}'));">
                                    <td>${user.userId}</td>
                                    <td>${user.userName}</td>
                                    <td>${user.roleName}</td>
                                    <td>${user.telephone}</td>
                                    <td>${user.email}</td>
                                    <td>
                                        <fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${user.insertDatetime}" />
                                    </td>
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
<!-- END : contents -->

<script type="text/javascript">
    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');
    var form = $('#userForm');

    var urlConfig = {
        'listUrl':'${rootPath}/user/list.html'
        ,'detailUrl':'${rootPath}/user/detail.html'
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
        detailForm.append($('<INPUT>').attr('type','hidden').attr('name','userId').attr('value',id));
        document.body.appendChild(detailForm.get(0));
        detailForm.submit();
    }
</script>