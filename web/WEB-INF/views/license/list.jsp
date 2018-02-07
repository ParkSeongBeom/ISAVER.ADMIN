<!-- 라이센스 목록, @author dhj -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<c:set value="E00000" var="menuId"/>
<c:set value="E00000" var="subMenuId"/>
<!-- viewOnly 일경우 라이센스 보기, @author psb -->
<c:if test="${viewOnly == true}">
    <c:set value="K00000" var="menuId"/>
    <c:set value="K00000" var="subMenuId"/>
</c:if>
<%--<isaver:pageRoleCheck menuId="${menuId}" />--%>
<script type="text/javascript" src="${rootPath}/assets/js/util/page-navigater.js"></script>

<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title">
            <c:if test="${viewOnly == false}">
                <spring:message code="common.title.license"/>
            </c:if>
            <c:if test="${viewOnly == true}">
                <spring:message code="common.title.licenseView"/>
            </c:if>
        </h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><isaver:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <form id="licenseForm" method="POST">
        <input type="hidden" name="pageNumber">

        <article class="search_area">
            <div class="search_contents">
                <p class="itype_01">
                    <span>License Key</span>
                    <span>
                        <input type="text" name="licenseKey" value="${paramBean.licenseKey}"/>
                    </span>
                </p>
                <p class="itype_01">
                    <span><spring:message code="license.column.deviceType" /></span>
                    <isaver:codeSelectBox groupCodeId="DEV" codeId="${paramBean.deviceCode}" htmlTagId="selectDeviceCode" htmlTagName="deviceCode" allModel="true"/>
                </p>
                <p class="itype_04">
                    <span><spring:message code="license.column.expireDate"/></span>
                    <span class="plable04">
                        <input type="text" name="expireStartDate" value="${paramBean.expireStartDate}">
                        <em>~</em>
                        <input type="text" name="expireEndDate" value="${paramBean.expireEndDate}">

                    </span>
                </p>
            </div>
            <div class="search_btn">
                <button class="btn bstyle01 btype01" onclick="javascript:search(); return false;"><spring:message code="common.button.search"/></button>
            </div>
        </article>
    </form>

    <article class="table_area">
        <div class="table_title_area">
            <h4></h4>
            <div class="table_btn_set">
                <p><span><spring:message code="common.message.total"/><em>${paramBean.totalCount}</em><spring:message code="common.message.number01"/></span></p>
                <c:if test="${viewOnly == false}">
                    <button class="btn btype01 bstyle03" onclick="javascript:moveDetail(); return false;"><spring:message code="common.button.add"/></button>
                </c:if>
            </div>
        </div>

        <div class="table_contents">
            <!-- 입력 테이블 Start -->
            <table class="t_defalut t_type01 t_style02">
                <colgroup>
                    <col style="width: 10%;" />
                    <col style="width: 20%;" />
                    <col style="width: 15%;" />
                    <col style="width: 10%;" />
                    <col style="width: 15%;" />
                </colgroup>
                <thead>
                <tr>
                    <th><spring:message code="license.column.deviceType"/></th>
                    <th><spring:message code="license.column.licenseKey"/></th>
                    <th><spring:message code="license.column.licenseCount"/></th>
                    <th><spring:message code="license.column.expireDate"/></th>
                    <th><spring:message code="common.column.insertDatetime"/></th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${licenses != null and fn:length(licenses) > 0}">
                        <c:forEach var="license" items="${licenses}">
                            <c:set var="licenseKey1" value="${fn:substring(license.licenseKey, 0, 5)}" />
                            <c:set var="licenseKey2" value="${fn:substring(license.licenseKey, 5,10)}" />
                            <c:set var="licenseKey3" value="${fn:substring(license.licenseKey, 10, 15)}" />
                            <c:set var="licenseKey4" value="${fn:substring(license.licenseKey, 15, 20)}" />
                            <c:set var="licenseKey5" value="${fn:substring(license.licenseKey, 20, 25)}" />
                            <c:set var="expireDate_yyyy" value="${fn:substring(license.expireDate, 0, 4)}" />
                            <c:set var="expireDate_MM" value="${fn:substring(license.expireDate, 4, 6)}" />
                            <c:set var="expireDate_dd" value="${fn:substring(license.expireDate, 6, 8)}" />
                            <tr <c:if test="${viewOnly == false}"> onclick="moveDetail(String('${license.licenseKey}'));"</c:if>>
                                <td>${license.deviceCode}</td>
                                <td>${licenseKey1}-${licenseKey2}-${licenseKey3}-${licenseKey4}-${licenseKey5}</td>
                                <td>${license.licenseCount}</td>
                                <td>${expireDate_yyyy}-${expireDate_MM}-${expireDate_dd}</td>
                                <td>
                                    <fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${license.insertDatetime}" />
                                </td>
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
    var form = $('#licenseForm');

    var urlConfig = {
        'listUrl':'${rootPath}/license/list.html'
        ,'detailUrl':'${rootPath}/license/detail.html'
    };

    var pageConfig = {
        pageSize     : Number(<c:out value="${paramBean.pageRowNumber}" />)
        ,pageNumber  : Number(<c:out value="${paramBean.pageNumber}" />)
        ,totalCount  : Number(<c:out value="${paramBean.totalCount}" />)
    };

    $(document).ready(function(){

        calendarHelper.load(form.find('input[name=expireStartDate]'));
        calendarHelper.load(form.find('input[name=expireEndDate]'));

        drawPageNavigater(pageConfig['pageSize'],pageConfig['pageNumber'],pageConfig['totalCount']);

        $("input:text").keypress(function(e) {
            if(e.which == 13) {
                search();
            }
        });
    });

    /*
     조회
     @author kst
     */
    function search(){
        form.attr('action',urlConfig['listUrl']);
        form.submit();
    }

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
     상세화면 이동
     @author kst
     */
    function moveDetail(id){
        var detailForm = $('<FORM>').attr('action',urlConfig['detailUrl']).attr('method','POST');
        detailForm.append($('<INPUT>').attr('type','hidden').attr('name','licenseKey').attr('value',id));
        document.body.appendChild(detailForm.get(0));
        detailForm.submit();
    }
</script>