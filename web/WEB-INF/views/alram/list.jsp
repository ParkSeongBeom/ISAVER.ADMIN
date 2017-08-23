<!-- 라이센스 목록, @author dhj -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<c:set value="J00020" var="menuId"/>
<c:set value="J00000" var="subMenuId"/>
<%--<jabber:pageRoleCheck menuId="${menuId}" />--%>
<script type="text/javascript" src="${rootPath}/assets/js/util/page-navigater.js"></script>

<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.alram"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><isaver:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <form id="alramForm" method="POST">
        <article class="search_area">
            <div class="search_contents">
                <p class="itype_01">
                    <span><spring:message code='alram.column.alramId'/></span>
                    <span>
                        <input type="text" name="alramId" value="${paramBean.alramId}"/>
                    </span>
                </p>
                <p class="itype_01">
                    <span><spring:message code='alram.column.alramName'/></span>
                    <span>
                        <input type="text" name="alramName" value="${paramBean.alramName}"/>
                    </span>
                </p>
                <p class="itype_01">
                    <span><spring:message code='device.column.deviceCode'/></span>
                    <span>
                        <select name="useYn">
                            <option value="" <c:if test="${paramBean.useYn == ''}">selected="selected"</c:if>><spring:message code="common.column.useAll"/></option>
                            <option value="Y" <c:if test="${paramBean.useYn == 'Y'}">selected="selected"</c:if>><spring:message code="common.column.useYes"/></option>
                            <option value="N" <c:if test="${paramBean.useYn == 'N'}">selected="selected"</c:if>><spring:message code="common.column.useNo"/></option>
                        </select>
                    </span>
                </p>
            </div>
            <div class="search_btn">
                <button class="btn bstyle01 btype01" onclick="javascript:search(); return false;"><spring:message code="common.button.search" /></button>
            </div>
        </article>
    </form>

    <article class="table_area">
        <div class="table_title_area">
            <h4></h4>
            <div class="table_btn_set">
                <%--<p><span>총<em>${paramBean.totalCount}</em>건</span></p>--%>
                <button class="btn btype01 bstyle03" onclick="javascript:moveDetail(); return false;"><spring:message code="common.button.add"/></button>
            </div>
        </div>

        <div class="table_contents">
            <!-- 입력 테이블 Start -->
            <table class="t_defalut t_type01 t_style02">
                <colgroup>
                    <col style="width: 15%;" />
                    <col style="width: *;" />
                    <col style="width: 10%;" />
                    <col style="width: 20%;" />
                </colgroup>
                <thead>
                <tr>
                    <th><spring:message code="alram.column.alramId"/></th>
                    <th><spring:message code="alram.column.alramName"/></th>
                    <th><spring:message code="common.column.useYn"/></th>
                    <th><spring:message code="common.column.insertDatetime"/></th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${alramList != null and fn:length(alramList) > 0}">
                        <c:forEach var="alram" items="${alramList}">
                            <tr onclick="moveDetail(String('${alram.alramId}'));">
                                <td>${alram.alramId}</td>
                                <td>${alram.alramName}</td>
                                <td>
                                    <c:if test="${alram.useYn=='Y'}">
                                        <spring:message code="common.column.useYes"/>
                                    </c:if>
                                    <c:if test="${alram.useYn=='N'}">
                                        <spring:message code="common.column.useNo"/>
                                    </c:if>
                                </td>
                                <td>
                                    <fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${alram.insertDatetime}" />
                                </td>
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
    var form = $('#alramForm');

    var urlConfig = {
        'listUrl':'${rootPath}/alram/list.html'
        ,'detailUrl':'${rootPath}/alram/detail.json'
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
     조회
     @author psb
     */
    function search(){
        form.attr('action',urlConfig['listUrl']);
        form.submit();
    }

    function moveDetail(id){
        var detailForm = $('<FORM>').attr('action',urlConfig['detailUrl']).attr('method','POST');
        detailForm.append($('<INPUT>').attr('type','hidden').attr('name','alramId').attr('value',id));
        document.body.appendChild(detailForm.get(0));
        detailForm.submit();
    }
</script>