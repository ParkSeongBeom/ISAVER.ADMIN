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

<div class="sub_title_area">
    <h3 class="1depth_title"><spring:message code="common.title.notification"/></h3>
    <div class="navigation">
        <span><isaver:menu menuId="${menuId}" /></span>
    </div>
</div>

<section class="container sub_area">
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
                    <span><spring:message code="notification.column.eventName" /></span>
                    <select name="eventId">
                        <option value=""><spring:message code="common.selectbox.select"/></option>
                        <c:forEach var="event" items="${eventList}">
                            <option value="${event.eventId}" <c:if test="${paramBean.eventId==event.eventId}">selected="selected"</c:if>>${event.eventName}</option>
                        </c:forEach>
                    </select>
                </p>
                <p class="itype_01">
                    <span><spring:message code="notification.column.fenceName" /></span>
                    <select name="fenceId">
                        <option value=""><spring:message code="common.selectbox.select"/></option>
                        <c:forEach var="fence" items="${fenceList}">
                            <option value="${fence.fenceId}" <c:if test="${paramBean.fenceId==fence.fenceId}">selected="selected"</c:if>>${fence.deviceName}(${fence.deviceId})-${fence.fenceName}</option>
                        </c:forEach>
                    </select>
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
                <button onclick="search(); return false;" class="btn bstyle01 btype01"><spring:message code="common.button.search"/></button>
            </div>
        </article>
    </form>

    <article class="table_area">
        <div class="table_title_area">
            <h4></h4>
            <div class="table_btn_set">
                <p><span><spring:message code="common.message.total"/><em>${paramBean.totalCount}</em><spring:message code="common.message.number01"/></span></p>
                <button class="btn btype01 bstyle03" onclick="excelFileDownloadFunc(); return false;"><spring:message code="common.button.excelDownload"/> </button>
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
                    <col> <!-- 5 펜스명 -->
                    <col> <!-- 6 임계치레벨 -->
                    <col> <!-- 7 확인자 -->
                    <col> <!-- 8 확인일시 -->
                    <col> <!-- 9 해제자-->
                    <col> <!-- 10 해제일시 -->
                    <col> <!-- 11 해제사유 -->
                    <col> <!-- 12 외부전송 -->
                    <col> <!-- 13 트래킹보기 -->
                </colgroup>
                <thead>
                <tr>
                    <th><spring:message code="notification.column.eventDatetime"/></th>
                    <th><spring:message code="notification.column.areaName"/></th>
                    <th><spring:message code="notification.column.deviceName"/></th>
                    <th><spring:message code="notification.column.eventName"/></th>
                    <th><spring:message code="notification.column.fenceName"/></th>
                    <th><spring:message code="notification.column.criticalLevel"/></th>
                    <th><spring:message code="notification.column.confirmUserName"/></th>
                    <th><spring:message code="notification.column.confirmDatetime"/></th>
                    <th><spring:message code="notification.column.cancelUserName"/></th>
                    <th><spring:message code="notification.column.cancelDatetime"/></th>
                    <th><spring:message code="notification.column.cancelDesc"/></th>
                    <th><spring:message code="notification.column.externalSendLog"/></th>
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
                                <td>${notification.fenceName}</td>
                                <td>
                                    <c:if test="${notification.criticalLevel!=null}">
                                        <span class="level-${criticalLevelCss[notification.criticalLevel]}"></span>
                                    </c:if>
                                </td>
                                <td>${notification.confirmUserName}</td>
                                <td><fmt:formatDate value="${notification.confirmDatetime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                                <td>${notification.cancelUserName}</td>
                                <td><fmt:formatDate value="${notification.cancelDatetime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                                <td>
                                    <c:if test="${notification.cancelUserId!=null}">
                                        <button class="eventdetail_btn" onclick="openCancelDescPopup(this);"></button>
                                        <textarea disabled="disabled" style="display:none;">${notification.cancelDesc}</textarea>
                                    </c:if>
                                </td>
                                <td>
                                    <c:if test="${notification.sendCnt>0}">
                                        <button class="eventdetail_btn" onclick="openSendLogDetailPopup('${notification.notificationId}');"></button>
                                    </c:if>
                                </td>
                                <td>
                                    <c:if test="${notification.trackingJson!=null && notification.trackingJson!='[]'}">
                                        <button class="eventdetail_btn"
                                                data-notification-id="${notification.notificationId}"
                                                data-critical-level="${notification.criticalLevel}"
                                                data-area-id="${notification.areaId}"
                                                data-device-id="${notification.deviceId}"
                                                data-object-id="${notification.objectId}"
                                                data-fence-id="${notification.fenceId}"
                                                onclick="openTrackingHistoryPopup(this);"></button>
                                        <textarea disabled="disabled" style="display:none;">${notification.trackingJson}</textarea>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="13"><spring:message code="common.message.emptyData"/></td>
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
    <div class="popupbase admin_popup eventSendLogPopup">
        <div>
            <div>
                <header>
                    <h2><spring:message code="notification.column.externalSendLog"/></h2>
                    <button onclick="closeSendLogDetailPopup();"></button>
                </header>
                <article>
                    <div class="search_area">
                        <div class="editable02" id="eventSendLogText"></div>
                    </div>
                </article>
            </div>
        </div>
        <div class="bg ipop_close" onclick="closeSendLogDetailPopup();"></div>
    </div>

    <div class="popupbase admin_popup eventdetail_popup">
        <div>
            <div>
                <header>
                    <h2><spring:message code="notification.column.cancelDesc"/></h2>
                    <button onclick="closeCancelDescPopup();"></button>
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
                    <button onclick="closeTrackingHistoryPopup();"></button>
                </header>
                <div class="trackinghistory-box">
                    <article class="map_sett_box">
                        <section class="map">
                            <div>
                                <div id="mapElement" class="map_images"></div>
                            </div>
                        </section>
                    </article>
                    <article class="video_area">
                        <section>
                            <!-- 입력 테이블 Start -->
                            <div>
                                <video id="videoElement" class="videobox" poster="" controls="ture" style="width:100%;">
                                    <source id="videoSource" type="video/mp4">
                                </video>

                                <div class="speed">
                                    <button class="x1 on" speed="1"></button>
                                    <button class="x2" speed="2"></button>
                                    <button class="x4" speed="4"></button>
                                    <button class="x8" speed="8"></button>
                                </div>
                            </div>
                        </section>
                        <section>
                            <ul class="video_list" id="videoList"></ul>
                        </section>
                    </article>
                </div>
            </div>
        </div>
        <div class="bg option_pop_close" onclick="closeTrackingHistoryPopup();"></div>
    </div>
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
        ,'videoListUrl':'${rootPath}/videoHistory/notiList.json'
        ,'notiSendLogUrl':'${rootPath}/notiSendLog/list.json'
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
        $(".speed > button").on("click",function(){
            $(".speed > button").removeClass("on");
            $(this).addClass("on");
            $("#videoElement")[0].playbackRate = Number($(this).attr("speed"));
            $("#videoElement")[0].play();
        });

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
        $("#cancelDescText").text($(_this).next().text());
        $(".eventdetail_popup").fadeIn();
    }

    /*
     close 이벤트 해제사유 popup
     @author psb
     */
    function closeCancelDescPopup(){
        $("#cancelDescText").text("");
        $(".eventdetail_popup").fadeOut();
    }

    function openSendLogDetailPopup(notificationId){
        callAjax('notiSendLog',{'notificationId':notificationId});
    }

    /*
     close 이벤트 해제사유 popup
     @author psb
     */
    function closeSendLogDetailPopup(){
        $("#eventSendLogText").empty();
        $(".eventSendLogPopup").fadeOut();
    }

    /*
     ajax call
     @author psb
     */
    function callAjax(actionType, data){
        sendAjaxPostRequest(urlConfig[actionType + 'Url'],data,notification_successHandler,notification_errorHandler,actionType);
    }

    /*
     ajax success handler
     @author psb
     */
    function notification_successHandler(data, dataType, actionType){
        switch(actionType){
            case 'videoList':
                $("#videoList").empty();
                var videoHistoryList = data['videoHistoryList'];
                if(videoHistoryList.length>0){
                    $(".video_area").show();
                }else{
                    $(".video_area").hide();
                }
                for(var index in videoHistoryList){
                    var videoHistory = videoHistoryList[index];
                    var fenceName = '';
                    if(videoHistory['fenceName']!=null){
                        fenceName = "("+videoHistory['fenceName']+")";
                    }
                    $("#videoList").append(
                        $("<li/>").click({videoFileUrl:data['videoUrl']+videoHistory['videoType']+"/"+videoHistory['videoFileName']},function(evt){
                            openVideo(this,evt.data.videoFileUrl);
                        }).append(
                            $("<div/>").append(
                                $("<img/>",{src:data['videoUrl']+videoHistory['videoType']+"/"+videoHistory['thumbnailFileName']})
                            )
                        ).append(
                            $("<div/>").append(
                                $("<span/>").text(videoHistory['areaName']?videoHistory['areaName']:'')
                            ).append(
                                $("<span/>").text(videoHistory['deviceName']?videoHistory['deviceName']:'')
                            ).append(
                                $("<p/>").text((videoHistory['eventName']?videoHistory['eventName']:'')+fenceName)
                            ).append(
                                $("<span/>").text(new Date(videoHistory['videoDatetime']).format("MM/dd HH:mm:ss"))
                            )
                        )
                    );
                }
                break;
            case 'notiSendLog':
                var notiSendLogList = data['notiSendLogList'];
                for(var index in notiSendLogList){
                    var notiSendLog = notiSendLogList[index];
                    $("#eventSendLogText").append(
                        $("<p/>").text(notiSendLog['sendDatetimeStr'] + ' [' + notiSendLog['sendCode']+'] - '+notiSendLog['sendUrl'])
                    )
                }
                $(".eventSendLogPopup").fadeIn();
                break;
        }
    }

    /*
     ajax error handler
     @author psb
     */
    function notification_errorHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        alertMessage(actionType + 'Failure');
    }

    /*
     open 이동경로 이력 popup
     @author psb
     */
    function openTrackingHistoryPopup(_this){
        $(".map_pop").fadeIn();

        var data = $(_this).data();
        data['objectType'] = 'human';
        var trackingJson = JSON.parse($(_this).next().text());

        customMapMediator = new CustomMapMediator(String('${rootPath}'),String('${version}'));
        try{
            customMapMediator.setElement($(".map_pop"), $(".map_pop").find("#mapElement"));
//            customMapMediator.setMessageConfig(_messageConfig);
            customMapMediator.init(data['areaId'],{
                'custom' : {
                    'draggable' : false
                    ,'fenceView' : true
                    ,'openLinkFlag' : false
                    ,'moveFenceHide' : false
                    ,'moveReturn' : false
                    ,'onLoad' : function(){
                        if(trackingJson!=null) {
                            for(var index in trackingJson){
                                var marker = {
                                    'areaId' : data['areaId']
                                    ,'deviceId' : data['deviceId']
                                    ,'objectType' : 'human'
                                    ,'id' : data['objectId']
                                    ,'location' : trackingJson[index]
                                };
                                customMapMediator.saveMarker('object', marker);
                            }

                            setTimeout(function(){
                                customMapMediator.setAnimate('add',data['criticalLevel'],data);
                            },500);
                        }
                    }
                }
                ,'object' :{
                    'pointsHideFlag' : false
                    ,'pointShiftCnt' : null
                }
            });
            callAjax('videoList',{'notificationId':data['notificationId'],'videoType':'event'});
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

    function openVideo(_this, videoFileUrl){
        $(".video_list li").removeClass("on");
        $(_this).addClass("on");

        $("#videoSource").attr("src",videoFileUrl);
        $("#videoElement")[0].load();
    }

    /*
     alert message method
     @author psb
     */
    function alertMessage(type){
        alert(messageConfig[type]);
    }
</script>