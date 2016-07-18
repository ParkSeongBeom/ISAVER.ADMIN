<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<c:set var="rootPath" value="${pageContext.servletContext.contextPath}" scope="application"/>
<%--<fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${serverDatetime}" var="serverDatetime"/>--%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <link href="${pageContext.servletContext.contextPath}/assets/css/base.css" rel="stylesheet" type="text/css" />
    <!--[endif] -->
    <title>iSaver Admin</title>
    <%-- dynatree, dhj --%>
    <link rel="stylesheet" type="text/css" href="${rootPath}/assets/css/dynatree/skin-vista/ui.dynatree.css" >
    <script type="text/javascript" src="${rootPath}/assets/js/common/jquery.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/common/jquery.autosize.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/common/jquery.event.drag-1.5.min.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/common/jquery.touchSlider.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/calendar-helper.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/common/jquery-ui.custom.min.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/common/jquery.mCustomScrollbar.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/common/default.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/data-util.js"></script>
    <%-- dynatree, dhj --%>
    <script type="text/javascript" src="${rootPath}/assets/js/common/jquery.cookie.js"></script>

    <%-- dynatree, dhj --%>
    <script src="${rootPath}/assets/js/page/menu/MenuModel.js" type="text/javascript" charset="UTF-8"></script>
    <script src="${rootPath}/assets/js/page/menu/MenuCtrl.js" type="text/javascript" charset="UTF-8"></script>
    <script src="${rootPath}/assets/js/page/menu/MenuView.js" type="text/javascript" charset="UTF-8"></script>

    <%-- dynatree, dhj --%>
    <script src="${rootPath}/assets/js/page/area/AreaModel.js" type="text/javascript" charset="UTF-8"></script>
    <script src="${rootPath}/assets/js/page/area/AreaCtrl.js" type="text/javascript" charset="UTF-8"></script>
    <script src="${rootPath}/assets/js/page/area/AreaView.js" type="text/javascript" charset="UTF-8"></script>

    <!-- util -->
    <script type="text/javascript" src="${rootPath}/assets/js/util/consolelog-helper.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/jquery.nanoscroller.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/common-util.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/dashBoard-helper.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/template/template-helper.js"></script>

    <script type="text/javascript">
        var rootPath = '${rootPath}';
        var calendarHelper = new CalendarHelper(rootPath);
        var menuModel = new MenuModel();
        var menuCtrl = null;
        var dashBoardHelper = new DashBoardHelper();
        var templateHelper = new TemplateHelper();
        var now = new Date();
        var serverDatetime = new Date();
        serverDatetime.setTime(${serverDatetime});

        var layoutUrlConfig = {
            'logoutUrl':'${rootPath}/logout.html'
            ,'mainUrl':'${rootPath}/main.html'
            ,'listUrl':'${rootPath}/eventLog/alram.html'
            ,'detailUrl':'${rootPath}/dashboard/detail.html'
            ,'alramDetailUrl':'${rootPath}/action/eventDetail.json'
            ,'alramCancelUrl':'${rootPath}/eventLog/cancel.json'
            ,'dashBoardAllUrl':'${rootPath}/dashboard/all.html'
        };

        var layoutMessageConfig = {
            alramCancelSuccess    :'<spring:message code="dashboard.message.alramCancelSuccess"/>'
            , alramDetailFailure  :'<spring:message code="dashboard.message.alramDetailFailure"/>'
            , alramCancelFailure  :'<spring:message code="dashboard.message.alramCancelFailure"/>'
            , emptyAlramCancel    :'<spring:message code="dashboard.message.emptyAlramCancel"/>'
        };

        var alarmPlayer;
        var segmentEnd;

        var evtDetectionList = ["EVT100", "EVT210"];
        var evtDetectionCancelList = ["EVT102", "EVT211"];

        $(document).ready(function(){

            /* 브라우저 종료 */

//            $(window).bind("beforeunload", function() {
//                return confirm("Do you really want to close?");
//            });

            // 메뉴그리기
            menuModel.setRootUrl(rootPath);
            menuModel.setViewStatus('detail');
            menuModel.setParentMenuId(subMenuId);

            menuCtrl = new MenuCtrl(menuModel);
            try {
                menuCtrl.findMenuTopBar(targetMenuId);
            } catch(e) {
                console.error(e);
            }

            // 타이틀에 텍스트 맵핑
            $.each($("table.t_type01 > tbody > tr > td"),function(){
                $(this).attr("title",$(this).text().trim());
            });

            // 알림센터 외부 클릭시 팝업 닫기
            $(".wrap").on("click",function(event){
                if (!$(event.target).closest("button, .db_area, .dbs_area").length) {
                    alramShowHide('list','hide');
                }
            });

            // 알림센터 내부 셀렉트 박스 클릭시 이벤트
            $("#eventType").on("change",function(){
                alramTypeChangeHandler();
            });
            $("#areaType").on("change",function(){
                alramTypeChangeHandler();
            });

            bodyAddClass();
            printTime();

            dashBoardHelper.addRequestData('alram', layoutUrlConfig['listUrl'], null, alramSuccessHandler, alramFailureHandler);
            dashBoardHelper.startInterval();
            aliveSend(900000);

            //스크롤바 플러그인 호출
            $(".nano").nanoScroller();

            alarmPlayer = document.getElementsByTagName("audio")[0];
            alarmPlayer.addEventListener('timeupdate', function (){
                if (segmentEnd && alarmPlayer.currentTime >= segmentEnd) {
                    alarmPlayer.pause();
                }
//                    console.log(alarmPlayer.currentTime);
            }, false);
        });

        function alramTypeChangeHandler() {
            $("#alramList li").hide();
            var eventType = $("#eventType option:selected").val() != "" ? "[eventType='"+$("#eventType option:selected").val()+"']" : "";
            var areaType = $("#areaType option:selected").val() != "" ? "[areaId='"+$("#areaType option:selected").val()+"']" : "";
            $("#alramList li"+eventType+areaType).show();
        }

        function alramAllCheck(_this){
            if($(_this).is(":checked")){
                $("#alramList li").addClass("check");
                $("#alramList .check_input").prop("checked",true);
            }else{
                $("#alramList li").removeClass("check");
                $("#alramList .check_input").prop("checked",false);
            }
        }

        function printTime() {

            $("#nowTime").text(serverDatetime.format("MM.dd E HH:mm:ss"));

            setTimeout(function(){
                serverDatetime.setSeconds(serverDatetime.getSeconds()+1);
                printTime();
            },1000);
        }

        /**
         * [인터벌] alive send
         * @author psb
         */
        function aliveSend(_time) {
            setInterval(function() {
                $.get('${rootPath}/alive.json', function() {
                }).done(function() {
                }).fail(function() {
                    console.log("[aliveSend][error]");
                }).always(function() {
                });
            }, _time);
        }

        /**
         * alram success handler
         * @author psb
         * @private
         */
        function alramSuccessHandler(data, dataType, actionType){
            if(data!=null && data['eventLogs']!=null){
                var marqueeFlag = false;

                for(var index in data['eventLogs']){
                    var eventLog = data['eventLogs'][index];
                    var eventTypeName = null;
                    var eventId = eventLog['eventId'];

                    switch (eventLog['eventType']){
                        case "crane" :
                            eventTypeName = "<spring:message code="dashboard.message.craneText"/>";
                            break;
                        case "worker" :
                            eventTypeName = "<spring:message code="dashboard.message.dropDownText"/>";
                            break;
                    }

                    var makeAllowFlag = true;
                    /* 충돌 감지 해제 */
                    for (var j = 0 ; j < evtDetectionCancelList.length; j++) {
                        var item = evtDetectionCancelList[j];
                        if (item == eventId) {
                            makeAllowFlag = false;
                            break;
                        }
                    }

                    if(eventTypeName!=null && makeAllowFlag){
                        marqueeFlag = true;

                        if(eventLog['eventCancelUserId']!="" && eventLog['eventCancelUserId']!=null){
                            $("#alramList li[eventLogId='"+eventLog['eventLogId']+"']").remove();
                            if($("#marqueeList button[eventLogId='"+eventLog['eventLogId']+"']").length>0){
                                $('.marquee').marquee('destroy');
                                $("#marqueeList button[eventLogId='"+eventLog['eventLogId']+"']").remove();
                            }
                        }else if($("#alramList li[eventLogId='"+eventLog['eventLogId']+"']").length==0){
                            if($("#marqueeList .js-marquee-wrapper").length>0){
                                $('.marquee').marquee('destroy');
                            }

                            // 알림센터
                            var alramTag = templateHelper.getTemplate("alram01");
                            alramTag.on("click",function(){
                                if($(this).hasClass("check")){
                                    $(this).find(".check_input").prop("checked",false);
                                    modifyElementClass($(this),'check','remove');
                                }else{
                                    $(this).find(".check_input").prop("checked",true);
                                    modifyElementClass($(this),'check','add');
                                }
                            });
                            alramTag.attr("eventType",eventLog['eventType']).attr("eventLogId",eventLog['eventLogId']).attr("areaId",eventLog['areaId']);
//                            alramTag.find("#eventType").text(eventTypeName);
                            alramTag.find("#eventName").text(eventLog['eventName']);
                            alramTag.find("#areaName").text(eventLog['areaName']);
                            alramTag.find("#eventDatetime").text(new Date(eventLog['eventDatetime']).format("MM/dd HH:mm:ss"));
                            alramTag.find(".infor_open").attr("onclick","javascript:searchAlramDetail('"+eventLog['eventLogId']+"','"+eventLog['eventId']+"','"+eventLog['eventType']+"'); return false;");
                            $("#alramList").prepend(alramTag);

                            // marquee
                            var marqueeTag = templateHelper.getTemplate("marquee01");
                            marqueeTag.attr("eventLogId",eventLog['eventLogId']).text(" " + new Date(eventLog['eventDatetime']).format("HH:mm:ss")).attr("onclick","javascript:alramShowHide('list', 'show');");
                            marqueeTag.prepend(
                                $("<span/>").text(eventLog['areaName'] + " " + eventLog['eventName'])
                            );
                            $("#marqueeList").prepend(marqueeTag);

                            // 토스트팝업
                            if(new Date(eventLog['eventDatetime']) > now){

                                /* 애니메이션 */
                                $(".issue_btn").removeClass("issue_on");
                                try {
                                    setTimeout(function() {
                                        $(".issue_btn").addClass("issue_on");
                                    }, 150);

                                } catch(e) {

                                }

                                /* 싸이렌 */
                                playSegment();
                                var toastTag = templateHelper.getTemplate("toast");
                                toastTag.attr("onclick","javascript:alramShowHide('list', 'show');");
                                toastTag.attr("eventLogId",eventLog['eventLogId']);
                                toastTag.find("#toastEventName").text(eventTypeName);
                                toastTag.find("#toastEventDesc").text(eventLog['eventName']);
                                $(".toast_popup").append(toastTag);

                                removeToastTag(toastTag);
                                function removeToastTag(_tag){
                                    setTimeout(function(){
                                        _tag.remove();
                                    },3000);
                                }
                            }
                        }
                    }
                }

                if(data['eventLogs'].length>0){
                    dashBoardHelper.saveRequestData('alram',{datetime:new Date(data['eventLogs'][data['eventLogs'].length-1]['eventDatetime']).format("yyyy-MM-dd HH:mm:ss")});
                }

                if(marqueeFlag && $("#marqueeList button").length>0 && $("#marqueeList .js-marquee-wrapper").length==0){
                    //마키 플러그인 호출
//                    $('.marquee').marquee({
//                        duration: 20000,
//                        direction: 'left',
//                        gap: 20,
//                        duplicated: true,
//                        pauseOnHover: true,
//                        startVisible: true,
//                    });
                }
            }

            if($("#alramList li").length>0){
                modifyElementClass($(".issue_btn"),'issue','add');
            }else{
                modifyElementClass($(".issue_btn"),'issue','remove');
            }

            alramTypeChangeHandler();
        }

        /**
         * alram failure handler
         * @author psb
         * @private
         */
        function alramFailureHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
            console.log(XMLHttpRequest, textStatus, errorThrown, actionType);
        }

        /**
         * alram cencel
         * @author psb
         */
        function alramCancel(){
            var eventLogIdList = $("#alramList li.check").map(function(){return $(this).attr("eventLogId")}).get();

            if(eventLogIdList==null || eventLogIdList.length == 0){
                layoutAlertMessage('emptyAlramCancel');
                return false;
            }

            var r = confirm("<spring:message code="dashboard.message.alramConfirm"/>");
            if (r == true) {
                layoutAjaxCall('alramCancel',{eventLogIds : eventLogIdList.join(",")});
            }

        }

        /**
         * search alram detail (action)
         * @author psb
         */
        function searchAlramDetail(eventLogId, eventId, eventType){
            var paramData = {
                eventLogId  : eventLogId
                , eventId   : eventId
                , eventType : eventType
            }

            alramShowHide('detail','hide');
            layoutAjaxCall('alramDetail',paramData);
        }

        /**
         * ajax call
         * @author psb
         */
        function layoutAjaxCall(actionType, data){
            sendAjaxPostRequest(layoutUrlConfig[actionType+'Url'],data,layoutSuccessHandler,layoutFailureHandler,actionType);
        }

        /**
         * layout success handler
         * @author psb
         * @private
         */
        function layoutSuccessHandler(data, dataType, actionType){
            switch(actionType){
                case 'alramDetail':
                    alramDetailRender(data);
                    break;
                case 'alramCancel':
                    layoutAlertMessage('alramCancelSuccess');
                    break;
            }
        }

        /**
         * layout failure handler
         * @author psb
         * @private
         */
        function layoutFailureHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
            layoutAlertMessage(actionType + 'Failure');
        }

        /*
         alert message method
         @author psb
         */
        function layoutAlertMessage(type){
            alert(layoutMessageConfig[type]);
        }

        function alramDetailRender(data){
            if(data!=null && data['action']!=null){
                var action = data['action'];
                var eventTypeName;

                switch (data['paramBean']['eventType']){
                    case "crane" :
                        eventTypeName = "크레인";
                        break;
                    case "worker" :
                        eventTypeName = "쓰러짐";
                        break;
                }

                $("#alramEvent").text(eventTypeName + " / " + action['eventName']);
                $("#alramActionDesc").html(action['actionDesc']);

                modifyElementClass($("#alramList li[eventLogId='"+data['paramBean']['eventLogId']+"']"),'infor','add');
                alramShowHide('detail','show');
            }else{
                alert("조치 정보가 없습니다.");
            }
        }

        function bodyAddClass(){
            switch (subMenuId){
                case "H00000": // 대쉬보드
                    modifyElementClass($("body"),'dashboard_mode','add');
                    break;
                default :
                    modifyElementClass($("body"),'admin_mode','add');
                    break;
            }
        }

        /**
         * 알람 show / hide
         */
        function alramShowHide(_type, _action, _status, _area){
            switch (_type){
                case "list":
                    if(_action == 'show'){
                        modifyElementClass($(".db_area"),'on','add');
                        if (_status != undefined) {
                            switch(_status) {
                                case "worker":
                                    $("#eventType option[value=worker]").prop("selected", "selected");
                                    break;
                                case "crane":
                                    $("#eventType option[value=crane]").prop("selected", "selected");
                                    break;
                            }
                        }

                        if (_area != undefined) {
                            $("#areaType option[value="+areaId+"]").prop("selected", "selected");
                        }

                    }else if(_action == 'hide'){
                        modifyElementClass($(".dbs_area"),'on','remove');
                        modifyElementClass($(".db_area"),'on','remove');
                        modifyElementClass($("#alramList > li"),'infor','remove');

                        $("#eventType option:eq(0)").prop("selected", "selected");
                        $("#areaType option:eq(0)").prop("selected", "selected");
                    }else{
                        if($(".db_area").hasClass("on")){
                            alramShowHide('list','hide');
                        }else{
                            alramShowHide('list','show');
                        }
                    }
                    break;
                case "detail":
                    if(_action == 'show'){
                        modifyElementClass($(".dbs_area"),'on','add');
                    }else if(_action == 'hide'){
                        modifyElementClass($(".dbs_area"),'on','remove');
                        modifyElementClass($("#alramList > li"),'infor','remove');
                    }
                    break;
            }
        }

        /**
         * 전체화면
         */
        function allView(_this){
            if($(_this).hasClass("on")){
                modifyElementClass($("body"),'on','remove');
                modifyElementClass($(_this),'on','remove');
            }else{
                modifyElementClass($("body"),'on','add');
                modifyElementClass($(_this),'on','add');
            }
        }

        /**
         * 메뉴바 동작
         */
        function menuView(_this){

//            var navPlusBtn = $(".nav_plus");
//            var navPlusTarget = $("nav");

//            navPlusBtn.on('click', function () {
//                $(this).toggleClass("on");
//                navPlusTarget.toggleClass("on");
//                $("body").toggleClass("navzoom");
//            });

            if($(_this).hasClass("on")){
                modifyElementClass($("body"),'navzoom','remove');
                modifyElementClass($(_this),'on','remove');
            }else{
                modifyElementClass($("body"),'navzoom','add');
                modifyElementClass($(_this),'on','add');
            }
        }

        function logout(){
            location.href = layoutUrlConfig['logoutUrl'];
        }

        function goHome(){
            location.href = layoutUrlConfig['mainUrl'];
        }

        function moveDashBoardDetail(id,name){
            var detailForm = $('<FORM>').attr('action',layoutUrlConfig['detailUrl']).attr('method','POST');
            detailForm.append($('<INPUT>').attr('type','hidden').attr('name','areaId').attr('value',id));
            detailForm.append($('<INPUT>').attr('type','hidden').attr('name','areaName').attr('value',name));
            document.body.appendChild(detailForm.get(0));
            detailForm.submit();
        }

        /**
        * 경고 알람 소리 재생
         * @param startTime
        * @param endTime
         */
        function playSegment(startTime, endTime){
            if (startTime == undefined) {
                startTime = 0;
            }

            if (endTime == undefined) {
                endTime = 5;
            }

            if (alarmPlayer.duration > 0 && !alarmPlayer.paused) {
                //Its playing...do your job
            } else {
                //Not playing...maybe paused, stopped or never played.
                segmentEnd = endTime;
                alarmPlayer.currentTime = startTime;
                alarmPlayer.play();
            }
        }
        /* 대쉬보드 전체 페이지 이동*/
        function moveFullDashFunc() {
            var deviceListForm = $('<FORM>').attr('method','POST').attr('action',layoutUrlConfig['dashBoardAllUrl']);
            deviceListForm.appendTo(document.body);
            deviceListForm.submit();
        }

    </script>
</head>
<body>
<!-- wrap Start -->
<div class="wrap">
    <!-- hearder Start 고통부분 -->
    <header id="header">
        <div class="header_area">
            <h1><button onclick="javascript:moveFullDashFunc(); return false;" href="#"></button></h1>
            <div class="ha_right_set">
                <div class="hrs_date">
                    <span id="nowTime"></span>
                    <span>${sessionScope.authAdminInfo.userName}</span>
                </div>
                <div class="hrs_btn_set">
                    <button class="db_btn issue_btn" onclick="javascript:alramShowHide('list');" title="<spring:message code="dashboard.title.alramCenter"/>"></button>
                    <button class="db_btn loginout_btn" href="#" onclick="javascript:logout();" title="<spring:message code="dashboard.title.logout"/>"></button>
                </div>
            </div>
        </div>
        <button class="db_btn zoom_btn change_btn" href="#" onclick="javascript:allView(this);" title="<spring:message code="dashboard.title.screenZoomout"/>"></button>
    </header>
    <!-- hearder End -->

    <!-- navigation 영역 Start -->
    <nav id="nav" class="nav">
        <button class="nav_plus" onclick="javascript:menuView(this);return false;"></button>
        <div class="nav_area"></div>
    </nav>
    <!-- navigation 영역 End -->

    <!-- 알림목록 영역 Start -->
    <aside class="db_area">
        <div class="db_header">
            <div>
                <h3 onclick="javascript:alramShowHide('list', 'hide'); return false;"><spring:message code="dashboard.title.alramCenter"/></h3>
                <button class="btn btype03 bstyle07" href="#" onclick="javascript:alramCancel();"><spring:message code="dashboard.title.alramCancel"/></button>
            </div>
            <div>
                <div class="check_box_set">
                    <input type="checkbox" class="check_input" onclick="javascript:alramAllCheck(this);"/>
                    <label class="lablebase lb_style01"></label>
                </div>
                <select id="eventType">
                    <option value="">전체</option>
                    <option value="crane"><spring:message code="dashboard.selectbox.crane"/></option>
                    <option value="worker"><spring:message code="dashboard.selectbox.worker"/></option>
                    <%--<option value="inout"><spring:message code="dashboard.selectbox.inout"/></option>--%>
                </select>
                <isaver:areaSelectBox htmlTagId="areaType" allModel="true"/>
            </div>
        </div>
        <div class="db_contents nano">
            <ul class="nano-content" id="alramList"></ul>
        </div>
        <div class="db_bottom">
            <button href="#" onclick="alramShowHide('list', 'hide');"><spring:message code="common.button.close"/></button>
        </div>
    </aside>
    <!-- 알림목록 영역 End -->

    <!-- 알림상세 영역 Start -->
    <aside class="dbs_area">
        <div class="db_header">
            <div><h3 onclick="javascript:alramShowHide('detail', 'hide'); return false;"><spring:message code="dashboard.title.action"/></h3></div>
            <div><p id="alramEvent"></p></div>
        </div>
        <div class="db_contents nano">
            <div class="nano-content text_area" id="alramActionDesc"></div>
        </div>
        <div class="db_bottom">
            <button href="#" onclick="alramShowHide('detail', 'hide');"><spring:message code="common.button.close"/></button>
        </div>
    </aside>
    <!-- 알림상세 영역 End -->

    <!-- 토스트 영역 Start -->
    <aside class="toast_popup on"></aside>
    <!-- 토스트 영역 End -->

    <audio controls style="display: none">
        <source src="${rootPath}/assets/library/sound/alarm.mp3" type="audio/mpeg">
    </audio>

    <tiles:insertAttribute name="body" />
</div>
</body>
</html>