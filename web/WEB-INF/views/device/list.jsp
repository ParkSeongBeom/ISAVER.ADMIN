<!-- 이벤트 관리, @author dhj -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<c:set value="D00000" var="menuId"/>
<c:set value="D00000" var="subMenuId"/>
<%--<jabber:pageRoleCheck menuId="${menuId}" />--%>
<script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/page-navigater.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/common/jquery-ui-1.10.4.min.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/data-util.js"></script>
<link rel="stylesheet" href="${rootPath}/assets/css/jqueryui/jquery-ui-1.10.4.min.css">

<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title">장치 관리</h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span>HOME 〉 장치 관리</span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <!-- 트리 영역 Start -->
    <article class="table_area tree_table">
        <div class="table_title_area">
            <h4></h4>
            <div class="table_btn_set">
                <button class="btn btype01 bstyle01" onclick="javascript:deviceCtrl.treeExpandAll(); return false;"><spring:message code='device.button.viewTheFulldevice'/></button>
                <button class="btn btype01 bstyle01 area_enrolment_btn" onclick="javascript:deviceCtrl.setAddBefore(); return false;" ><spring:message code='device.button.addDevice'/></button>
            </div>
        </div>
        <div class="table_contents">
            <div id="menuTreeArea" class="tree_box">
                <ul class="dynatree-container dynatree-no-connector">
                </ul>
            </div>
        </div>
    </article>
    <!-- 트리 영역 End -->


    <form id="deviceForm" method="POST" onsubmit="return false;">
        <input type="hidden" name="parentDeviceId" />
        <article class="table_area tr_table">
            <%--<div class="table_title_area area_enrolment">--%>
                <%--<h4>장치 조회</h4>--%>
            <%--</div>--%>
            <%--<article class="search_area" name="showHideTag" style="display: table;">--%>
                <%--<div class="search_contents">--%>
                    <%--<!-- 일반 input 폼 공통 -->--%>
                    <%--<p class="itype_01">--%>
                        <%--<span><spring:message code='device.column.deviceId'/></span>--%>
                        <%--<span>--%>
                            <%--<input type="text" name="search_deviceId" value="">--%>
                        <%--</span>--%>
                    <%--</p>--%>
                <%--</div>--%>
                <%--<div class="search_btn">--%>
                    <%--<button onclick="javascript:organizationCtrl.searchOrgUser(); return false;" class="btn bstyle01 btype01">조회</button>--%>
                <%--</div>--%>
            <%--</article>--%>

            <div class="table_title_area">
                <h4><spring:message code='device.column.deviceList'/></h4>
            </div>

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
                            <input type="text" name="deviceId" placeholder="<spring:message code='device.message.requiredDeviceId'/>" maxlength="6">
                        </td>
                        <th class="point"><spring:message code='device.column.serialNo'/></th>
                        <td class="point">
                            <input type="text" name="serialNo" placeholder="<spring:message code='device.message.requiredSerialNo'/>" maxlength="32">
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code='device.column.deviceType'/></th>
                        <td>
                            <input type="hidden"  name="deviceTypeCode" />
                            <isaver:codeSelectBox groupCodeId="D00" codeId="" htmlTagId="selectDeviceType"/>
                        </td>
                        <th><spring:message code='device.column.deviceCode'/></th>
                        <td>
                            <input type="hidden"  name="deviceCode" />
                            <isaver:codeSelectBox groupCodeId="DEV" codeId="" htmlTagId="selectDeviceCode"/>
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code='device.column.parentdeviceName'/></th>
                        <td colspan="3">
                            <select id="selectParentDeviceId" onchange="deviceCtrl.selectParentDeviceIdChangeEvent(event);">
                                <option value=""><spring:message code="device.message.emptyData"/></option>
                                <c:forEach items="${devices}" var="devices"  varStatus="status">
                                    <c:if test="${devices.delYn == 'N' }">
                                        <option value="${devices.deviceId}">
                                            ${devices.deviceCodeName}(${devices.deviceId})
                                            <%--<c:forEach var="i" begin="1" end="${devices.depth}" step="1"><c:if test="${i != 1}"> &nbsp; &nbsp;</c:if></c:forEach>${devices.deviceCodeName}(${devices.deviceId})--%>
                                        </option>
                                    </c:if>
                                </c:forEach>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code='area.column.areaName'/></th>
                        <td colspan="3">
                            <input type="hidden"  name="areaId"/>
                            <select id="selectAreaId">
                                <option value=""><spring:message code="device.message.emptyData"/></option>
                                <c:forEach items="${areas}" var="areas">
                                    <c:if test="${areas.delYn == 'N'}">
                                        <option value="${areas.areaId}">${areas.areaName}</option>
                                    </c:if>
                                </c:forEach>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code='device.column.ipAddress'/></th>
                        <td colspan="3">
                            <input type="text" name="ipAddress" placeholder="<spring:message code='device.message.requiredIpAddress' />" maxlength="20">
                        </td>
                    </tr>
                    <tr name="showHideTag">
                        <th><spring:message code='device.column.provisionFlag'/></th>
                        <td class="point">
                            <span name="provisionFlag"></span>
                        </td>
                        <th><spring:message code='device.column.deviceStat'/></th>
                        <td>
                            <span name="deviceStat"></span>
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code='device.column.deviceDesc'/></th>
                        <td class="point" colspan="3">
                            <textarea name="deviceDesc" class="textboard"></textarea>
                        </td>
                    </tr>
                    <tr name="showHideTag" >
                        <th><spring:message code="common.column.insertUser"/></th>
                        <td name="insertUserName"></td>
                        <th><spring:message code="common.column.insertDatetime"/></th>
                        <td name="insertDatetime"></td>
                    </tr>
                    <tr name="showHideTag" >
                        <th><spring:message code="common.column.updateUser"/></th>
                        <td name="updateUserName"></td>
                        <th><spring:message code="common.column.updateDatetime"/></th>
                        <td name="updateDatetime"></td>
                    </tr>
                    </tbody>
                </table>
                <!-- 입력 테이블 End -->
            </div>

            <div class="table_title_area">
                <div class="table_btn_set">
                    <button class="btn btype01 bstyle03" name="addBtn" onclick="javascript:deviceCtrl.addDeviceVaild(); return false;"><spring:message code="common.button.add"/> </button>
                    <button class="btn btype01 bstyle03" name="saveBtn" onclick="javascript:deviceCtrl.saveDeviceVaild(); return false;"><spring:message code="common.button.save"/> </button>
                    <button class="btn btype01 bstyle03" name="removeBtn" onclick="javascript:deviceCtrl.removeDeviceVaild(); return false;"><spring:message code="common.button.remove"/> </button>
                </div>
            </div>
        </article>
        <!-- 테이블 입력 / 조회 영역 End -->
        <!-- END : contents -->
    </form>
</section>

<script src="${rootPath}/assets/js/common/dynatree/jquery.dynatree.js"type="text/javascript" ></script>
<script src="${rootPath}/assets/js/util/ajax-util.js" type="text/javascript" charset="UTF-8"></script>
<script src="${rootPath}/assets/js/page/device/DeviceModel.js" type="text/javascript" charset="UTF-8"></script>
<script src="${rootPath}/assets/js/page/device/DeviceCtrl.js" type="text/javascript" charset="UTF-8"></script>
<script src="${rootPath}/assets/js/page/device/DeviceView.js" type="text/javascript" charset="UTF-8"></script>

<script type="text/javascript">
    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');

    var messageConfig = {
        menuBarFailure            :'<spring:message code="menu.message.menuTreeFailure"/>'
        ,   menuTreeFailure           :'<spring:message code="menu.message.menuBarFailure"/>'
        ,   addFailure                :'<spring:message code="device.message.addFailure"/>'
        ,   saveFailure               :'<spring:message code="device.message.saveFailure"/>'
        ,   removeFailure             :'<spring:message code="device.message.removeFailure"/>'
        ,   addComplete               :'<spring:message code="device.message.addComplete"/>'
        ,   saveComplete              :'<spring:message code="device.message.saveComplete"/>'
        ,   removeComplete            :'<spring:message code="device.message.removeComplete"/>'
        ,   addConfirmMessage         :'<spring:message code="common.message.addConfirm"/>'
        ,   saveConfirmMessage        :'<spring:message code="common.message.saveConfirm"/>'
        ,   removeConfirmMessage      :'<spring:message code="common.message.removeConfirm"/>'
        ,   requiredDeviceId            :"<spring:message code='device.message.requiredDeviceId'/>"
        ,   requiredSerialNo          :"<spring:message code='device.message.requiredSerialNo'/>"
        ,   requiredIpAddress          :"<spring:message code='device.message.requiredIpAddress'/>"
        ,   requiredMenuUrl           :"<spring:message code='menu.message.requiredMenuUrl'/>"
        ,   regexpDigits              :"<spring:message code='menu.message.regexpDigits'/>"
        ,   regexpUrl                 :"<spring:message code='menu.message.regexpUrl'/>"
        ,   pleaseChooseMenu          :"<spring:message code='menu.message.pleaseChooseMenu'/>"
        ,   menuNotDeleted            :"<spring:message code='menu.message.menuNotDeleted'/>"
        ,   existsDeviceId            :"<spring:message code='device.message.existsDeviceId'/>"
        ,   existsSerialNo            :"<spring:message code='device.message.existsSerialNo'/>"
        ,   existsIpAddress            :"<spring:message code='device.message.existsIpAddress'/>"
        ,   regexpIpAddress :"<spring:message code='device.message.regexpIpAddress'/>"
    };

    $(document).ready(function(){
        /**
         * 장치 트리 생성
         */
        deviceCtrl.findMenuTree();
        var view = new DeviceView(deviceModel);
        view.setAddBefore();

        $("select[id=selectDeviceType]").change(function() {
            var id  = $(event.currentTarget).val();
            $("input[name=deviceTypeCode]").val(id);
        });

        $("select[id=selectDeviceCode]").change(function() {
            var id  = $(event.currentTarget).val();
            $("input[name=deviceCode]").val(id);
        });

        $("select[id=selectAreaId]").change(function() {
            var id  = $(event.currentTarget).val();
            $("input[name=areaId]").val(id);
        });
    });

    var deviceModel = new DeviceModel();
    deviceModel.setRootUrl(String('${rootPath}'));
    deviceModel.setPageRowNumber(10);
    deviceModel.setPageIndex(0);

    var deviceCtrl = new DeviceCtrl(deviceModel);


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

</script>