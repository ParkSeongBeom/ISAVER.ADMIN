<!-- 라이센스 목록, @author dhj -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<c:set value="D00030" var="menuId"/>
<c:set value="D00000" var="subMenuId"/>

<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.deviceList"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><isaver:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <div class="popupbase admin_popup device_detail_popup">
        <div>
            <div>
                <header>
                    <h2><spring:message code="common.title.deviceDetail"/></h2>
                    <button onclick="javascript:closePopup();"></button>
                </header>
                <article>
                    <div class="table_area">
                        <div class="table_contents">
                            <!-- 입력 테이블 Start -->
                            <table class="t_defalut t_type02 devicetblist_col">
                                <colgroup>
                                    <col>  <!-- 01 -->
                                    <col>  <!-- 02 -->
                                    <col>  <!-- 03 -->
                                    <col>  <!-- 04 -->
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th><spring:message code='device.column.deviceId'/></th>
                                    <td>
                                        <input type="text" id="deviceId" disabled="disabled"/>
                                    </td>
                                    <th><spring:message code='device.column.serialNo'/></th>
                                    <td>
                                        <input type="text" id="serialNo" disabled="disabled"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th><spring:message code='device.column.deviceType'/></th>
                                    <td>
                                        <isaver:codeSelectBox groupCodeId="D00" htmlTagId="deviceTypeCode" disabled="true"/>
                                    </td>
                                    <th><spring:message code='device.column.deviceCode'/></th>
                                    <td>
                                        <isaver:codeSelectBox groupCodeId="CA1" htmlTagId="vendorCode" disabled="true"/>
                                        <isaver:codeSelectBox groupCodeId="DEV" htmlTagId="deviceCode" disabled="true"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th><spring:message code='device.column.parentdeviceName'/></th>
                                    <td colspan="3">
                                        <select id="parentDeviceId" disabled>
                                            <option value=""><spring:message code="device.message.emptyData"/></option>
                                            <c:forEach items="${devices}" var="devices"  varStatus="status">
                                                <c:if test="${devices.delYn == 'N' }">
                                                    <option value="${devices.deviceId}">${devices.path}</option>
                                                </c:if>
                                            </c:forEach>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <th><spring:message code='area.column.areaName'/></th>
                                    <td colspan="3">
                                        <select id="areaId" disabled>
                                            <option value=""><spring:message code="device.message.emptyData"/></option>
                                            <c:forEach items="${areas}" var="areas">
                                                <c:if test="${areas.delYn == 'N'}">
                                                    <option value="${areas.areaId}">${areas.path}</option>
                                                </c:if>
                                            </c:forEach>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <th><spring:message code='device.column.ipAddress'/></th>
                                    <td colspan="3">
                                        <input type="text" name="ipAddress" maxlength="20" disabled="disabled"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th><spring:message code='area.column.linkUrl'/></th>
                                    <td colspan="3">
                                        <input type="text" id="linkUrl" disabled="disabled"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th><spring:message code='device.column.deviceDesc'/></th>
                                    <td colspan="3">
                                        <textarea id="deviceDesc" class="textboard" disabled="disabled"></textarea>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                            <!-- 입력 테이블 End -->
                        </div>
                    </div>
                    <div class="table_area">
                    </div>
                </article>
            </div>
        </div>
        <div class="bg ipop_close" onclick="closePopup();"></div>
    </div>

    <form id="deviceForm" method="POST">
        <article class="search_area">
            <div class="search_contents">
                <spring:message code="common.selectbox.select" var="allSelectText"/>
                <p class="itype_01">
                    <span><spring:message code='device.column.deviceId'/></span>
                    <span>
                        <input type="text" name="deviceId" value="${paramBean.deviceId}"/>
                    </span>
                </p>
                <p class="itype_01">
                    <span><spring:message code='device.column.deviceType'/></span>
                    <span>
                        <isaver:codeSelectBox groupCodeId="D00" codeId="${paramBean.deviceTypeCode}" htmlTagName="deviceTypeCode" allModel="true" allText="${allSelectText}"/>
                    </span>
                </p>
                <p class="itype_01">
                    <span><spring:message code='device.column.deviceCode'/></span>
                    <span>
                        <isaver:codeSelectBox groupCodeId="DEV" codeId="${paramBean.deviceCode}" htmlTagName="deviceCode" allModel="true" allText="${allSelectText}"/>
                    </span>
                </p>
                <p class="itype_01">
                    <span><spring:message code='device.column.areaName'/></span>
                    <span>
                        <select name="areaId">
                            <option value=""><spring:message code='common.column.useAll'/></option>
                            <c:forEach items="${areas}" var="areas">
                                <c:if test="${areas.delYn == 'N'}">
                                    <option value="${areas.areaId}" <c:if test="${paramBean.areaId == areas.areaId}">selected="selected"</c:if>>${areas.path}</option>
                                </c:if>
                            </c:forEach>
                        </select>
                    </span>
                </p>
                <p class="itype_01">
                    <span><spring:message code="device.column.deviceStat" /></span>
                    <span>
                        <select name="deviceStat">
                            <option value=""><spring:message code="common.column.useAll"/></option>
                            <option value="Y" <c:if test="${paramBean.deviceStat == 'Y'}">selected="selected"</c:if>><spring:message code="common.column.useYes"/></option>
                            <option value="N" <c:if test="${paramBean.deviceStat == 'N'}">selected="selected"</c:if>><spring:message code="common.column.useNo"/></option>
                        </select>
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
                <%--<p><span>총<em>${paramBean.totalCount}</em>건</span></p>--%>
                <%--<button class="btn btype01 bstyle03" onclick="javascript:moveDetail(); return false;"><spring:message code="common.button.add"/></button>--%>
            </div>
        </div>

        <div class="table_contents">
            <!-- 입력 테이블 Start -->
            <table class="t_defalut t_type01 t_style02">
                <colgroup>
                    <col style="width: 10%;" />
                    <col style="width: 10%;" />
                    <col style="width: 10%;" />
                    <col style="width: *;" />
                    <col style="width: 20%;" />
                    <col style="width: 10%;" />
                    <col style="width: 15%;" />
                </colgroup>
                <thead>
                <tr>
                    <th><spring:message code="device.column.deviceId"/></th>
                    <th><spring:message code="device.column.deviceType"/></th>
                    <th><spring:message code="device.column.vendorCode"/></th>
                    <th><spring:message code="device.column.deviceCode"/></th>
                    <th><spring:message code="device.column.areaName"/></th>
                    <th><spring:message code="device.column.deviceStat"/></th>
                    <th><spring:message code="common.column.insertDatetime"/></th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${devices != null and fn:length(devices) > 0}">
                        <c:forEach var="device" items="${devices}">
                            <tr onclick="moveDetail(String('${device.deviceId}'));">
                                <td>${device.deviceId}</td>
                                <td>${device.deviceTypeCode}</td>
                                <td>
                                    <c:if test="${device.vendorCodeName==null}">
                                        <spring:message code="device.message.emptyData"/>
                                    </c:if>
                                    <c:if test="${device.vendorCodeName!=null}">
                                        ${device.vendorCodeName}
                                    </c:if>
                                </td>
                                <td>${device.deviceCode}</td>
                                <td>${device.areaName}</td>
                                <td>
                                    <c:if test="${device.deviceStat=='Y'}">
                                        <spring:message code="common.column.useYes"/>
                                    </c:if>
                                    <c:if test="${device.deviceStat=='N'}">
                                        <spring:message code="common.column.useNo"/>
                                    </c:if>
                                </td>
                                <td>
                                    <fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${device.insertDatetime}" />
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="7"><spring:message code="common.message.emptyData"/></td>
                        </tr>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
    </article>
</section>

<script type="text/javascript">
    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');
    var form = $('#deviceForm');

    var urlConfig = {
        'listUrl':'${rootPath}/device/tbList.html'
        ,'detailUrl':'${rootPath}/device/detail.json'
    };

    var layoutMessageConfig = {
        detailFailure    :'<spring:message code="device.message.detailFailure"/>'
    };

    $(document).ready(function(){
        $("input:text").keypress(function(e) {
            if(e.which == 13) {
                search();
            }
        });
    });

    /*
     조회
     @author psb
     */
    function search(){
        form.attr('action',urlConfig['listUrl']);
        form.submit();
    }

    function moveDetail(deviceId){
        ajaxCall('detail', {'deviceId' : deviceId});
    }

    function detailRender(data){
        $("#deviceId").val(data['deviceId']);
        $("#serialNo").val(data['serialNo']);
        $("#deviceTypeCode").val(data['deviceTypeCode']);
        $("#deviceCode").val(data['deviceCode']);
        $("#parentDeviceId").val(data['parentDeviceId']);
        $("#areaId").val(data['areaId']);
        $("#ipAddress").val(data['ipAddress']);
        $("#linkUrl").val(data['linkUrl']);
        $("#deviceDesc").text(data['deviceDesc']);

        openPopup();
    }

    /**
     * ajax call
     * @author psb
     */
    function ajaxCall(actionType, data){
        sendAjaxPostRequest(urlConfig[actionType+'Url'],data,successHandler,failureHandler,actionType);
    }

    /**
     * layout success handler
     * @author psb
     * @private
     */
    function successHandler(data, dataType, actionType){
        switch(actionType){
            case 'detail':
                detailRender(data.device);
                break;
        }
    }

    function failureHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        alert(actionType + 'Failure');
    }

    function openPopup(){
        $(".device_detail_popup").fadeIn();
    }

    function closePopup(){
        $(".device_detail_popup").fadeOut();
    }
</script>