<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set value="100000" var="menuId"/>
<c:set value="100000" var="subMenuId"/>

<script type="text/javascript" src="${rootPath}/assets/js/page/dashboard/dashboard-helper.js?version=${version}"></script>
<script src="${rootPath}/assets/library/tree/jquery.dynatree.js?version=${version}" type="text/javascript" ></script>
<script src="${rootPath}/assets/library/svg/jquery.svg.js?version=${version}" type="text/javascript" ></script>
<script src="${rootPath}/assets/library/svg/jquery.svgdom.js?version=${version}" type="text/javascript" ></script>

<div class="sub_title_area">
    <h3>
        <c:if test="${area.areaId!=null}">
            ${area.areaName}
        </c:if>
        <c:if test="${area.areaId==null}">
            <isaver:menu menuId="${menuId}" />
        </c:if>
    </h3>

    <nav class="navigation">
        <%--<span onclick="javascript:moveDashboard(); return false;">DASHBOARD</span>--%>
        <span onclick="javascript:moveDashboard(); return false;"><isaver:menu menuId="${menuId}" /></span>
        <c:choose>
            <c:when test="${navList != null and fn:length(navList) > 0}">
                <c:forEach var="navArea" items="${navList}">
                    <span onclick="javascript:moveDashboard('${navArea.areaId}'); return false;">${navArea.areaName}</span>
                </c:forEach>
            </c:when>
        </c:choose>
    </nav>

    <div class="checkbox_set csl_style01">
        <input type="checkbox" name="notificationShowOnly" onClick="javascript:dashboardHelper.setNotificationOption(String('${empty area.areaId?'100000':area.areaId}'),this);" />
        <label></label>
        <span><spring:message code="dashboard.column.notificationShowOnly"/></span>
    </div>

    <%--<div class="expl">--%>
        <%--<c:forEach var="critical" items="${criticalList}">--%>
            <%--<span>${critical.codeName}</span>--%>
        <%--</c:forEach>--%>
    <%--</div>--%>
</div>

<c:set var="areaCntClass" value=""/>
<c:choose>
    <c:when test="${fn:length(childAreas)==1}">
        <c:set var="areaCntClass" value="area01"/>
    </c:when>
    <c:when test="${fn:length(childAreas)==2}">
        <c:set var="areaCntClass" value="area02"/>
        <c:if test="${mainTarget.targetId=='pnit'}">
            <c:set var="areaCntClass" value="area02 warea02"/>
        </c:if>
    </c:when>
    <c:when test="${fn:length(childAreas)>=3 and fn:length(childAreas)<=4}">
        <c:set var="areaCntClass" value="area04"/>
    </c:when>
    <c:when test="${fn:length(childAreas)>=5 and fn:length(childAreas)<=6}">
        <c:set var="areaCntClass" value="area06"/>
    </c:when>
    <c:when test="${fn:length(childAreas)>=7 and fn:length(childAreas)<=8}">
        <c:set var="areaCntClass" value="area08"/>
    </c:when>
    <c:when test="${fn:length(childAreas)>=9}">
        <c:set var="areaCntClass" value="area09"/>
    </c:when>
</c:choose>

<!-- 구역이 9개 이하 일때 구역레이아웃 변경 design.js "구역 개수에 따른 레이아웃 변경"-->
<section class="watch_area ${areaCntClass}">
    <!-- 더보기, 검색 로딩 바 -->
    <section id="areaLoading" class="loding_bar"></section>

    <c:choose>
        <c:when test="${childAreas != null and fn:length(childAreas) > 0}">
            <!--
            Template Code 분기
            TMP001 : 신호등 (default)
            TMP002 : Safe-Eye
            TMP003 : Blinker
            TMP004 : Detector
            TMP005 : Safe-Guard
            TMP008 : 화장실재실
            -->
            <c:forEach var="childArea" items="${childAreas}">
                <c:if test="${childArea.templateCode=='TMP001'}">
                    <!-- Default 신호등 -->
                    <div templateCode="${childArea.templateCode}" areaId="${childArea.areaId}" childAreaIds="${childArea.childAreaIds}">
                        <header>
                            <h3>${childArea.areaName}</h3>
                            <!-- 구역 하나로 확장 area -->
                            <button class="one-screen" onclick="javascript:moveDashboard('${area.areaId}','${childArea.areaId}'); return false;" title="ONE SCREEN"></button>
                            <c:if test="${childArea.childAreaIds!=null}">
                                <!-- 구역에 구역이 존재할 때 area -->
                                <button class="area" onclick="javascript:moveDashboard('${childArea.areaId}'); return false;" title="AREA VIEW"></button>
                            </c:if>
                            <c:if test="${childArea.devices!=null and fn:length(childArea.devices) > 0}">
                                <button class="device_view" title="Device Status" onClick="javascript:openDeviceList(this);"></button>
                            </c:if>
                        </header>
                        <article>
                            <section class="treffic_set">
                                <div class="s_lbox">
                                    <div class="treffic">
                                        <c:forEach var="critical" items="${criticalList}">
                                            <div class="ts-${criticalLevelCss[critical.codeId]}" criticalLevel="${critical.codeId}"><p></p></div>
                                        </c:forEach>
                                    </div>
                                </div>
                                <div class="device_box">
                                    <div class="device_set">
                                        <c:forEach var="device" items="${childArea.devices}">
                                            <div deviceId="${device.deviceId}" class='${deviceCodeCss[device.deviceCode]}<c:if test="${device.deviceStat=='N'}"> level-die</c:if>'>
                                                <p>${device.deviceName}</p>
                                                <p></p>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </section>
                            <div class="m_marqueebox">
                                <!-- <span>에 내용 삽입 -->
                                <p messageBox></p>
                            </div>
                        </article>
                    </div>
                </c:if>

                <c:if test="${childArea.templateCode=='TMP002'}">
                    <!-- Safe-Eye -->
                    <div templateCode="${childArea.templateCode}" class="type-list" areaId="${childArea.areaId}">
                        <header>
                            <h3>${childArea.areaName}</h3>
                            <!-- 구역 하나로 확장 area -->
                            <button class="one-screen" onclick="javascript:moveDashboard('${area.areaId}','${childArea.areaId}'); return false;" title="ONE SCREEN"></button>
                            <c:if test="${childArea.childAreaIds!=null}">
                                <!-- 구역에 구역이 존재할 때 area -->
                                <button class="area" childAreaIds="${childArea.childAreaIds}" onclick="javascript:moveDashboard('${childArea.areaId}'); return false;" title="AREA VIEW"></button>
                            </c:if>
                            <c:if test="${childArea.devices!=null and fn:length(childArea.devices) > 0}">
                                <button class="device_view" title="Device Status" onClick="javascript:openDeviceList(this);"></button>
                            </c:if>
                        </header>
                        <article>
                            <section class="safeeye_set">
                                <div class="s_lbox ico-invasion"></div>
                                <div class="device_box">
                                    <div class="device_set">
                                        <c:forEach var="device" items="${childArea.devices}">
                                            <div deviceId="${device.deviceId}" class='${deviceCodeCss[device.deviceCode]}<c:if test="${device.deviceStat=='N'}"> level-die</c:if>'>
                                                <p>${device.deviceName}</p>
                                                <p></p>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </section>
                            <div class="m_marqueebox">
                                <!-- <span>에 내용 삽입 -->
                                <p messageBox></p>
                            </div>
                        </article>
                    </div>
                </c:if>

                <c:if test="${childArea.templateCode=='TMP003'}">
                    <!-- Blinker -->
                    <div class="type-list">
                        <header>
                            <h3>${childArea.areaName}</h3>
                            <button class="ioset" title="진출입 설정" onclick="javascript:openInoutConfigListPopup('${childArea.areaId}'); return false;"></button>
                            <!-- 구역 하나로 확장 area -->
                            <button class="one-screen" onclick="javascript:moveDashboard('${area.areaId}','${childArea.areaId}'); return false;" title="ONE SCREEN"></button>
                            <c:if test="${childArea.childAreaIds!=null}">
                                <!-- 구역에 구역이 존재할 때 area -->
                                <button class="area" childAreaIds="${childArea.childAreaIds}" onclick="javascript:moveDashboard('${childArea.areaId}'); return false;" title="AREA VIEW"></button>
                            </c:if>
                            <c:if test="${childArea.devices!=null and fn:length(childArea.devices) > 0}">
                                <button class="device_view" title="Device Status" onClick="javascript:openDeviceList(this);"></button>
                            </c:if>
                        </header>
                        <article>
                            <c:if test="${mainTarget.targetId=='taekwon'}">
                                <section class="personnel_set">
                                    <div templateCode="${childArea.templateCode}" areaId="${childArea.areaId}" class="kblinker_set">
                                        <p class="title">
                                            <em>${childArea.areaName}</em>
                                            <em><spring:message code="dashboard.title.taekwonOutCount"/></em>
                                        </p>
                                        <p out class="out">0</p>
                                    </div>
                                </section>
                                <section class="chart_area">
                                    <div class="chart_select_set" inoutChart dateSelType="${childArea.areaId}">
                                        <button value="day" class="on" href="#" onclick="javascript:dateSelTypeClick('${childArea.areaId}', this); return false;"><spring:message code="common.column.day"/></button>
                                        <button value="week" href="#" onclick="javascript:dateSelTypeClick('${childArea.areaId}', this); return false;"><spring:message code="common.column.week"/></button>
                                        <button value="month" href="#" onclick="javascript:dateSelTypeClick('${childArea.areaId}', this); return false;"><spring:message code="common.column.month"/></button>
                                        <button value="year" href="#" onclick="javascript:dateSelTypeClick('${childArea.areaId}', this); return false;"><spring:message code="common.column.year"/></button>
                                    </div>
                                    <div class="chart_box chart01" chartAreaId="${childArea.areaId}"></div>
                                </section>
                            </c:if>
                            <c:if test="${mainTarget.targetId!='taekwon'}">
                                <section class="blinker_set">
                                    <!--
                                    s_lbox : 왼쪽 컨텐츠 삽입 영역
                                    s_rbox : 오른쪽 컨텐츠 리스트 삽입영역
                                    -->
                                    <!-- 대표 지정 진출입 -->
                                    <div class="s_lbox">
                                        <div class="inout">
                                            <h4><spring:message code="dashboard.column.blinkerSum"/></h4>
                                            <div valueType="sum" sumAreaId="${childArea.areaId}">
                                                <p gap>0</p>
                                                <div>
                                                    <p in>0</p>
                                                    <p out>0</p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <c:choose>
                                        <c:when test="${childArea.areas != null and fn:length(childArea.areas) > 0}">
                                            <c:set var="childBlinker" value="0"/>
                                            <c:forEach var="area" items="${childArea.areas}">
                                                <c:if test="${area.templateCode=='TMP003'}">
                                                    <c:set var="childBlinker" value="1"/>
                                                </c:if>
                                            </c:forEach>
                                            <c:if test="${childBlinker==1}">
                                                <div class="s_rbox ">
                                                <!-- 스크롤 영역 시작 -->
                                                <ul data-duplicated='true' data-direction='up'>
                                            </c:if>
                                            <li class="inout current_view">
                                                <h3>${childArea.areaName}</h3>
                                                <div sumAreaId="${childArea.areaId}" templateCode="${childArea.templateCode}" areaId="${childArea.areaId}">
                                                    <p gap>0</p>
                                                    <div>
                                                        <p in>0</p>
                                                        <p out>0</p>
                                                    </div>
                                                </div>
                                            </li>
                                            <c:forEach var="area" items="${childArea.areas}">
                                                <c:if test="${area.templateCode=='TMP003'}">
                                                    <li class="inout">
                                                        <h3>${area.areaName}</h3>
                                                        <div sumAreaId="${childArea.areaId}" templateCode="${area.templateCode}" areaId="${area.areaId}">
                                                            <p gap>0</p>
                                                            <div>
                                                                <p in>0</p>
                                                                <p out>0</p>
                                                            </div>
                                                        </div>
                                                    </li>
                                                </c:if>
                                            </c:forEach>
                                            <c:if test="${childBlinker==1}">
                                                </ul>
                                                <!-- 스크롤 영역 끝 -->
                                                </div>
                                            </c:if>
                                        </c:when>
                                    </c:choose>
                                    <div class="device_box">
                                        <div class="device_set">
                                            <c:forEach var="device" items="${childArea.devices}">
                                                <div deviceId="${device.deviceId}" class='${deviceCodeCss[device.deviceCode]}<c:if test="${device.deviceStat=='N'}"> level-die</c:if>'>
                                                    <p>${device.deviceName}</p>
                                                    <p></p>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </section>
                                <div class="m_marqueebox">
                                    <!-- <span>에 내용 삽입 -->
                                    <p messageBox></p>
                                </div>
                            </c:if>
                        </article>
                    </div>
                </c:if>

                <c:if test="${childArea.templateCode=='TMP004'}">
                    <!-- Detector -->
                    <div templateCode="${childArea.templateCode}" class="type-list" areaId="${childArea.areaId}">
                        <header>
                            <h3>${childArea.areaName}</h3>
                            <!-- 구역 하나로 확장 area -->
                            <button class="one-screen" onclick="javascript:moveDashboard('${area.areaId}','${childArea.areaId}'); return false;" title="ONE SCREEN"></button>
                            <c:if test="${childArea.childAreaIds!=null}">
                                <!-- 구역에 구역이 존재할 때 area -->
                                <button class="area" childAreaIds="${childArea.childAreaIds}" onclick="javascript:moveDashboard('${childArea.areaId}'); return false;" title="AREA VIEW"></button>
                            </c:if>
                            <c:if test="${childArea.devices!=null and fn:length(childArea.devices) > 0}">
                                <button class="device_view" title="Device Status" onClick="javascript:openDeviceList(this);"></button>
                            </c:if>
                        </header>
                        <article>
                            <section class="detector_set">
                                <div class="s_lbox">
                                    <div class="chart_select_set" dateSelType="${childArea.areaId}">
                                        <button value="day" class="on" href="#" onclick="javascript:dateSelTypeClick('${childArea.areaId}', this); return false;"><spring:message code="common.column.day"/></button>
                                        <button value="week" href="#" onclick="javascript:dateSelTypeClick('${childArea.areaId}', this); return false;"><spring:message code="common.column.week"/></button>
                                        <button value="month" href="#" onclick="javascript:dateSelTypeClick('${childArea.areaId}', this); return false;"><spring:message code="common.column.month"/></button>
                                        <button value="year" href="#" onclick="javascript:dateSelTypeClick('${childArea.areaId}', this); return false;"><spring:message code="common.column.year"/></button>
                                    </div>
                                    <div class="chart_box chart01" chartAreaId="${childArea.areaId}"></div>
                                </div>
                                <div class="device_box">
                                    <div detectorDeviceList class="device_set">
                                        <c:forEach var="device" items="${childArea.devices}">
                                            <div deviceId="${device.deviceId}" areaId="${childArea.areaId}" class='${deviceCodeCss[device.deviceCode]}<c:if test="${device.deviceStat=='N'}"> level-die</c:if>'>
                                                <p>${device.deviceName}</p>
                                                <p evtValue>
                                                    <c:if test="${device.evtValue!=null}">
                                                        <fmt:formatNumber value="${device.evtValue}" type="pattern" pattern="0.00" />
                                                    </c:if>
                                                    <c:if test="${device.evtValue==null}">
                                                        -
                                                    </c:if>
                                                </p>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </section>
                            <div class="m_marqueebox">
                                <!-- <span>에 내용 삽입 -->
                                <p messageBox></p>
                            </div>
                        </article>
                    </div>
                </c:if>

                <c:if test="${childArea.templateCode=='TMP005'}">
                    <!-- Safe-Guard -->
                    <div templateCode="${childArea.templateCode}" class="type-list bmt" areaId="${childArea.areaId}" areaDesc="${childArea.areaDesc}">
                        <header>
                            <h3>${childArea.areaName}</h3>
                            <!-- 구역 하나로 확장 area -->
                            <button class="one-screen" onclick="javascript:moveDashboard('${area.areaId}','${childArea.areaId}'); return false;" title="ONE SCREEN"></button>
                            <c:if test="${childArea.childAreaIds!=null}">
                                <!-- 구역에 구역이 존재할 때 area -->
                                <button class="area" childAreaIds="${childArea.childAreaIds}" onclick="javascript:moveDashboard('${childArea.areaId}'); return false;" title="AREA VIEW"></button>
                            </c:if>
                            <c:if test="${childArea.devices!=null and fn:length(childArea.devices) > 0}">
                                <button class="device_view" title="Device Status" onClick="javascript:openDeviceList(this);"></button>
                            </c:if>
                        </header>
                        <article>
                            <section class="guard_set">
                                <div class="s_lbox">
                                    <button class="check_btn_menu" onclick="javascript:$(this).toggleClass('on');">
                                        <input type="checkbox" name="">
                                        <label></label>
                                    </button>

                                    <div class="check_btn_set">
                                        <div class="range_check">
                                            <input type="checkbox" name="lidarCkb" onClick="javascript:dashboardHelper.setGuardOption('lidarHide','${childArea.areaId}',this);">
                                            <label></label>
                                        </div>
                                        <div class="human_check">
                                            <input type="checkbox" name="humanCkb" onClick="javascript:dashboardHelper.setGuardOption('objectView','${childArea.areaId}',this);">
                                            <label></label>
                                        </div>
                                        <div class="object_check">
                                            <input type="checkbox" name="pointsCkb" onClick="javascript:dashboardHelper.setGuardOption('pointsHide','${childArea.areaId}',this);">
                                            <label></label>
                                        </div>
                                        <div class="fence_check">
                                            <input type="checkbox" name="moveFenceCkb" onClick="javascript:dashboardHelper.setGuardOption('moveFenceHide','${childArea.areaId}',this);">
                                            <label></label>
                                        </div>
                                    </div>
                                    <div name="map-canvas" class="map_images"></div>
                                    <div name="copyboxElement" class="copybox_area"></div>
                                </div>
                                <div class="s_rbox">
                                    <ul ptzPlayers></ul>
                                </div>
                                <div class="device_box">
                                    <div class="device_set">
                                        <c:forEach var="device" items="${childArea.devices}">
                                            <div deviceId="${device.deviceId}" class='${deviceCodeCss[device.deviceCode]}<c:if test="${device.deviceStat=='N'}"> level-die</c:if>'
                                                 data-device-id="${device.deviceId}"
                                                 data-device-code="${device.deviceCode}"
                                                 data-ip-address="${device.ipAddress}"
                                                 data-port="${device.port}"
                                                 data-device-user-id="${device.deviceUserId}"
                                                 data-device-password="${device.devicePassword}"
                                                 data-sub-url="${device.subUrl}"
                                                 data-link-url="${device.linkUrl}"
                                                 data-stream-server-url="${device.streamServerUrl}"
                                                 data-device-stat="${device.deviceStat}"
                                                 data-device-name="${device.deviceName}"
                                                    >
                                                <p>${device.deviceName}</p>
                                                <p></p>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </section>
                            <div class="m_marqueebox">
                                <!-- <span>에 내용 삽입 -->
                                <p messageBox></p>
                            </div>
                        </article>
                    </div>
                </c:if>

                <c:if test="${childArea.templateCode=='TMP008'}">
                    <!-- Safe-Guard -->
                    <div templateCode="${childArea.templateCode}" class="type-list" areaId="${childArea.areaId}">
                        <header>
                            <h3>${childArea.areaName}</h3>
                            <!-- 구역 하나로 확장 area -->
                            <button class="one-screen" onclick="javascript:moveDashboard('${area.areaId}','${childArea.areaId}'); return false;" title="ONE SCREEN"></button>
                            <c:if test="${childArea.childAreaIds!=null}">
                                <!-- 구역에 구역이 존재할 때 area -->
                                <button class="area" childAreaIds="${childArea.childAreaIds}" onclick="javascript:moveDashboard('${childArea.areaId}'); return false;" title="AREA VIEW"></button>
                            </c:if>
                            <c:if test="${childArea.devices!=null and fn:length(childArea.devices) > 0}">
                                <button class="device_view" title="Device Status" onClick="javascript:openDeviceList(this);"></button>
                            </c:if>
                        </header>
                        <article>
                            <section class="entrance_set">
                                <!-- 클라우드 이미지-->
                                <button class="ir_btn" onclick="javascript:openAuthorizePopup(this,'${childArea.areaId}');"></button>
                                <div class="s_lbox">
                                    <canvas name="toiletRoom-canvas"></canvas>
                                </div>
                                <!-- 재실정보 이미지-->
                                <div class="s_rbox">
                                    <div id="statusIco" class="entrance_ico"></div>
                                    <h3>${childArea.areaName}</h3>
                                    <div class="c_time">
                                        <p id="eventDatetime">00:00:00</p>
                                        <button name="resetEventBtn" onclick="javascript:dashboardHelper.toiletRoomSendMessage({messageType:'resetEvent',areaId:'${childArea.areaId}'});"></button>
                                    </div>
                                </div>
                                <div class="device_box">
                                    <div class="device_set">
                                        <c:forEach var="device" items="${childArea.devices}">
                                            <div deviceId="${device.deviceId}" class='${deviceCodeCss[device.deviceCode]}<c:if test="${device.deviceStat=='N'}"> level-die</c:if>'
                                                 data-device-id="${device.deviceId}"
                                                 data-device-code="${device.deviceCode}"
                                                 data-ip-address="${device.ipAddress}"
                                                 data-port="${device.port}"
                                                 data-device-user-id="${device.deviceUserId}"
                                                 data-device-password="${device.devicePassword}"
                                                 data-sub-url="${device.subUrl}"
                                                 data-link-url="${device.linkUrl}"
                                                 data-stream-server-url="${device.streamServerUrl}"
                                                 data-device-stat="${device.deviceStat}"
                                                 data-device-name="${device.deviceName}"
                                                    >
                                                <p>${device.deviceName}</p>
                                                <p></p>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </section>
                            <div class="m_marqueebox">
                                <!-- <span>에 내용 삽입 -->
                                <p messageBox></p>
                            </div>
                        </article>
                    </div>
                </c:if>
            </c:forEach>
        </c:when>
    </c:choose>
</section>

<section class="popup-layer">
    <div class="popupbase iocount_popup">
        <div>
            <div>
                <header>
                    <h2><spring:message code="dashboard.title.inoutSetting"/></h2>
                    <button class="close_btn" onclick="javascript:closeInoutConfigListPopup();"></button>
                </header>
                <article>
                    <!-- 진출입 트리보기 센션 -->
                    <section>
                        <div class="tree_table">
                            <div class="table_title_area">
                                <div class="table_btn_set">
                                    <button class="btn" id="expandShow" onclick="javascript:areaTreeExpandAll(true); return false;"><spring:message code='common.button.viewTheFull'/></button>
                                    <button class="btn" id="expandClose" style="display:none;" onclick="javascript:areaTreeExpandAll(false); return false;"><spring:message code='common.button.viewTheFullClose'/></button>
                                </div>
                            </div>
                            <div class="table_contents">
                                <div id="menuTreeArea" class="tree_box">
                                    <ul class="dynatree-container dynatree-no-connector">
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </section>

                    <!-- 진출입 설정 셋션 -->
                    <section>
                        <ul class="u_defalut time_set_type iotime_set">
                            <c:forEach begin="0" end="5" varStatus="mainLoop">
                                <li settingIndex="${mainLoop.index}">
                                    <div class="checkbox_set csl_style02">
                                        <input type="checkbox" checked="checked" <c:if test="${mainLoop.index==0}">disabled="disabled"</c:if>>
                                        <label></label>
                                    </div>
                                    <div class="timepicker">
                                        <div class="hour">
                                            <input type="number" name="format" value="00" pattern="00" placeholder="<spring:message code="common.column.hour"/>" maxlength="2" onkeyup="this.value = minMaxFunc(this.value, 0, 23)">
                                            <select onchange="this.previousElementSibling.value=this.value">
                                                <c:forEach begin="0" end="23" varStatus="loop">
                                                    <option value="<fmt:formatNumber value="${loop.index}" pattern="00" type="Number"/>"><fmt:formatNumber value="${loop.index}" pattern="00" type="Number"/><spring:message code="common.column.hour"/></option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="minute">
                                            <input type="number" name="format" value="00" pattern="00" placeholder="<spring:message code="common.column.minute"/>" maxlength="2" onkeyup="this.value = minMaxFunc(this.value, 0, 59)">
                                            <select onchange="this.previousElementSibling.value=this.value">
                                                <c:forEach begin="0" end="5" varStatus="loop">
                                                    <option value="<fmt:formatNumber value="${loop.index*10}" pattern="00" type="Number"/>"><fmt:formatNumber value="${loop.index*10}" pattern="00" type="Number"/><spring:message code="common.column.minute"/></option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="second">
                                            <input type="number" name="format" value="00" pattern="00" placeholder="<spring:message code="common.column.second"/>" maxlength="2" onkeyup="this.value = minMaxFunc(this.value, 0, 59)">
                                            <select onchange="this.previousElementSibling.value=this.value">
                                                <c:forEach begin="0" end="5" varStatus="loop">
                                                    <option value="<fmt:formatNumber value="${loop.index*10}" pattern="00" type="Number"/>"><fmt:formatNumber value="${loop.index*10}" pattern="00" type="Number"/><spring:message code="common.column.second"/></option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <em>~</em>
                                        <input type="text" name="endTime" disabled="disabled">
                                    </div>
                                </li>
                            </c:forEach>
                        </ul>
                    </section>
                </article>

                <footer>
                    <button class="btn" onclick="javascript:saveInoutConfiguration();"><spring:message code="common.button.save"/></button>
                </footer>
            </div>
        </div>
        <div class="bg" onclick="javascript:closeInoutConfigListPopup();"></div>
    </div>

    <div class="popupbase ir_popup">
        <div>
            <div>
                <header>
                    <h2><spring:message code="dashboard.title.userAuthorize"/></h2>
                    <button class="close_btn" onclick="javascript:closeAuthorizePopup();"></button>
                </header>
                <article>
                    <section>
                        <input type="hidden" id="authrizeAreaId" />
                        <p><spring:message code="dashboard.column.password"/></p>
                        <input type="password" id="authrizePassword" />
                    </section>
                </article>
                <footer>
                    <button class="btn" onclick="javascript:confirmAuthorize();"><spring:message code="common.button.confirm"/></button>
                </footer>
            </div>
        </div>
        <div class="bg" onclick="javascript:closeAuthorizePopup();"></div>
    </div>
</section>

<%-- VXG Player를 통한 RTSP Stream --%>
<%--<link type="text/css" href="${rootPath}/assets/library/vxg/vxgplayer-1.8.23.min.css?version=${version}" rel="stylesheet"/>--%>
<%--<script type="text/javascript" src="${rootPath}/assets/js/page/dashboard/video-mediator_vxg.js?version=${version}"></script>--%>
<%--<script type="text/javascript" src="${rootPath}/assets/library/vxg/vxgplayer-1.8.23.js?version=${version}"></script>--%>

<%-- Medea Server를 통한 RTSP Stream --%>
<script type="text/javascript" src="${rootPath}/assets/library/webrtc-streamer/request.min.js?version=${version}"></script>
<script type="text/javascript" src="${rootPath}/assets/library/webrtc-streamer/adapter.js?version=${version}"></script>
<script type="text/javascript" src="${rootPath}/assets/library/webrtc-streamer/webrtcstreamer.js?version=${version}"></script>
<script type="text/javascript" src="${rootPath}/assets/js/page/dashboard/video-mediator.js?version=${version}"></script>

<c:if test="${templateSetting['safeGuardMapView']=='online'}">
    <script async defer src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCvOCPKPcMLaU1bYIP5QsO7HauSHTqGO6M&callback=initMap"></script>
    <script type="text/javascript">
        /**
         * Google Map Initialize
         * @param message
         */
        function initMap() {
            addAsynchronousScript("${pageContext.request.contextPath}/assets/library/googlemap/richmarker.js?version=${version}");
            addAsynchronousScript("${pageContext.request.contextPath}/assets/library/googlemap/maplabel.js?version=${version}");
            addAsynchronousScript("${pageContext.request.contextPath}/assets/library/googlemap/jquery_easing.js?version=${version}");
            addAsynchronousScript("${pageContext.request.contextPath}/assets/library/googlemap/markerAnimate.js?version=${version}");
            dashboardHelper.initAreaTemplate();
        }
    </script>
</c:if>
<script type="text/javascript" src="${rootPath}/assets/js/page/dashboard/map-mediator.js?version=${version}"></script>
<script type="text/javascript" src="${rootPath}/assets/js/page/dashboard/custom-map-mediator.js?version=${version}"></script>
<script type="text/javascript" src="${rootPath}/assets/js/page/dashboard/toilet-room-mediator.js?version=${version}"></script>

<script type="text/javascript">
    var targetMenuId = String('${empty paramBean.subAreaId?(empty paramBean.areaId?'100000':paramBean.areaId):paramBean.subAreaId}');
    var subMenuId = String('${subMenuId}');
    var chartList = {};
    var imageCheckUnload = {};
    var renderDatetime = new Date();
    var dashboardHelper = new DashboardHelper("${rootPath}","${version}");
    var fileUploadPath = '${fileUploadPath}';
    var templateSetting = {
        'safeGuardMapView' : '${templateSetting['safeGuardMapView']}'
        ,'safeGuardObjectTypeHuman' : '${templateSetting['safeGuardObjectTypeHuman']}'
        ,'safeGuardObjectTypeUnknown' : '${templateSetting['safeGuardObjectTypeUnknown']}'
    };

    /*
     url defind
     @author psb
     */
    var urlConfig = {
        inoutConfigListUrl : "${rootPath}/inoutConfiguration/list.json"
        ,chartUrl : "${rootPath}/eventLog/chart.json"
        ,saveInoutConfigurationUrl : "${rootPath}/inoutConfiguration/save.json"
        ,inoutConfigAreaTreeUrl : "${rootPath}/area/list.json"
        ,authorizeCheckUrl : "${rootPath}/authCheck.json"
    };

    var messageConfig = {
        inoutListFailure  :'<spring:message code="dashboard.message.inoutFailure"/>'
        , inoutConfigListFailure  :'<spring:message code="dashboard.message.inoutConfigListFailure"/>'
        , inoutConfigDuplication : '<spring:message code="dashboard.message.inoutConfigDuplication"/>'
        , inoutConfigEmptyArea : '<spring:message code="dashboard.message.inoutConfigEmptyArea"/>'
        , saveInoutConfigurationComplete : '<spring:message code="dashboard.message.saveInoutConfigurationComplete"/>'
        , saveInoutConfigurationFailure : '<spring:message code="dashboard.message.saveInoutConfigurationFailure"/>'
        , customMapListFailure :'<spring:message code="resource.message.customMapListFailure"/>'
        , emptyPassword : '<spring:message code="dashboard.message.emptyPassword"/>'
        , authorizeCheckFailure : '<spring:message code="dashboard.message.authorizeCheckFailure"/>'
    };

    $(window).on("beforeunload", function(){
        for(var index in imageCheckUnload){
            dashboardHelper.toiletRoomSendMessage({messageType:'imageMode',areaId:index,'imageMode':'bg'});
        }
    });

    $(document).ready(function(){
        for(var key in criticalCss){
            modifyElementClass($(".treffic_set div[criticalLevel='"+key+"']"),"ts-"+criticalCss[key],'add');
        }

        // 조회주기 체크 제어
        $(".iotime_set .checkbox_set > input[type='checkbox']").click(function(){
            if($(this).is(":checked")) {
                $(this).parent().addClass("on");
            } else {
                $(this).parent().removeClass("on");
            }
        });

        $(".iotime_set").on('change',function(){
            updateInoutSettingDatetime();
        });

        dashboardHelper.setConfig(messageConfig, fileUploadPath, templateSetting);
        dashboardHelper.setWebsocket(webSocketHelper, {'map':"${mapWebSocketUrl}",'toiletRoom':"${toiletRoomWebSocketUrl}"});
        dashboardHelper.setNotificationOption(String('${empty area.areaId?'100000':area.areaId}'));
        dashboardHelper.initAreaTemplate();
        notificationHelper.setCallBackEventHandler(dashboardHelper.appendEventHandler);

        /* 이벤트 callback (websocket 리스너) */
        addRefreshTimeCallBack(refreshInoutSetting);
        initInoutConfigAreaDynatree();
        initChartList();
    });

    function test(_areaId, _deviceId){
        if(_areaId==null){
            _areaId = "AR0000";
        }
        if(_deviceId==null){
            _deviceId = "DE0012";
        }

        if(templateSetting['safeGuardMapView']=='online'){
            webSocketHelper.sendMessage("map",{"messageType":"device","actionType":"add","areaId":_areaId,"id":"DE0000","location":[{"lat": 37.49541728092977,"lng": 127.03102138773158}]});
            webSocketHelper.sendMessage("map",{"messageType":"fence","actionType":"add","areaId":_areaId,"id":"fence1","location":[
                {"lat" : "37.495463","lng" : "127.030996"},
                {"lat" : "37.495473","lng" : "127.031013"},
                {"lat" : "37.495503","lng" : "127.030998"},
                {"lat" : "37.495493","lng" : "127.030984"}
            ]});
            webSocketHelper.sendMessage("map",{"messageType":"object","actionType":"add","areaId":_areaId,"id":"1235","location":[{"lat": "37.495463","lng": "127.031004"}]});
            webSocketHelper.sendMessage("map",{"messageType":"object","actionType":"add","areaId":_areaId,"id":"1234","location":[{"lat": "37.495493","lng": "127.030984"}]});
        }else{
            webSocketHelper.sendMessage("map",{"messageType":"object","actionType":"add","objectType":"human","areaId":_areaId,"deviceId":_deviceId,"id":"1235","location":[{"lat": "100","lng": "100"}]});
            webSocketHelper.sendMessage("map",{"messageType":"object","actionType":"add","objectType":"human","areaId":_areaId,"deviceId":_deviceId,"id":"1234","location":[{"lat": "-100","lng": "-100"}]});
        }
    }

    var id = 1;
    function testObject(_type, _lat){
        var gps = getGps();
        webSocketHelper.sendMessage("map",{"messageType":_type!=null?_type:"object","actionType":"add","areaId":gps['areaId'],"id":id++,"location":[_lat!=null?_lat:gps['center']]});
    }

    function getGps(_areaId){
        var guard;
        if(_areaId==null){
            var fullGuard = dashboardHelper.getGuard("full");
            for(var index in fullGuard){
                guard = fullGuard[index];
                _areaId = index;
                break;
            }
        }else{
            guard = dashboardHelper.getGuard("all", _areaId);
        }

        var map = guard['map'].getMap();
        return {
            'areaId' : _areaId
            ,'center' :  {
                lat : map.center.lat()
                ,lng : map.center.lng()
            }
            ,bounds : {
                north: map.getBounds().getNorthEast().lat(),
                east: map.getBounds().getNorthEast().lng(),
                south: map.getBounds().getSouthWest().lat(),
                west: map.getBounds().getSouthWest().lng()
            }
        };
    }

    function areaTreeExpandAll(flag){
        $(".iocount_popup #menuTreeArea").dynatree("getRoot").visit(function(node){
            node.expand(flag);
            if(flag){
                $("#expandClose").show();
                $("#expandShow").hide();
            }else{
                $("#expandClose").hide();
                $("#expandShow").show();
            }
        });
    }

    function openDeviceList(_this){
        var target = $(_this).parent().parent().find(".device_box");
        if($(_this).hasClass("on")){
            $(_this).removeClass("on");
            $(target).removeClass("on");
        }else{
            $(_this).addClass("on");
            $(target).addClass("on");
        }
    }

    function initChartList(){
        $(".watch_area div[detectorDeviceList] div[deviceId]").on("click",function(){
            if(!$(this).hasClass("on")){
                $(this).parent().find("> div").removeClass("on");
                $(this).addClass("on");
                findListChart($(this).attr("areaId"), $(this).attr("deviceId"));
            }
        });

        $(".watch_area div[chartAreaId]").each(function(){
           chartList[$(this).attr("chartAreaId")] = new Chartist.Line(this, {
               labels: [],
               series: [[], []]
           }, {
               low: 0,
               showArea: true,
               showLabel: true,
               fullWidth: false,
               axisY: {
                   onlyInteger: true,
                   offset: 20
               },
               lineSmooth: Chartist.Interpolation.simple({
                   divisor: 100
               }),
               plugins: [
                   ctPointLabels()
                   ,Chartist.plugins.tooltip()
               ]
           });
        });

        // Detector 초기 로딩시 처음 Device 선택
        $(".watch_area div[detectorDeviceList]").each(function(){
            $(this).find("> div:eq(0)").trigger("click");
        });

        // Blinker Chart 초기 로딩시 데이터 로드
        $("div[inoutChart][dateSelType]").each(function(){
            findListChart($(this).attr("dateSelType"), null);
        });
    }

    function dateSelTypeClick(_areaId, _this){
        if($(_this).hasClass("on")){
            return false;
        }else{
            $(_this).parent().find("button").removeClass("on");
            $(_this).addClass("on");

            findListChart(_areaId, $(".watch_area div[areaId='"+_areaId+"'] li[deviceId].on").attr("deviceId"));
        }
    }

    function initInoutConfigAreaDynatree(){
        callAjax('inoutConfigAreaTree', {delYn:'N'});
    }

    function refreshInoutSetting(_serverDatetime){
        $.each($(".watch_area div[templateCode='TMP003']"),function(){
            if(_serverDatetime.getTime() > $(this).attr("endDatetime")){
                dashboardHelper.getBlinker($(this).attr("areaId"));
            }
        });

        if(renderDatetime.format("yyyyMMdd")!=_serverDatetime.format("yyyyMMdd")){
            $.each($(".watch_area li[deviceId]"),function(){
                $(this).find("span[evtValue]").text("-");
                if($(this).hasClass("on")){
                    findListChart($(this).attr("areaId"), $(this).attr("deviceId"));
                }
            });
            renderDatetime = new Date(_serverDatetime);
        }
    }

    /**
     * 진출입 조회주기 종료시간 자동 입력
     * @author psb
     */
    function updateInoutSettingDatetime(){
        var inoutDatetimes = [];

        $.each($(".iotime_set li"),function(){
            if($(this).find("input[type='checkbox']").is(":checked")){
                var numberTags = $(this).find("input[type='number']");
                var inoutDateStr = new Date("2000-01-01 " + numberTags.eq(0).val() + ":" + numberTags.eq(1).val() + ":" + numberTags.eq(2).val());
                inoutDatetimes.push(inoutDateStr)
            }else{
                $(this).find("input[name='endTime']").val("");
            }
        });

        inoutDatetimes.sort();

        $.each($(".iotime_set li"),function(){
            if($(this).find("input[type='checkbox']").is(":checked")){
                var numberTags = $(this).find("input[type='number']");
                var hour = Number(numberTags.eq(0).val());
                if(hour>=0 && hour<10) {hour = "0" + hour;}
                var minute = Number(numberTags.eq(1).val());
                if(minute>=0 && minute<10) {minute = "0" + minute;}
                var second = Number(numberTags.eq(2).val());
                if(second>=0 && second<10) {second = "0" + second;}
                var inoutDateStr = hour + ":" + minute + ":" + second;
                var drawFlag = false;

                for(var index in inoutDatetimes){
                    if(inoutDateStr == inoutDatetimes[index].format("HH:mm:ss")){
                        var endTime = new Date(inoutDatetimes[Number(index)+1]);

                        if(!(endTime == "Invalid Date" || isNaN(endTime.getTime()))){
                            endTime.setSeconds(-1);
                            $(this).find("input[name='endTime']").val(endTime.format("HH:mm:ss"));
                            drawFlag = true;
                        }
                    }
                }

                if(!drawFlag){
                    $(this).find("input[name='endTime']").val('23:59:59');
                }
            }
        });
    }

    /**
     * 진출입 설정 팝업 열기
     * @author psb
     */
    function openInoutConfigListPopup(_areaId){
        $(".iocount_popup").attr("areaId",_areaId);
        $(".iocount_popup").fadeIn(200);

        $("#menuTreeArea").dynatree("getTree").visit(function(node){
            if(node.data.id === _areaId){
                node.activate();
                node.select();
                node.focus();
            }
        });
    }

    /**
     * 진출입 설정 팝업 닫기
     * @author psb
     */
    function closeInoutConfigListPopup(){
        $('.iocount_popup').fadeOut(200);
    }

    /**
     * 진출입 설정 구역 선택
     * @author psb
     */
    function selectInoutConfigArea(_areaId){
        callAjax('inoutConfigList',{areaId:_areaId});
    }

    /**
     * inout configuration save
     * @author psb
     */
    function saveInoutConfiguration(){
        var areaId = $(".iocount_popup").attr("areaId");

        if(areaId==null){
            console.error("[saveInoutConfiguration] areaId is null");
            alertMessage('inoutConfigEmptyArea');
            return false;
        }

        var inoutDatetimes = [];

        $.each($(".iotime_set li"),function(){
            if($(this).find("input[type='checkbox']").is(":checked")){
                var numberTags = $(this).find("input[type='number']");
                var hour = Number(numberTags.eq(0).val());
                if(hour>=0 && hour<10) {hour = "0" + hour;}
                var minute = Number(numberTags.eq(1).val());
                if(minute>=0 && minute<10) {minute = "0" + minute;}
                var second = Number(numberTags.eq(2).val());
                if(second>=0 && second<10) {second = "0" + second;}
                var inoutDateStr = hour + ":" + minute + ":" + second;

                inoutDatetimes.push(inoutDateStr+"|"+$(this).find("input[name='endTime']").val());
            }
        });

        inoutDatetimes.sort();
        if(isDuplicationArray(inoutDatetimes)){
            alertMessage('inoutConfigDuplication');
            return false;
        }

        var param = {
            'areaId' : areaId
            ,'inoutDatetimes' : inoutDatetimes.join(",")
        };
        callAjax('saveInoutConfiguration',param);
    }

    /**
     * 사용자 인증 팝업 열기
     * @author psb
     */
    function openAuthorizePopup(_this, areaId){
        if($(_this).hasClass("on")){
            dashboardHelper.toiletRoomSendMessage({messageType:'imageMode',areaId:areaId,'imageMode':'bg'});
        }else{
            $("#authrizeAreaId").val(areaId);
            $("#authrizePassword").val('');
            $(".ir_popup").fadeIn(200);

            $("#authrizePassword").bind("keyup", function(evt){
                var code = evt.keyCode || evt.which;
                if(code == 13){
                    confirmAuthorize();
                }
            });
        }
    }

    /**
     * 사용자 인증 팝업 닫기
     * @author psb
     */
    function closeAuthorizePopup(){
        $('.ir_popup').fadeOut(200);
    }

    /**
     * 사용자 인증
     * @author psb
     */
    function confirmAuthorize(){
        if($("#authrizePassword").val().trim().length==0){
            alertMessage('emptyPassword');
            return false;
        }
        var param = {
            'userPassword' : $("#authrizePassword").val()
            ,'areaId' : $("#authrizeAreaId").val()
        };
        callAjax('authorizeCheck',param);
    }

    function callAjax(actionType, data){
        sendAjaxPostRequest(urlConfig[actionType + 'Url'],data,dashBoardSuccessHandler,dashBoardFailureHandler,actionType);
    }

    /**
     * alarm success handler
     * @author psb
     * @private
     */
    function dashBoardSuccessHandler(data, dataType, actionType){
        switch(actionType){
            case 'authorizeCheck':
                if(data['result']!=null && Boolean(data['result'])){
                    dashboardHelper.toiletRoomSendMessage({messageType:'imageMode',areaId:data['paramBean']['areaId'],'imageMode':'ir'});
                    closeAuthorizePopup();
                }else{
                    alertMessage(actionType+'Failure');
                }
                break;
            case 'chart':
                chartRender(data);
                break;
            case 'inoutConfigList':
                inoutConfigListRender(data['inoutConfigList']);
                break;
            case 'saveInoutConfiguration':
                alertMessage(actionType+'Complete');
                closeInoutConfigListPopup();
                break;
            case 'inoutConfigAreaTree':
                var areaList = data['areas'];
                var _treeModel = [];
                for(var index in areaList){
                    var area = areaList[index];
                    var appendFlag = false;
                    var view = {
                        id        : String(area.areaId),
                        title     : "<span style='font-weight: bold;'>"+String(area['areaName'] + "</span> (" + area['areaId'] +")"),
                        isFolder  : false,
                        children  : []
                    };

                    for(var i in _treeModel){
                        var _parentNode = _treeModel[i];
                        if(_parentNode['id']==area['parentAreaId']){
                            _parentNode['children'].push(view);
                            appendFlag = true;
                        }
                    }

                    if(!appendFlag){
                        _treeModel.push(view);
                    }
                }

                $("#menuTreeArea").dynatree({
                    minExpandLevel: 1,
                    debugLevel: 1,
                    persist: false,
                    onPostInit: function (isReloading, isError) {
                        var myParam = location.search.split('ctrl=')[1];
                        if (myParam) {
                            if ("reload" == myParam) {
                                this.reactivate();
                            }
                        }
                    }
                    ,children: _treeModel
                    ,onActivate: function (node) {
                        var id = node.data.id;
                        $(".iocount_popup").attr("areaId",id);
                        selectInoutConfigArea(id);
                    }
                });
                break;
        }
    }

    function findListChart(_chartAreaId, _deviceId){
        var dateSelType = $("div[dateSelType='"+_chartAreaId+"'] button.on").attr("value");
        var truncType;

        switch (dateSelType){
            case 'day':
                truncType = 'hour';
                break;
            case 'week':
                truncType = 'day';
                break;
            case 'month':
                truncType = 'week';
                break;
            case 'year':
                truncType = 'month';
                break;
        }
        callAjax('chart',{areaId:_chartAreaId, deviceId:_deviceId, truncType: truncType, dateType: dateSelType});
    }

    /**
     * 진출입 조회주기 설정 Render
     */
    function inoutConfigListRender(data){
        if(data==null){
            return false;
        }

        var inoutSetTag = $(".iocount_popup .iotime_set");
        // 진출입 조회주기 설정 초기화
        inoutSetTag.find(".checkbox_set").removeClass("on");
        inoutSetTag.find("input[type='checkbox']").not(":eq(0)").prop("checked",false);
        inoutSetTag.find("input[type='number']").val(0);
        inoutSetTag.find("input[name='endTime']").val("");

        try{
            for(var index in data){
                var inout = data[index];
                var inoutDatetime = inout['inoutStarttime'].split(":");
                var settingTag = inoutSetTag.find("li[settingIndex='"+index+"']");

                if(settingTag!=null){
                    if(index>0){
                        settingTag.find(".checkbox_set").addClass("on");
                        settingTag.find("input[type='checkbox']").prop("checked",true);
                    }

                    for(var i in inoutDatetime){
                        settingTag.find("input[type='number']:eq("+i+")").val(inoutDatetime[i]);
                    }
                }
            }
        }catch(e){
            console.error("[inoutConfigListRender] parse error - "+ e.message);
        }

        updateInoutSettingDatetime();
    }

    /**
     * 차트 가공 진출입
     * @author psb
     */
    function chartRender(data) {
        var paramBean = data['paramBean'];

        if(chartList[paramBean['areaId']]==null || chartList[paramBean['areaId']] == undefined){
            return false;
        }

        if (data['eventLogChartList'] != null) {
            var eventLogChartList = data['eventLogChartList'];
            var _chartList = [];
            var _eventDateList = [];

            for(var index in eventLogChartList){
                var item = eventLogChartList[index];
                var _eventDate = new Date();
                _eventDate.setTime(item['eventDatetime']);
                _chartList.push(item['value']);
                switch (paramBean['truncType']){
                    case 'hour':
                        _eventDateList.push(_eventDate.format("HH"));
                        break;
                    case 'day':
                        _eventDateList.push(_eventDate.format("es"));
                        break;
                    case 'week':
                        _eventDateList.push(_eventDate.getWeekOfMonth()+"주");
                        break;
                    case 'month':
                        _eventDateList.push(_eventDate.format("MM"));
                        break;
                }
            }
            _chartList.reverse();
            _eventDateList.reverse();

            chartList[paramBean['areaId']].data.series[0] = _chartList;
            chartList[paramBean['areaId']].data.labels = _eventDateList;
            chartList[paramBean['areaId']].update();
        }
    }

    /*
     ajax error handler
     @author psb
     */
    function dashBoardFailureHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        if(XMLHttpRequest['status']!="0"){
            alertMessage(actionType + 'Failure');
        }
    }

    /*
     alert message method
     @author psb
     */
    function alertMessage(type){
        alert(messageConfig[type]);
    }
</script>