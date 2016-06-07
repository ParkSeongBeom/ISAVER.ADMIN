<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>

<form id="accountOrgForm" method="POST">
    <input type="hidden" name="tabId" value="organization"/>

    <article class="search_area">
        <div class="search_contents">
            <!-- 일반 input 폼 공통 -->
            <p class="itype_03">
                <span><spring:message code="account.column.selDatetime" /></span>
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

<div class="table_contents ox_auto">
    <!-- 입력 테이블 Start -->
    <table id="orgAccountTb" class="t_defalut t_type01 t_style02 min_td tl">
        <colgroup>
            <col style="width: *%;" />
            <col style="width: 10%;" />
            <c:forEach var="dateList" items="${dateLists}">
                <col style="width: 12%;" />
            </c:forEach>
        </colgroup>
        <thead>
            <tr>
                <th><spring:message code="account.column.organization"/></th>
                <th><spring:message code="account.column.totalCnt"/></th>
                <c:forEach var="dateList" items="${dateLists}">
                    <th>${dateList}</th>
                </c:forEach>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${accounts != null and fn:length(accounts) > 0}">
                    <c:forEach var="account" items="${accounts}">
                        <tr onclick="moveDetail('${account.orgid}')">
                            <td>${account.path}</td>
                            <td><fmt:formatNumber value="${account.totalcnt}" pattern="#,###.##"/></td>
                            <c:forEach var="dateList" items="${dateLists}" varStatus="status">
                                <c:set var="dateName">date${status.count-1}</c:set>
                                <td><fmt:formatNumber value="${account[dateName]}" pattern="#,###.##"/></td>
                            </c:forEach>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="${fn:length(dateLists)+3}"><spring:message code="common.message.emptyData"/></td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
</div>

<script type="text/javascript">
    var form = $('#accountOrgForm');

    /*
     조회조건 validate
     @author psb
     */
    function validateSearch(){
        var startDatetiemStr = form.find('input[name=startDatetimeStr]').val();
        if(startDatetiemStr.length == 0 || !startDatetiemStr.checkDatePattern('-')){
            alertMessage('confirmStartDatetime');
            return false;
        }

        var endDatetimeStr = form.find('input[name=endDatetimeStr]').val();
        if(startDatetiemStr.length == 0 || !endDatetimeStr.checkDatePattern('-')){
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
        if(validateSearch){
            var searchForm = $('<FORM>').attr('action',urlConfig['listUrl']).attr('method','POST');
            searchForm.append($('<INPUT>').attr('type','hidden').attr('name','tabId').attr('value','organization'));
            searchForm.append($('<INPUT>').attr('type','hidden').attr('name','startDatetimeStr').attr('value',$("input[name='startDatetimeStr']").val()));
            searchForm.append($('<INPUT>').attr('type','hidden').attr('name','endDatetimeStr').attr('value',$("input[name='endDatetimeStr']").val()));
            document.body.appendChild(searchForm.get(0));
            searchForm.submit();
        }
    }

    /*
     상세화면 이동
     @author psb
     */
    function moveDetail(id){
        var detailForm = $('<FORM>').attr('action',urlConfig['listUrl']).attr('method','POST');
        detailForm.append($('<INPUT>').attr('type','hidden').attr('name','tabId').attr('value','user'));
        detailForm.append($('<INPUT>').attr('type','hidden').attr('name','id').attr('value',id));
        detailForm.append($('<INPUT>').attr('type','hidden').attr('name','startDatetimeStr').attr('value',$("input[name='startDatetimeStr']").val()));
        detailForm.append($('<INPUT>').attr('type','hidden').attr('name','endDatetimeStr').attr('value',$("input[name='endDatetimeStr']").val()));
        document.body.appendChild(detailForm.get(0));
        detailForm.submit();
    }

    function summery(){
        var orgAccountTb = $("#orgAccountTb");
        var summeryHtml = "<tr class='summery'><td><spring:message code="account.column.summery"/></td>";

        for(var i=1; i<orgAccountTb.find('thead th').length; i++){
            var cnt = 0;
            $.each(orgAccountTb.find('tbody tr'),function(){
                var _td = $(this).find("td")[i];
                cnt += eval(numberWithoutCommas($(_td).text()));
            });
            summeryHtml += "<td>"+numberWithCommas(cnt)+"</td>";
        }

        summeryHtml += "</tr>";

        orgAccountTb.find('tbody tr:last').after(summeryHtml);
    }

    function initialize(){
        calendarHelper.load(form.find('input[name=startDatetimeStr]'));
        calendarHelper.load(form.find('input[name=endDatetimeStr]'));

        summery();

        $.each($("table.t_type01 > tbody > tr > td"),function(){
            $(this).attr("title",$(this).text().trim());
        });
    }

    initialize();
</script>