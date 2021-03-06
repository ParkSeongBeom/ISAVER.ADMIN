<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<c:set value="B00050" var="menuId"/>
<c:set value="B00000" var="subMenuId"/>
<isaver:pageRoleCheck menuId="${menuId}" locale="${pageContext.response.locale}"/>
<script type="text/javascript" src="${rootPath}/assets/js/util/page-navigater.js"></script>

<div class="sub_title_area">
    <h3 class="1depth_title"><spring:message code="common.title.role"/></h3>
    <div class="navigation">
        <span><isaver:menu menuId="${menuId}" /></span>
    </div>
</div>

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <form id="roleForm" method="POST">
        <input type="hidden" name="pageNumber"/>

        <article class="search_area">
            <div class="search_contents">
                <!-- 일반 input 폼 공통 -->
                <p class="itype_01">
                    <span><spring:message code="role.column.roleId" /></span>
                    <span>
                        <input type="text" name="roleId" value="${paramBean.roleId}"/>
                    </span>
                </p>
                <p class="itype_01">
                    <span><spring:message code="role.column.roleName" /></span>
                    <span>
                        <input type="text" name="roleName" value="${paramBean.roleName}"/>
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
                <button class="btn btype01 bstyle03" onclick="javascript:moveDetail(METHOD.ADD, null); return false;"><spring:message code="common.button.add"/> </button>
            </div>
        </div>

        <div class="table_contents">
            <!-- 입력 테이블 Start -->
            <table class="t_defalut t_type01 t_style02">
                <colgroup>
                    <col style="width: 20%;" />
                    <col style="width: *%;" />
                    <col style="width: 10%;" />
                    <col style="width: 15%;" />
                    <col style="width: 10%;" />
                    <col style="width: 15%;" />
                </colgroup>
                <thead>
                    <tr>
                        <th><spring:message code="role.column.roleId"/></th>
                        <th><spring:message code="role.column.roleName"/></th>
                        <th><spring:message code="common.column.insertUser"/></th>
                        <th><spring:message code="common.column.insertDatetime"/></th>
                        <th><spring:message code="common.column.updateUser"/></th>
                        <th><spring:message code="common.column.updateDatetime"/></th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${roles != null and fn:length(roles) > 0}">
                            <c:forEach var="role" items="${roles}">
                                <tr onclick="moveDetail(METHOD.DETAIL, '${role.roleId}')">
                                    <td>${role.roleId}</td>
                                    <td>${role.roleName}</td>
                                    <td>${role.insertUserId}</td>
                                    <td><fmt:formatDate value="${role.insertDatetime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                                    <td>${role.updateUserId}</td>
                                    <td><fmt:formatDate value="${role.updateDatetime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
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

<script type="text/javascript" charset="utf-8">
    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');
    var form = $('#roleForm');

    var METHOD = {
        ADD:'add',
        SAVE:'save',
        REMOVE:'remove',
        DETAIL:'detail'
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
     @author kst
     */
    function drawPageNavigater(pageSize,pageNumber,totalCount){
        var pageNavigater = new PageNavigator(pageSize,pageNumber,totalCount);
        pageNavigater.setClass('paging','pll','pl','','on','');
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


    function getRequestUrl(type, method) {
        var rootUrl = String();
        try {
            rootUrl = String('${rootPath}');
        }catch(e) {rootUrl = '';}

        return {
            add: rootUrl + "/" + type + "/detail.html",
            detail: rootUrl + "/" + type + "/detail.html",
            list: rootUrl + "/" + type + "/list.html"
        }[method];
    };

    /*
     조회
     @author kst
     */
    function search(){
        form.attr('action',getRequestUrl('role','list'));
        form.submit();
    }

    function moveDetail(method, id){
        var type = 'role';
        var form = $('<FORM>').attr('action',getRequestUrl(type, method) ).attr('method','POST');

        var methodModule = {
            detail: function () {
                form.append($('<INPUT>').attr('type','hidden').attr('name','roleId').attr('value',id));
            },
            add: function() {}
        }

        try {
            methodModule[method]();
            document.body.appendChild(form.get(0));
            form.submit()
        } catch(e) {
            console.error('[Error][Role][moveDetail()] ' + e);
        }
    }

</script>