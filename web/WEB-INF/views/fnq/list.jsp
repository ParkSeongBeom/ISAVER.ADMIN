<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="jabber" uri="/WEB-INF/views/common/tags/jabber.tld"%>
<c:set value="MN000000-C000-0000-0000-000000000000" var="subMenuId"/>
<c:set value="MN000000-C000-0000-0000-000000000005" var="menuId"/>
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
        <h3 class="1depth_title"><spring:message code="common.title.fnq"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><jabber:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <form id="fnqForm" method="POST">
        <input type="hidden" name="pageNumber"/>

        <article class="search_area">
            <div class="search_contents">
                <!-- 일반 input 폼 공통 -->
                <p class="itype_01">
                    <span><spring:message code="fnq.column.title" /></span>
                    <span>
                        <input type="text" name="title" value="${paramBean.title}"/>
                    </span>
                </p>
                <p class="itype_01">
                    <span><spring:message code="fnq.column.header" /></span>
                    <span>
                        <jabber:codeSelectBox groupCodeId="F001" codeId="${paramBean.type}" htmlTagName="type" allModel="true"/>
                    </span>
                </p>
                <p class="itype_01">
                    <span><spring:message code="fnq.column.device" /></span>
                    <span>
                        <jabber:codeSelectBox groupCodeId="C005" codeId="${paramBean.device}" htmlTagName="device" allModel="true"/>
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
                    <col style="width: 80px;" />
                    <col style="width: 10%;" />
                    <col style="width: 20px;" />
                    <col style="width: *%;" />
                    <col style="width: 10%;" />
                    <col style="width: 18%;" />
                </colgroup>
                <thead>
                    <tr>
                        <th><spring:message code="fnq.column.header"/></th>
                        <th><spring:message code="fnq.column.device"/></th>
                        <th colspan="2"><spring:message code="fnq.column.title"/></th>
                        <th><spring:message code="common.column.insertUser"/></th>
                        <th><spring:message code="common.column.insertDatetime"/></th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${fnqs != null and fn:length(fnqs) > 0}">
                            <c:forEach var="fnq" items="${fnqs}">
                                <tr onclick="moveDetail('${fnq.fnqId}')">
                                    <td>[${fnq.headerCode}]</td>
                                    <td>${fnq.device}</td>
                                    <td <c:if test="${!empty fnq.logicalFileName}">class="fplus" onclick="fileDownload('${fnq.fnqId}',event);"</c:if>></td>
                                    <td>${fnq.title}</td>
                                    <td>${fnq.insertUserId}</td>
                                    <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${fnq.insertDatetime}" /></td>
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
    var form = $('#fnqForm');

    var urlConfig = {
        'listUrl':'${rootPath}/fnq/list.html'
        ,'detailUrl':'${rootPath}/fnq/detail.html'
        ,'downloadUrl':'${rootPath}/fnq/download.html'
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

    $(document).ready(function(){
        drawPageNavigater(pageConfig['pageSize'],pageConfig['pageNumber'],pageConfig['totalCount']);
    });

    /*
     페이지 네이게이터를 그린다.
     @author dhj
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
     @author dhj
     */
    function goPage(pageNumber){
        form.find('input[name=pageNumber]').val(pageNumber);
        search();
    }

    /*
     조회
     @author dhj
     */
    function search(){
        form.attr('action',urlConfig['listUrl']);
        form.submit();
    }

    /*
     상세화면 이동
     @author dhj
     */
    function moveDetail(id){
        var detailForm = $('<FORM>').attr('action',urlConfig['detailUrl']).attr('method','POST');
        detailForm.append($('<INPUT>').attr('type','hidden').attr('name','fnqId').attr('value',id));
        document.body.appendChild(detailForm.get(0));
        detailForm.submit();
    }

    function fileDownload(fnqId, event){
        var link = document.createElement("a");
        link.href = urlConfig['downloadUrl'] + "?fnqId=" + fnqId;
        link.click();

        event.stopPropagation();
    }
</script>