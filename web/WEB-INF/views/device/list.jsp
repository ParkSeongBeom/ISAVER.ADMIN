<!-- 이벤트 관리, @author dhj -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<c:set value="D00010" var="menuId"/>
<c:set value="D00000" var="subMenuId"/>
<isaver:pageRoleCheck menuId="${menuId}" locale="${pageContext.response.locale}"/>
<script type="text/javascript" src="${rootPath}/assets/js/util/page-navigater.js"></script>

<!-- 장치 상세 화면 -->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code='common.title.device'/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><isaver:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <!-- 알림 장치 맵핑 팝업-->
    <div class="popupbase admin_popup list_popup">
        <div>
            <div>
                <header>
                    <h2><spring:message code="device.column.notificationDeviceList"/></h2>
                    <button onclick="javascript:closePopup('list_popup');"></button>
                </header>
                <article>
                    <input type="hidden" name="pageNumber">
                    <div class="search_area">
                        <div class="search_contents">
                            <!-- 일반 input 폼 공통 -->
                            <p class="itype_01">
                                <span><spring:message code="device.column.deviceId"/></span>
                            <span>
                                <input type="text" name="pop_device_id" >
                            </span>
                            </p>
                            <p class="itype_01">
                                <span><spring:message code="device.column.deviceCode"/></span>
                                <spring:message code="common.selectbox.select" var="allSelectText"/>
                                <span><isaver:codeSelectBox groupCodeId="DEV" codeId="" htmlTagId="pop_device_code" allModel="true" allText="${allSelectText}"/></span>
                            </p>
                            <p class="itype_01">
                                <span><spring:message code="device.column.areaName"/></span>
                            <span>
                                <input type="text" name="pop_areaName" >
                            </span>
                            </p>
                        </div>
                        <div class="search_btn">
                            <button onclick="javascript:deviceCtrl.alarmDeviceLoadFunc(); return false;" class="btn">조회</button>
                        </div>
                    </div>
                    <div class="table_area">
                        <div class="table_contents">
                            <!-- 입력 테이블 Start -->
                            <table id="actionList" class="t_defalut t_type01 t_style02">
                                <colgroup>
                                    <col style="width: 5%;">
                                    <col style="width: 15%;">
                                    <col style="width: 20%;">
                                    <col style="width: *%;">
                                </colgroup>
                                <thead>
                                <tr>
                                    <th class="t_center"></th>
                                    <th><spring:message code="device.column.deviceId"/></th>
                                    <th><spring:message code="device.column.deviceCode"/></th>
                                    <th><spring:message code="device.column.areaName"/></th>
                                    <th><spring:message code="device.column.provisionFlag"/></th>
                                </tr>
                                </thead>
                                <tbody>
                                <tr>
                                    <td colspan="5"><spring:message code="common.message.emptyData"/></td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </article>
                <footer>
                    <button class="btn btype01 bstyle03 c_ok" onclick="javascript:deviceCtrl.appendAlarmDeviceFunc();return false;"><spring:message code="common.button.save"/></button>
                    <button class="btn btype01 bstyle03 c_cancle" onclick="javascript:closePopup('list_popup'); return false;"><spring:message code="common.button.cancel"/></button>
                </footer>
            </div>
        </div>
        <div class="bg ipop_close" onclick="closePopup('list_popup');"></div>
    </div>

    <!-- 트리 영역 Start -->
    <article class="table_area tree_table">
        <div class="table_title_area">
            <h4></h4>
            <div class="table_btn_set">
                <button class="btn btype01 bstyle01" id="expandShow" onclick="javascript:deviceCtrl.treeExpandAll(true); return false;"><spring:message code='common.button.viewTheFull'/></button>
                <button class="btn btype01 bstyle01" id="expandClose" style="display:none;" onclick="javascript:deviceCtrl.treeExpandAll(false); return false;"><spring:message code='common.button.viewTheFullClose'/></button>
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

    <form id="deviceForm" method="POST" onsubmit="return false;" class="form_type01">
        <article class="table_area tr_table">

            <div class="table_title_area">
                <h4><spring:message code='device.column.deviceInformation'/></h4>
            </div>

            <div class="table_contents">
                <!-- 입력 테이블 Start -->
                <table class="t_defalut t_type02 devicelist_col">
                    <colgroup>
                        <col>  <!-- 01 -->
                        <col>  <!-- 02 -->
                        <col>  <!-- 03 -->
                        <col>  <!-- 04 -->
                    </colgroup>
                    <tbody>
                    <tr class="rootShow">
                        <th><spring:message code='device.column.deviceId'/></th>
                        <td>
                            <input type="text" name="deviceId" placeholder="<spring:message code='device.message.requiredDeviceId'/>" disabled="disabled" />
                        </td>
                        <th class="point"><spring:message code='device.column.serialNo'/></th>
                        <td class="point">
                            <input type="text" name="serialNo" placeholder="<spring:message code='device.message.requiredSerialNo'/>" maxlength="32" disabled />
                        </td>
                    </tr>
                    <tr>
                        <th class="point"><spring:message code='device.column.deviceType'/></th>
                        <td class="point">
                            <isaver:codeSelectBox groupCodeId="D00" codeId="" htmlTagName="deviceTypeCode"/>
                        </td>
                        <th class="point"><spring:message code='device.column.deviceCode'/></th>
                        <td class="point">
                            <div class="infile_set">
                                <isaver:codeSelectBox groupCodeId="DEV" codeId="" htmlTagName="deviceCode"/><br />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code='device.column.parentdeviceName'/></th>
                        <td colspan="3">
                            <select name="parentDeviceId">
                                <option value=""><spring:message code="device.message.emptyData"/></option>
                                <c:forEach items="${devices}" var="devices"  varStatus="status">
                                    <c:if test="${devices.delYn == 'N' }">
                                        <option value="${devices.deviceId}">
                                            ${devices.path}
                                            <%--<c:forEach var="i" begin="1" end="${devices.depth}" step="1"><c:if test="${i != 1}"> &nbsp; &nbsp;</c:if></c:forEach>${devices.deviceCodeName}(${devices.deviceId})--%>
                                        </option>
                                    </c:if>
                                </c:forEach>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th class="point"><spring:message code='area.column.areaName'/></th>
                        <td class="point" colspan="3">
                            <select name="areaId">
                                <%--<option value=""><spring:message code="device.message.emptyData"/></option>--%>
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
                            <input type="text" name="ipAddress" maxlength="20" placeholder="<spring:message code='device.message.requiredIpAddress' />"/>
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code='area.column.linkUrl'/></th>
                        <td colspan="3">
                            <input type="text" name="linkUrl" maxlength="200"/>
                        </td>
                    </tr>
                    <tr name="showHideTag">
                        <th class="point"><spring:message code='device.column.provisionFlag'/></th>
                        <td class="point">
                            <div class="checkbox_set csl_style03">
                                <input type="hidden" name="provisionFlag" value="Y"/>
                                <input type="checkbox" id="provisionFlagCheckBox" checked onchange="setCheckBoxYn(this,'provisionFlag')"/>
                                <label></label>
                            </div>
                        </td>
                        <th class=""><spring:message code='device.column.deviceStat'/></th>
                        <td class="">
                            <div class="checkbox_set csl_style02 disabled">
                                <input type="hidden" name="deviceStat" value="Y"/>
                                <input type="checkbox" id="deviceStatCheckBox" checked onchange="setCheckBoxYn(this,'deviceStat')"/>
                                <label></label>
                            </div>
                        </td>
                    </tr>
                    <tr class="rootShow">
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



</script>

<script src="${rootPath}/assets/library/tree/jquery.dynatree.js" type="text/javascript" ></script>
<script src="${rootPath}/assets/js/page/device/DeviceModel.js?version=${version}" type="text/javascript" charset="UTF-8"></script>
<script src="${rootPath}/assets/js/page/device/DeviceCtrl.js?version=${version}" type="text/javascript" charset="UTF-8"></script>
<script src="${rootPath}/assets/js/page/device/DeviceView.js?version=${version}" type="text/javascript" charset="UTF-8"></script>

<script type="text/javascript">

    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');
    var selectedDeviceId = String("${paramBean.deviceId}");
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
        ,   requiredAreaId            :"<spring:message code='device.message.requiredAreaId'/>"
        ,   requiredSerialNo          :"<spring:message code='device.message.requiredSerialNo'/>"
        ,   requiredMenuUrl           :"<spring:message code='menu.message.requiredMenuUrl'/>"
        ,   regexpDigits              :"<spring:message code='menu.message.regexpDigits'/>"
        ,   regexpUrl                 :"<spring:message code='menu.message.regexpUrl'/>"
        ,   pleaseChooseMenu          :"<spring:message code='menu.message.pleaseChooseMenu'/>"
        ,   menuNotDeleted            :"<spring:message code='menu.message.menuNotDeleted'/>"
        ,   existsDeviceId            :"<spring:message code='device.message.existsDeviceId'/>"
        ,   existsSerialNo            :"<spring:message code='device.message.existsSerialNo'/>"
        ,   provisionExistError : "<spring:message code='device.message.provisionExistError'/>"
        ,   emptyLinkUrl           :"<spring:message code='device.message.emptyLinkUrl'/>"
    };

    var alertMessageList = [
        "<spring:message code="menu.message.alarm01"/>"
        , "<spring:message code="menu.message.alarm02"/>"
        , "<spring:message code="menu.message.alarm03"/>"
        , "<spring:message code="menu.message.alarm04"/>"];

    var emptyListTag = $("<tr/>").append(
        $("<td/>", {colspan:"6"}).text('<spring:message code="common.message.emptyData"/>')
    );

    $(document).ready(function(){
        /**
         * 장치 트리 생성
         */
        deviceCtrl.findMenuTree();
        deviceCtrl.setAddBefore();
    });

    var deviceModel = new DeviceModel();
    deviceModel.setRootUrl(String('${rootPath}'));
    deviceModel.setPageRowNumber(10);
    deviceModel.setPageIndex(0);
    deviceModel.setAlertMessageList(alertMessageList);
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

    /* 팝업 보이기 버튼 */
    function openPopup(className) {
        $("."+className).fadeIn();
    }

    /* 팝업 취소 버튼 */
    function closePopup(className) {
        $("."+className).fadeOut();
    }

    /* 알림 장치 목록 조회*/
    function alarmListLoad() {
        var actionType = "actionList";

        var data = {
            deviceId : deviceModel.getDeviceId()
        };

        /*  테이블 목록 - 내용 */
        $("#actionList > tbody").empty();

        sendAjaxPostRequest(urlConfig[actionType + 'Url'],data,requestAction_successHandler,requestAction_errorHandler,actionType);
    }

</script>