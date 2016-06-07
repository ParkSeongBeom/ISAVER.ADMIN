<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="jabber" uri="/WEB-INF/views/common/tags/jabber.tld"%>
<c:set value="MN000000-D000-0000-0000-000000000000" var="subMenuId"/>
<c:set value="MN000000-D000-0000-0000-000000000003" var="menuId"/>
<jabber:pageRoleCheck menuId="${menuId}" />
<script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/page-navigater.js"></script>

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.logauthclientuser"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><jabber:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <form id="logAuthClientUserForm" method="POST">
        <input type="hidden" name="pageNumber"/>

        <article class="search_area">
            <div class="search_contents">
                <!-- 일반 input 폼 공통 -->
                <p class="itype_01">
                    <span><spring:message code="logauthclientuser.column.userId" /></span>
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
                    <span><spring:message code="logauthclientuser.column.logType"/></span>
                    <span>
                        <select name="type">
                            <option value=""><spring:message code="common.button.select"/></option>
                            <option value="LOGIN" ${paramBean.type eq 'LOGIN' ? 'selected' : ''}>LOGIN</option>
                            <option value="LOGOUT" ${paramBean.type eq 'LOGOUT' ? 'selected' : ''}>LOGOUT</option>
                            <option value="DISCONNECT" ${paramBean.type eq 'DISCONNECT' ? 'selected' : ''}>DISCONNECT</option>
                            <option value="PUSHED" ${paramBean.type eq 'PUSHED' ? 'selected' : ''}>PUSHED</option>
                        </select>
                    </span>
                </p>
                <p class="itype_01">
                    <span><spring:message code="logauthclientuser.column.status"/></span>
                    <span>
                        <jabber:codeSelectBox groupCodeId="C010" htmlTagName="status" allModel="true" codeId="${paramBean.status}"/>
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
            <table class="t_defalut t_type01 t_style02 cursor_no">
                <colgroup>
                    <col style="width: 8%;" />
                    <col style="width: 5%;" />
                    <col style="width: 10%;" />
                    <col style="width: 8%;" />
                    <col style="width: 15%;" />
                    <col style="width: *;" />
                    <col style="width: 8%;" />
                    <col style="width: 10%;" />
                    <col style="width: 11%;" />
                    <col style="width: 13%;" />
                </colgroup>
                <thead>
                    <tr>
                        <th><spring:message code="logauthclientuser.column.logType"/></th>
                        <th><spring:message code="logauthclientuser.column.status"/></th>
                        <th><spring:message code="logauthclientuser.column.device"/></th>
                        <th><spring:message code="logauthclientuser.column.productVersion"/></th>
                        <th><spring:message code="logauthclientuser.column.osVersion"/></th>
                        <th><spring:message code="logauthclientuser.column.logMessage"/></th>
                        <th><spring:message code="logauthclientuser.column.userId"/></th>
                        <th><spring:message code="logauthclientuser.column.ipAddress"/></th>
                        <th><spring:message code="logauthclientuser.column.macAddress"/></th>
                        <th><spring:message code="logauthclientuser.column.logDatetime"/></th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${logAuthClientUsers != null and fn:length(logAuthClientUsers) > 0}">
                            <c:forEach var="logAuthClientUser" items="${logAuthClientUsers}">
                                <tr>
                                    <td>${logAuthClientUser.logType}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${logAuthClientUser.status == 'SUCCESS'}">
                                                <spring:message code="logauthclientuser.common.successStatus" />
                                            </c:when>
                                            <c:when test="${logAuthClientUser.status == 'FAILURE'}">
                                                <spring:message code="logauthclientuser.common.failureStatus" />
                                            </c:when>
                                            <c:otherwise>

                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${logAuthClientUser.device}</td>
                                    <td>${logAuthClientUser.productVersion}</td>
                                    <td>${logAuthClientUser.osVersion}</td>
                                    <td>${logAuthClientUser.logMessage}</td>
                                    <td>${logAuthClientUser.userId}</td>
                                    <td>${logAuthClientUser.ipAddress}</td>
                                    <td>${logAuthClientUser.macAddress}</td>
                                    <td>
                                        <fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${logAuthClientUser.logDatetime}" />
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="10"><spring:message code="common.message.emptyData"/></td>
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
    var form = $('#logAuthClientUserForm');

    var urlConfig = {
        'listUrl':'${rootPath}/logauthuser/list.html'
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