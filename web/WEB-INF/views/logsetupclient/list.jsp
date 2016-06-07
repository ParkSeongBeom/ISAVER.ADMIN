<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="jabber" uri="/WEB-INF/views/common/tags/jabber.tld"%>
<c:set value="MN000000-D000-0000-0000-000000000000" var="subMenuId"/>
<c:set value="MN000000-D000-0000-0000-000000000002" var="menuId"/>
<jabber:pageRoleCheck menuId="${menuId}" />
<script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/page-navigater.js"></script>

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.logsetupclient"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><jabber:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <form id="logSetupClientForm" method="POST">
        <input type="hidden" name="pageNumber"/>

        <article class="search_area">
            <div class="search_contents">
                <!-- 일반 input 폼 공통 -->
                <p class="itype_01">
                    <span><spring:message code="logsetupclient.column.userId" /></span>
                    <span>
                        <input type="text" name="id" value="${paramBean.id}"/>
                    </span>
                </p>
                <p class="itype_01">
                    <span><spring:message code="logauthclientuser.column.device"/></span>
                    <span>
                        <select name="name">
                            <option value=""><spring:message code="common.button.select"/></option>
                            <c:forEach items="${deviceCodes}" var="deviceCode">
                                <option value="${deviceCode.codeId}" ${paramBean.name eq deviceCode.codeId ? 'selected' : ''}><c:out value="${deviceCode.codeName}"/> </option>
                            </c:forEach>
                        </select>
                    </span>
                </p>
                <p class="itype_01">
                    <span><spring:message code="logsetupclient.column.logType"/></span>
                    <span>
                        <select id="logTypeSelect" name="type" value="${paramBean.type}">
                            <option value=""><spring:message code="common.button.select"/></option>
                            <option value="SETUP" ${paramBean.type == 'SETUP' ? 'selected' : ''}><spring:message code="logsetupclient.button.setup"/></option>
                            <option value="UPDATE" ${paramBean.type == 'UPDATE' ? 'selected' : ''}><spring:message code="logsetupclient.button.update"/></option>
                        </select>
                    </span>
                </p>
                <p class="itype_01">
                    <span><spring:message code="logsetupclient.column.logAction"/></span>
                    <span>
                        <jabber:codeSelectBox groupCodeId="C010" htmlTagName="status" allModel="true" codeId="${paramBean.status}"/>
                    </span>
                </p>
                <%--<p class="itype_01">--%>
                    <%--<span><spring:message code="logsetupclient.column.description"/></span>--%>
                    <%--<span>--%>
                        <%--<input type="text" name="id" value="${paramBean.id}"/>--%>
                    <%--</span>--%>
                <%--</p>--%>
            </div>
            <div class="search_btn">
                <button onclick="javascript:search(); return false;" class="btn bstyle01 btype01"><spring:message code="common.button.search"/></button>
            </div>
        </article>
    </form>

    <article class="table_area">
        <div class="table_contents">
            <!-- 입력 테이블 Start -->
            <table class="t_defalut t_type01 t_style02 cursor_no">
                <colgroup>
                    <col style="width: 8%;" />
                    <col style="width: 5%;" />
                    <col style="width: 10%;" />
                    <col style="width: 8%;" />
                    <col style="width: *%;" />
                    <col style="width: 8%;" />
                    <col style="width: 10%;" />
                    <col style="width: 12%;" />
                    <col style="width: 13%;" />
                </colgroup>
                <thead>
                    <tr>
                        <th><spring:message code="logsetupclient.column.logType"/></th>
                        <th><spring:message code="logsetupclient.column.logAction"/></th>
                        <th><spring:message code="logsetupclient.column.device"/></th>
                        <th><spring:message code="logsetupclient.column.productVersion"/></th>
                        <th><spring:message code="logsetupclient.column.osVersion"/></th>
                        <th><spring:message code="logsetupclient.column.userId"/></th>
                        <th><spring:message code="logsetupclient.column.ipAddress"/></th>
                        <th><spring:message code="logsetupclient.column.macAddress"/></th>
                        <th><spring:message code="logsetupclient.column.logDatetime"/></th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${logSetupClients != null and fn:length(logSetupClients) > 0}">
                            <c:forEach var="logSetupClient" items="${logSetupClients}">
                                <tr>
                                    <td>${logSetupClient.logType}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${logSetupClient.logAction == 'SUCCESS'}">
                                                <spring:message code="logsetupclient.button.success"/>
                                            </c:when>
                                            <c:otherwise>
                                                <spring:message code="logsetupclient.button.failure"/>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${logSetupClient.device}</td>
                                    <td>${logSetupClient.productVersion}</td>
                                    <td>${logSetupClient.osVersion}</td>
                                    <td>${logSetupClient.userId}</td>
                                    <td>${logSetupClient.ipAddress}</td>
                                    <td>${logSetupClient.macAddress}</td>
                                    <td>
                                        <fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${logSetupClient.logDatetime}" />
                                    </td>
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
    var form = $('#logSetupClientForm');

    var urlConfig = {
        'listUrl':'${rootPath}/logsetupclient/list.html'
    };

    var pageConfig = {
        'pageSize':${paramBean.pageRowNumber}
        ,'pageNumber':${paramBean.pageNumber}
        ,'totalCount':${paramBean.totalCount}
    };

    $(document).ready(function(){
        drawPageNavigater(pageConfig['pageSize'],pageConfig['pageNumber'],pageConfig['totalCount']);
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

    /*
     조회
     @author kst
     */
    function search(){
        form.attr('action',urlConfig['listUrl']);
        form.submit();
    }
</script>