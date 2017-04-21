<!-- 이벤트 관리, @author dhj -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<c:set value="D00010" var="menuId"/>
<c:set value="D00000" var="subMenuId"/>
<%--<jabber:pageRoleCheck menuId="${menuId}" />--%>
<script type="text/javascript" src="${rootPath}/assets/js/util/page-navigater.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/common/jquery-ui-1.10.4.min.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/data-util.js"></script>

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
    <aside class="admin_popup ipop_type01 code_select_popup">
        <section class="layer_wrap i_type04">
            <article class="layer_area">
                <div class="layer_header">
                    알림 대상 장치 목록
                    <button class="ipop_x" onclick="closePopup('code_select_popup');"></button>
                </div>
                <div class="layer_contents">
                    <%--<form id="userForm" method="POST">--%>
                    <input type="hidden" name="pageNumber">
                    <article class="search_area">
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
                            <span>
                                <isaver:codeSelectBox groupCodeId="DEV" codeId="" htmlTagId="pop_device_code" allModel="true"/>
                            </span>
                            </p>
                            <p class="itype_01">
                                <span><spring:message code="device.column.areaName"/></span>
                            <span>
                                <input type="text" name="pop_areaName" >
                            </span>
                            </p>
                        </div>
                        <div class="search_btn">
                            <button onclick="javascript:deviceCtrl.alarmDeviceLoadFunc(); return false;" class="btn bstyle01 btype01">조회</button>
                        </div>
                    </article>
                    <%--</form>--%>
                    <article class="table_area">
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
                    </article>
                    <div class="table_title_area">
                        <div class="table_btn_set">
                            <button class="btn btype01 bstyle03 c_ok" onclick="javascript:deviceCtrl.appendAlarmDeviceFunc();return false;"><spring:message code="common.button.save"/></button>
                            <button class="btn btype01 bstyle03 c_cancle" onclick="javascript:closePopup('code_select_popup'); return false;"><spring:message code="common.button.cancel"/></button>
                            <%--<button class="btn btype01 bstyle03 c_ok" onclick="javascript:alert(0); return false;" >확인</button>--%>
                            <%--<button class="btn btype01 bstyle03 c_cancle"  onclick="javascript:alert(1); return false;">취소</button>--%>
                        </div>
                    </div>
                </div>
            </article>
        </section>
        <div class="layer_popupbg ipop_close" onclick="closePopup('code_select_popup');"></div>
    </aside>

    <aside class="admin_popup file_popup">
        <section class="layer_wrap i_type05">
            <article class="layer_area">
                <div class="layer_header">
                    <spring:message code="device.column.fileList"/>
                    <button class="ipop_x" onclick="closePopup('file_popup');"></button>
                </div>
                <div class="layer_contents">
                    <input type="hidden" name="pageNumber">
                    <article class="search_area">
                        <div class="search_contents">
                            <!-- 일반 input 폼 공통 -->
                            <p class="itype_01">
                                <span><spring:message code="device.column.title"/></span>
                                <span>
                                    <input type="text" id="fileTitle" />
                                </span>
                            </p>
                            <p class="itype_01">
                                <span><spring:message code="device.column.fileName"/></span>
                                <span>
                                    <input type="text" id="fileName" />
                                </span>
                            </p>
                        </div>
                        <div class="search_btn">
                            <button onclick="javascript:deviceCtrl.fileLoadFunc(); return false;" class="btn bstyle01 btype01"><spring:message code="common.button.search"/></button>
                        </div>
                    </article>
                    <%--</form>--%>
                    <article class="table_area">
                        <div class="table_contents">
                            <!-- 입력 테이블 Start -->
                            <table class="t_defalut t_type01 t_style02">
                                <colgroup>
                                    <col style="width: 5%;">
                                    <col style="width: 20%;">
                                    <col style="width: *%;">
                                    <col style="width: 20%;">
                                    <col style="width: 10%;">
                                    <col style="width: 20%;">
                                </colgroup>
                                <thead>
                                <tr>
                                    <th class="t_center"></th>
                                    <th><spring:message code="device.column.title"/></th>
                                    <th><spring:message code="device.column.fileName"/></th>
                                    <th><spring:message code="device.column.description"/></th>
                                    <th><spring:message code="device.column.insertUserName"/></th>
                                    <th><spring:message code="device.column.insertDatetime"/></th>
                                </tr>
                                </thead>
                                <tbody id="fileList">
                                </tbody>
                            </table>
                        </div>
                    </article>
                    <div class="table_title_area">
                        <div class="table_btn_set">
                            <button class="btn btype01 bstyle03 c_cancle" onclick="javascript:closePopup('file_popup'); return false;">닫기</button>
                        </div>
                    </div>
                </div>
            </article>
        </section>
        <div class="layer_popupbg ipop_close" onclick="closePopup('file_popup');"></div>
    </aside>

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

    <form id="deviceForm" method="POST" onsubmit="return false;" class="form_type01">
        <article class="table_area tr_table">

            <div class="table_title_area">
                <h4><spring:message code='device.column.deviceInformation'/></h4>
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
                    <tr class="rootShow">
                        <th class="point"><spring:message code='device.column.deviceId'/></th>
                        <td class="point">
                            <input type="text" name="deviceId" placeholder="<spring:message code='device.message.requiredDeviceId'/>" disabled="disabled" />
                        </td>
                        <th class="point"><spring:message code='device.column.serialNo'/></th>
                        <td class="point">
                            <input type="text" name="serialNo" placeholder="<spring:message code='device.message.requiredSerialNo'/>" maxlength="32" disabled title=" - 형식 : XX-YYYYY
  → XX : 장치유형, YYYYY : 넘버 (랜덤 제너레이션)
   > TMS(00), IVAS(10), SIOC(20)
      IP Camera(11)
      IR Sensor(21), Laser Scanner(22), Speaker(23), LED Light(24),
      경광등(25)
      People Count Device(31), 유해가스감지센서(32)
 ex) 00-YYYYY TMS , 10-YYYYY IVAS, 20-YYYYY SIOC,
      21-YYYYY IR Sensor
      ※ S/N에 대한 형식은 숫자로만 구성 " />
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code='device.column.deviceType'/></th>
                        <td>
                            <isaver:codeSelectBox groupCodeId="D00" codeId="" htmlTagName="deviceTypeCode"/>
                        </td>
                        <th><spring:message code='device.column.deviceCode'/></th>
                        <td>
                            <isaver:codeSelectBox groupCodeId="DEV" codeId="" htmlTagName="deviceCode"/><br />
                            <button id="ipCameraSetting" class="btn btype01 bstyle01" onclick="javascript:deviceCtrl.alarmListLoadFunc(); return false;"><spring:message code="device.button.ivasSetting"/></button>
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
                    <tr class="ipCamShowHide">
                        <th class="point"><spring:message code='device.column.eventName'/></th>
                        <td class="point">
                            <select name="eventId">
                                <option value="">이벤트를 선택하세요.</option>
                                <c:forEach items="${events}" var="event">
                                    <option value="${event.eventId}">[${event.eventId}]${event.eventName}</option>
                                </c:forEach>
                            </select>
                        </td>
                        <th><spring:message code='device.column.fileName'/></th>
                        <td>
                            <div class="infile_set">
                                <input type="text" name="fileName" readonly="readonly"/>
                                <input type="hidden" name="fileId"/>
                                <span class="btn_infile btype03 bstyle04" onclick="javascript:deviceCtrl.fileListLoadFunc(); return false;"></span>
                            </div>
                        </td>
                    </tr>
                    <tr class="ipCamShowHide">
                        <th class="point"><spring:message code='device.column.cameraManufacturer'/></th>
                        <td class="point" colspan="3">
                            <isaver:codeSelectBox groupCodeId="CA1" codeId="" htmlTagName="cameraManufacturer" allModel="true" allText="카메라 제조사를 선택하세요."/>
                        </td>
                    </tr>
                    <tr class="ipAddressShowHide">
                        <th><spring:message code='device.column.hostType'/></th>
                        <td>
                            <isaver:codeSelectBox groupCodeId="H01" codeId="" htmlTagName="hostType"/>
                        </td>
                        <td ipAddress colspan="2">
                            <input type="text" name="ipAddress" maxlength="20" placeholder="<spring:message code='device.message.requiredIpAddress' />"/>
                        </td>
                        <td domain colspan="2">
                            <input type="text" name="domain" maxlength="100" placeholder="<spring:message code='device.message.requiredDomain' />"/>
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code='device.column.webPort'/></th>
                        <td>
                            <input type="text" name="webPort" maxlength="20" />
                        </td>
                        <th><spring:message code='device.column.rtspPort'/></th>
                        <td>
                            <input type="text" name="rtspPort" maxlength="20" />
                        </td>
                    </tr>
                    <tr>
                        <th><spring:message code='device.column.deviceUserId'/></th>
                        <td>
                            <input type="text" name="deviceUserId" maxlength="20" />
                        </td>
                        <th><spring:message code='device.column.devicePassword'/></th>
                        <td>
                            <input type="text" name="devicePassword" maxlength="50" />
                        </td>
                    </tr>
                    <tr name="showHideTag">
                        <th class=""><spring:message code='device.column.deviceStatusCheckFlag'/></th>
                        <td class="">
                            <select name="deviceAliveFlag" >
                                <option value="Y"><spring:message code='common.message.Y'/></option>
                                <option value="N"><spring:message code='common.message.N'/></option>
                            </select>
                        </td>
                        <th class=""><spring:message code='device.column.deviceStatusCheckType'/></th>
                        <td class="">
                            <isaver:codeSelectBox groupCodeId="DAL" codeId="${action.actionCode}" htmlTagId="deviceAliveCheckType" htmlTagName="deviceAliveCheckType" allModel="true"  />
                        </td>
                    </tr>
                    <tr name="showHideTag">
                        <th class="point"><spring:message code='device.column.provisionFlag'/></th>
                        <td class="point">
                            <select name="provisionFlag" >
                                <option value="Y"><spring:message code='common.message.Y'/></option>
                                <option value="N"><spring:message code='common.message.N'/></option>
                            </select>
                        </td>
                        <th class=""><spring:message code='device.column.deviceStat'/></th>
                        <td class="">
                            <input name="deviceStat" type="radio" value="Y"  disabled><spring:message code='device.button.statusOn'/>
                            <input name="deviceStat" type="radio" value="N" disabled><spring:message code='device.button.statusOff'/>
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

<script src="${rootPath}/assets/js/common/dynatree/jquery.dynatree.js"type="text/javascript" ></script>
<script src="${rootPath}/assets/js/page/device/DeviceModel.js" type="text/javascript" charset="UTF-8"></script>
<script src="${rootPath}/assets/js/page/device/DeviceCtrl.js" type="text/javascript" charset="UTF-8"></script>
<script src="${rootPath}/assets/js/page/device/DeviceView.js" type="text/javascript" charset="UTF-8"></script>

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
        ,   requiredIpAddress          :"<spring:message code='device.message.requiredIpAddress'/>"
        ,   requiredMenuUrl           :"<spring:message code='menu.message.requiredMenuUrl'/>"
        ,   regexpDigits              :"<spring:message code='menu.message.regexpDigits'/>"
        ,   regexpUrl                 :"<spring:message code='menu.message.regexpUrl'/>"
        ,   pleaseChooseMenu          :"<spring:message code='menu.message.pleaseChooseMenu'/>"
        ,   menuNotDeleted            :"<spring:message code='menu.message.menuNotDeleted'/>"
        ,   existsDeviceId            :"<spring:message code='device.message.existsDeviceId'/>"
        ,   existsSerialNo            :"<spring:message code='device.message.existsSerialNo'/>"
        ,   existsIpAddress           :"<spring:message code='device.message.existsIpAddress'/>"
        ,   regexpIpAddress : "<spring:message code='device.message.regexpIpAddress'/>"
        ,   provisionExistError : "<spring:message code='device.message.provisionExistError'/>"
        ,   emptyEventId              :"<spring:message code='device.message.emptyEventId'/>"
        ,   emptyCameraManufacturer   :"<spring:message code='device.message.emptyCameraManufacturer'/>"
    };

    var emptyListTag = $("<tr/>").append(
        $("<td/>", {colspan:"6"}).text('<spring:message code="common.message.emptyData"/>')
    );

    $(document).ready(function(){
        /**
         * 장치 트리 생성
         */
        deviceCtrl.findMenuTree();
        deviceCtrl.setAddBefore();

        $("select[name=hostType]").change(function() {
            $(this).prop("disabled",false);

            if($(this).val()=="H01001"){
                $("#deviceForm input[name='ipAddress']").prop("disabled",false);
                $("#deviceForm input[name='domain']").prop("disabled",true);
                $("#deviceForm tr td[ipAddress]").show();
                $("#deviceForm tr td[domain]").hide();
            }else{
                $("#deviceForm input[name='domain']").prop("disabled",false);
                $("#deviceForm input[name='ipAddress']").prop("disabled",true);
                $("#deviceForm tr td[ipAddress]").hide();
                $("#deviceForm tr td[domain]").show();
            }
        });

        $("select[name=deviceCode]").change(function() {
            var id  = $(this).val();
            $("select[name=deviceCode]").val(id);

            if (id == "DEV002") {
                $(".ipCamShowHide").show();
            } else {
                $(".ipCamShowHide").hide();
            }

            switch (deviceModel.getViewStatus()) {
                case "menuTree":
                case "add":
                    if(deviceModel.checkModifyDeviceIpList(id)){
                        $(".ipAddressShowHide").show();
                        $("select[name=hostType]").trigger("change");
                    }else{
                        $("#deviceForm select[name='hostType']").prop("disabled",true);
                        $("#deviceForm input[name='ipAddress']").prop("disabled",true);
                        $("#deviceForm input[name='domain']").prop("disabled",true);
                        $(".ipAddressShowHide").hide();
                    }
                    break;
                case "detail":
                    $("select[name=hostType]").trigger("change");
                    if(!deviceModel.checkModifyDeviceIpList(id)){
                        $("#deviceForm select[name='hostType']").prop("disabled",true);
                        $("#deviceForm input[name='ipAddress']").prop("disabled",true);
                        $("#deviceForm input[name='domain']").prop("disabled",true);
                    }

                    if (id == "DEV002") {
                        $("#ipCameraSetting").show();
                    } else {
                        $("#ipCameraSetting").hide();
                    }
                    break;
            }
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

    /* 팝업 보이기 버튼 */
    function openPopup(className) {
        $("."+className).show();
    }

    /* 팝업 취소 버튼 */
    function closePopup(className) {
        $("."+className).hide();
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