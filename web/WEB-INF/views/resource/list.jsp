<!-- 구역 관리 목록 -->
<!-- @author dhj -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<c:set value="D00000" var="menuId"/>
<c:set value="D00000" var="subMenuId"/>
<isaver:pageRoleCheck menuId="${menuId}" locale="${pageContext.response.locale}"/>
<script src="${rootPath}/assets/js/page/resource/resource-helper.js?version=${version}" type="text/javascript" charset="UTF-8"></script>
<script src="${rootPath}/assets/js/popup/template-setting-popup.js?version=${version}" type="text/javascript" charset="UTF-8"></script>
<script src="${rootPath}/assets/js/popup/custom-map-popup.js?version=${version}" type="text/javascript" charset="UTF-8"></script>
<script src="${rootPath}/assets/js/popup/ptz-control-popup.js?version=${version}" type="text/javascript" charset="UTF-8"></script>
<script src="${rootPath}/assets/library/svg/jquery.svg.js?version=${version}" type="text/javascript" ></script>
<script src="${rootPath}/assets/library/svg/jquery.svgdom.js?version=${version}" type="text/javascript" ></script>
<script src="${rootPath}/assets/js/page/dashboard/custom-map-mediator.js?version=${version}" type="text/javascript" charset="UTF-8"></script>

<%-- Medea Server를 통한 RTSP Stream --%>
<script type="text/javascript" src="${rootPath}/assets/library/webrtc-streamer/request.min.js?version=${version}"></script>
<script type="text/javascript" src="${rootPath}/assets/library/webrtc-streamer/adapter.js?version=${version}"></script>
<script type="text/javascript" src="${rootPath}/assets/library/webrtc-streamer/webrtcstreamer.js?version=${version}"></script>
<script src="${rootPath}/assets/js/page/dashboard/video-mediator.js?version=${version}" type="text/javascript" charset="UTF-8"></script>

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.resource"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><isaver:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <!-- 트리 영역 Start -->
    <article class="table_area tree_table">
        <div class="table_title_area">
            <h4></h4>
            <div class="table_btn_set">
                <button class="btn" onclick="javascript:resourceHelper.getAreaDetail(); return false;"><spring:message code='resource.button.addArea'/></button>
                <button class="btn" onclick="javascript:resourceHelper.getDeviceDetail(); return false;"><spring:message code='resource.button.addDevice'/></button>
                <button class="btn sett_btn option_btn" onclick="javascript:templateSettingPopup.openPopup(); return false;"></button>
                <button class="btn refl_btn" onclick="javascript:resourceHelper.refreshList(); return false;" title="<spring:message code='resource.title.refresh'/>"></button>
            </div>
        </div>
        <div class="table_contents">
            <div class="table_btn_set type03 tree_tab_btn">
                <button class="btn tab_area" onclick="javascript:moveTab('area'); return false;"><spring:message code='resource.title.area'/></button>
                <button class="btn tab_device" onclick="javascript:moveTab('device'); return false;"><spring:message code='resource.title.device'/></button>
            </div>

            <div class="tree_tab_set">
                <ul class="area_tree_set tab_area" title="<spring:message code='resource.title.area'/>" >
                    <li>
                        <button class="all_see_btn" onclick="javascript:allView(this); return false;" title="<spring:message code='resource.title.allView'/>"></button>
                        <ul id="areaList"></ul>
                    </li>
                </ul>

                <ul class="area_tree_set tab_device" title="<spring:message code='resource.title.device'/>">
                    <li>
                        <button class="all_see_btn" onclick="javascript:allView(this); return false;" title="<spring:message code='resource.title.allView'/>"></button>
                        <ul id="deviceList"></ul>
                    </li>
                </ul>
            </div>
        </div>
    </article>
    <!-- 트리 영역 End -->

    <!-- 테이블 입력 / 조회 영역 Start -->
    <article class="table_area tr_table type01">
        <div class="table_title_area">
            <h4><spring:message code='resource.title.detail'/></h4>
        </div>

        <!-- 아무 선택이 없을 경우 코멘트 영역 Start-->
        <div detail class="ment on">
            <div>Click the after-view button</div>
        </div>
        <!-- 아무 선택이 없을 경우 코멘트 영역 End -->

        <!-- 구역 상세 Start-->
        <div detail class="area_table">
            <form id="areaForm" method="POST" onsubmit="return false;" class="form_type01">
                <input type="hidden" name="allTemplate"/>
                <div class="table_contents">
                    <!-- 입력 테이블 Start -->
                    <table class="t_defalut t_type02 arealist_col">
                        <colgroup>
                            <col>  <!-- 01 -->
                            <col>  <!-- 02 -->
                            <col>  <!-- 03 -->
                            <col>  <!-- 04 -->
                        </colgroup>
                        <tbody>
                            <tr>
                                <th><spring:message code="area.column.areaId"/></th>
                                <td>
                                    <input type="text" name="areaId" placeholder="<spring:message code="area.message.requiredAreaId"/>" readonly>
                                </td>
                                <th class="point"><spring:message code="area.column.areaName"/></th>
                                <td class="point">
                                    <input type="text" name="areaName" placeholder="<spring:message code="area.message.requiredAreaName"/>" maxlength="50">
                                </td>
                            </tr>
                            <tr>
                                <th><spring:message code='area.column.parentareaName'/></th>
                                <td colspan="3">
                                    <select name="parentAreaId">
                                        <option value=""><spring:message code="device.message.emptyData"/></option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <th><spring:message code="area.column.sortOrder"/></th>
                                <td>
                                    <input type="number" name="sortOrder" placeholder="<spring:message code="area.message.requiredSortOrder"/>" >
                                </td>
                                <th class="point"><spring:message code="area.column.templateCode"/></th>
                                <td class="point intd">
                                    <div>
                                        <isaver:codeSelectBox groupCodeId="TMP" codeId="" htmlTagName="templateCode"/>
                                        <button class="btn map_sett_btn" style="display:none;"><spring:message code="resource.title.mapSetting"/></button>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th><spring:message code="area.column.areaDesc"/></th>
                                <td class="point" colspan="3">
                                    <textarea name="areaDesc" class="textboard"></textarea>
                                </td>
                            </tr>
                            <tr modifyTag>
                                <th><spring:message code="common.column.insertUser"/></th>
                                <td name="insertUserName"></td>
                                <th><spring:message code="common.column.insertDatetime"/></th>
                                <td name="insertDatetime"></td>
                            </tr>
                            <tr modifyTag>
                                <th><spring:message code="common.column.updateUser"/></th>
                                <td name="updateUserName"></td>
                                <th><spring:message code="common.column.updateDatetime"/></th>
                                <td name="updateDatetime"></td>
                            </tr>
                        </tbody>
                    </table>
                    <!-- 입력 테이블 End -->
                </div>

                <div class="table_btn_set">
                    <button class="btn" name="addBtn" onclick="javascript:resourceHelper.submit('area','add'); return false;"><spring:message code="common.button.add"/></button>
                    <button class="btn" name="saveBtn" onclick="javascript:resourceHelper.submit('area','save'); return false;"><spring:message code="common.button.save"/></button>
                    <button class="btn" name="removeBtn" onclick="javascript:resourceHelper.submit('area','remove'); return false;"><spring:message code="common.button.remove"/></button>
                </div>
            </form>
        </div>
        <!-- 구역 상세 End-->

        <!-- 장치 상세 Start-->
        <div detail class="device_table">
            <form id="deviceForm" method="POST" onsubmit="return false;" class="form_type01">
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
                            <tr>
                                <th><spring:message code='device.column.deviceId'/></th>
                                <td>
                                    <input type="text" name="deviceId" placeholder="<spring:message code='device.message.requiredDeviceId'/>" readonly/>
                                </td>
                                <th class="point"><spring:message code='device.column.serialNo'/></th>
                                <td class="point">
                                    <input type="text" name="serialNo" placeholder="<spring:message code='device.message.requiredSerialNo'/>" maxlength="32"/>
                                </td>
                            </tr>
                            <tr>
                                <th class="point"><spring:message code='device.column.deviceName'/></th>
                                <td class="point" colspan="3">
                                    <input type="text" name="deviceName" placeholder="<spring:message code='device.message.requiredDeviceName'/>" maxlength="50"/>
                                </td>
                            </tr>
                            <tr>
                                <th><spring:message code='device.column.vendorCode'/></th>
                                <td>
                                    <spring:message code="device.message.emptyData" var="emptyData"/>
                                    <isaver:codeSelectBox groupCodeId="CA1" codeId="" htmlTagName="vendorCode" allModel="true" allText='${emptyData}'/>
                                </td>
                                <th class="point"><spring:message code='device.column.deviceCode'/></th>
                                <td class="point intd">
                                    <div>
                                        <isaver:codeSelectBox groupCodeId="DEV" codeId="" htmlTagName="deviceCode"/>
                                        <button class="btn onvif_sett_btn" style="display:none;"><spring:message code="resource.title.ptzControl"/></button>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th><spring:message code='device.column.parentdeviceName'/></th>
                                <td>
                                    <select name="parentDeviceId">
                                        <option value=""><spring:message code="device.message.emptyData"/></option>
                                    </select>
                                </td>
                                <th class="point"><spring:message code='device.column.deviceType'/></th>
                                <td class="point">
                                    <isaver:codeSelectBox groupCodeId="D00" codeId="" htmlTagName="deviceTypeCode"/>
                                </td>
                            </tr>
                            <tr>
                                <th class="point"><spring:message code='area.column.areaName'/></th>
                                <td class="point" colspan="3">
                                    <select name="areaId"></select>
                                </td>
                            </tr>
                            <tr>
                                <th><spring:message code='device.column.ipAddress'/></th>
                                <td>
                                    <input type="text" name="ipAddress" maxlength="20" placeholder="<spring:message code='device.message.requiredIpAddress' />" onkeypress="isNumberWithPoint(this);"/>
                                </td>
                                <th><spring:message code='device.column.port'/></th>
                                <td>
                                    <input type="text" name="port" maxlength="6" onkeypress="isNumber(this);"/>
                                </td>
                            </tr>
                            <tr>
                                <th><spring:message code='device.column.deviceUserId'/></th>
                                <td>
                                    <input type="text" name="deviceUserId" maxlength="20"/>
                                </td>
                                <th><spring:message code='device.column.devicePassword'/></th>
                                <td>
                                    <input type="password" name="devicePassword" maxlength="50"/>
                                </td>
                            </tr>
                            <tr>
                                <th><spring:message code='device.column.mainFlag'/></th>
                                <td>
                                    <div class="checkbox_set csl_style03">
                                        <input type="hidden" name="mainFlag" value="N"/>
                                        <input type="checkbox" id="mainFlagCB" onchange="setCheckBoxYn(this,'mainFlag')"/>
                                        <label></label>
                                    </div>
                                </td>
                                <th><spring:message code='device.column.streamServerUrl'/></th>
                                <td>
                                    <input type="text" name="streamServerUrl" readonly="readonly"/>
                                </td>
                            </tr>
                            <tr>
                                <th><spring:message code='device.column.subUrl'/></th>
                                <td colspan="3">
                                    <input type="text" name="subUrl" maxlength="200"/>
                                </td>
                            </tr>
                            <tr>
                                <th><spring:message code='device.column.linkUrl'/></th>
                                <td colspan="3" class="intd">
                                    <div>
                                        <input type="text" name="linkUrl" maxlength="200"/>
                                        <button class="btn" style="" onclick="javascript:window.open($(this).prev().val(), '_blank'); return false;"><spring:message code='device.button.move'/></button>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th><spring:message code='device.column.deviceDesc'/></th>
                                <td class="point" colspan="3">
                                    <textarea name="deviceDesc" class="textboard"></textarea>
                                </td>
                            </tr>
                            <tr modifyTag>
                                <th><spring:message code="common.column.insertUser"/></th>
                                <td name="insertUserName"></td>
                                <th><spring:message code="common.column.insertDatetime"/></th>
                                <td name="insertDatetime"></td>
                            </tr>
                            <tr modifyTag>
                                <th><spring:message code="common.column.updateUser"/></th>
                                <td name="updateUserName"></td>
                                <th><spring:message code="common.column.updateDatetime"/></th>
                                <td name="updateDatetime"></td>
                            </tr>
                        </tbody>
                    </table>
                    <!-- 입력 테이블 End -->
                </div>

                <div class="table_btn_set">
                    <button class="btn" name="addBtn" onclick="javascript:resourceHelper.submit('device','add'); return false;"><spring:message code="common.button.add"/></button>
                    <button class="btn" name="saveBtn" onclick="javascript:resourceHelper.submit('device','save'); return false;"><spring:message code="common.button.save"/></button>
                    <button class="btn" name="removeBtn" onclick="javascript:resourceHelper.submit('device','remove'); return false;"><spring:message code="common.button.remove"/></button>
                </div>
            </form>
        </div>
        <!-- 장치 상세 End-->
    </article>
    <!-- 테이블 입력 / 조회 영역 End -->

    <!-- 옵션 팝업 -->
    <div class="popupbase option_pop" >
        <div>
            <div>
                <header>
                    <h2><spring:message code="resource.title.preferences"/></h2>
                    <button onclick="javascript:templateSettingPopup.closePopup();"></button>
                </header>
                <article class="opatin_list">
                    <div class="safeeye_option">
                        <input type="checkbox" />
                        <ul><li><spring:message code="resource.message.emptyOption"/></li></ul>
                    </div>
                    <div class="blinker_option">
                        <input type="checkbox" />
                        <ul><li><spring:message code="resource.message.emptyOption"/></li></ul>
                    </div>
                    <div class="detector_option">
                        <input type="checkbox" />
                        <ul><li><spring:message code="resource.message.emptyOption"/></li></ul>
                    </div>
                    <div class="safeguard_option">
                        <input type="checkbox" checked/>
                        <ul>
                            <li>
                                <span>Map View</span>
                                <select name="safeGuardMapView">
                                    <option value="online">Online Map</option>
                                    <option value="offline">Offline Map</option>
                                </select>
                            </li>
                        </ul>
                    </div>
                </article>
                <footer>
                    <button class="btn" onclick="javascript:templateSettingPopup.reset();"><spring:message code="common.button.reset"/></button>
                    <button class="btn" onclick="javascript:templateSettingPopup.save();"><spring:message code="common.button.save"/></button>
                </footer>
            </div>
        </div>
        <div class="bg option_pop_close" onclick="javascript:templateSettingPopup.closePopup();"></div>
    </div>

    <!-- MAP 설정 팝업 -->
    <div class="popupbase map_pop mapSetting">
        <div>
            <div>
                <header>
                    <h2><spring:message code="resource.title.mapSetting"/></h2>
                    <button onclick="javascript:customMapPopup.closePopup();"></button>
                </header>
                <article class="map_sett_box">
                    <section id="customMapSection" class="map">
                        <div>
                            <div id="mapElement" class="map_images"></div>
                            <div class="fencebtn_set">
                                <button class="btn-pdel" onclick="javascript:customMapPopup.removePointFence();"></button>
                                <button class="btn-canc" onclick="javascript:customMapPopup.resetAddFenceInfo();"></button>
                            </div>
                        </div>
                        <div>
                            <select id="fileId">
                                <option value=""><spring:message code="common.column.selectNo"/></option>
                            </select>
                            <span>X1</span>
                            <input name="x1" type="number" onkeypress="isNumberWithPoint(this);"/>
                            <span>Y1</span>
                            <input name="y1" type="number" onkeypress="isNumberWithPoint(this);"/>
                            <span>X2</span>
                            <input name="x2" type="number" onkeypress="isNumberWithPoint(this);"/>
                            <span>Y2</span>
                            <input name="y2" type="number" onkeypress="isNumberWithPoint(this);"/>
                        </div>
                    </section>
                    <section class="list">
                        <h3 id="areaName"></h3>
                        <div>
                            <p><spring:message code="resource.column.resourceTarget"/></p>
                            <p><spring:message code="resource.column.useYn"/></p>
                        </div>
                        <ul id="childList"></ul>
                        <div class="fenceset_popup">
                            <div></div>
                        </div>
                    </section>
                </article>
                <footer>
                    <button class="btn" onclick="javascript:customMapPopup.save();"><spring:message code="common.button.save"/></button>
                </footer>
            </div>
        </div>
        <div class="bg option_pop_close" onclick="javascript:customMapPopup.closePopup();"></div>
    </div>

    <!-- PTZ 제어 팝업 -->
    <div class="popupbase map_pop ptzControl">
        <div>
            <div>
                <header>
                    <h2><spring:message code="resource.title.ptzControl"/></h2>
                    <button onclick="javascript:ptzControlPopup.closePopup();"></button>
                </header>
                <article class="map_sett_box">
                    <section class="onvif">
                        <video></video>
                    </section>
                    <section class="controls">
                        <h3 id="deviceName"></h3>
                        <div>
                            <div class="direction_set">
                                <button onmousedown="javascript:ptzControlPopup.operation('leftTop',true);" onmouseup="javascript:ptzControlPopup.stopOperation();"></button> <!-- 1 좌상단-->
                                <button onmousedown="javascript:ptzControlPopup.operation('top',true);" onmouseup="javascript:ptzControlPopup.stopOperation();"></button> <!-- 2 상단-->
                                <button onmousedown="javascript:ptzControlPopup.operation('rightTop',true);" onmouseup="javascript:ptzControlPopup.stopOperation();"></button> <!-- 3 우상단-->
                                <button onmousedown="javascript:ptzControlPopup.operation('left',true);" onmouseup="javascript:ptzControlPopup.stopOperation();"></button> <!-- 4 좌-->
                                <button onmousedown="javascript:ptzControlPopup.operation('right',true);" onmouseup="javascript:ptzControlPopup.stopOperation();"></button> <!-- 5 우-->
                                <button onmousedown="javascript:ptzControlPopup.operation('leftBottom',true);" onmouseup="javascript:ptzControlPopup.stopOperation();"></button> <!-- 6 좌하단-->
                                <button onmousedown="javascript:ptzControlPopup.operation('bottom',true);" onmouseup="javascript:ptzControlPopup.stopOperation();"></button> <!-- 7 하단-->
                                <button onmousedown="javascript:ptzControlPopup.operation('rightBottom',true);" onmouseup="javascript:ptzControlPopup.stopOperation();"></button> <!-- 8 우하단-->
                                <span></span>
                            </div>

                            <div class="function_set">
                                <div class="zoom"> <!-- 줌인/아웃 -->
                                    <button onclick="javascript:ptzControlPopup.operation('zoomIn');"></button> <!-- Zoom IN -->
                                    <button onclick="javascript:ptzControlPopup.operation('zoomOut');"></button> <!-- Zoom OUT -->
                                </div>
                                <div class="focus"> <!-- 포커스 인/아웃 -->
                                    <button onclick="javascript:ptzControlPopup.operation('focusIn');"></button> <!-- 포커스 IN -->
                                    <button onclick="javascript:ptzControlPopup.operation('focusOut');"></button> <!-- 포커스 OUT -->
                                </div>
                            </div>
                        </div>
                        <ul id="presetElement"></ul>
                    </section>
                </article>
            </div>
        </div>
        <div class="bg option_pop_close" onclick="javascript:ptzControlPopup.closePopup();"></div>
    </div>
</section>

<script type="text/javascript">
    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');
    var resourceHelper = new ResourceHelper(String('${rootPath}'));
    var templateSettingPopup = new TemplateSettingPopup(String('${rootPath}'));
    var customMapPopup = new CustomMapPopup(String('${rootPath}'),String('${version}'));
    var ptzControlPopup = new PtzControlPopup(String('${rootPath}'), String('${ptzWebSocketUrl}'));

    var messageConfig = {
        // 공통
        addConfirmMessage         :'<spring:message code="common.message.addConfirm"/>'
        ,   saveConfirmMessage    :'<spring:message code="common.message.saveConfirm"/>'
        ,   removeConfirmMessage  :'<spring:message code="common.message.removeConfirm"/>'
        // 구역
        ,   addAreaComplete       :'<spring:message code="area.message.addComplete"/>'
        ,   saveAreaComplete      :'<spring:message code="area.message.saveComplete"/>'
        ,   removeAreaComplete    :'<spring:message code="area.message.removeComplete"/>'
        ,   addAreaFailure        :'<spring:message code="area.message.addFailure"/>'
        ,   addOverflowFailure    :"<spring:message code='area.message.addOverflowFailure'/>"
        ,   saveAreaFailure       :'<spring:message code="area.message.saveFailure"/>'
        ,   removeAreaFailure     :'<spring:message code="area.message.removeFailure"/>'
        ,   requiredAreaName      :"<spring:message code='area.message.requiredAreaName'/>"
        ,   areaDetailFailure     :"<spring:message code='area.message.detailFailure'/>"
        // 장치
        ,   addDeviceComplete     :'<spring:message code="device.message.addComplete"/>'
        ,   saveDeviceComplete    :'<spring:message code="device.message.saveComplete"/>'
        ,   removeDeviceComplete  :'<spring:message code="device.message.removeComplete"/>'
        ,   addDeviceFailure      :'<spring:message code="device.message.addFailure"/>'
        ,   saveDeviceFailure     :'<spring:message code="device.message.saveFailure"/>'
        ,   removeDeviceFailure   :'<spring:message code="device.message.removeFailure"/>'
        ,   deviceDetailFailure   :"<spring:message code='device.message.detailFailure'/>"
        ,   requiredSerialNo      :"<spring:message code='device.message.requiredSerialNo'/>"
        ,   requiredDeviceName    :"<spring:message code='device.message.requiredDeviceName'/>"
        ,   existsSerialNo        :"<spring:message code='device.message.existsSerialNo'/>"
        ,   requiredM8            :"<spring:message code='device.message.requiredM8'/>"
        ,   requiredQnServer      :"<spring:message code='device.message.requiredQnServer'/>"
        ,   onlyOneServer         :"<spring:message code='device.message.onlyOneServer'/>"
        ,   expireLicense         :"<spring:message code='common.message.expireLicense'/>"
        ,   excessLicense         :"<spring:message code='common.message.excessLicense'/>"
    };

    var templateSettingMessageConfig = {
        listFailure             :'<spring:message code="resource.message.listFailure"/>'
        ,   saveConfirmMessage  :'<spring:message code="common.message.saveConfirm"/>'
        ,   saveComplete        :'<spring:message code="common.message.saveComplete"/>'
        ,   saveFailure         :'<spring:message code="area.message.saveFailure"/>'
    };

    var customMapMessageConfig = {
        listFailure             :'<spring:message code="resource.message.listFailure"/>'
        ,   customMapSupport    :'<spring:message code="resource.message.customMapSupport"/>'
        ,   fenceNotEnough      :'<spring:message code="resource.message.fenceNotEnough"/>'
        ,   settingsInUsed      :'<spring:message code="resource.message.settingsInUsed"/>'
        ,   saveConfirmMessage  :'<spring:message code="common.message.saveConfirm"/>'
        ,   saveComplete        :'<spring:message code="common.message.saveComplete"/>'
        ,   saveFailure         :'<spring:message code="common.message.saveFailure"/>'
    };

    $(document).ready(function(){
        resourceHelper.setMessageConfig(messageConfig);
        resourceHelper.refreshList();

        templateSettingPopup.setMessageConfig(templateSettingMessageConfig);
        templateSettingPopup.setElement($(".option_pop"));
        templateSettingPopup.reset();

        ptzControlPopup.setElement($(".ptzControl"));

        customMapPopup.setMessageConfig(customMapMessageConfig);
        customMapPopup.setElement($(".mapSetting"));
        customMapPopup.initFileList();

        $("#customMapSection").find("input[type='number']").on("change",function(){
            customMapPopup.setTargetValue(this);
        });
        $(".tree_tab_btn > button:eq(0)").trigger("click");
    });

    function moveTab(tabId){
        var targetClass = null;

        switch (tabId){
            case "area" :
                targetClass = '.tab_area';
                break;
            case "device" :
                targetClass = '.tab_device';
                break;
        }

        if(targetClass && !$(targetClass).hasClass("on")){
            $(".tree_tab_btn > button").removeClass("on");
            $(".tree_tab_set > .area_tree_set").removeClass("on");
            $(targetClass).addClass("on");
        }
    }

    function allView(_this){
        $(_this).toggleClass("on");

        if($(_this).hasClass("on")){
            $(_this).parent().find("input[type='checkbox']").prop('checked', true);
        }else{
            $(_this).parent().find("input[type='checkbox']").prop('checked', false);
        }
    }
</script>