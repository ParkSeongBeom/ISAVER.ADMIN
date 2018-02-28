﻿/**
 * Notification Helper
 * - 알림센터 제어
 *
 * @author psb
 * @type {Function}
 */
var NotificationHelper = (
    function(rootPath){
        var _rootPath;
        var _urlConfig = {
            'notificationListUrl':'/notification/dashboard.json'
            ,'notificationDetailUrl':'/action/eventDetail.json'
            ,'confirmNotificationUrl':'/notification/save.json'
            ,'cancelNotificationUrl':'/notification/save.json'
        };
        var _messageConfig;
        var _notificationList = {};
        var _element;

        var _callBackEventHandler = null;
        var CALL_BACK_RETRY = {
            'cnt' : 10
            , 'delay' : 1000
        };
        var _self = this;

        /**
         * initialize
         * @author psb
         */
        var _initialize = function(rootPath){
            _rootPath = rootPath;

            for(var index in _urlConfig){
                _urlConfig[index] = _rootPath + _urlConfig[index];
            }
            console.log('[NotificationHelper] initialize complete');
        };


        this.setCallBackEventHandler = function(_eventHandler){
            if(_eventHandler==null || typeof _eventHandler != "function"){
                console.error('[RequestHelper][setCallBackEventHandler] _appendEventHandler is null or type error');
                return false;
            }

            _callBackEventHandler = _eventHandler;
        };

        /**
         * event listener
         * @author psb
         */
        this.createEventListener = function(){
            // 알림해제 버튼 활성화
            $(".check_input").click(function(){
                notificationCancelBtnAction();
            });

            // 알림센터 내부 셀렉트 박스 클릭시 이벤트
            $("#criticalLevel, #areaType").on("change",function(){
                console.log("aa");
                selectBoxChangeHandler();
            });
        };
        
        /**
         * set message config
         * @author psb
         */
        this.setMessageConfig = function(messageConfig){
            _messageConfig = messageConfig;
        };

        /**
         * set element
         * @author psb
         */
        this.setElement = function(element){
            if($(element).length == 0){
                console.error("[NotificationHelper][setElement] error - empty element");
                return false;
            }

            _element = element;
        };

        /**
         * ajax call
         * @author psb
         */
        var _ajaxCall = function(actionType, data){
            sendAjaxPostRequest(_urlConfig[actionType+'Url'],data,_successHandler,_failureHandler,actionType);
        };

        /**
         * success handler
         * @author psb
         */
        var _successHandler = function(data, dataType, actionType){
            switch(actionType){
                case 'notificationList':
                    notificationHelper.addNotificationList(data['notifications']);
                    break;
                case 'confirmNotification':
                case 'cancelNotification':
                    layerShowHide('notificationCancel','hide');
                    _alertMessage(actionType+'Success');
                    break;
                case 'notificationDetail':
                    notificationDetailRender(data);
                    break;
            }
        };

        /**
         * failure handler
         * @author psb
         */
        var _failureHandler = function(XMLHttpRequest, textStatus, errorThrown, actionType){
            if(XMLHttpRequest['status']!="0"){
                _alertMessage(actionType + 'Failure');
            }
        };

        /**
         * get notification
         * @author psb
         */
        this.getNotification = function(type, notificationId){
            switch (type){
                case 'element' :
                case 'data' :
                    if(_notificationList[notificationId]!=null){
                        return _notificationList[notificationId][type];
                    }
                    break;
                case "all" :
                    return _notificationList[notificationId];
            }
            return null;
        };

        /**
         * search notification list
         * @author psb
         */
        this.getNotificationList = function(){
            _ajaxCall('notificationList');
        };

        /**
         * search notification detail (action)
         * @author psb
         */
        this.getNotificationDetail = function(_this){
            if(!$(_this).hasClass("on")){
                layerShowHide('detail','hide');
                var notification = _self.getNotification('all',$(_this).parent().attr("notificationId"));

                if(notification!=null){
                    var paramData = {
                        notificationId  : notification['data']["notificationId"]
                        , eventId   : notification['data']["eventId"]
                        , areaName   : $(notification['element']).find("#areaName").text()
                        , deviceId   : notification['data']["deviceId"]
                        , eventDatetime : notification['data']["eventDatetime"]
                        , criticalLevel : notification['data']["criticalLevel"]
                    };

                    _ajaxCall('notificationDetail',paramData);
                }
            }else{
                layerShowHide('detail','hide');
            }
        };

        /**
         * notification detail render
         * @author psb
         */
        var notificationDetailRender = function(data){
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
                modifyElementClass($("#notificationList li[notificationId='"+data['paramBean']['notificationId']+"'] .infor_btn"),'on','add');
                layerShowHide('detail','show');
            }else{
                _alertMessage('emptyAction');
            }
        };

        /*
         alert message method
         @author psb
         */
        var _alertMessage = function(type){
            alert(_messageConfig[type]);
        };

        /**
         * add notification List
         * @author psb
         * @param notifications
         */
        this.addNotificationList = function(notifications){
            if(notifications!=null){
                for(var index in notifications){
                    _self.addNotification(notifications[index], false);
                }

                notificationBtnRefresh();
                selectBoxChangeHandler();
            }
        };

        /**
         * add notification
         * @author psb
         * @param notification
         * @param flag
         */
        this.addNotification = function(notification, flag){
            if(_self.getNotification('element',notification['notificationId'])!=null){
                console.warn("[NotificationHelper][addNotification] exist notification - "+notification['notificationId']);
                return false;
            }

            var notificationTag = templateHelper.getTemplate("notification");
            notificationTag.on("click",function(){
                if($(this).hasClass("check")){
                    $(this).find(".check_input").prop("checked",false);
                    modifyElementClass($(this),'check','remove');
                }else{
                    $(this).find(".check_input").prop("checked",true);
                    modifyElementClass($(this),'check','add');
                }
                notificationCancelBtnAction();
            });

            notificationTag.addClass("level-"+criticalCss[notification['criticalLevel']]);
            notificationTag.attr("notificationId",notification['notificationId']);
            notificationTag.find("#areaName").text(notification['areaName'] + (notification['fenceId']!=null?' - '+notification['fenceId']:''));
            notificationTag.find("#eventName").text(notification['eventName'] + (notification['value']!=null?'('+notification['value']+')':''));
            notificationTag.find("#eventDatetime").text(new Date(notification['eventDatetime']).format("MM/dd HH:mm:ss"));
            notificationTag.find(".infor_btn").on("click",function(){
                _self.getNotificationDetail(this);
                event.stopPropagation();
            });

            if(notification['confirmUserId']!=null){
                appendConfirm(
                    notificationTag
                    , {
                        userName:notification['confirmUserName']!=null?notification['confirmUserName']:notification['confirmUserId']
                        ,datetime:notification['confirmDatetime']
                    });
            }

            _element.prepend(notificationTag);
            _notificationList[notification['notificationId']] = {
                'element' : notificationTag
                ,'data' : notification
            };

            // 알림센터 상단 카운트 및 알림아이콘
            var levelTag = $("div[criticalLevelCnt] span["+notification['criticalLevel']+"]");
            levelTag.text(Number(levelTag.text())+1);
            modifyElementClass($(".issue_btn"),"level-"+criticalCss[notification['criticalLevel']],'add');

            if(flag==true){
                /* 애니메이션 */
                $(".issue_btn").removeClass("on");
                try {
                    setTimeout(function() {
                        $(".issue_btn").addClass("on");
                    }, 150);
                } catch(e) {}

                /* 싸이렌 */
                playSegment();

                var toastTag = templateHelper.getTemplate("toast");
                toastTag.addClass("level-"+criticalCss[notification['criticalLevel']]);
                toastTag.attr("onclick","javascript:layerShowHide('list', 'show');");
                toastTag.find("#toastAreaName").text(notification['areaName']);
                toastTag.find("#toastEventDesc").text(notification['eventName']);
                $(".toast_popup").append(toastTag);

                removeToastTag(toastTag);
                function removeToastTag(_tag){
                    setTimeout(function(){
                        _tag.remove();
                    },3000);
                }

                selectBoxChangeHandler();
            }

            _self.callBackEvent('addNotification', {'notification':notification});
        };

        /**
         * save notification (confirm/cancel)
         * @author psb
         */
        this.saveNotification = function(actionType){
            var paramData = _element.find("li.check").map(function(){
                var notificationData = _self.getNotification('data',$(this).attr("notificationId"));
                return notificationData["notificationId"]+"|"+notificationData["areaId"]+"|"+notificationData["criticalLevel"]
            }).get();
            var cancelDesc = $("#cancelDesc").val();

            var param = {
                'paramData' : paramData.join(",")
                ,'actionType' : actionType
                ,'cancelDesc' : cancelDesc
            };

            _ajaxCall(actionType+'Notification',param);
        };

        /**
         * update notification List
         * @author psb
         * @param notifications
         */
        this.updateNotificationList = function(notifications){
            if(notifications!=null){
                for(var index in notifications){
                    _self.updateNotification(notifications[index]);
                }

                notificationCancelBtnAction();
                notificationBtnRefresh();
            }
        };

        /**
         * update notification
         * @author psb
         * @private
         */
        this.updateNotification = function(notification){
            var notificationTag = _self.getNotification('element',notification['notificationId']);
            if(notificationTag==null){
                console.warn("[NotificationHelper][updateNotification] empty notification - "+notification['notificationId']);
                return false;
            }

            switch (notification['actionType']){
                case "confirm" :
                    appendConfirm(
                        notificationTag
                        , {
                            userName:notification['updateUserName']!=null?notification['updateUserName']:notification['updateUserId']
                            ,datetime:notification['updateDatetime']
                        });
                    break;
                case "cancel" :
                    if(notificationTag.find(".infor_btn").hasClass("on")){
                        modifyElementClass($(".db_infor_box"),'on','remove');
                        modifyElementClass($(".infor_btn"),'on','remove');
                    }

                    var notificationData = _self.getNotification('data',notification['notificationId']);
                    var levelTag = $("div[criticalLevelCnt] span["+notificationData['criticalLevel']+"]");
                    var levelCtn = Number(levelTag.text())-1;
                    levelTag.text(levelCtn);

                    if(levelCtn==0){
                        modifyElementClass($(".issue_btn"),"level-"+criticalCss[notificationData['criticalLevel']],'remove');
                    }

                    notificationTag.remove();
                    delete _notificationList[notification['notificationId']];

                    _self.callBackEvent('removeNotification', {'notification':notificationData});
                    break;
            }
        };

        /**
         * append data
         * WS에서 이벤트 수신시 DB거치지 않고 실시간 대쉬보드 반영을 위함
         * @author psb
         */
        this.callBackEvent = function(messageType, data, count){
            if(dashboardFlag){
                if(_callBackEventHandler!=null){
                    _callBackEventHandler(messageType, data);
                }else{
                    if(count == null){
                        count = CALL_BACK_RETRY['cnt'];
                    }
                    console.log('[NotificationHelper] callBackEvent retry - ' + (CALL_BACK_RETRY['cnt']-count));

                    if(count > 0){
                        setTimeout(function(){
                            _self.callBackEvent(messageType, data, count - 1);
                        },CALL_BACK_RETRY['deley']);
                    }else{
                        console.error('[NotificationHelper] callBackEvent failure - callback event handler is null');
                    }
                }
            }
        };

        var appendConfirm = function(element, param){
            if(!element.hasClass("confirm")){
                element.find(".infor_set").append(
                    $("<p/>").text("알림확인 " + param['userName'])
                ).append(
                    $("<p/>").text(new Date(param['datetime']).format("MM/dd HH:mm:ss"))
                );
                modifyElementClass(element,'confirm','add');
            }
        };

        /**
         * add Notification
         * @author psb
         */
        var notificationCancelBtnAction = function(){
            if(_element.find(".check_input").is(":checked")) {
                modifyElementClass($(".dbc_open_btn"),'on','add');
            } else {
                modifyElementClass($(".dbc_open_btn"),'on','remove');
                $(".db_allcheck .check_input").prop("checked",false);
            }
        };

        /**
         * add Notification
         * @author psb
         */
        var notificationBtnRefresh = function(){
            if(_element.find(">li").length>0){
                modifyElementClass($(".issue_btn"),'issue','add');
            }else{
                modifyElementClass($(".issue_btn"),'issue','remove');
            }
        };

        /**
         * notification all check
         * @author psb
         */
        this.notificationAllCheck = function(_this){
            if($(_this).is(":checked")){
                _element.find(">li:visible").addClass("check");
                _element.find(">li:visible .check_input").prop("checked",true);
            }else{
                _element.find(">li:visible").removeClass("check");
                _element.find(">li:visible .check_input").prop("checked",false);
            }
        };

        /**
         * notification select box change handler
         * @author psb
         */
        var selectBoxChangeHandler = function(){
            var criticalLevel = $("#criticalLevel option:selected").val();
            var areaId = $("#areaType option:selected").val();

            for(var index in _notificationList){
                var notification = _notificationList[index];
                if((criticalLevel=="" || notification['data']['criticalLevel']==criticalLevel) && (areaId=="" || notification['data']['areaId']==areaId)){
                    notification['element'].show();
                }else{
                    notification['element'].hide();
                }
            }
        };

        _initialize(rootPath);
    }
);