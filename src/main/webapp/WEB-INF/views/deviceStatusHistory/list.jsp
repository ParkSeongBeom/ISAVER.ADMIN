<!-- 이벤트 로그 관리, @author dhj -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<c:set value="D00030" var="menuId"/>
<c:set value="D00000" var="subMenuId"/>
<%--<isaver:pageRoleCheck menuId="${menuId}" locale="${pageContext.response.locale}"/>--%>
<script type="text/javascript" src="${rootPath}/assets/js/util/page-navigater.js"></script>

<div class="sub_title_area">
    <h3 class="1depth_title"><spring:message code="common.title.deviceStatusHistory"/></h3>
    <div class="navigation">
        <span><isaver:menu menuId="${menuId}" /></span>
    </div>
</div>

<section class="container sub_area">
    <form id="deviceStatusHistoryForm" method="POST">
        <input type="hidden" name="pageNumber"/>

        <article class="search_area">
            <div class="search_contents">
                <spring:message code="common.selectbox.select" var="allSelectText"/>
                <p class="itype_01">
                    <span><spring:message code='deviceStatusHistory.column.deviceId'/></span>
                    <span>
                        <input type="text" name="deviceId" value="${paramBean.deviceId}"/>
                    </span>
                </p>
                <p class="itype_01">
                    <span><spring:message code='deviceStatusHistory.column.deviceCode'/></span>
                    <span>
                        <isaver:codeSelectBox groupCodeId="DEV" codeId="${paramBean.deviceCode}" htmlTagName="deviceCode" allModel="true" allText="${allSelectText}"/>
                    </span>
                </p>
                <p class="itype_01">
                    <span><spring:message code='deviceStatusHistory.column.areaName'/></span>
                    <span><isaver:areaSelectBox htmlTagName="areaId" allModel="true" areaId="${paramBean.areaId}" allText="${allSelectText}"/></span>
                </p>
                <p class="itype_01">
                    <span><spring:message code="deviceStatusHistory.column.deviceStat" /></span>
                    <span>
                        <select name="deviceStat">
                            <option value=""><spring:message code="common.column.useAll"/></option>
                            <option value="Y" <c:if test="${paramBean.deviceStat == 'Y'}">selected="selected"</c:if>><spring:message code="common.column.useYes"/></option>
                            <option value="N" <c:if test="${paramBean.deviceStat == 'N'}">selected="selected"</c:if>><spring:message code="common.column.useNo"/></option>
                        </select>
                    </span>
                </p>
                <p class="itype_04">
                    <span><spring:message code="deviceStatusHistory.column.logDatetime" /></span>
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
                <p><span><spring:message code="common.message.total"/><em>${paramBean.totalCount}</em><spring:message code="common.message.number01"/></span></p>
                <button class="btn btype01 bstyle03" onclick="javascript:excelFileDownloadFunc(); return false;"><spring:message code="common.button.excelDownload"/> </button>
            </div>
        </div>

        <div class="table_contents">
            <!-- 입력 테이블 Start -->
            <table class="t_defalut t_type01 t_style02">
                <colgroup>
                    <col style="width: 10%;" />
                    <col style="width: *;" />
                    <col style="width: 10%;" />
                    <col style="width: 20%;" />
                    <col style="width: 10%;" />
                    <col style="width: 15%;" />
                    <col style="width: 5%;" >
                </colgroup>
                <thead>
                <tr>
                    <th><spring:message code="deviceStatusHistory.column.deviceId"/></th>
                    <th><spring:message code="deviceStatusHistory.column.deviceName"/></th>
                    <th><spring:message code="deviceStatusHistory.column.deviceCode"/></th>
                    <th><spring:message code="deviceStatusHistory.column.areaName"/></th>
                    <th><spring:message code="deviceStatusHistory.column.deviceStat"/></th>
                    <th><spring:message code="deviceStatusHistory.column.logDatetime"/></th>
                    <th><spring:message code="deviceStatusHistory.column.description"/></th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${deviceStatusHistoryList != null and fn:length(deviceStatusHistoryList) > 0}">
                        <c:forEach var="deviceStatusHistory" items="${deviceStatusHistoryList}">
                            <tr>
                                <td>${deviceStatusHistory.deviceId}</td>
                                <td>${deviceStatusHistory.deviceName}</td>
                                <td>${deviceStatusHistory.deviceCodeName}</td>
                                <td>${deviceStatusHistory.areaName}</td>
                                <td>
                                    <c:if test="${deviceStatusHistory.deviceStat=='Y'}">
                                        <spring:message code="common.column.useYes"/>
                                    </c:if>
                                    <c:if test="${deviceStatusHistory.deviceStat=='N'}">
                                        <spring:message code="common.column.useNo"/>
                                    </c:if>
                                </td>
                                <td><fmt:formatDate value="${deviceStatusHistory.logDatetime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                                <td <c:if test="${deviceStatusHistory.description!=null}">class="eventdetail_btn" onclick="javascript:openCancelDescPopup(this);"</c:if>>
                                    <textarea name="description" style="display:none;">${deviceStatusHistory.description}</textarea>
                                </td>
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

<section class="popup-layer">
    <div class="popupbase admin_popup detail_popup">
        <div>
            <div>
                <header>
                    <h2><spring:message code="deviceStatusHistory.column.description"/></h2>
                    <button onclick="javascript:closeCancelDescPopup();"></button>
                </header>
                <article>
                    <div class="search_area">
                        <div class="editable02" id="description"></div>
                    </div>
                </article>
            </div>
        </div>
        <div class="bg ipop_close" onclick="closeCancelDescPopup();"></div>
    </div>
</section>

<script type="text/javascript">
    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');
    var form = $('#deviceStatusHistoryForm');

    var messageConfig = {
        'earlyDatetime':'<spring:message code="deviceStatusHistory.message.earlyDatetime"/>'
    };

    var urlConfig = {
        'listUrl':'${rootPath}/deviceStatusHistory/list.html'
        ,'excelUrl':'${rootPath}/deviceStatusHistory/excel.html'
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
        calendarHelper.load(form.find('input[name=startDatetimeStr]'));
        calendarHelper.load(form.find('input[name=endDatetimeStr]'));

        setHourDataToSelect($('#startDatetimeHourSelect'),searchConfig['startDatetimeHour'],false);
        setHourDataToSelect($('#endDatetimeHourSelect'),searchConfig['endDatetimeHour'],true);

        drawPageNavigater(pageConfig['pageSize'],pageConfig['pageNumber'],pageConfig['totalCount']);

        $("input:text").keypress(function(e) {
            if(e.which == 13) {
                search();
            }
        });
    });

    function validate(){
        var start = new Date($("input[name='startDatetimeStr']").val() + " " + $("#startDatetimeHourSelect").val() + ":00:00");
        var end = new Date($("input[name='endDatetimeStr']").val() + " " + $("#endDatetimeHourSelect").val() + ":00:00");

        if(start>end){
            alertMessage("earlyDatetime");
            return false;
        }
        return true;
    }

    /*
     조회
     @author kst
     */
    function search(){
        if(validate()){
            form.attr('action',urlConfig['listUrl']);
            form.submit();
        }
    }

    /*
     페이지 네이게이터를 그린다.
     @author kst
     */
    function drawPageNavigater(pageSize,pageNumber,totalCount){
        var pageNavigater = new PageNavigator(pageSize,pageNumber,totalCount);
        pageNavigater.setClass('paging','pll','pl','','on','');
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
     open 비고 popup
     @author psb
     */
    function openCancelDescPopup(_this){
        $("#description").text($(_this).find("[name='description']").text());
        $(".detail_popup").fadeIn();
    }

    /*
     close 비고 popup
     @author psb
     */
    function closeCancelDescPopup(){
        $("#description").text("");
        $(".detail_popup").fadeOut();
    }

    /* Excel File Download*/
    function excelFileDownloadFunc() {
        form.attr('action',urlConfig['excelUrl']);
        form.submit();
    }

    /*
     alert message method
     @author psb
     */
    function alertMessage(type){
        alert(messageConfig[type]);
    }
</script>