/**
 * Dashboard Helper
 *
 * @author psb
 * @type {Function}
 */
var DashboardHelper = (
    function(rootPath, criticalList){
        var _rootPath;
        var _urlConfig = {
            blinkerListUrl : "/eventLog/blinkerList.json"
        };
        var _messageConfig;
        var _areaList = {};
        var _criticalList = {};

        var _self = this;

        /**
         * initialize
         */
        var initialize = function(rootPath, criticalList){
            _rootPath = rootPath;
            _criticalList = criticalList;

            for(var index in _urlConfig){
                _urlConfig[index] = _rootPath + _urlConfig[index];
            }
            console.log('[DashboardHelper] initialize complete');
        };

        /**
         * set message config
         * @author psb
         */
        this.setMessageConfig = function(messageConfig){
            _messageConfig = messageConfig;
        };

        /**
         * set Area List
         */
        this.setAreaList = function(){
            $.each($(".watch_area div[areaId]"), function(){
                var areaId = $(this).attr("areaId");
                _areaList[areaId] = {
                    'element' : $(this)
                    ,'templateCode' : $(this).attr("templateCode")
                    ,'notification' : $.extend(true,{},_criticalList)
                    ,'childDevice' : {}
                };

                $.each($(this).find("li[deviceId]"),function(){
                    _areaList[areaId]['childDevice'][$(this).attr("deviceId")] = {
                        'element' : $(this)
                        ,'notification' : $.extend(true,{},_criticalList)
                    };
                });
            });
        };

        /**
         * get blinker list
         */
        this.getBlinkerList = function(){
            var areaIds = "";
            $.each($(".watch_area div[inoutArea]"), function(){
                if(areaIds!=""){ areaIds += ",";}
                areaIds += $(this).attr("areaId");
            });
            _self.getBlinker(areaIds);
        };

        /**
         * websocket callback append event handler
         */
        this.appendEventHandler = function(messageType, data){
            switch (messageType) {
                case "refreshBlinker": // 진출입 갱신
                    _self.getBlinker(data['areaId']);
                    break;
                case "addEvent" : // 일반 이벤트
                    switch (_self.getArea("templateCode", data['eventLog']['areaId'])){
                        case "TMP001": // 신호등
                            break;
                        case "TMP002": // safe-eye
                            break;
                        case "TMP003": // blinker
                            blinkerUpdate(data['eventLog']);
                            break;
                        case "TMP004": // detector
                            detectorUpdate(data['eventLog']);
                            break;
                        case "TMP008": // guard
                            break;
                    }
                    break;
                case "addNotification": // 알림이벤트 등록
                    if(data['notification']['areaId']!=null && guardList[data['notification']['areaId']]!=null){
                        guardList[data['notification']['areaId']]['googleMap'].setAnimate(
                            data['notification']['deviceId']
                            ,data['notification']['fenceId']
                            ,data['notification']['objectId']
                            ,"add"
                            ,"level-"+criticalCss[data['notification']['criticalLevel']]
                        );
                    }
                    notificationUpdate(messageType, data['notification']);
                    break;
                case "removeNotification": // 알림이벤트 해제
                    notificationUpdate(messageType, data['notification']);
                    break;
                case "cancelDetection": // 감지 해제
                    if(data['notification']['areaId']!=null && guardList[data['notification']['areaId']]!=null){
                        for(var index in data['cancel']){
                            guardList[data['notification']['areaId']]['googleMap'].setAnimate(
                                data['notification']['deviceId']
                                ,data['notification']['fenceId']
                                ,data['notification']['objectId']
                                ,"remove"
                                ,"level-"+criticalCss[data['cancel'][index]['criticalLevel']]
                            );
                        }
                    }
                    break;
            }
        };

        /**
         * get notification
         * @author psb
         */
        this.getBlinker = function(areaIds){
            if(areaIds!=null){
                _ajaxCall('blinkerList', {areaIds:areaIds});
            }
        };

        /**
         * get area obj
         * @author psb
         */
        this.getArea = function(type, areaId){
            var result = null;
            switch (type){
                case "all" :
                    if(_areaList[areaId]!=null){
                        result = _areaList[areaId];
                    }
                    break;
                case "full" :
                    result = _areaList;
                    break;
                default :
                    if(_areaList[areaId]!=null && _areaList[areaId][type]!=null){
                        result = _areaList[areaId][type];
                    }
                    break;
            }
            return result;
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
                case 'blinkerList':
                    blinkerRender(data['eventLog']);
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
         * alert message method
         * @author psb
         */
        var _alertMessage = function(type){
            alert(_messageConfig[type]);
        };

        /**
         * 구역별 진출입 상태
         */
        var blinkerRender = function(data){
            if(data==null){
                return false;
            }

            var _targetAreaId = null;

            console.log(data);
            for(var index in data){
                var inout = data[index];
                if(_targetAreaId==null || _targetAreaId!=inout['areaId']){
                    _targetAreaId = inout['areaId'];
                    var inoutTag = _self.getArea("element", inout['areaId']);
                    if(inoutTag!=null){
                        var inCount = inout['inCount']!=null?inout['inCount']:0;
                        var outCount = inout['outCount']!=null?inout['outCount']:0;
                        inoutTag.find("p[in]").text(inCount);
                        inoutTag.find("p[out]").text(outCount);
                        inoutTag.find("p[gap]").text(inCount-outCount);
                        inoutTag.attr("startDatetime",inout['startDatetime']);
                        inoutTag.attr("endDatetime",inout['endDatetime']);
                    }
                }
            }
        };

        /**
         * Notification update
         */
        var notificationUpdate = function(messageType, data){
            var areaComponent = _self.getArea("all", data['areaId']);
            if(areaComponent==null){
                console.warn("[DashboardHelper][notificationRender] do not need to work on '" + data['areaId'] + "' area - " + data['notificationId']);
                return false;
            }
            var element = areaComponent['element'];
            var notification = areaComponent['notification'];
            var childDevice = areaComponent['childDevice'];

            switch (messageType){
                case "addNotification" :
                    notification[data['criticalLevel']].push(data['notificationId']);
                    if(childDevice[data['deviceId']] != null){
                        childDevice[data['deviceId']]['notification'][data['criticalLevel']].push(data['notificationId']);
                    }
                    element.find("p[messageBox]").append(
                        $("<span/>",{notificationId:data['notificationId']}).text(data['areaName']+" "+data['deviceName']+" "+data['eventName']+" "+new Date(data['eventDatetime']).format("yyyy.MM.dd HH:mm:ss"))
                    );
                    break;
                case "removeNotification" :
                    notification[data['criticalLevel']].splice(data['notificationId'],1);
                    if(childDevice[data['deviceId']] != null){
                        childDevice[data['deviceId']]['notification'][data['criticalLevel']].splice(data['notificationId'],1);
                    }
                    element.find("p[messageBox] span[notificationId='"+data['notificationId']+"']").remove();
                    break;
            }

            for(var index in notification){
                if(notification[index].length > 0){
                    element.addClass("level-"+criticalCss[index]);
                }else{
                    element.removeClass("level-"+criticalCss[index]);
                }
            }

            for(var i in childDevice){
                var childElement = childDevice[i]['element'];
                var childNotification = childDevice[i]['notification'];
                for(var index in childNotification){
                    if(childNotification[index].length > 0){
                        childElement.addClass("ts-"+criticalCss[index]);
                    }else{
                        childElement.removeClass("ts-"+criticalCss[index]);
                    }
                }
            }
        };

        /**
         * inout update
         */
        var blinkerUpdate = function(data){
            var element = _self.getArea("element", data['areaId']);
            var notification = _self.getArea("notification", data['areaId']);
            var childDevice = _self.getArea("childDevice", data['areaId']);

            var startDatetime = new Date(Number(element.attr("startDatetime")));
            var endDatetime = new Date(Number(element.attr("endDatetime")));
            var eventDatetime = new Date(data['eventDatetime']);
            var updateFlag = false;

            if(eventDatetime>=startDatetime && eventDatetime<=endDatetime){
                for(var index in data['infos']){
                    var info = data['infos'][index];

                    if(info['key']=="inCount"){
                        var inTag = element.find("[in]");
                        var inCount = Number(inTag.text());
                        inCount += Number(info['value']);
                        inTag.text(inCount);
                        updateFlag = true;
                    }else if(info['key']=="outCount"){
                        var outTag = element.find("[out]");
                        var outCount = Number(outTag.text());
                        outCount += Number(info['value']);
                        outTag.text(outCount);
                        updateFlag = true;
                    }
                }
            }

            if(updateFlag){
                element.find("[gap]").text(Number(element.find("[in]").text())-Number(element.find("[out]").text()));
            }
        };

        /**
         * detector update
         */
        var detectorUpdate = function(data){
            // 배재호SB 요청으로 스마트플래그 이벤트는 (A)만 입력받음
            if(data['eventId']=='EVT308' || data['eventId']=='EVT310' || data['eventId']=='EVT312' || data['eventId']=='EVT313'){
                return false;
            }

            var element = _self.getArea("element", data['areaId']);
            var notification = _self.getArea("notification", data['areaId']);
            var childDevice = _self.getArea("childDevice", data['areaId']);

            if(childDevice[data['deviceId']] != null){
                var deviceElement = childDevice[data['deviceId']]['element'];
                var updateFlag = false;
                var eventValue;
                for(var index in data['infos']){
                    var info = data['infos'][index];

                    if(info['key']=="value"){
                        eventValue = info['value'];
                        try{
                            deviceElement.find("span[evtValue]").text(Number(eventValue).toFixed(2));
                        }catch(e){
                            deviceElement.find("span[evtValue]").text(eventValue);
                            console.error("[detectorUpdate] parse error - "+ e.message);
                        }
                        updateFlag = true;
                    }
                }

                if(deviceElement.hasClass("on") && updateFlag){
                    if(chartList[data['areaId']]==null) {
                        console.error("[detectorUpdate] chartList is null - areaId : " + data['areaId']);
                        return false;
                    }

                    var _eventDate = new Date();
                    _eventDate.setTime(data['eventDatetime']);
                    var _eventDateStr;
                    switch (element.find("div[dateSelType] button.on").attr("value")){
                        case 'day':
                            _eventDateStr = _eventDate.format("HH");
                            break;
                        case 'week':
                            _eventDateStr = _eventDate.format("es");
                            break;
                        case 'month':
                            _eventDateStr = _eventDate.getWeekOfMonth()+"주";
                            break;
                        case 'year':
                            _eventDateStr = _eventDate.format("MM");
                            break;
                    }

                    var _labels = chartList[data['areaId']].data.labels;
                    var seriesIndex = null;
                    for(var i=0; i<_labels.length; i++){
                        if(_labels[i]==_eventDateStr){
                            seriesIndex = i;
                            break;
                        }
                    }

                    if(seriesIndex!=null){
                        try{
                            if(chartList[data['areaId']].data.series[0][i] < eventValue){
                                chartList[data['areaId']].data.series[0][i] = eventValue;
                                chartList[data['areaId']].update();
                            }
                        }catch(e){
                            console.error("[detectorUpdate] series index error - "+e);
                        }
                    }
                }
            }
        };

        initialize(rootPath, criticalList);
    }
);