<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="isaver" uri="/WEB-INF/views/common/tags/isaver.tld"%>
<!DOCTYPE html>
<html lang="ko" class="admin_mode">
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
    <script type="text/javascript" src="${rootPath}/assets/js/util/common-util.js?version=${version}"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/ajax-util.js?version=${version}"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/common/jquery.iframe-post-form.js"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/elements-util.js?version=${version}"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/request-helper.js?version=${version}"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/template/template-helper.js?version=${version}"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/websocket-helper.js?version=${version}"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/notification-helper.js?version=${version}"></script>
    <script type="text/javascript" src="${rootPath}/assets/js/util/md5.min.js"></script>

    <script type="text/javascript">
        var rootPath = '${rootPath}';
        var calendarHelper = new CalendarHelper(rootPath);
        var menuModel = new MenuModel();
        var menuCtrl = null;
        var requestHelper = new RequestHelper();
        var templateHelper = new TemplateHelper();
        var serverDatetime = new Date();
        serverDatetime.setTime(${serverDatetime});
        var _eventDatetime = new Date();
        var webSocketHelper = new WebSocketHelper();
        var notificationHelper = new NotificationHelper(rootPath);

        var layoutUrlConfig = {
            'logoutUrl':'${rootPath}/logout.html'
            ,'mainUrl':'${rootPath}/main.html'
            ,'dashboardUrl':'${rootPath}/dashboard/list.html'
            ,'profileUrl':'${rootPath}/user/profile.json'
            ,'saveProfileUrl':'${rootPath}/user/save.json'
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
            , cancelNotificationFailure    :'<spring:message code="dashboard.message.cancelNotificationFailure"/>'
            , confirmNotificationSuccess  :'<spring:message code="dashboard.message.confirmNotificationSuccess"/>'
            , confirmNotificationFailure    :'<spring:message code="dashboard.message.confirmNotificationFailure"/>'
            , cancelNotificationSuccess  :'<spring:message code="dashboard.message.cancelNotificationSuccess"/>'
        };

        var alarmPlayer;
        var alarmDefaultSource = '${rootPath}/assets/library/sound/alarm.mp3';
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

            // 외부 클릭시 팝업 닫기
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

            // 타이틀에 텍스트 맵핑
            $.each($("table.t_type01 > tbody > tr > td"),function(){
                $(this).attr("title",$(this).text().trim());
            });

            if(subMenuId == "100000"){
                modifyElementClass($("html"),'admin_mode','remove');
                modifyElementClass($("body"),'admin_mode','remove');
                modifyElementClass($("html"),'dashboard_mode','add');
                modifyElementClass($("body"),'dashboard_mode','add');
                modifyElementClass($("body"),'dark_mode','add');
            }

            printTime();

            notificationHelper.setMessageConfig(layoutMessageConfig);
            notificationHelper.setElement($("#notificationList"));
            notificationHelper.createEventListener();
            notificationHelper.getNotificationList();

            webSocketHelper.addWebSocketList("notification", "${webSocketUrl}", null, notificationMessageEventHandler);
            webSocketHelper.wsConnect("notification", true);
            aliveSend(900000);

            alarmPlayer = document.getElementsByTagName("audio")[0];
            alarmPlayer.addEventListener('timeupdate', function (){
                if (segmentEnd && alarmPlayer.currentTime >= segmentEnd) {
                    alarmPlayer.pause();
                }
            }, false);
            setAlarmAudio();
        });

        /**
         * 웹소켓 메세지 리스너
         * @param message
         */
        function notificationMessageEventHandler(message) {
            var resultData;
            try{
                resultData = JSON.parse(message.data);
            }catch(e){
                return false;
            }

            switch (resultData['messageType']) {
                case "refreshView": // 화면갱신
                    requestHelper.getData("inoutList");
                    break;
                case "addNotification": // 알림센터 이벤트 등록
                    if(resultData['dashboardAlarmFileUrl']!=null){
                        setAlarmAudio(resultData['dashboardAlarmFileUrl']);
                    }else{
                        setAlarmAudio();
                    }
                    notificationHelper.addNotification(resultData['notification'], true);
                    requestHelper.callBackEvent(resultData['messageType'], null, resultData['notification'], null);
                    break;
                case "updateNotification": // 알림센터 이벤트 수정 (확인, 해제)
                    notificationHelper.updateNotificationList(resultData['notification'], requestHelper.callBackEvent);
                    break;
                case "cancelDetection": // 감지 해제
                    requestHelper.callBackEvent(resultData['messageType'], resultData['eventLog'], resultData['notification'], resultData['cancelList']);
                    break;
                case "addEvent": // 일반이벤트 등록
                    requestHelper.callBackEvent(resultData['messageType'], resultData['eventLog'], null, null);
                    break;
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
                if(hour>=0 && hour<10) {hour = "0" + hour;}
                var minute = Math.floor(gap / (1000*60))%60;
                if(minute>=0 && minute<10) {minute = "0" + minute;}
                var second = Math.floor(gap / (1000))%60;
                if(second>=0 && second<10) {second = "0" + second;}

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
            if(XMLHttpRequest['status']!="0"){
                layoutAlertMessage(actionType + 'Failure');
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

        function cctvOpen(linkUrl){
            window.open(linkUrl);
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
                alarmPlayer.play();
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
</head>
<body class="admin_mode">
<!-- wrap Start -->
<div class="wrap">
    <!-- hearder Start 고통부분 -->
    <header id="header">
        <div class="header_area">
            <h1><a href="#" onclick="javascript:moveDashboard(); return false;"></a></h1>

            <!-- menu Start -->
            <menu id="topMenu"></menu>
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
                    <!-- 다국어 지원 추가 -->
                    <select class="language" onchange="javascript:window.location.href='?lang='+$(this).val();">
                        <option value="ko_KR" ${pageContext.response.locale=='ko_KR'?'selected':''}><spring:message code="common.selectbox.korean"/></option>
                        <option value="en_US" ${pageContext.response.locale=='en_US'?'selected':''}><spring:message code="common.selectbox.english"/></option>
                    </select>
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
            <span><spring:message code="dashboard.title.alarmCenter"/></span>
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
            <div class="db_filter_set" alarm_menu>
                <div class="checkbox_set csl_style01 db_allcheck">
                    <input type="checkbox" class="check_input" onclick="javascript:notificationHelper.notificationAllCheck(this);"/>
                    <label></label>
                </div>
                <isaver:codeSelectBox groupCodeId="LEV" htmlTagId="criticalLevel" allModel="true"/>
                <isaver:areaSelectBox htmlTagId="areaType" allModel="true"/>
                <button class="btn dbc_open_btn" onclick="javascript:layerShowHide('notificationCancel','show');"></button>
            </div>

            <!-- 알림 이력-->
            <ul id="notificationList"></ul>

            <!-- 알림해지 영역 -->
            <div class="db_cancel_set">
                <div class="db_filter_set">
                    <h3><spring:message code='dashboard.title.alarmAction'/></h3>
                    <button class="btn dbc_close_btn" onclick="javascript:layerShowHide('notificationCancel','hide');"></button>
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
        <source id="alarmSource" type="audio/mpeg">
    </audio>

    <tiles:insertAttribute name="body" />
</div>
</body>
</html>