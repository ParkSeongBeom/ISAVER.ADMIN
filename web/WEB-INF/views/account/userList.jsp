<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="jabber" uri="/WEB-INF/views/common/tags/jabber.tld"%>
<script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>

<form id="accountUserForm" method="POST">
    <input type="hidden" name="tabId" value="user"/>

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
            <p class="itype_01">
                <span ><spring:message code="account.column.organization" /></span>
                <span>
                    <select name="id">
                        <option value="">전체</option>
                        <c:forEach items="${organizationList}" var="org">
                            <option value="${org.orgId}" <c:if test="${org.orgId==paramBean.id}">selected</c:if>>${org.path}</option>
                        </c:forEach>
                    </select>
                </span>
            </p>
            <p class="itype_01">
                <span><spring:message code="account.column.gubn" /></span>
                <span>
                    <jabber:codeSelectBox groupCodeId="C005" codeId="${paramBean.type}" htmlTagName="type" allModel="true"/>
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
    <table id="userAccountTb" class="t_defalut t_type01 t_style02 min_td tl">
        <colgroup>
            <col style="width: *%;" />
            <col style="width: 10%;" />
            <c:forEach var="dateList" items="${dateLists}">
                <col style="width: 10%;" />
            </c:forEach>
            <col style="width: 15%;" />
        </colgroup>
        <thead>
            <tr>
                <th><spring:message code="account.column.organization"/></th>
                <th><spring:message code="account.column.userName"/></th>
                <c:forEach var="dateList" items="${dateLists}">
                    <th>${dateList}</th>
                </c:forEach>
                <th><spring:message code="account.column.lastLoginDate"/></th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${accounts != null and fn:length(accounts) > 0}">
                    <c:forEach var="account" items="${accounts}">
                        <tr>
                            <td>${account.orgname}</td>
                            <td>${account.username}</td>
                            <c:forEach var="dateList" items="${dateLists}" varStatus="status">
                                <c:set var="dateName">date${status.count-1}</c:set>
                                <td>${account[dateName]}</td>
                            </c:forEach>
                            <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${account.lastlogindate}" /></td>
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
    var form = $('#accountUserForm');

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
        if(validateSearch()){
            var searchForm = $('<FORM>').attr('action',urlConfig['listUrl']).attr('method','POST');
            searchForm.append($('<INPUT>').attr('type','hidden').attr('name','tabId').attr('value','user'));
            searchForm.append($('<INPUT>').attr('type','hidden').attr('name','id').attr('value',$("select[name='id'] option:selected").val()));
            searchForm.append($('<INPUT>').attr('type','hidden').attr('name','startDatetimeStr').attr('value',$("input[name='startDatetimeStr']").val()));
            searchForm.append($('<INPUT>').attr('type','hidden').attr('name','endDatetimeStr').attr('value',$("input[name='endDatetimeStr']").val()));
            searchForm.append($('<INPUT>').attr('type','hidden').attr('name','type').attr('value',$("select[name='type'] option:selected").val()));
            document.body.appendChild(searchForm.get(0));
            searchForm.submit();
        }
    }

    function summery(){
        var userAccountTb = $("#userAccountTb");
        var summeryHtml = "<tr class='summery'>" +
                "<td><spring:message code="account.column.summery"/></td>" +
                "<td>"+ userAccountTb.find('tbody tr').length +"</td>";

        for(var i=2; i < userAccountTb.find('thead th').length-1; i++){
            var cnt = 0;
            $.each(userAccountTb.find('tbody tr'),function(){
                var _td = $(this).find("td")[i];
                if($(_td).text()=='O'){ cnt++; }
            });
            summeryHtml += "<td>"+numberWithCommas(cnt)+"</td>";
        }

        summeryHtml += "<td></td></tr>";

        userAccountTb.find('tbody tr:last').after(summeryHtml);
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