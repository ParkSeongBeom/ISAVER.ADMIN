<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="jabber" uri="/WEB-INF/views/common/tags/jabber.tld"%>
<link rel="stylesheet" href="${rootPath}/assets/css/jqueryui/jquery-ui-1.10.4.min.css">
<script type="text/javascript" src="${rootPath}/assets/js/common/jquery-ui-1.10.4.min.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/page-navigater.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/elements-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/data-util.js"></script>

<form id="listViewForm" method="POST">
    <input type="hidden" name="pageNumber"/>

    <article class="search_area search_tline">
        <div class="search_contents">
            <!-- 일반 input 폼 공통 -->
            <p class="itype_01">
                <span><spring:message code="calendar.column.type" /></span>
                <span>
                    <select name="type" onchange="javascript:changeType();">
                        <option value="" <c:if test="${empty paramBean.type || type==''}">selected</c:if>>전체</option>
                        <option value="mon" <c:if test="${paramBean.type=='mon'}">selected</c:if>>일정</option>
                        <option value="rev" <c:if test="${paramBean.type=='rev'}">selected</c:if>>회의실예약</option>
                    </select>
                </span>
            </p>
            <p class="itype_01 typeDetail" id="monSelType">
                <span><spring:message code="calendar.column.monType" /></span>
                <span>
                    <jabber:codeSelectBox groupCodeId="CAL001" codeId="${paramBean.typeCode}" htmlTagName="monType" allModel="true"/>
                </span>
            </p>
            <p class="itype_01 typeDetail" id="revSelType">
                <span><spring:message code="calendar.column.reservation" /></span>
                <span>
                    <select name="revType">
                        <option value=""><spring:message code="common.button.select" /></option>
                        <c:choose>
                            <c:when test="${assetses != null and fn:length(assetses) > 0}">
                                <c:forEach var="assets" items="${assetses}">
                                    <option value="${assets.assetsId}" <c:if test="${assets.assetsId == paramBean.typeCode}">selected</c:if>>${assets.assetsName}</option>
                                </c:forEach>
                            </c:when>
                        </c:choose>
                    </select>
                </span>
            </p>
            <p class="itype_01">
                <span><spring:message code="calendar.column.title" /></span>
                <span>
                    <input type="text" name="title" value="${paramBean.title}"/>
                </span>
            </p>
            <p class="itype_01">
                <span><spring:message code="calendar.column.insertUserName" /></span>
                <span>
                    <input type="text" name="insertUserName" value="${paramBean.insertUserName}"/>
                </span>
            </p>
            <p class="itype_03">
                <span><spring:message code="calendar.column.date" /></span>
                <span>
                    <input type="text" name="startDatetimeStr" value="${paramBean.startDatetimeStr}" />
                    <em>~</em>
                    <input type="text" name="endDatetimeStr" value="${paramBean.endDatetimeStr}" />
                </span>
            </p>
        </div>
        <div class="search_btn">
            <button onclick="javascript:search(); return false;" class="btn bstyle01 btype01"><spring:message code="common.button.search"/></button>
        </div>
    </article>
</form>

<div class="table_title_area">
    <h4></h4>
    <div class="table_btn_set">
        <button class="btn btype01 bstyle03" onclick="javascript:detail('mon',null); return false;"><spring:message code="calendar.button.add"/> </button>
    </div>
</div>

<div class="table_contents">
    <!-- 입력 테이블 Start -->
    <table class="t_defalut t_type01 t_style02">
        <colgroup>
            <col style="width:120px">  <!-- 01 -->
            <col style="width:*">  <!-- 02 -->
            <col style="width:20%">  <!-- 03 -->
            <col style="width:15%">  <!-- 04 -->
            <col style="width:15%">    <!-- 05 -->
        </colgroup>
        <thead>
            <tr>
                <th><spring:message code="calendar.column.type"/></th>
                <th><spring:message code="calendar.column.title"/></th>
                <th><spring:message code="calendar.column.date"/></th>
                <th><spring:message code="calendar.column.insertUserName"/></th>
                <th><spring:message code="common.column.insertDatetime"/></th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${calendars != null and fn:length(calendars) > 0}">
                    <c:forEach var="calendar" items="${calendars}">
                        <tr onclick="detail('${calendar.type}', '${calendar.id}')">
                            <td><span class="mon_ico fa ico_${calendar.type}"></span>${calendar.typeName}</td>
                            <td>${calendar.title}</td>
                            <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm" value="${calendar.dateTime}" /></td>
                            <td>${calendar.insertUserName}</td>
                            <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${calendar.insertDatetime}" /></td>
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

<script type="text/javascript">
    var form = $('#listViewForm');

    var pageConfig = {
        pageSize     : Number(<c:out value="${paramBean.pageRowNumber}" />)
        ,pageNumber  : Number(<c:out value="${paramBean.pageNumber}" />)
        ,totalCount  : Number(<c:out value="${paramBean.totalCount}" />)
    };

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
     조회조건 validate
     @author psb
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

        var sDate = new Date(startDatetiemStr);
        var eDate = new Date(endDatetimeStr);

        if (sDate > eDate) {
            alert('시작일이 종료일보다 클 수 없습니다.');
            return false;
        }

        return true;
    }

    /*
     조회
     @author psb
     */
    function search(){
        if(validateSearch()){
            var searchForm = $('<FORM>').attr('action',urlConfig['listUrl']).attr('method','POST');
            searchForm.append($('<INPUT>').attr('type','hidden').attr('name','tabId').attr('value','listView'));
            searchForm.append($('<INPUT>').attr('type','hidden').attr('name','title').attr('value',$("input[name='title']").val()));
            searchForm.append($('<INPUT>').attr('type','hidden').attr('name','pageNumber').attr('value',$("input[name='pageNumber']").val()));

            var _type = $("select[name='type'] option:selected").val();
            searchForm.append($('<INPUT>').attr('type','hidden').attr('name','type').attr('value',_type));
            searchForm.append($('<INPUT>').attr('type','hidden').attr('name','typeCode').attr('value',$("select[name='"+_type+"Type'] option:selected").val()));

            searchForm.append($('<INPUT>').attr('type','hidden').attr('name','startDatetimeStr').attr('value',$("input[name='startDatetimeStr']").val()));
            searchForm.append($('<INPUT>').attr('type','hidden').attr('name','endDatetimeStr').attr('value',$("input[name='endDatetimeStr']").val()));
            searchForm.append($('<INPUT>').attr('type','hidden').attr('name','insertUserName').attr('value',$("input[name='insertUserName']").val()));
            document.body.appendChild(searchForm.get(0));
            searchForm.submit()
        }
    }

    function changeType(){
        var _sel = $("select[name='type'] option:selected").val();

        $(".typeDetail").hide();
        $("#"+_sel+"SelType").show();
    }

    function initialize(){
        drawPageNavigater(pageConfig['pageSize'],pageConfig['pageNumber'],pageConfig['totalCount']);

        calendarHelper.load(form.find('input[name=startDatetimeStr]'));
        calendarHelper.load(form.find('input[name=endDatetimeStr]'));

        $("input:text").keypress(function(e) {
            if(e.which == 13) {
                search();
            }
        });

        changeType();
    }

    initialize();
</script>