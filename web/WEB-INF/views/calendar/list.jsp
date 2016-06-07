<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="jabber" uri="/WEB-INF/views/common/tags/jabber.tld"%>
<c:set value="MN000000-H000-0000-0000-000000000000" var="subMenuId"/>
<c:set value="MN000000-J000-0000-0000-000000000001" var="menuId"/>
<jabber:pageRoleCheck menuId="${menuId}" />
<script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/common-util.js"></script>
<script type="text/javascript" src="${rootPath}/assets/js/util/data-util.js"></script>

<aside class="layer_popup">
    <section class="layer_wrap">
    </section>
    <div class="layer_popupbg ipop_close"></div>
</aside>

<!-- section Start / 메인 "main_area", 서브 "sub_area"-->
<section class="container sub_area">
    <!-- 2depth 타이틀 영역 Start -->
    <article class="sub_title_area">
        <!-- 2depth 타이틀 Start-->
        <h3 class="1depth_title"><spring:message code="common.title.calendar"/></h3>
        <!-- 2depth 타이틀 End -->
        <div class="navigation">
            <span><jabber:menu menuId="${menuId}" /></span>
        </div>
    </article>
    <!-- 2depth 타이틀 영역 End -->

    <div class="tabs_area">
        <ul class="tabs">
            <li rel="#calendarView" href="${rootPath}/calendar/calendarView.html"><span><spring:message code="calendar.tab.calendarView"/></span></li>
            <li rel="#listView" href="${rootPath}/calendar/listView.html"><span><spring:message code="calendar.tab.listView"/></span></li>
        </ul>

        <div class="tabs_contents_area">
            <article class="tabs_content table_area" id="calendarView"></article>
            <article class="tabs_content table_area" id="listView"></article>
        </div>
    </div>
</section>

<script type="text/javascript">
    var targetMenuId = String('${menuId}');
    var subMenuId = String('${subMenuId}');
    var tabId = String('${tabId}');

    var parameters = {
        'id' : "${paramBean.id}"
        ,"type" : "${paramBean.type}"
        ,"pageNumber" : "${paramBean.pageNumber}"
        ,"title" : "${paramBean.title}"
        ,"typeCode" : "${paramBean.typeCode}"
        ,"startDatetimeStr" : "${paramBean.startDatetimeStr}"
        ,"endDatetimeStr" : "${paramBean.endDatetimeStr}"
        ,"insertUserName" : "${paramBean.insertUserName}"
    };

    var urlConfig = {
        'listJsonUrl':'${rootPath}/calendar/calendarView.json'
        ,'monAddUrl':'${rootPath}/calendar/add.json'
        ,'monSaveUrl':'${rootPath}/calendar/save.json'
        ,'revRemoveUrl':'${rootPath}/reservation/remove.json'
        ,'monRemoveUrl':'${rootPath}/calendar/remove.json'
        ,'listUrl':'${rootPath}/calendar/list.html'
        ,'revDetailUrl':'${rootPath}/reservation/detail.html'
        ,'monDetailUrl':'${rootPath}/calendar/detail.html'
    };

    var messageConfig = {
        listJsonFailure : '<spring:message code="calendar.message.listJsonFailure"/>'
        ,monAddConfirm  : '<spring:message code="common.message.addConfirm"/>'
        ,monAddFailure  : '<spring:message code="common.message.addFailure"/>'
        ,monAddComplete : '<spring:message code="common.message.addComplete"/>'
        ,monSaveConfirm  : '<spring:message code="common.message.saveConfirm"/>'
        ,monSaveFailure  : '<spring:message code="common.message.saveFailure"/>'
        ,monSaveComplete : '<spring:message code="common.message.saveComplete"/>'
        ,revRemoveConfirm  : '<spring:message code="common.message.removeConfirm"/>'
        ,revRemoveFailure  : '<spring:message code="common.message.removeFailure"/>'
        ,revRemoveComplete : '<spring:message code="common.message.removeComplete"/>'
        ,monRemoveConfirm  : '<spring:message code="common.message.removeConfirm"/>'
        ,monRemoveFailure  : '<spring:message code="common.message.removeFailure"/>'
        ,monRemoveComplete : '<spring:message code="common.message.removeComplete"/>'
        ,repeatDataConfirm  :'<spring:message code="calendar.message.repeatDataConfirm"/>'
        ,'failedDatetime':'<spring:message code="common.message.failedDatetime"/>'
        ,'confirmStartDatetime':'<spring:message code="calendar.message.confirmStartDatetime"/>'
        ,'confirmEndDatetime':'<spring:message code="calendar.message.confirmEndDatetime"/>'
        ,'monTitle':'<spring:message code="calendar.column.monTitle"/>'
        ,'revTitle':'<spring:message code="calendar.column.revTitle"/>'
        ,'emptyTitle':'<spring:message code="calendar.message.emptyTitle"/>'
        ,'emptyDate':'<spring:message code="calendar.message.emptyDate"/>'
    };

    var revLayerTag = $("<article/>").addClass("layer_area").append(
        $("<div/>").addClass("layer_header").text(messageConfig['revTitle']).append(
            $("<button/>").addClass("ipop_x").attr("onclick","javascript:closeLayer(); return false;")
        )
    ).append(
        $("<div/>").addClass("layer_contents").append(
            $("<div/>").addClass("layer_sc").append(
                $("<p/>").addClass("itype_00").append(
                    $("<span/>").text("제목")
                ).append(
                    $("<span/>").attr("id","title")
                )
            ).append(
                $("<p/>").addClass("itype_00").append(
                    $("<span/>").text("장소")
                ).append(
                    $("<span/>").attr("id","assetsName")
                )
            ).append(
                $("<p/>").attr("id","entryLayer").addClass("itype_00").append(
                    $("<span/>").text("참여자")
                ).append(
                    $("<span/>").attr("id","entry")
                )
            ).append(
                $("<p/>").addClass("itype_00").append(
                    $("<span/>").text("일자")
                ).append(
                    $("<span/>").addClass("plable04")
                )
            ).append(
                $("<p/>").addClass("itype_00").append(
                    $("<span/>").text("메모")
                ).append(
                    $("<span/>").attr("id","description")
                )
            ).append(
                $("<p/>").attr("id","insertUserLayer").addClass("itype_00").append(
                    $("<span/>").text("등록자")
                ).append(
                    $("<span/>").attr("id","insertUserName")
                )
            )
        )
    ).append(
        $("<div/>").addClass("layer_bottom")
    );


    var monLayerTag = $("<article/>").addClass("layer_area").append(
        $("<div/>").addClass("layer_header").text(messageConfig['monTitle']).append(
            $("<button/>").addClass("ipop_x").attr("onclick","javascript:closeLayer(); return false;")
        )
    ).append(
        $("<div/>").addClass("layer_contents").append(
            $("<div/>").addClass("layer_sc").append(
                $("<p/>").addClass("itype_00").append(
                    $("<span/>").text("제목")
                ).append(
                    $("<span/>").append(
                        $("<input/>").attr("type","text").attr("id","monTitle")
                    )
                )
            ).append(
                $("<p/>").addClass("itype_00").append(
                    $("<span/>").text("구분")
                ).append(
                    $("<span/>").attr("id","monType")
                )
            ).append(
                $("<p/>").addClass("itype_00").append(
                    $("<span/>").text("일자")
                ).append(
                    $("<span/>").addClass("plable04").append(
                        $("<input/>").attr("type","text").attr("id","monDate")
                    )
                )
            ).append(
                $("<p/>").addClass("itype_00").append(
                    $("<span/>").text("메모")
                ).append(
                    $("<span/>").append(
                        $("<textarea/>").addClass("textboard").attr("id","monDescription")
                    )
                )
            ).append(
                $("<p/>").attr("id","insertUserLayer").addClass("itype_00").append(
                    $("<span/>").text("등록자")
                ).append(
                    $("<span/>").attr("id","insertUserName")
                )
            )
        )
    ).append(
        $("<div/>").addClass("layer_bottom")
    );

    $(document).ready(function(){
        $("ul.tabs li").click(function () {
            $("ul.tabs li").removeClass("tabs_on");
            $(this).addClass("tabs_on");
            $(".tabs_content").hide();
            var activeTab = $(this).attr("rel");
            $(activeTab).empty().load($(this).attr("href"), parameters).fadeIn();
        });

        if(tabId!=""){
            $(".tabs > li[rel='#"+tabId+"']").trigger("click");
        }else{
            $(".tabs > li[rel='#calendarView']").trigger("click");
        }
    });

    /*
     상세화면 이동
     @author psb
     */
    function detail(type, id){
        var data = {};

        switch(type){
            case 'mon':
                data['calendarId']=id;
                break;
            case 'rev':
                data['reservationId']=id;
                break;
        }

        callAjax(type+'Detail',data);
    }

    function closeLayer(){
        $('.layer_popup').fadeOut(200);
        setTimeout(function () {
            $('.layer_popup').removeClass("ipop_type01");
            $('.layer_popup').removeClass("ipop_type02");
            $('.layer_popup').removeClass("ipop_type03");
            $('.layer_wrap').removeClass("i_type01");
            $('.layer_wrap').removeClass("i_type02");
            $('.layer_wrap').removeClass("i_type03");
        }, 300);
    }

    function reservationDetailRender(data){
        var _layerTag = revLayerTag.clone();
        var _reservation = data.reservation;
        var _entryReservations = data.entryReservations;

        var entryHtml = "";
        for (var i=0 ; i<_entryReservations.length; i++){
            if(_entryReservations[i].entryName!=null){
                entryHtml += _entryReservations[i].entryName + ',';
            }
        }
        entryHtml = entryHtml.slice(0,-1);

        _layerTag.find("#assetsName").text(_reservation['assetsName']);
        _layerTag.find("#title").text(_reservation['title']);
        _layerTag.find("#entry").text(entryHtml);
        _layerTag.find(".plable04").append(new Date(_reservation['startDate']).format("yyyy-MM-dd hh:mm")).append(
            $("<em/>").text("~")
        ).append(new Date(_reservation['endDate']).format("hh:mm"));

        _layerTag.find("#description").text(_reservation['description']);
        _layerTag.find("#insertUserName").text(_reservation['insertUserName']);
        _layerTag.find(".layer_bottom").append(
            $("<button/>").addClass("btn btype01 bstyle03").attr("onclick","javascript:removeReservation('"+_reservation['reservationId']+"'); return false;").text("삭제")
        ).append(
            $("<button/>").addClass("btn btype01 bstyle03 ipop_close").attr("onclick","javascript:closeLayer(); return false;").text("취소")
        );

        $('.layer_popup').addClass("ipop_type01");
        $('.layer_wrap').addClass("i_type01").html(_layerTag);
        $('.ipop_type01').fadeIn(200);
    }

    function calendarDetailRender(data){
        var _layerTag = monLayerTag.clone();
        var _calendar = data.calendar;
        var _headers = data.headers;

        var _headerSelect = $("<select/>").attr("id","monTypeCode");

        for(var i in _headers){
            var _header = _headers[i];
            _headerSelect.append(
                $("<option/>").val(_header['codeId']).text(_header['codeName'])
            )
        }
        _layerTag.find("#monType").append(_headerSelect);

        if(_calendar!=null){
            _layerTag.find("#monTitle").val(_calendar['title']);
            _layerTag.find("#monDate").val(new Date(_calendar['date']).format("yyyy-MM-dd"));
            _layerTag.find("#monDescription").val(_calendar['description']);
            _layerTag.find("#insertUserName").text(_calendar['insertUserName']!=null?_calendar['insertUserName']:"");
            _layerTag.find("#monTypeCode").val(_calendar['type']).attr("selected","selected");
            _layerTag.find(".layer_bottom").append(
                $("<button/>").addClass("btn btype01 bstyle03").attr("onclick","javascript:saveCalendar('"+_calendar['calendarId']+"'); return false;").text("저장")
            ).append(
                $("<button/>").addClass("btn btype01 bstyle03").attr("onclick","javascript:removeCalendar('"+_calendar['calendarId']+"'); return false;").text("삭제")
            ).append(
                $("<button/>").addClass("btn btype01 bstyle03 ipop_close").attr("onclick","javascript:closeLayer(); return false;").text("취소")
            );
        }else{
            _layerTag.find(".layer_bottom").append(
                $("<button/>").addClass("btn btype01 bstyle03").attr("onclick","javascript:addCalendar(); return false;").text("등록")
            ).append(
                $("<button/>").addClass("btn btype01 bstyle03 ipop_close").attr("onclick","javascript:closeLayer(); return false;").text("취소")
            );

            _layerTag.find("#insertUserLayer").hide();
        }

        $('.layer_popup').addClass("ipop_type01");
        $('.layer_wrap').addClass("i_type01").html(_layerTag);

        calendarHelper.load($('#monDate'));
        $('.ipop_type01').fadeIn(200);
    }

    /*
     validate method
     @author kst
     */
    function validate(){
        if($('#monTitle').val().trim().length == 0){
            $('#monTitle').focus();
            alertMessage('emptyTitle');
            return false;
        }

        if($('#monDate').val().trim().length == 0){
            $('#monDate').focus();
            alertMessage('emptyDate');
            return false;
        }
        return true;
    }

    function addCalendar(){
        if(!confirm(messageConfig['monAddConfirm'])){
            return false;
        }

        if(validate()){
            var data = {
                'title' : $("#monTitle").val()
                ,'date' : $("#monDate").val()
                ,'description' : $("#monDescription").val()
                ,'type' : $("#monTypeCode option:selected").val()
            };

            callAjax('monAdd', data);
        }
    }

    function saveCalendar(id){
        if(!confirm(messageConfig['monSaveConfirm'])){
            return false;
        }

        if(validate()){
            var data = {
                'calendarId' : id
                ,'title' : $("#monTitle").val()
                ,'date' : $("#monDate").val()
                ,'description' : $("#monDescription").val()
                ,'type' : $("#monTypeCode option:selected").val()
            };

            callAjax('monSave', data);
        }
    }

    function removeCalendar(id){
        if(!confirm(messageConfig['monRemoveConfirm'])){
            return false;
        }

        if(validate()){
            callAjax('monRemove', { "calendarId" : id });
        }
    }

    /*
     * 회의실예약 삭제
     * @author psb
     */
    function removeReservation(id){
        var addText = '';
        if($("#repeatYn").val()=="Y" && $("#repeatId").val()==""){
            addText = messageConfig['repeatDataConfirm'];
        }

        if(!confirm(addText + messageConfig['revRemoveConfirm'])){
            return false;
        }

        callAjax('revRemove', { "reservationId" : id });
    }

    function callAjax(actionType, data){
        sendAjaxPostRequest(urlConfig[actionType + 'Url'],data,requestCode_successHandler,requestCode_errorHandler,actionType);
    }

    function requestCode_successHandler(data, dataType, actionType){
        if (actionType!='listJson' && actionType!='revDetail' && actionType!='monDetail'){
            alertMessage(actionType + 'Complete');
        }

        switch(actionType){
            case 'listJson':
                if(data.reservations!=null){
                    reservationListRender(data.reservations);
                }
                if(data.calendars!=null){
                    calendarListRender(data.calendars);
                }
                break;
            case 'revDetail':
                reservationDetailRender(data);
                break;
            case 'monDetail':
                calendarDetailRender(data);
                break;
            case 'monAdd':
                search();
                break;
            case 'monSave':
                search();
                break;
            case 'monRemove':
                search();
                break;
            case 'revRemove':
                search();
                break;
        }
    }

    function requestCode_errorHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
        alertMessage(actionType + 'Failure');
    }

    function alertMessage(type){
        alert(messageConfig[type]);
    }
</script>