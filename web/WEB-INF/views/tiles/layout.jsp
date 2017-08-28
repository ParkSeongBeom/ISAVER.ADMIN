<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <link href="${rootPath}/assets/css/base.css?version=${version}" rel="stylesheet" type="text/css" />
    <title>iSaver Admin</title>
    <script type="text/javascript" src="${rootPath}/assets/js/common/jquery.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/common/jquery.event.drag-1.5.min.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/common/jquery-ui.custom.min.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/calendar-helper.js?version=${version}"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/common/default.js?version=${version}"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/data-util.js?version=${version}"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/common/jquery.cookie.js"></script>

    <script src="${rootPath}/assets/js/page/menu/MenuModel.js?version=${version}" type="text/javascript" charset="UTF-8"></script>
    <script src="${rootPath}/assets/js/page/menu/MenuCtrl.js?version=${version}" type="text/javascript" charset="UTF-8"></script>
    <script src="${rootPath}/assets/js/page/menu/MenuView.js?version=${version}" type="text/javascript" charset="UTF-8"></script>

    <script src="${rootPath}/assets/js/page/area/AreaModel.js?version=${version}" type="text/javascript" charset="UTF-8"></script>
    <script src="${rootPath}/assets/js/page/area/AreaCtrl.js?version=${version}" type="text/javascript" charset="UTF-8"></script>
    <script src="${rootPath}/assets/js/page/area/AreaView.js?version=${version}" type="text/javascript" charset="UTF-8"></script>

    <!-- util -->
    <script type="text/javascript" src="${rootPath}/assets/js/util/consolelog-helper.js?version=${version}"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js?version=${version}"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/common-util.js?version=${version}"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/elements-util.js?version=${version}"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/dashBoard-helper.js?version=${version}"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/template/template-helper.js?version=${version}"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/md5.min.js"></script>

    <script type="text/javascript">
        var rootPath = '${rootPath}';
        var calendarHelper = new CalendarHelper(rootPath);
        var menuModel = new MenuModel();
        var menuCtrl = null;
        var dashBoardHelper = new DashBoardHelper();
        var templateHelper = new TemplateHelper();
        var serverDatetime = new Date();
        serverDatetime.setTime(${serverDatetime});
        var _eventDatetime = new Date();

        var layoutUrlConfig = {
            'logoutUrl':'${rootPath}/logout.html'
            ,'mainUrl':'${rootPath}/main.html'
            ,'dashboardUrl':'${rootPath}/dashboard/list.html'
            ,'alarmListUrl':'${rootPath}/eventLog/alarm.json'
            ,'alarmDetailUrl':'${rootPath}/action/eventDetail.json'
            ,'alarmCancelUrl':'${rootPath}/eventLog/cancel.json'
            ,'dashboardUrl':'${rootPath}/dashboard/list.html'
            ,'profileUrl':'${rootPath}/user/profile.json'
            ,'saveProfileUrl':'${rootPath}/user/save.json'
        };

        var layoutMessageConfig = {
            alarmCancelSuccess    :'<spring:message code="dashboard.message.alarmCancelSuccess"/>'
            , alarmDetailFailure  :'<spring:message code="dashboard.message.alarmDetailFailure"/>'
            , alarmCancelFailure  :'<spring:message code="dashboard.message.alarmCancelFailure"/>'
            , emptyAlarmCancel    :'<spring:message code="dashboard.message.emptyAlarmCancel"/>'
            , emptyAlarmCancelDesc:'<spring:message code="dashboard.message.emptyAlarmCancelDesc"/>'
            , profileFailure      :'<spring:message code="dashboard.message.profileFailure"/>'
            , emptyUserName       :'<spring:message code="dashboard.message.emptyUserName"/>'
            , saveProfileSuccess  :'<spring:message code="dashboard.message.saveProfileSuccess"/>'
            , notEqualPassword    :'<spring:message code="dashboard.message.notEqualPassword"/>'
        };

        var alramPlayer;
        var alramDefaultSource = '${rootPath}/assets/library/sound/alarm.mp3';
        var segmentEnd;
        var refreshTimeCallBack;

        var criticalCss = {
            <c:forEach var="criticalLevel" items="${criticalLevelCss}">
                '${criticalLevel.key}' : '${criticalLevel.value}',
            </c:forEach>
        };

        $(document).ready(function(){
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
                if($("body").hasClass("admin_mode")){
                    if (!$(event.target).closest("button, .db_area, .dbs_area, .personal_popup, .popupbase").length) {
                        layerShowHide('list','hide');
                    }
                }else if($("body").hasClass("dashboard_mode")){
                    if (!$(event.target).closest("button, .db_area, .dbs_area, .personal_popup, .popupbase").length) {
                        layerShowHide('profile','hide');
                    }
                }
            });

            // 알림해제 버튼 활성화
            $(".check_input").click(function(){
                alarmCancelBtnAction();
            });

            // 알림센터 내부 셀렉트 박스 클릭시 이벤트
            $("#criticalLevel").on("change",function(){
                alarmTypeChangeHandler();
            });
            $("#areaType").on("change",function(){
                alarmTypeChangeHandler();
            });

            bodyAddClass();
            printTime();

            // 알람 리스트 불러오기
            layoutAjaxCall('alarmList');

            wsConnect();
            aliveSend(900000);

            alramPlayer = document.getElementsByTagName("audio")[0];
            alramPlayer.addEventListener('timeupdate', function (){
                if (segmentEnd && alramPlayer.currentTime >= segmentEnd) {
                    alramPlayer.pause();
                }
            }, false);
            setAlramAudio();
        });

        function alarmCancelBtnAction(){
            if($("#alarmList .check_input").is(":checked")) {
                modifyElementClass($(".dbc_open_btn"),'on','add');
            } else {
                modifyElementClass($(".dbc_open_btn"),'on','remove');
                $(".db_allcheck .check_input").prop("checked",false);
            }
        }

        function alarmListRefresh() {
            if($("#alarmList li").length>0){
                modifyElementClass($(".issue_btn"),'issue','add');
            }else{
                modifyElementClass($(".issue_btn"),'issue','remove');
            }
        }

        function alarmTypeChangeHandler() {
            var criticalLevel = $("#criticalLevel option:selected").val() != "" ? "[criticalLevel='"+$("#criticalLevel option:selected").val()+"']" : "";
            var areaType = $("#areaType option:selected").val() != "" ? "[areaId='"+$("#areaType option:selected").val()+"']" : "";

            if(criticalLevel=="" && areaType==""){
                $("#alarmList li").show();
            } else{
                $("#alarmList li"+criticalLevel+areaType).show();
                $("#alarmList li").not(criticalLevel+areaType).hide();
            }
        }

        function alarmAllCheck(_this){
            if($(_this).is(":checked")){
                $("#alarmList li").addClass("check");
                $("#alarmList .check_input").prop("checked",true);
            }else{
                $("#alarmList li").removeClass("check");
                $("#alarmList .check_input").prop("checked",false);
            }
        }

        function setRefreshTimeCallBack(_function){
            if(_function!=null && typeof _function == "function"){
                refreshTimeCallBack = _function;
            }
        }

        function printTime() {
            $("#nowTime").text(serverDatetime.format("MM.dd E HH:mm:ss"));

            if(_eventDatetime!=null){
                var gap = serverDatetime.getTime() - _eventDatetime.getTime();
                var hour = Math.floor(gap / (1000*60*60));
                if(hour>0 && hour<10) {hour = "0" + hour;}
                var minute = Math.floor(gap / (1000*60))%60;
                if(minute>0 && minute<10) {minute = "0" + minute;}
                var second = Math.floor(gap / (1000))%60;
                if(second>0 && second<10) {second = "0" + second;}

                $("section[alarm_detail] p[currentDatetime]").text(hour + ":" + minute + ":" + second);
            }

            if(refreshTimeCallBack!=null && typeof refreshTimeCallBack == "function"){
                refreshTimeCallBack(serverDatetime);
            }

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
         * alarm cencel
         * @author psb
         */
        function alarmCancel(){
            var eventLogIdList = $("#alarmList li.check").map(function(){return $(this).attr("eventLogId")}).get();
            var alarmIdList = $("#alarmList li.check").map(function(){return $(this).attr("alarmId")}).get();
            var eventCancelDesc = $("#eventCancelDesc").val();

            if(eventCancelDesc==null || eventLogIdList.length == 0){
                layoutAlertMessage('emptyAlarmCancelDesc');
                return false;
            }

            var param = {
                'eventLogIds' : eventLogIdList.join(",")
                ,'alarmIds' : alarmIdList.join(",")
                ,'eventCancelDesc' : eventCancelDesc
            };

            layoutAjaxCall('alarmCancel',param);
        }

        /**
         * get profile
         * @author psb
         */
        function getProfile(_this){
            if($(_this).hasClass("on")){
                layerShowHide('profile','hide');
            }else{
                layoutAjaxCall('profile',{userId:"${sessionScope.authAdminInfo.userId}"});
            }
        }

        /**
         * save profile
         * @author psb
         */
        function saveProfile(){
            var userName = $("#userName").val().trim();
            var userPassword = $("#userPassword").val().trim();
            var password_confirm = $("#password_confirm").val().trim();

            if(userName==null || userName==""){
                layoutAlertMessage('alarmCancelSuccess');
                return false;
            }

            if(userPassword!="" && userPassword != password_confirm){
                layoutAlertMessage('notEqualPassword');
                return false;
            }

            var paramData = {
                userId : "${sessionScope.authAdminInfo.userId}"
                , userName : userName
                , userPassword : userPassword
                , telephone : $("#telephone").val()
                , email : $("#email").val()
            };

            layoutAjaxCall('saveProfile',paramData);
        }

        /**
         * search alarm detail (action)
         * @author psb
         */
        function searchAlarmDetail(_this){
            if(!$(_this).hasClass("on")){
                var _parent = $(_this).parent();
                var paramData = {
                    eventLogId  : $(_parent).attr("eventLogId")
                    , eventId   : $(_parent).attr("eventId")
                    , areaName   : $(_parent).find("#areaName").text()
                    , deviceId   : $(_parent).attr("deviceId")
                    , eventDatetime : $(_parent).attr("eventDatetime")
                    , criticalLevel : $(_parent).attr("criticalLevel")
                };
                layoutAjaxCall('alarmDetail',paramData);
            }

            layerShowHide('detail','hide');
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
                case 'alarmList':
                    alarmListRender(data);
                    break;
                case 'alarmDetail':
                    alarmDetailRender(data);
                    break;
                case 'alarmCancel':
                    layerShowHide('alarmCancel','hide');
                    layoutAlertMessage('alarmCancelSuccess');
                    break;
                case 'profile':
                    var user = data['user'];
                    if(user!=null){
                        $("#userName").val(user['userName']);
                        $("#telephone").val(user['telephone']);
                        $("#email").val(user['email']);
                        $("#userPassword").val("");
                        $("#password_confirm").val("");
                        layerShowHide('profile','show');
                    }else{
                        layoutAlertMessage('profileFailure');
                    }
                    break;
                case 'saveProfile':
                    layerShowHide('profile','hide');
                    layoutAlertMessage('saveProfileSuccess');
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

        /**
         * Alarm List Render
         * @author psb
         * @private
         */
        function alarmListRender(data){
            if(data!=null && data['eventLogs']!=null){
                for(var index in data['eventLogs']){
                    addAlarm(data['eventLogs'][index], false);
                }

                alarmListRefresh();
                alarmTypeChangeHandler();
            }
        }

        /**
         * Add Alarm
         * @author psb
         * @private
         */
        function addAlarm(eventLog, flag){
            if($("#alarmList li[eventLogId='"+eventLog['eventLogId']+"']").length==0){
                var eventInfos = eventLog['infos'];
                var alarmId = "";
                var criticalLevel = "";
                if(eventInfos!=null){
                    for(var i in eventInfos){
                        if(eventInfos[i]['key']=='criticalLevel'){
                            criticalLevel = eventInfos[i]['value'];
                        }else if(eventInfos[i]['key']=='alarmId'){
                            alarmId = eventInfos[i]['value'];
                        }
                    }
                }

                if(criticalLevel==""){
                    return false;
                }

                // 알림센터
                var alarmTag = templateHelper.getTemplate("alarm01");
                alarmTag.on("click",function(){
                    if($(this).hasClass("check")){
                        $(this).find(".check_input").prop("checked",false);
                        modifyElementClass($(this),'check','remove');
                    }else{
                        $(this).find(".check_input").prop("checked",true);
                        modifyElementClass($(this),'check','add');
                    }
                    alarmCancelBtnAction();
                });

                alarmTag.addClass("level-"+criticalCss[criticalLevel]);
                alarmTag.attr("eventId",eventLog['eventId'])
                        .attr("criticalLevel",criticalLevel)
                        .attr("eventLogId",eventLog['eventLogId'])
                        .attr("areaId",eventLog['areaId'])
                        .attr("deviceId",eventLog['deviceId'])
                        .attr("alarmId",alarmId)
                        .attr("eventDatetime",eventLog['eventDatetime']);
                alarmTag.find("#areaName").text(eventLog['areaName']);
                alarmTag.find("#eventName").text(eventLog['eventName']);
                alarmTag.find("#eventDatetime").text(new Date(eventLog['eventDatetime']).format("MM/dd HH:mm:ss"));
                alarmTag.find(".infor_btn").attr("onclick","javascript:searchAlarmDetail(this); event.stopPropagation();");
                $("#alarmList").prepend(alarmTag);
                var levelTag = $("div[criticalLevelCnt] span["+criticalLevel+"]");
                levelTag.text(Number(levelTag.text())+1);
                modifyElementClass($(".issue_btn"),"level-"+criticalCss[criticalLevel],'add');

                if(flag==true){
                    /* 애니메이션 */
                    $(".issue_btn").removeClass("issue");
                    try {
                        setTimeout(function() {
                            $(".issue_btn").addClass("issue");
                        }, 150);
                    } catch(e) {}

                    /* 싸이렌 */
//                    setAlramAudio();
                    playSegment();

                    var toastTag = templateHelper.getTemplate("toast");
                    toastTag.addClass("level-"+criticalCss[criticalLevel]);
                    toastTag.attr("onclick","javascript:layerShowHide('list', 'show');");
                    toastTag.attr("eventLogId",eventLog['eventLogId']);
                    toastTag.find("#toastAreaName").text(eventLog['areaName']);
                    toastTag.find("#toastEventDesc").text(eventLog['eventName']);
                    $(".toast_popup").append(toastTag);

                    removeToastTag(toastTag);
                    function removeToastTag(_tag){
                        setTimeout(function(){
                            _tag.remove();
                        },3000);
                    }

                    alarmTypeChangeHandler();
                }
            }
        }

        /**
         * Remove Alarm
         * @author psb
         * @private
         */
        function removeAlarm(eventLogs){
            for(var index in eventLogs){
                var eventLog = eventLogs[index];
                var eventInfos = eventLog['infos'];

                var criticalLevel = "";
                if(eventInfos!=null){
                    for(var i in eventInfos){
                        if(eventInfos[i]['key']=='criticalLevel'){
                            criticalLevel = eventInfos[i]['value'];
                        }
                    }
                }

                if($("#alarmList li[eventLogId='"+eventLog['eventLogId']+"'] .infor_btn").hasClass("on")){
                    modifyElementClass($(".db_infor_box"),'on','remove');
                    modifyElementClass($(".infor_btn"),'on','remove');
                }

                $("#alarmList li[eventLogId='"+eventLog['eventLogId']+"']").remove();
                var levelTag = $("div[criticalLevelCnt] span["+criticalLevel+"]");
                var levelCtn = Number(levelTag.text())-1;
                levelTag.text(levelCtn);

                if(levelCtn==0){
                    modifyElementClass($(".issue_btn"),"level-"+criticalCss[criticalLevel],'remove');
                }
            }

            alarmCancelBtnAction();
            alarmListRefresh();
        }

        /**
         * Alarm Detail Render
         * @author psb
         * @private
         */
        function alarmDetailRender(data){
            if(data!=null && data['action']!=null){
                var action = data['action'];

                for(var key in criticalCss){
                    modifyElementClass($("section[alarm_detail]"),"level-"+criticalCss[key],'remove');
                }
                $("section[alarm_detail]").addClass("level-"+criticalCss[data['paramBean']['criticalLevel']]);
                $("section[alarm_detail] p[areaName]").text(data['paramBean']['areaName']);
                $("section[alarm_detail] p[eventName]").text(action['eventName']);
                $("section[alarm_detail] p[actionDesc]").text(action['actionDesc']);
                _eventDatetime.setTime(data['paramBean']['eventDatetime']);

                if(data['device']!=null && data['device']['linkUrl']!=null){
                    $("section[alarm_detail] .dbi_cctv button").attr("onclick","javascript:cctvOpen('"+data['device']['linkUrl']+"'); event.stopPropagation();");
                    $("section[alarm_detail] .dbi_cctv").show();
                }else{
                    $("section[alarm_detail] .dbi_cctv button").removeAttr("onclick");
                    $("section[alarm_detail] .dbi_cctv").hide();
                }

                $("section[alarm_detail] p[eventDatetime]").text(_eventDatetime.format("MM/dd HH:mm:ss"));
                modifyElementClass($("#alarmList li[eventLogId='"+data['paramBean']['eventLogId']+"'] .infor_btn"),'on','add');
                layerShowHide('detail','show');
            }else{
                alert("대응 정보가 없습니다.");
            }
        }

        function bodyAddClass(){
            switch (subMenuId){
                case "H00000": // 대쉬보드
                    modifyElementClass($("html"),'dashboard_mode','add');
                    modifyElementClass($("body"),'dashboard_mode','add');
                    break;
                default :
                    modifyElementClass($("html"),'admin_mode','add');
                    modifyElementClass($("body"),'admin_mode','add');
                    break;
            }
        }

        /**
         * 경보 show / hide
         */
        function layerShowHide(_type, _action){
            if(_action == null){
                if($("body").hasClass("admin_mode")){
                    if($(".db_area").hasClass("on")){
                        layerShowHide('list','hide');
                    }else{
                        layerShowHide('list','show');
                    }
                }
                return false;
            }

            switch (_type){
                case "list":
                    if(_action == 'show'){
                        modifyElementClass($(".db_area"),'on','add');
                        modifyElementClass($(".body.admin_mode section.container"),'on','add');
                    }else if(_action == 'hide'){
                        modifyElementClass($(".db_area"),'on','remove');
                        modifyElementClass($(".body.admin_mode section.container"),'on','remove');
                        layerShowHide('detail','hide');
                        layerShowHide('profile','hide');
                    }
                    break;
                case "detail":
                    if(_action == 'show'){
                        modifyElementClass($(".db_infor_box"),'on','add');
                    }else if(_action == 'hide'){
                        modifyElementClass($(".db_infor_box"),'on','remove');
                        modifyElementClass($(".infor_btn"),'on','remove');
                    }
                    break;
                case "profile":
                    if(_action == 'show'){
                        modifyElementClass($(".user_btn"),'on','add');
                        modifyElementClass($(".personal_popup"),'on','add');
                    }else if(_action == 'hide'){
                        modifyElementClass($(".user_btn"),'on','remove');
                        modifyElementClass($(".personal_popup"),'on','remove');
                    }
                    break;
                case "alarmCancel":
                    if(_action == 'show'){
                        var eventLogIdList = $("#alarmList li.check").map(function(){return $(this).attr("eventLogId")}).get();

                        if(eventLogIdList==null || eventLogIdList.length == 0){
                            layoutAlertMessage('emptyAlarmCancel');
                            return false;
                        }
                        modifyElementClass($("div[alarm_menu]"),'open_cancel','add');
                        modifyElementClass($(".db_cancel_set"),'on','add');
                    }else if(_action == 'hide'){
                        $("#eventCancelDesc").val("");
                        modifyElementClass($("div[alarm_menu]"),'open_cancel','remove');
                        modifyElementClass($(".db_cancel_set"),'on','remove');
                    }
                    break;
            }
        }

        function cctvOpen(linkUrl){
            window.open(linkUrl);
        }

        function logout(){
            location.href = layoutUrlConfig['logoutUrl'];
        }

        function goHome(){
            location.href = layoutUrlConfig['mainUrl'];
        }

        function setAlramAudio(sourceUrl){
            if(sourceUrl==null){
                sourceUrl = alramDefaultSource;
            }

            $("#alramSource").attr("src",sourceUrl);

            if(alramPlayer!=null){
                alramPlayer.load();
            }
        }

        /**
        * 경보 소리 재생
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

            if (alramPlayer.duration > 0 && !alramPlayer.paused) {
                //Its playing...do your job
            } else {
                //Not playing...maybe paused, stopped or never played.
                segmentEnd = endTime;
                alramPlayer.currentTime = startTime;
                alramPlayer.play();
            }
        }

        /* 대쉬보드 전체 페이지 이동*/
        function moveDashboard(areaId) {
            var dashboardForm = $('<FORM>').attr('method','POST').attr('action',layoutUrlConfig['dashboardUrl']);
            dashboardForm.append($('<INPUT>').attr('type','hidden').attr('name','areaId').attr('value',areaId));
            dashboardForm.appendTo(document.body);
            dashboardForm.submit();
        }
    </script>

    <!--
        웝소켓
        @authro dhj
        @date 2016.12.12
    -->
    <script type="text/javascript">
        var ws;
        var reConnectFlag = true;
        var webSocketUrl = "${webSocketUrl}";

        /**
         * 웹소켓 접속 연결
         * @author dhj
         */
        function wsConnect() {
            setTimeout(function() {
                dashBoardHelper.getData();

                if(webSocketUrl=="" || webSocketUrl==null){
                    console.error('[wsConnect]websocket url is null');
                    return false;
                }

                ws = new WebSocket(webSocketUrl);
                ws.onopen = function () {
                    console.log('websocket opened');
                };

                ws.onmessage = messageEventHandler;

                ws.onclose = function (event) {
                    console.log(event);
                    console.log('websocket closed');

                    if (reConnectFlag) {
                        setTimeout(function() {
                            wsConnect();
                        }, 5000);
                    }
                };
            }, 250);

        }

        /**
        * 웹소켓 메세지 전송
        * @param _text
         * @author dhj
         */
        function wsSendMsg(_text) {
            if (ws) {
                if (_text != null && _text != "") {
                    ws.send(_text);
                }
            } else {
                console.log("ws disConnect!");
            }
        }

        /**
        * 웹소켓 접속 종료
         * @author dhj
         */
        function wsDisconnect() {
            if (ws) {
                ws.close();
                ws = null;
            }
        }

        /**
        * 웹소켓 메세지 리스너
        * @param message
        */
        function messageEventHandler(message) {
            var resultData = JSON.parse(message.data);
            var callBackFlag = false;

            switch (resultData['messageType']) {
                case "refreshView": // 화면갱신
                    callBackFlag = false;
                    break;
                case "addAlarmEvent": // 알림이벤트 등록
                    if(resultData['dashboardAlramFileUrl']!=null){
                        setAlramAudio(resultData['dashboardAlramFileUrl']);
                    }else{
                        setAlramAudio();
                    }
                    addAlarm(resultData['eventLog'], true);
                    callBackFlag = true;
                    break;
                case "removeAlarmEvent": // 알림이벤트 해제
                    removeAlarm(resultData['eventLog']);
                    callBackFlag = true;
                    break;
                case "addEvent": // 일반이벤트 등록
                    callBackFlag = true;
                    break;
            }

            if(callBackFlag){
                dashBoardHelper.callBackEvent(resultData['eventLog'], resultData['messageType']);
            }else{
                dashBoardHelper.getData();
            }
        }
    </script>
</head>
<body>
<!-- wrap Start -->
<div class="wrap">
    <!-- hearder Start 고통부분 -->
    <header id="header">
        <div class="header_area">
            <h1><a href="#" onclick="javascript:moveDashboard(); return false;"></a></h1>

            <!-- menu Start -->
            <menu><ul menu_main></ul></menu>
            <!-- menu End -->

            <!-- 시계 + 알림 + 사용자 + 로그아웃 버튼 영역 Start -->
            <div class="header_right_area">
                <div class="datetime_set">
                    <span id="nowTime"></span>
                </div>
                <div class="header_btn_set">
                    <button class="issue_btn" onclick="javascript:layerShowHide('list');" title="<spring:message code="dashboard.title.alarmCenter"/>"></button>
                    <button class="user_btn" onclick="javascript:getProfile(this); event.stopPropagation();" title="<spring:message code="dashboard.title.profile"/>"></button>
                    <button class="loginout_btn" onclick="javascript:logout();" title="<spring:message code="dashboard.title.logout"/>"></button>
                </div>
            </div>
            <!-- 시계 + 알림 + 사용자 + 로그아웃 버튼 영역 End -->
        </div>
        <!-- header_area 영역 End -->
    </header>
    <!-- hearder End -->

    <!-- 알림센터 영역 Start -->
    <aside class="db_area">
        <h2>
            <!-- 임계치별 알림 카운트 -->
            <div criticalLevelCnt>
                <c:forEach var="critical" items="${criticalList}">
                    <span ${critical.codeId}>0</span>
                </c:forEach>
            </div>
        </h2>

        <!-- 알림 이력 + 알림 해지 영역 -->
        <section class="db_list_box">
            <!-- 이력 선택 및 알림해지 버튼-->
            <div alarm_menu>
                <div class="checkbox_set csl_style01 db_allcheck">
                    <input type="checkbox" class="check_input" onclick="javascript:alarmAllCheck(this);"/>
                    <label></label>
                </div>
                <isaver:codeSelectBox groupCodeId="LEV" htmlTagId="criticalLevel" allModel="true"/>
                <isaver:areaSelectBox htmlTagId="areaType" allModel="true"/>
                <button class="btn dbc_open_btn" onclick="javascript:layerShowHide('alarmCancel','show');"></button>
            </div>

            <!-- 알림 이력-->
            <ul id="alarmList"></ul>

            <!-- 알림해지 영역 -->
            <div class="db_cancel_set">
                <textarea id="eventCancelDesc" placeholder="<spring:message code='dashboard.placeholder.alarmCancel'/>"></textarea>
                <div class="btn_set">
                    <button class="btn" onclick="javascript:alarmCancel();"><spring:message code="common.button.save"/></button>
                    <button class="btn close" onclick="javascript:layerShowHide('alarmCancel','hide');"><spring:message code="common.button.cancel"/></button>
                </div>
            </div>
        </section>

        <!-- 알림 상세 영역 -->
        <section alarm_detail class="db_infor_box">
            <div class="dbi_event">
                <p areaName></p>
                <p eventName></p>
                <p eventDatetime></p>
                <p currentDatetime></p>
            </div>
            <div class="dbi_cctv"><button></button></div>
            <div class="dbi_copy">
                <p actionDesc></p>
            </div>
        </section>
    </aside>
    <!-- 알림목록 영역 End -->

    <!-- 토스트 영역 Start -->
    <div class="toast_popup on"></div>
    <!-- 토스트 영역 End -->

    <!-- 개인상세 정보 팝업-->
    <div class="personal_popup">
        <section>
            <h2><spring:message code="dashboard.title.profile"/></h2>
            <form>
                <div class="form_area">
                    <span><spring:message code="dashboard.column.userName"/></span>
                    <input type="text" id="userName" />
                    <span><spring:message code="dashboard.column.password"/></span>
                    <input type="password" id="userPassword" placeholder="<spring:message code="common.message.passwordEdit"/>"/>
                    <span><spring:message code="dashboard.column.passwordConfirm"/></span>
                    <input type="password" id="password_confirm" placeholder="<spring:message code="common.message.passwordEdit"/>"/>
                    <span><spring:message code="dashboard.column.telephone"/></span>
                    <input type="text" id="telephone" />
                    <span><spring:message code="dashboard.column.email"/></span>
                    <input type="text" id="email" />
                </div>
            </form>
        </section>
        <div class="btn_set">
            <button class="btn" onclick="javascript:saveProfile();"><spring:message code="common.button.save"/></button>
        </div>
    </div>

    <audio controls style="display: none">
        <source id="alramSource" type="audio/mpeg">
    </audio>

    <tiles:insertAttribute name="body" />
</div>
</body>
</html>