<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<!DOCTYPE html>
<html class="admin_mode">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <link href="${rootPath}/assets/css/reset.css?version=${version}" rel="stylesheet" type="text/css" />
    <link href="${rootPath}/assets/css/layouts.css?version=${version}" rel="stylesheet" type="text/css" />
    <link href="${rootPath}/assets/css/elements.css?version=${version}" rel="stylesheet" type="text/css" />
    <link href="${rootPath}/assets/css/dashboard.css?version=${version}" rel="stylesheet" type="text/css" />
    <link href="${rootPath}/assets/css/admin.css?version=${version}" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" type="text/css" href="${rootPath}/assets/library/chartist/chartist.min.css" >
    <link rel="stylesheet" type="text/css" href="${rootPath}/assets/library/chartist/chartist-plugin-tooltip.css" >
    <title>iSaver Admin</title>
    <script type="text/javascript" src="${rootPath}/assets/js/common/jquery.js?version=${version}"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/common/jquery.event.drag-1.5.min.js?version=${version}"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/common/jquery-ui.min.js?version=${version}"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/calendar-helper.js?version=${version}"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/common/default.js?version=${version}"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/data-util.js?version=${version}"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/common/jquery.cookie.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/library/chartist/chartist.min.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/library/chartist/chartist-plugin-tooltip.js"></script>

    <script src="${rootPath}/assets/js/page/menu/MenuModel.js?version=${version}" type="text/javascript" charset="UTF-8"></script>
    <script src="${rootPath}/assets/js/page/menu/MenuCtrl.js?version=${version}" type="text/javascript" charset="UTF-8"></script>
    <script src="${rootPath}/assets/js/page/menu/MenuView.js?version=${version}" type="text/javascript" charset="UTF-8"></script>

    <!-- util -->
    <script type="text/javascript" src="${rootPath}/assets/js/util/consolelog-helper.js?version=${version}"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/common-util.js?version=${version}"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js?version=${version}"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/common/jquery.iframe-post-form.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/elements-util.js?version=${version}"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/template/template-helper.js?version=${version}"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/websocket-helper.js?version=${version}"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/notification-helper.js?version=${version}"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/md5.min.js?version=${version}"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/cs.communicator.js?version=${version}"></script>

    <script type="text/javascript">
        var rootPath = '${rootPath}';
        var cs;
        var targetId = '${mainTarget.targetId}';
        var calendarHelper = new CalendarHelper(rootPath, "${pageContext.response.locale}");
        var menuModel = new MenuModel();
        var menuCtrl = null;
        var templateHelper = new TemplateHelper();
        var serverDatetime = new Date();
        serverDatetime.setTime(${serverDatetime});
        var datetimeGap = new Date().getTime() - serverDatetime.getTime();
        var _eventDatetime = new Date();
        var webSocketHelper = new WebSocketHelper();
        var notificationHelper = new NotificationHelper(rootPath);
        var dashboardFlag = false;

        var layoutUrlConfig = {
            'logoutUrl':'${rootPath}/logout.html'
            ,'mainUrl':'${rootPath}/main.html'
            ,'dashboardUrl':'${rootPath}/dashboard/list.html'
            ,'profileUrl':'${rootPath}/user/profile.json'
            ,'saveProfileUrl':'${rootPath}/user/save.json'
            ,'aliveUrl':'${rootPath}/license/list.json'
            ,'licenseUrl':'${rootPath}/license/list.json'
            ,'resourceDeviceUrl':'${rootPath}/device/resourceList.json'
            ,'resourceChartUrl' : "${rootPath}/eventLog/resourceChart.json"
        };

        var commonMessageConfig = {
            'inProgress':'<spring:message code="common.message.inProgress"/>'
        };

        var layoutMessageConfig = {
            notificationDetailFailure  :'<spring:message code="dashboard.message.notificationDetailFailure"/>'
            , profileFailure      :'<spring:message code="dashboard.message.profileFailure"/>'
            , emptyUserName       :'<spring:message code="dashboard.message.emptyUserName"/>'
            , saveProfileSuccess  :'<spring:message code="dashboard.message.saveProfileSuccess"/>'
            , notEqualPassword    :'<spring:message code="dashboard.message.notEqualPassword"/>'
            , emptyAction  :'<spring:message code="dashboard.message.emptyAction"/>'
            , emptyNotification    :'<spring:message code="dashboard.message.emptyNotification"/>'
            , confirmAllCancelNotification  :'<spring:message code="dashboard.message.confirmAllCancelNotification"/>'
            , allCancelNotificationSuccess  :'<spring:message code="dashboard.message.cancelNotificationSuccess"/>'
            , allCancelNotificationFailure    :'<spring:message code="dashboard.message.cancelNotificationFailure"/>'
            , cancelNotificationSuccess  :'<spring:message code="dashboard.message.cancelNotificationSuccess"/>'
            , cancelNotificationFailure    :'<spring:message code="dashboard.message.cancelNotificationFailure"/>'
            , confirmNotificationSuccess  :'<spring:message code="dashboard.message.confirmNotificationSuccess"/>'
            , confirmNotificationFailure    :'<spring:message code="dashboard.message.confirmNotificationFailure"/>'
            , emptyLicense :'<spring:message code="common.message.emptyLicense"/>'
            , expireLicense :'<spring:message code="common.message.expireLicense"/>'
        };

        var alarmPlayer;
        var alarmDefaultSource = '${rootPath}/assets/library/sound/alarm.mp3';
        var segmentEnd;
        var refreshTimeCallBack = [];
        var resourceChart = {
            "chartist" : null
            ,"interval" : null
            ,"intervalDelay" : 10000
        };

        var criticalCss = {
            <c:forEach var="criticalLevel" items="${criticalLevelCss}" varStatus="status">
                '${criticalLevel.key}' : '${criticalLevel.value}' ${!status.last?',':''}
            </c:forEach>
        };

        var criticalList = {
            <c:forEach var="critical" items="${criticalList}" varStatus="status">
                '${critical.codeId}' : [] ${!status.last?',':''}
            </c:forEach>
        };

        $(document).ready(function(){
            cs = new fnCSController();
            cs.init();

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

            // 외부 클릭시 팝업 닫기
            $(".wrap").on("click",function(event){
                if (!$(event.target).closest("button, .db_area, .dbs_area, .tpopup-personal, .popupbase, .tpopup-info, .tpopup-resource").length) {
                    layerShowHide('detail','hide');
                    layerShowHide('profile','hide');
                    layerShowHide('license','hide');
                    layerShowHide('resource','hide');
                }
            });

            // 타이틀에 텍스트 맵핑
            $.each($("table.t_type01 > tbody > tr > td"),function(){
                var text = $(this).immediateText();
                if(text!=""){
                    $(this).attr("title",text);
                }
            });

            if(subMenuId == "100000"){
                modifyElementClass($("html"),'admin_mode','remove');
                modifyElementClass($("body"),'admin_mode','remove');
                modifyElementClass($("html"),'dashboard_mode','add');
                modifyElementClass($("body"),'dashboard_mode','add');
                modifyElementClass($("body"),'dark_mode','add');
                dashboardFlag = true;
            }

            printTime();

            notificationHelper.setMessageConfig(layoutMessageConfig);
            notificationHelper.setElement($("#notificationList"));
            notificationHelper.createEventListener();
            notificationHelper.getNotificationList();
            notificationHelper.setWebsocket(webSocketHelper, {'notification':"${eventWebSocketUrl}"});
            aliveSend("${aliveCheckDelay}");

            alarmPlayer = document.getElementsByTagName("audio")[0];
            alarmPlayer.addEventListener('timeupdate', function (){
                if (segmentEnd && alarmPlayer.currentTime >= segmentEnd) {
                    alarmPlayer.pause();
                }
            }, false);
            setAlarmAudio();

            $.cookie.defaults = {path:'/'};
            if($.cookie("notificationShowFlag")=='Y'){
                layerShowHide('list');
            }
            initResourceChart();
        });

        function initResourceChart(){
            resourceChart['chartist'] = new Chartist.Line($("#resourceChartElement")[0], {
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
                lineSmooth: Chartist.Interpolation.cardinal({
                    fillHoles: true
                }),
                plugins: [
                    Chartist.plugins.tooltip()
//                    ,ctPointLabels()
                ]
            });

            $("#resourceAreaId").on("change",function(){
                var areaId = $(this).val();
                if(areaId!=null && areaId!=""){
                    layoutAjaxCall('resourceDevice',{'areaId':areaId,'eventIds':'EVT800,EVT801,EVT802,EVT803'});
                }
            });
        }

        function addRefreshTimeCallBack(_function){
            if(_function!=null && typeof _function == "function"){
                refreshTimeCallBack.push(_function);
            }
        }

        function printTime() {
            serverDatetime.setTime(new Date().getTime()-datetimeGap);
            $("#nowTime").text(serverDatetime.format("MM.dd E HH:mm:ss"));

            if(_eventDatetime!=null){
                var gap;
                var negative = false;
                if(serverDatetime > _eventDatetime){
                    gap = serverDatetime.getTime() - _eventDatetime.getTime();
                }else{
                    gap = _eventDatetime.getTime() - serverDatetime.getTime();
                    negative = true;
                }
                var hour = Math.floor(gap / (1000*60*60));
                if(hour>=0 && hour<10) {hour = "0" + hour;}
                var minute = Math.floor(gap / (1000*60))%60;
                if(minute>=0 && minute<10) {minute = "0" + minute;}
                var second = Math.floor(gap / (1000))%60;
                if(second>=0 && second<10) {second = "0" + second;}

                $("section[alarm_detail] p[currentDatetime]").text((negative?"-":"") + hour + ":" + minute + ":" + second);
            }

            for(var index in refreshTimeCallBack){
                if(refreshTimeCallBack[index]!=null && typeof refreshTimeCallBack[index] == "function"){
                    refreshTimeCallBack[index](serverDatetime);
                }
            }

            setTimeout(function(){
                printTime();
            },1000);
        }

        /**
         * [인터벌] alive send
         * @author psb
         */
        function aliveSend(_time) {
            if(_time==null || _time==""){
                _time = 60000;
            }

            setInterval(function() {
                layoutAjaxCall('alive');
            }, _time);
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
         * get License
         * @author psb
         */
        function getLicense(_this){
            if($(_this).hasClass("on")){
                $(".tpopup-info #licenseList").empty();
                layerShowHide('license','hide');
            }else{
                layoutAjaxCall('license');
            }
        }

        /**
         * resource Popup open
         * @author psb
         */
        function openResourcePopup(_this){
            if($(_this).hasClass("on")){
                layerShowHide('resource','hide');
            }else{
                layerShowHide('resource','show');
            }
        }

        function resourceDeviceRender(deviceList, eventList, deviceCodeCss){
            $("#resourceDeviceId option").not(":eq(0)").remove();

            // 장치리스트
            for(var index in deviceList){
                var device = deviceList[index];

                if(device['deviceCode']=="DEV800" || device['deviceCode']=="DEV801"){
                    $("#resourceDeviceId").append(
                        $("<option/>",{value:device['deviceId']}).text(device['deviceName'])
                    );
                }
            }

            if($("#resourceEventId option").length <= 1){
                for(var i in eventList){
                    $("#resourceEventId").append(
                        $("<option/>",{value:eventList[i]['eventId']}).text(eventList[i]['eventName'])
                    );
                }
            }
        }

        function resourceDateSelTypeClick(_this){
            if($(_this).hasClass("on")){
                return false;
            }else{
                $("#resourceDateSelType").find("button").removeClass("on");
                $(_this).addClass("on");
                findListResourceChart();
            }
        }

        function findListResourceChart(){
            function getResourceChart(){
                if($("#resourceAreaId option:selected").val()!="" && $("#resourceDeviceId option:selected").val()!="" && $("#resourceEventId option:selected").val()!=""){
                    var _now = new Date();
                    var _truncType = $("#resourceDateSelType button.on").attr("value");
                    layoutAjaxCall(
                            'resourceChart'
                            ,{
                                areaId:$("#resourceAreaId option:selected").val()
                                , deviceId:$("#resourceDeviceId option:selected").val()
                                , eventId:$("#resourceEventId option:selected").val()
                                , startDatetime:new Date(_now.getTime()-_truncType*1000).format('yyyy-MM-dd HH:mm:ss')
                                , endDatetime:_now.format('yyyy-MM-dd HH:mm:ss')
                            }
                    );
                }else{
                    stopResourceChartInterval();
                }
            }
            function stopResourceChartInterval(){
                if(resourceChart['interval']!=null){
                    clearInterval(resourceChart['interval']);
                }
            }
            stopResourceChartInterval();

            getResourceChart();
            resourceChart['interval'] = setInterval(function() {
                getResourceChart();
            }, resourceChart['intervalDelay']);
        }

        function resourceUpdate(data){
            if($("#resourceAreaId option:selected").val()!=data['areaId'] || $("#resourceDeviceId option:selected").val()!=data['deviceId'] || $("#resourceEventId option:selected").val()!=data['eventId']){
                return false;
            }

            let updateFlag = false;
            let eventValue;
            for(let index in data['infos']){
                const info = data['infos'][index];

                if(info['key']=="value"){
                    eventValue = info['value'];
                    updateFlag = true;
                }
            }

            if(updateFlag){
                let _eventDate = new Date(data['eventDatetime']).format("HH:mm:ss");
                resourceChart['chartist'].data.series[0].push({meta:_eventDate,value:eventValue});
                resourceChart['chartist'].data.labels[resourceChart['chartist'].data.labels.length-1] = null;
                resourceChart['chartist'].data.labels.push(_eventDate);
                resourceChart['chartist'].update();
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
                layoutAlertMessage('emptyUserName');
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
                case 'license':
                    const popupElement = $(".tpopup-info");
                    if(data['license']['status']==-99){
                        popupElement.find("#expireDate").text("none authorize license");
                    }else{
                        if(data['licenseExpireDate']!=null){
                            popupElement.find("#expireDate").text(data['licenseExpireDate']);
                        }
                        var licenseList = data['licenseList'];
                        for(var index in licenseList){
                            var license = licenseList[index];
                            popupElement.find("#licenseList").append(
                                $("<div/>").append(
                                    $("<span/>").text(license['deviceCodeName'])
                                ).append(
                                    $("<p/>").text(license['deviceCnt']+"/"+license['licenseCnt'])
                                )
                            );
                        }
                    }
                    layerShowHide('license','show');
                    notificationHelper.licenseStatusChangeHandler(data['license']['status']);
                    break;
                case 'saveProfile':
                    layerShowHide('profile','hide');
                    layoutAlertMessage('saveProfileSuccess');
                    break;
                case 'alive':
                    notificationHelper.licenseStatusChangeHandler(data['license']['status']);
                    break;
                case 'resourceDevice':
                    resourceDeviceRender(data['deviceList'],data['eventList'],data['deviceCodeCss']);
                    break;
                case 'resourceChart':
                    var paramBean = data['paramBean'];

                    if($("#resourceAreaId option:selected").val()!=paramBean['areaId']){
                        return false;
                    }

                    var _chartList = [];
                    var _eventDateList = [];
                    var _startDt = new Date(paramBean['startDatetime']).format("HH:mm:ss");
                    _chartList.push({meta:_startDt,value:null});
                    _eventDateList.push(_startDt);

                    var _endDt = new Date(paramBean['endDatetime']).format("HH:mm:ss");
                    var endDtAddFlag = true;

                    if (data['eventLogChartList'] != null) {
                        var eventLogChartList = data['eventLogChartList'];

                        for(var index in eventLogChartList){
                            var item = eventLogChartList[index];
                            var _eventDate = new Date(item['eventDatetime']).format("HH:mm:ss");
                            _chartList.push({meta:_eventDate,value:item['value']});
                            if(_eventDate == _endDt){
                                endDtAddFlag = false;
                                _eventDateList.push(_eventDate);
                            }else{
                                _eventDateList.push(null);
                            }
                        }
                    }

                    if(endDtAddFlag){
                        _chartList.push({meta:_endDt,value:null});
                        _eventDateList.push(_endDt);
                    }
                    resourceChart['chartist'].data.series[0] = _chartList;
                    resourceChart['chartist'].data.labels = _eventDateList;
                    resourceChart['chartist'].update();
                    break;
            }
        }

        /**
         * layout failure handler
         * @author psb
         * @private
         */
        function layoutFailureHandler(XMLHttpRequest, textStatus, errorThrown, actionType){
            switch(actionType){
                case 'alive':
                    $('.network_popup').show();
                    break;
                default :
                    if(XMLHttpRequest['status']!="0"){
                        layoutAlertMessage(actionType + 'Failure');
                    }
            }
        }

        /*
         alert message method
         @author psb
         */
        function layoutAlertMessage(type){
            alert(layoutMessageConfig[type]);
        }

        /**
         * 경보 show / hide
         */
        function layerShowHide(_type, _action){
            if(_action == null){
                if($(".db_area").hasClass("on")){
                    $.cookie('notificationShowFlag','');
                    layerShowHide('list','hide');
                }else{
                    $.cookie('notificationShowFlag','Y');
                    layerShowHide('list','show');
                }
                return false;
            }

            switch (_type){
                case "list":
                    if(_action == 'show'){
                        modifyElementClass($(".db_area"),'on','add');
                    }else if(_action == 'hide'){
                        modifyElementClass($(".db_area"),'on','remove');
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
                        modifyElementClass($(".tpopup-personal"),'on','add');
                    }else if(_action == 'hide'){
                        modifyElementClass($(".user_btn"),'on','remove');
                        modifyElementClass($(".tpopup-personal"),'on','remove');
                    }
                    break;
                case "license":
                    if(_action == 'show'){
                        modifyElementClass($(".info_btn"),'on','add');
                        modifyElementClass($(".tpopup-info"),'on','add');
                    }else if(_action == 'hide'){
                        modifyElementClass($(".info_btn"),'on','remove');
                        modifyElementClass($(".tpopup-info"),'on','remove');
                    }
                    break;
                case "resource":
                    if(_action == 'show'){
                        modifyElementClass($(".reso_btn"),'on','add');
                        modifyElementClass($(".tpopup-resource"),'on','add');
                    }else if(_action == 'hide'){
                        modifyElementClass($(".reso_btn"),'on','remove');
                        modifyElementClass($(".tpopup-resource"),'on','remove');
                    }
                    break;
                case "notificationCancel":
                    if(_action == 'show'){
                        var notificationIdList = $("#notificationList li.check").map(function(){return $(this).attr("notificationId")}).get();

                        if(notificationIdList==null || notificationIdList.length == 0){
                            layoutAlertMessage('emptyNotification');
                            return false;
                        }
                        modifyElementClass($("div[alarm_menu]"),'open_cancel','add');
                        modifyElementClass($(".db_cancel_set"),'on','add');
                    }else if(_action == 'hide'){
                        $("#cancelDesc").val("");
                        modifyElementClass($("div[alarm_menu]"),'open_cancel','remove');
                        modifyElementClass($(".db_cancel_set"),'on','remove');
                    }
                    break;
            }
        }

        function openLink(url){
            window.open(url);
        }

        function logout(){
            location.href = layoutUrlConfig['logoutUrl'];
        }

        function goHome(){
            location.href = layoutUrlConfig['mainUrl'];
        }

        function setAlarmAudio(sourceUrl){
            if(sourceUrl==null){
                sourceUrl = alarmDefaultSource;
            }

            $("#alarmSource").attr("src",sourceUrl);

            if(alarmPlayer!=null){
                alarmPlayer.load();
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

            if (alarmPlayer.duration > 0 && !alarmPlayer.paused) {
                //Its playing...do your job
            } else {
                //Not playing...maybe paused, stopped or never played.
                segmentEnd = endTime;
                alarmPlayer.currentTime = startTime;
                alarmPlayer.pause();
                alarmPlayer.play();
            }
        }

        function menuBarToggle(_this){
            $("#menu").toggleClass("hide");
            $(_this).toggleClass("on")
        }

        /* 대쉬보드 전체 페이지 이동*/
        function moveDashboard(areaId, subAreaId) {
            var dashboardForm = $('<FORM>').attr('method','POST').attr('action',layoutUrlConfig['dashboardUrl']);
            dashboardForm.append($('<INPUT>').attr('type','hidden').attr('name','refreshFlag').attr('value','false'));
            dashboardForm.append($('<INPUT>').attr('type','hidden').attr('name','areaId').attr('value',areaId));
            dashboardForm.append($('<INPUT>').attr('type','hidden').attr('name','subAreaId').attr('value',subAreaId));
            dashboardForm.appendTo(document.body);
            dashboardForm.submit();
        }
    </script>
</head>
<body class="admin_mode view_mode ${mainTarget.targetId=='taekwon'?'taekwon_mode':''}">
    <!-- wrap Start -->
    <div class="wrap">
        <main>
            <menu id="menu">
                <div class="menu-btnset">
                    <!-- 데시보드, 통계, 어드민 링크 버튼 -->
                    <div class="group-menubtn" id="menuBtnGroup"></div>
                    <div class="ignore"></div>
                    <!-- 기능 버튼 -->
                    <div class="group-functionbtn">
                        <button class="funcbtn-info info_btn" onclick="javascript:getLicense(this); event.stopPropagation();" title="<spring:message code="dashboard.title.license"/>"><spring:message code="dashboard.title.license"/></button>
                        <button class="funcbtn-user user_btn" onclick="javascript:getProfile(this); event.stopPropagation();" title="<spring:message code="dashboard.title.profile"/>"><spring:message code="dashboard.title.profile"/></button>
                        <c:if test="${mainTarget.targetId!='nonsan'}">
                            <button class="funcbtn-reso reso_btn" onclick="javascript:openResourcePopup(this);" title="<spring:message code="dashboard.title.resourceMonitoring"/>"><spring:message code="dashboard.title.resourceMonitoring"/></button>
                        </c:if>
                        <button class="funcbtn-logi loginout_btn" onclick="javascript:logout();" title="<spring:message code="dashboard.title.logout"/>"><spring:message code="dashboard.title.logout"/></button>
                        <button class="funcbtn-mscr" onclick="javascript:menuBarToggle(this);" data-content="SHOW MENU BAR"><p>HIDE MENU BAR</p></button>
                    </div>
                </div>

                <div class="menu-navset" id="menuNav"></div>
            </menu>

            <div class="notice-area">
                <button class="notice-btn" onclick="javascript:layerShowHide('list');" title="<spring:message code="dashboard.title.alarmCenter"/>"></button>
            </div>

            <!-- 알림센터 -->
            <aside class="db_area">
                <article>
                    <h2>
                        <span><spring:message code="dashboard.title.alarmCenter"/></span>
                    </h2>

                    <!-- 임계치별 알림 카운트 -->
                    <section criticalLevelCnt class="issue_board">
                        <c:forEach var="critical" items="${criticalList}">
                            <span ${critical.codeId}>0</span>
                        </c:forEach>
                    </section>

                    <!-- 알림 이력 + 알림 해지 영역 -->
                    <section class="db_list_box">
                        <!-- 이력 선택 및 알림해지 버튼-->
                        <div class="db_filter_set" alarm_menu>
                            <div class="checkbox_set csl_style01 db_allcheck">
                                <input type="checkbox" class="check_input" onclick="javascript:notificationHelper.notificationAllCheck(this);"/>
                                <label></label>
                            </div>
                            <button class="dbc_open_btn" onclick="javascript:layerShowHide('notificationCancel','show');" title="<spring:message code="dashboard.title.alarmAction"/>"></button> <!-- 선택 이력 알림해지, 알림확인 박스 열기 -->
                            <button class="dbc_dele_btn" onclick="javascript:notificationHelper.allCancelNotification();" title="<spring:message code="dashboard.title.allCancel"/>"></button> <!-- 이력 모두 지우기 -->
                            <button class="dbc_sera_btn" onclick="javascript:$(this).toggleClass('on');" title="<spring:message code="dashboard.title.search"/>"></button> <!-- 찾기 필터 보기 -->
                            <div class="search_box">
                                <spring:message code="common.selectbox.select" var="allSelectText"/>
                                <isaver:codeSelectBox groupCodeId="LEV" htmlTagId="criticalLevel" allModel="true" allText="${allSelectText}"/>
                                <isaver:areaSelectBox htmlTagId="areaType" allModel="true" allText="${allSelectText}"/>
                            </div>
                        </div>

                        <!-- 알림 이력-->
                        <ul id="notificationList"></ul>

                        <!-- 더보기, 검색 로딩 바 -->
                        <div id="notiLoading" class="loding_bar"></div>

                        <!-- 더보기 버튼 -->
                        <button id="notiMoreBtn" class="dbc_more" onclick="javascript:notificationHelper.moveNotificationPage(); return false;"></button>

                        <!-- 알림해지 영역 -->
                        <div class="db_cancel_set">
                            <div class="title">
                                <h3><spring:message code='dashboard.title.alarmAction'/></h3>
                                <button class="dbc_close_btn" onclick="javascript:layerShowHide('notificationCancel','hide');"></button>
                            </div>

                            <textarea id="cancelDesc" placeholder="<spring:message code='dashboard.placeholder.notificationAction'/>"></textarea>
                            <div class="btn_set">
                                <button class="btn" onclick="javascript:notificationHelper.saveNotification('cancel');"><spring:message code="dashboard.button.notificationCancel"/></button>
                                <button class="btn" onclick="javascript:notificationHelper.saveNotification('confirm');"><spring:message code="dashboard.button.notificationConfirm"/></button>
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
                            <p><textarea disabled="true" actionDesc></textarea></p>
                        </div>
                    </section>
                </article>
            </aside>

            <article>
                <tiles:insertAttribute name="body" />
            </article>

            <section class="common-popup-layer">
                <!-- 토스트 영역 -->
                <div class="toast_popup on"></div>

                <!-- 자원 모니터링 팝업 -->
                <div class="tpopup-resource type01">
                    <h2><spring:message code="dashboard.title.resourceMonitoring"/></h2>
                    <div class="chart_select_set" id="resourceDateSelType">
                        <button value="300" class="on" href="#" onclick="javascript:resourceDateSelTypeClick(this); return false;">5<spring:message code="common.column.minute"/></button>
                        <button value="600" href="#" onclick="javascript:resourceDateSelTypeClick(this); return false;">10<spring:message code="common.column.minute"/></button>
                        <button value="1800" href="#" onclick="javascript:resourceDateSelTypeClick(this); return false;">30<spring:message code="common.column.minute"/></button>
                        <button value="3600" href="#" onclick="javascript:resourceDateSelTypeClick(this); return false;">60<spring:message code="common.column.minute"/></button>
                    </div>
                    <section>
                        <div class="resource_view">
                            <div class="chart_box chart01" id="resourceChartElement"></div>
                        </div>
                        <div class="resource_list">
                            <div>
                                <isaver:areaSelectBox htmlTagId="resourceAreaId" templateCode="TMP009" allModel="true" allText="${allSelectText}"/>
                                <select id="resourceDeviceId" onchange="findListResourceChart();">
                                    <option value=""><spring:message code="common.selectbox.select"/></option>
                                </select>
                                <select id="resourceEventId" onchange="findListResourceChart();">
                                    <option value=""><spring:message code="common.selectbox.select"/></option>
                                </select>
                            </div>
                        </div>
                    </section>
                </div>

                <!-- 개인상세 정보 팝업-->
                <div class="tpopup-personal">
                    <h2><spring:message code="dashboard.title.profile"/></h2>
                    <section>
                        <form>
                            <div class="form_area">
                                <span><spring:message code="dashboard.column.userName"/></span>
                                <input type="text" id="userName" />
                                <span><spring:message code="dashboard.column.password"/></span>
                                <input autocomplete="off" type="password" id="userPassword" placeholder="<spring:message code="common.message.passwordEdit"/>"/>
                                <span><spring:message code="dashboard.column.passwordConfirm"/></span>
                                <input autocomplete="off" type="password" id="password_confirm" placeholder="<spring:message code="common.message.passwordEdit"/>"/>
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

                <!-- 라이센스 정보 팝업-->
                <div class="tpopup-info">
                    <h2>
                        <spring:message code="dashboard.title.license"/>
                    </h2>
                    <div class="d-day">
                        <span><spring:message code="dashboard.column.expireDate"/></span>
                        <p id="expireDate"></p>
                    </div>
                    <section id="licenseList"></section>
                </div>

                <!-- 라이센스 만료 경고 팝업 -->
                <div class="license_notice">
                    <p></p>
                </div>

                <!-- 연결 오류 팝업 -->
                <div class="popupbase network_popup">
                    <div>
                        <div>
                            <header>
                                <h2><spring:message code="error.message.networkTitle"/></h2>
                                <button class="close_btn" onclick="javascript:$('.network_popup').hide();"></button>
                            </header>
                            <article>
                                <section><spring:message code="error.message.network"/></section>
                            </article>
                            <footer>
                                <button class="btn" onclick="javascript:logout();"><spring:message code="error.button.login"/></button>
                            </footer>
                        </div>
                    </div>
                    <div class="bg"></div>
                </div>
            </section>
        </main>

        <audio controls style="display: none">
            <source id="alarmSource" type="audio/mpeg">
        </audio>
    </div>
</body>
</html>