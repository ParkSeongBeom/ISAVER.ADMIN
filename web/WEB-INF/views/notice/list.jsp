<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="jabber" uri="/WEB-INF/views/common/tags/jabber.tld"%>
<c:set value="MN000000-C000-0000-0000-000000000000" var="subMenuId"/>
<c:set value="MN000000-C000-0000-0000-000000000001" var="menuId"/>
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
        <h3 class="1depth_title"><spring:message code="common.title.notice"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><jabber:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <form id="noticeForm" method="POST">
        <input type="hidden" name="pageNumber"/>

        <article class="search_area">
            <div class="search_contents">
                <!-- 일반 input 폼 공통 -->
                <p class="itype_01">
                    <span><spring:message code="notice.column.title" /></span>
                    <span>
                        <input type="text" name="title" value="${paramBean.title}"/>
                    </span>
                </p>
                <p class="itype_01">
                    <span><spring:message code="notice.column.header" /></span>
                    <span>
                        <jabber:codeSelectBox groupCodeId="C007" codeId="${paramBean.type}" htmlTagName="type" allModel="true"/>
                    </span>
                </p>
                <p class="itype_04">
                    <span><spring:message code="notice.column.noticeDate" /></span>
                    <span class="plable04">
                        <input type="text" name="startDatetimeStr" value="${paramBean.startDatetimeStr}" />
                        <select id="startDatetimeHourSelect" name="startDatetimeHour"></select>
                        <em>~</em>
                        <input type="text" name="endDatetimeStr" value="${paramBean.endDatetimeStr}" />
                        <select id="endDatetimeHourSelect" name="endDatetimeHour"></select>
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
                    <col style="width:87px" />
                    <col style="width:20px" />
                    <col style="width:*" />
                    <col style="width:200px" />
                    <col style="width:80px" />
                    <col style="width:87px" />
                    <col style="width:70px" />
                </colgroup>
                <thead>
                    <tr>
                        <th><spring:message code="notice.column.header"/></th>
                        <th colspan="2"><spring:message code="notice.column.title"/></th>
                        <th><spring:message code="notice.column.noticeDate"/></th>
                        <th><spring:message code="notice.column.popYn"/></th>
                        <th><spring:message code="common.column.insertUser"/></th>
                        <th><spring:message code="notice.column.hitsCount"/></th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${notices != null and fn:length(notices) > 0}">
                            <c:forEach var="notice" items="${notices}">
                                <tr onclick="moveDetail('${notice.noticeId}')" <c:if test="${notice.pinYn=='Y'}">class="point"</c:if>>
                                    <td>[${notice.headerCode}]</td>
                                    <td <c:if test="${!empty notice.logicalFileName}">class="fplus" onclick="fileDownload('${notice.noticeId}',event);"</c:if>></td>
                                    <td>${notice.title}</td>
                                    <td>
                                        <c:if test="${!empty notice.startDatetime}">
                                            <fmt:formatDate pattern="yy.MM.dd HH" value="${notice.startDatetime}" /><spring:message code="common.column.hour"/> ~
                                        </c:if>
                                        <c:if test="${!empty notice.endDatetime}">
                                            <fmt:formatDate pattern="yy.MM.dd HH" value="${notice.endDatetime}" /><spring:message code="common.column.hour"/>
                                        </c:if>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${notice.popYn == 'Y'}">
                                                <spring:message code="common.column.useYes"/>
                                            </c:when>
                                            <c:otherwise>
                                                <spring:message code="common.column.useNo"/>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${notice.insertUserId}</td>
                                    <td>${notice.hitsCount}</td>
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
    var form = $('#noticeForm');

    var urlConfig = {
        'listUrl':'${rootPath}/notice/list.html'
        ,'detailUrl':'${rootPath}/notice/detail.html'
        ,'downloadUrl':'${rootPath}/notice/download.html'
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
        'confirmStartDatetime':'<spring:message code="notice.message.confirmStartDatetime"/>'
        ,'confirmEndDatetime':'<spring:message code="notice.message.confirmEndDatetime"/>'
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
     조회조건 validate
     @author kst
     */
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
     @author dhj
     */
    function search(){
        if(validateSearch()){
            form.attr('action',urlConfig['listUrl']);
            form.submit();
        }
    }

    /*
     상세화면 이동
     @author dhj
     */
    function moveDetail(id){
        var detailForm = $('<FORM>').attr('action',urlConfig['detailUrl']).attr('method','POST');
        detailForm.append($('<INPUT>').attr('type','hidden').attr('name','noticeId').attr('value',id));
        document.body.appendChild(detailForm.get(0));
        detailForm.submit();
    }

    function alertMessage(type){
        alert(messageConfig[type]);
    }

    function fileDownload(noticeId, event){
        var link = document.createElement("a");
        link.href = urlConfig['downloadUrl'] + "?noticeId=" + noticeId;
        link.click();

        event.stopPropagation();
    }
</script>