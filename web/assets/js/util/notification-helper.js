/**
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
            ,'fenceListUrl' : "/fence/list.json"
        };
        var _messageConfig;
        var _fenceList = {};
        var _notificationList = {};
        var _element;

        var _callBackEventHandler = null;
        var _CALL_BACK_RETRY = {
            'cnt' : 10
            , 'delay' : 1000
        };
        var _self = this;
        var _notiPageObj = {
            viewMaxCnt : 20
            ,pageIndex : 1
            ,elementArr : []
            ,elementIndex : 0
            ,initFlag : false
        };

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
                console.error('[NotificationHelper][setCallBackEventHandler] _appendEventHandler is null or type error');
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
                selectBoxChangeHandler('reset');
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

        this.getFenceList = function(areaId){
            var resultList = [];
            if(areaId==null || areaId==""){
                resultList = _fenceList;
            }else{
                for(var index in _fenceList){
                    var fence = _fenceList[index];
                    if(fence['areaId']==areaId){
                        resultList.push(fence);
                    }
                }
            }
            return resultList;
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
                case 'fenceList':
                    for(var index in data['fenceList']){
                        var fence = data['fenceList'][index];
                        _fenceList[fence['fenceId']]=fence;
                    }
                    break;
                case 'notificationList':
                    notificationHelper.addNotificationList(data['notifications'], data['notiCountList']);
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
            var result = null;
            switch (type){
                case 'element' :
                case 'data' :
                    if(_notificationList[notificationId]!=null){
                        result = _notificationList[notificationId][type];
                    }
                    break;
                case "all" :
                    result = _notificationList[notificationId];
                    break;
                case "full" :
                    result = _notificationList;
                    break;
            }
            return result;
        };

        /**
         * search notification list
         * @author psb
         */
        this.getNotificationList = function(){
            _ajaxCall('fenceList');
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
                $("section[alarm_detail] textarea[actionDesc]").text(action['actionDesc']);
                _eventDatetime.setTime(data['paramBean']['eventDatetime']);

                $("section[alarm_detail] .dbi_cctv button").removeAttr("onclick");
                $("section[alarm_detail] .dbi_cctv").hide();
                //if(data['device']!=null && data['device']['linkUrl']!=null){
                //    $("section[alarm_detail] .dbi_cctv button").attr("onclick","javascript:cctvOpen('"+data['device']['linkUrl']+"'); event.stopPropagation();");
                //    $("section[alarm_detail] .dbi_cctv").show();
                //}else{
                //    $("section[alarm_detail] .dbi_cctv button").removeAttr("onclick");
                //    $("section[alarm_detail] .dbi_cctv").hide();
                //}

                $("section[alarm_detail] p[eventDatetime]").text(_eventDatetime.format("MM/dd HH:mm:ss"));
                modifyElementClass($("#notificationList li[notificationId='"+data['paramBean']['notificationId']+"'] .infor_btn"),'on','add');
                layerShowHide('detail','show');
            }else{
                _alertMessage('emptyAction');
            }
        };

        /**
         * alert message method
         * @author psb
         */
        var _alertMessage = function(type){
            alert(_messageConfig[type]);
        };

        /**
         * add notification List
         * @author psb
         * @param notifications
         */
        this.addNotificationList = function(notifications, notiCountList){
            setLoading('noti', true);
            setLoading('area', true);

            if(notifications!=null){
                for(var index in notifications){
                    _self.addNotification(notifications[index], false, (notifications.length-_notiPageObj['viewMaxCnt'])<=index?true:false);
                }

                if(notifications.length<=_notiPageObj['viewMaxCnt']){
                    $("#notiMoreBtn").hide();
                }
                notificationBtnRefresh();
            }

            if(notiCountList!=null){
                for(var index in notiCountList){
                    // 알림센터 상단 카운트 및 알림아이콘
                    var levelTag = $("div[criticalLevelCnt] span["+notiCountList[index]['criticalLevel']+"]");
                    levelTag.text(notiCountList[index]['notiCnt']);
                    if(notiCountList[index]['notiCnt']>0){
                        modifyElementClass($(".issue_btn"),"level-"+criticalCss[notiCountList[index]['criticalLevel']],'add');
                    }
                }
            }
            setLoading('noti', false);

            setTimeout(function () {
                _self.callBackEvent('addNotification', {'notification':notifications});
                setLoading('area', false);
            }, 10);
        };

        var notificationViewRender = function(notification, flag){
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
            notificationTag.find("#areaName").text(notification['areaName'] + (notification['fenceName']!=null?' - '+notification['fenceName']:''));
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

            if(flag){
                _element.prepend(notificationTag);
            }else{
                _element.append(notificationTag);
            }
            return notificationTag;
        };

        /**
         * add notification
         * @author psb
         * @param notification
         * @param newFlag
         * @param viewFlag
         */
        this.addNotification = function(notification, newFlag, viewFlag){
            if(_self.getNotification('element',notification['notificationId'])!=null){
                console.warn("[NotificationHelper][addNotification] exist notification - "+notification['notificationId']);
                return false;
            }

            if(notification['fenceId']!=null && (notification['fenceName']==null || notification['fenceName']=='')){
                if(_fenceList[notification['fenceId']]!=null){
                    notification['fenceName'] = _fenceList[notification['fenceId']]['fenceName']!=null?_fenceList[notification['fenceId']]['fenceName']:notification['fenceId'];
                }else{
                    notification['fenceName'] = notification['fenceId'];
                }
            }

            _notificationList[notification['notificationId']] = {
                'element' : (viewFlag&&checkNotificationData(notification))?notificationViewRender(notification,true):null
                ,'data' : notification
            };

            if(newFlag){
                // 알림센터 상단 카운트 및 알림아이콘
                var levelTag = $("div[criticalLevelCnt] span["+notification['criticalLevel']+"]");
                levelTag.text(Number(levelTag.text())+1);
                modifyElementClass($(".issue_btn"),"level-"+criticalCss[notification['criticalLevel']],'add');

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
                _self.callBackEvent('addNotification', notification);
            }
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

            if(paramData.length==0){
                return false;
            }

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

                if(_element.find(">li:visible").length < _notiPageObj['viewMaxCnt']){
                    selectBoxChangeHandler('reset');
                }
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
            }

            switch (notification['actionType']){
                case "confirm" :
                    if(notificationTag!=null){
                        appendConfirm(
                            notificationTag
                            , {
                                userName:notification['updateUserName']!=null?notification['updateUserName']:notification['updateUserId']
                                ,datetime:notification['updateDatetime']
                            }
                        );
                    }
                    break;
                case "cancel" :
                    var notificationData = _self.getNotification('data',notification['notificationId']);
                    var levelTag = $("div[criticalLevelCnt] span["+notificationData['criticalLevel']+"]");
                    var levelCtn = Number(levelTag.text())-1;
                    levelTag.text(levelCtn);

                    if(levelCtn==0){
                        modifyElementClass($(".issue_btn"),"level-"+criticalCss[notificationData['criticalLevel']],'remove');
                    }

                    if(notificationTag!=null){
                        if(notificationTag.find(".infor_btn").hasClass("on")){
                            modifyElementClass($(".db_infor_box"),'on','remove');
                            modifyElementClass($(".infor_btn"),'on','remove');
                        }
                        notificationTag.remove();
                    }
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
                        count = _CALL_BACK_RETRY['cnt'];
                    }
                    console.log('[NotificationHelper] callBackEvent retry - ' + (_CALL_BACK_RETRY['cnt']-count));

                    if(count > 0){
                        setTimeout(function(){
                            _self.callBackEvent(messageType, data, count - 1);
                        },_CALL_BACK_RETRY['deley']);
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
         * notification cancel btn action
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
         * notification issue btn action
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

        this.moveNotificationPage = function(){
            selectBoxChangeHandler('more');
        };

        /**
         * notification select box change handler
         * @author psb
         */
        var selectBoxChangeHandler = function(type){
            setLoading('noti', true);
            setTimeout(function(){
                try{
                    var limitCnt = 0;
                    var moreBtnViewFlag = false;

                    switch (type){
                        case "reset":
                            _notiPageObj['pageIndex'] = 1;
                            _notiPageObj['initFlag'] = false;
                            limitCnt = _notiPageObj['viewMaxCnt']*_notiPageObj['pageIndex'];
                            break;
                        case "more":
                            _notiPageObj['pageIndex']++;
                            limitCnt = _notiPageObj['viewMaxCnt']*_notiPageObj['pageIndex'];
                            if(_notiPageObj['initFlag']){
                                limitCnt -= _element.find(">li:visible").length;
                            }
                            break;
                    }

                    if(_notiPageObj['initFlag']==false){
                        _notiPageObj['elementArr'] = [];
                        for(var index in _notificationList){
                            var notification = _notificationList[index];
                            if(notification['element']!=null){
                                notification['element'].remove();
                            }
                            notification['element'] = null;
                            _notiPageObj['elementArr'].push(notification);
                        }
                        if(_notiPageObj['elementArr'].length>0){
                            _notiPageObj['elementIndex'] = _notiPageObj['elementArr'].length-1;
                        }
                        _notiPageObj['initFlag'] = true;
                    }

                    if(_notiPageObj['elementIndex']>=0 && _notiPageObj['elementArr'].length>0){
                        for(var i=_notiPageObj['elementIndex']; i>=0; i--){
                            var notification = _notiPageObj['elementArr'][i];
                            if(limitCnt>=0){
                                if(checkNotificationData(notification['data'])){
                                    if(limitCnt==0){
                                        moreBtnViewFlag = true;
                                        _notiPageObj['elementIndex'] = i;
                                    }else{
                                        notification['element'] = notificationViewRender(notification['data'],false);
                                    }
                                    limitCnt--;
                                }
                            }else{
                                break;
                            }
                        }
                    }

                    if(moreBtnViewFlag){
                        $("#notiMoreBtn").show();
                    }else{
                        $("#notiMoreBtn").hide();
                    }
                }catch(e){
                    console.error("[selectBoxChangeHandler] error - " + e );
                }
                setLoading('noti', false);
            },50);
        };

        var checkNotificationData = function(notification){
            var criticalLevel = $("#criticalLevel option:selected").val();
            var areaId = $("#areaType option:selected").val();
            if((criticalLevel=="" || notification['criticalLevel']==criticalLevel) && (areaId=="" || notification['areaId']==areaId)){
                return true;
            }else{
                return false;
            }
        };

        var setLoading = function(type, flag){
            var _target = null;
            switch(type){
                case "noti":
                    _target = $("#notiLoading");
                    break;
                case "area":
                    _target = $("#areaLoading");
                    break;
            }

            if(flag){
                _target.addClass("on");
            }else{
                _target.removeClass("on");
            }
        };

        _initialize(rootPath);
    }
);