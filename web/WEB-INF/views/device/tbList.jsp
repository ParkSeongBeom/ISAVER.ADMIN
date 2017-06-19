<!-- 라이센스 목록, @author dhj -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<c:set value="D00030" var="menuId"/>
<c:set value="D00000" var="subMenuId"/>
<script type="text/javascript" src="${rootPath}/assets/js/util/data-util.js"></script>

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

    <aside class="admin_popup device_detail_popup">
        <section class="layer_wrap i_type04">
            <article class="layer_area">
                <div class="layer_header">
                    <spring:message code="common.title.deviceDetail"/>
                    <button class="ipop_x" onclick="closePopup();"></button>
                </div>
                <div class="layer_contents">
                    <article class="search_area">
                        <div class="table_contents">
                            <!-- 입력 테이블 Start -->
                            <table class="t_defalut t_type02 t_style03">
                                <colgroup>
                                    <col style="width:16%">  <!-- 01 -->
                                    <col style="width:34%">  <!-- 02 -->
                                    <col style="width:16%">  <!-- 03 -->
                                    <col style="width:*">    <!-- 04 -->
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
                                    <th><spring:message code='area.column.linkUrl'/></th>
                                    <td colspan="3">
                                        <input type="text" id="linkUrl" disabled="disabled"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th><spring:message code='device.column.eventName'/></th>
                                    <td>
                                        <select id="eventId" disabled>
                                            <option value=""><spring:message code="device.message.emptyData"/></option>
                                            <c:forEach items="${events}" var="event">
                                                <option value="${event.eventId}">[${event.eventId}]${event.eventName}</option>
                                            </c:forEach>
                                        </select>
                                    </td>
                                    <th><spring:message code='device.column.fileName'/></th>
                                    <td>
                                        <input type="text" id="fileName" disabled="disabled"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th><spring:message code='device.column.cameraManufacturer'/></th>
                                    <td colspan="3">
                                        <isaver:codeSelectBox groupCodeId="CA1" htmlTagId="cameraManufacturer" allModel="true" allText="없음" disabled="true"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th><spring:message code='device.column.hostType'/></th>
                                    <td>
                                        <isaver:codeSelectBox groupCodeId="H01" htmlTagId="hostType" disabled="true"/>
                                    </td>
                                    <td colspan="3">
                                        <input type="text" id="ipAddress" disabled="disabled"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th><spring:message code='device.column.webPort'/></th>
                                    <td>
                                        <input type="text" id="webPort" disabled="disabled"/>
                                    </td>
                                    <th><spring:message code='device.column.rtspPort'/></th>
                                    <td>
                                        <input type="text" id="rtspPort" disabled="disabled"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th><spring:message code='device.column.deviceUserId'/></th>
                                    <td>
                                        <input type="text" id="deviceUserId" disabled="disabled"/>
                                    </td>
                                    <th><spring:message code='device.column.devicePassword'/></th>
                                    <td>
                                        <input type="text" id="devicePassword" disabled="disabled"/>
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
                    </article>
                </div>
            </article>
        </section>
        <div class="layer_popupbg ipop_close" onclick="closePopup();"></div>
    </aside>

    <form id="deviceForm" method="POST">
        <article class="search_area">
            <div class="search_contents">
                <p class="itype_01">
                    <span><spring:message code='device.column.deviceId'/></span>
                    <span>
                        <input type="text" name="deviceId" value="${paramBean.deviceId}"/>
                    </span>
                </p>
                <p class="itype_01">
                    <span><spring:message code='device.column.deviceType'/></span>
                    <span>
                        <isaver:codeSelectBox groupCodeId="D00" codeId="${paramBean.deviceTypeCode}" htmlTagName="deviceTypeCode" allModel="true"/>
                    </span>
                </p>
                <p class="itype_01">
                    <span><spring:message code='device.column.deviceCode'/></span>
                    <span>
                        <isaver:codeSelectBox groupCodeId="DEV" codeId="${paramBean.deviceCode}" htmlTagName="deviceCode" allModel="true"/>
                    </span>
                </p>
                <p class="itype_01">
                    <span><spring:message code='device.column.areaName'/></span>
                    <span>
                        <select name="areaId">
                            <option value="">전체</option>
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
                            <option value="">전체</option>
                            <option value="Y" <c:if test="${paramBean.deviceStat == 'Y'}">selected="selected"</c:if>>사용</option>
                            <option value="N" <c:if test="${paramBean.deviceStat == 'N'}">selected="selected"</c:if>>미사용</option>
                        </select>
                    </span>
                </p>
            </div>
            <div class="search_btn">
                <button class="btn bstyle01 btype01" onclick="javascript:search(); return false;">조회</button>
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
                    <col style="width: 20%;" />
                    <col style="width: 15%;" />
                    <col style="width: 10%;" />
                    <col style="width: 15%;" />
                </colgroup>
                <thead>
                <tr>
                    <th><spring:message code="device.column.deviceId"/></th>
                    <th><spring:message code="device.column.deviceType"/></th>
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
                            <td colspan="6"><spring:message code="common.message.emptyData"/></td>
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
        $("#linkUrl").val(data['linkUrl']);
        $("#eventId").val(data['eventId']);
        $("#fileName").val(data['fileName']);
        $("#cameraManufacturer").val(data['cameraManufacturer']);
        $("#hostType").val(data['hostType']);
        $("#ipAddress").val(data['ipAddress']);
        $("#webPort").val(data['webPort']);
        $("#rtspPort").val(data['rtspPort']);
        $("#deviceUserId").val(data['deviceUserId']);
        $("#devicePassword").val(data['devicePassword']);

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
        $(".device_detail_popup").show();
    }

    function closePopup(){
        $(".device_detail_popup").hide();
    }
</script>