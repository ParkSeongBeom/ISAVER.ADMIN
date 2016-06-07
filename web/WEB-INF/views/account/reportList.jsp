<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>

<article class="table_area left_table">
    <div class="table_title_area">
        <h4><spring:message code="account.column.useReport"/></h4>
        <div class="table_btn_set">
        </div>
    </div>

    <div class="table_contents">
        <!-- 입력 테이블 Start -->
        <table class="t_defalut t_type02 t_style03">
            <colgroup>
                <col style="width:142px">  <!-- 01 -->
                <col style="width:*">      <!-- 02 -->
            </colgroup>
            <tbody>
                <tr>
                    <th><spring:message code="account.column.license"/></th>
                    <td>
                        <c:choose>
                            <c:when test="${license>0}">
                                <fmt:formatNumber value="${license}" pattern="#,###.##"/><spring:message code="common.column.cnt"/>
                            </c:when>
                            <c:otherwise>
                                <spring:message code="account.column.limit"/>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
                <tr>
                    <th><spring:message code="account.column.useCount"/></th>
                    <td>
                        <fmt:formatNumber value="${useAccount}" pattern="#,###.##"/><spring:message code="common.column.cnt"/>
                    </td>
                </tr>
                <tr>
                    <th><spring:message code="account.column.summeryCount"/></th>
                    <td>
                        <fmt:formatNumber value="${summeryAccount}" pattern="#,###.##"/><spring:message code="common.column.cnt"/>
                    </td>
                </tr>
            </tbody>
        </table>
        <!-- 입력 테이블 End -->
    </div>
</article>

<article class="table_area right_table">
    <div class="table_title_area">
        <h4><spring:message code="account.column.joinReport"/></h4>
        <div class="table_btn_set">
            <select name="reportDt" onchange="search()">
                <jsp:useBean id="now" class="java.util.Date" scope="request" />
                <fmt:formatDate value="${now}" pattern="yyyy" var="thisYear"/>
                <c:forEach var="selYear" begin="${paramBean.reportDt-10}" end="${thisYear}">
                    <option value="${selYear}" <c:if test="${selYear==paramBean.reportDt}">selected</c:if>><c:out value="${selYear}" /></option>
                </c:forEach>
            </select>
        </div>
    </div>
    <div class="table_contents">
        <!-- 입력 테이블 Start -->
        <table class="t_defalut t_type02 t_style03">
            <colgroup>
                <col style="width:142px">  <!-- 01 -->
                <col style="width:*">      <!-- 02 -->
            </colgroup>
            <tbody>
                <c:choose>
                    <c:when test="${reports != null and fn:length(reports) > 0}">
                        <c:forEach var="report" items="${reports}">
                            <tr>
                                <th>${report.reportDt}</th>
                                <td><fmt:formatNumber value="${report.totalCnt}" pattern="#,###.##"/></td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="2"><spring:message code="common.message.emptyData"/></td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
        <!-- 입력 테이블 End -->
    </div>
</article>

<script type="text/javascript">
    /*
     조회
     @author psb
     */
    function search(){
        var searchForm = $('<FORM>').attr('action',urlConfig['listUrl']).attr('method','POST');
        searchForm.append($('<INPUT>').attr('type','hidden').attr('name','tabId').attr('value','report'));
        searchForm.append($('<INPUT>').attr('type','hidden').attr('name','reportDt').attr('value',$("select[name='reportDt'] option:selected").val()));
        document.body.appendChild(searchForm.get(0));
        searchForm.submit();
    }

    function initialize(){
        $.each($("table.t_type01 > tbody > tr > td"),function(){
            $(this).attr("title",$(this).text().trim());
        });
    }

    initialize();
</script>