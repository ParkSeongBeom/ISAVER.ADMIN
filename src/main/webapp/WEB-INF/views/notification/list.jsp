<!-- 알림이력, @author psb -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<c:set value="2B0010" var="menuId"/>
<c:set value="2B0000" var="subMenuId"/>

<script src="${rootPath}/assets/js/popup/custom-map-popup.js?version=${version}" type="text/javascript" charset="UTF-8"></script>
<script src="${rootPath}/assets/library/svg/jquery.svg.js?version=${version}" type="text/javascript" ></script>
<script src="${rootPath}/assets/library/svg/jquery.svgdom.js?version=${version}" type="text/javascript" ></script>
<script src="${rootPath}/assets/js/page/dashboard/custom-map-mediator.js?version=${version}" type="text/javascript" charset="UTF-8"></script>

<script type="text/javascript" src="${rootPath}/assets/js/util/page-navigater.js"></script>

<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.notification"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><isaver:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <div class="popupbase admin_popup eventdetail_popup">
        <div>
            <div>
                <header>
                    <h2><spring:message code="notification.column.cancelDesc"/></h2>
                    <button onclick="javascript:closeCancelDescPopup();"></button>
                </header>
                <article>
                    <div class="search_area">
                        <div class="editable02" id="cancelDescText"></div>
                    </div>
                </article>
            </div>
        </div>
        <div class="bg ipop_close" onclick="closeCancelDescPopup();"></div>
    </div>

    <!-- 트래킹이력 팝업 -->
    <div class="popupbase map_pop">
        <div>
            <div>
                <header>
                    <h2><spring:message code="notification.title.trackingHistory"/></h2>
                    <button onclick="javascript:closeTrackingHistoryPopup();"></button>
                </header>
                <article class="map_sett_box">
                    <section class="map">
                        <div>
                            <div id="mapElement" class="map_images"></div>
                        </div>
                    </section>
                </article>
            </div>
        </div>
        <div class="bg option_pop_close" onclick="javascript:closeTrackingHistoryPopup();"></div>
    </div>

    <form id="eventLogForm" method="POST">
        <input type="hidden" name="pageNumber"/>

        <article class="search_area">
            <div class="search_contents">
                <spring:message code="common.selectbox.select" var="allSelectText"/>
                <!-- 일반 input 폼 공통 -->
                <p class="itype_01">
                    <span><spring:message code="notification.column.areaName" /></span>
                    <span><isaver:areaSelectBox htmlTagName="areaId" allModel="true" areaId="${paramBean.areaId}" allText="${allSelectText}"/></span>
                </p>
                <p class="itype_01">
                    <span><spring:message code="notification.column.deviceName" /></span>
                    <isaver:codeSelectBox groupCodeId="DEV" codeId="${paramBean.deviceCode}" htmlTagName="deviceCode" allModel="true" allText="${allSelectText}"/>
                </p>
                <p class="itype_01">
                    <span><spring:message code="notification.column.criticalLevel" /></span>
                    <isaver:codeSelectBox groupCodeId="LEV" codeId="${paramBean.criticalLevel}" htmlTagName="criticalLevel" allModel="true" allText="${allSelectText}"/>
                </p>
                <p class="itype_04">
                    <span><spring:message code="notification.column.eventDatetime" /></span>
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
                    <col> <!-- 1 알림발생일시 -->
                    <col> <!-- 2 구역명 -->
                    <col> <!-- 3 장치명 -->
                    <col> <!-- 4 이벤트명 -->
                    <col> <!-- 5 임계치레벨 -->
                    <col> <!-- 6 확인자 -->
                    <col> <!-- 7 확인일시 -->
                    <col> <!-- 8 해제자-->
                    <col> <!-- 9 해제일시 -->
                    <col> <!-- 10 해제사유 -->
                    <col> <!-- 11 트래킹보기 -->
                </colgroup>
                <thead>
                <tr>
                    <th><spring:message code="notification.column.eventDatetime"/></th>
                    <th><spring:message code="notification.column.areaName"/></th>
                    <th><spring:message code="notification.column.deviceName"/></th>
                    <th><spring:message code="notification.column.eventName"/></th>
                    <th><spring:message code="notification.column.criticalLevel"/></th>
                    <th><spring:message code="notification.column.confirmUserName"/></th>
                    <th><spring:message code="notification.column.confirmDatetime"/></th>
                    <th><spring:message code="notification.column.cancelUserName"/></th>
                    <th><spring:message code="notification.column.cancelDatetime"/></th>
                    <th><spring:message code="notification.column.cancelDesc"/></th>
                    <th><spring:message code="notification.column.trackingJson"/></th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${notifications != null and fn:length(notifications) > 0}">
                        <c:forEach var="notification" items="${notifications}">
                            <tr>
                                <td><fmt:formatDate value="${notification.eventDatetime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                                <td>${notification.areaName}</td>
                                <td>${notification.deviceName}</td>
                                <td>${notification.eventName}</td>
                                <td>
                                    <c:if test="${notification.criticalLevel!=null}">
                                        <span class="level-${criticalLevelCss[notification.criticalLevel]}"></span>
                                    </c:if>
                                </td>
                                <td>${notification.confirmUserName}</td>
                                <td><fmt:formatDate value="${notification.confirmDatetime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                                <td>${notification.cancelUserName}</td>
                                <td><fmt:formatDate value="${notification.cancelDatetime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                                <td <c:if test="${notification.cancelUserId!=null}">class="eventdetail_btn" onclick="javascript:openCancelDescPopup(this);"</c:if>>
                                    <textarea name="cancelDesc" style="display:none;">${notification.cancelDesc}</textarea>
                                </td>
                                <td <c:if test="${notification.trackingJson!=null}">class="eventdetail_btn" onclick="javascript:openTrackingHistoryPopup('${notification.areaId}','${notification.deviceId}','${notification.objectId}',this);"</c:if>>
                                    <textarea name="trackingJson" style="display:none;">${notification.trackingJson}</textarea>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="10"><spring:message code="common.message.emptyData"/></td>
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
    var form = $('#eventLogForm');
    var customMapMediator;

    var messageConfig = {
        'earlyDatetime':'<spring:message code="notification.message.earlyDatetime"/>'
    };

    var urlConfig = {
        'listUrl':'${rootPath}/notification/list.html'
        ,'excelUrl':'${rootPath}/notification/excel.html'
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

    /* Excel File Download*/
    function excelFileDownloadFunc() {
        form.attr('action',urlConfig['excelUrl']);
        form.submit();
    }

    /*
     open 이벤트 해제사유 popup
     @author psb
     */
    function openCancelDescPopup(_this){
        $("#cancelDescText").text($(_this).find("[name='cancelDesc']").text());
        $(".eventdetail_popup").fadeIn();
    }

    /*
     open 이동경로 이력 popup
     @author psb
     */
    function openTrackingHistoryPopup(areaId, deviceId, objectId, _this){
        $(".map_pop").fadeIn();

        customMapMediator = new CustomMapMediator(String('${rootPath}'),String('${version}'));
        try{
            customMapMediator.setElement($(".map_pop"), $(".map_pop").find("#mapElement"));
//            customMapMediator.setMessageConfig(_messageConfig);
            customMapMediator.init(areaId,{
                'custom' : {
                    'draggable' : true
                    ,'fenceView' : true
                    ,'openLinkFlag': false
                    ,'onLoad' : function(){
                        var trackingJson = JSON.parse($(_this).find("[name='trackingJson']").text());
                        if(trackingJson!=null) {
                            for(var index in trackingJson){
                                var marker = {
                                    'areaId' : areaId
                                    ,'deviceId' : deviceId
                                    ,'objectType' : 'human'
                                    ,'id' : objectId
                                    ,'location' : trackingJson[index]
                                };
                                customMapMediator.saveMarker('object', marker);
                            }
                        }
                    }
                }
                ,'object' :{
                    'pointsHideFlag' : false
                    ,'pointShiftCnt' : 9999
                }
            });
        }catch(e){
            console.error("[openTrackingHistoryPopup] custom map mediator init error - "+ e.message);
        }
    }

    /*
     close 이동경로 이력 popup
     @author psb
     */
    function closeTrackingHistoryPopup(){
        $(".map_pop").fadeOut();
    }


    /*
     close 이벤트 해제사유 popup
     @author psb
     */
    function closeCancelDescPopup(){
        $("#cancelDescText").text("");
        $(".eventdetail_popup").fadeOut();
    }

    /*
     alert message method
     @author psb
     */
    function alertMessage(type){
        alert(messageConfig[type]);
    }
</script>