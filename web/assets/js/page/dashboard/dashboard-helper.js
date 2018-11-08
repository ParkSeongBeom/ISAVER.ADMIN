/**
 * Dashboard Helper
 *
 * @author psb
 * @type {Function}
 */
var DashboardHelper = (
    function(rootPath, version){
        var _rootPath;
        var _version;
        var _MEDIATOR_TYPE = ['video','map','toiletRoom'];
        var _urlConfig = {
            blinkerListUrl : "/eventLog/blinkerList.json"
        };
        var _options ={
            marquee : true
            ,guardInfo : true
        };
        var _noneAddEvents = ['EVT999'];
        var _messageConfig;
        var _fileUploadPath;
        var _defaultTemplateCode = "TMP001";
        var _areaList = {};
        var _guardList = {};
        var _toiletRoomList = {};
        var _self = this;

        /**
         * initialize
         */
        var initialize = function(rootPath, version){
            _rootPath = rootPath;
            _version = version;

            for(var index in _urlConfig){
                _urlConfig[index] = _rootPath + _urlConfig[index];
            }
            updateDeviceStatus();
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
         * set message config
         * @author psb
         */
        this.setFileUploadPath = function(fileUploadPath){
            _fileUploadPath = fileUploadPath;
        };

        /**
         * set websocket
         * @author psb
         */
        this.setWebsocket = function(_type, _webSocketHelper, _webSocketUrl){
            switch (_type) {
                case "map":
                    if($("div[templateCode='TMP005']").length>0){
                        _webSocketHelper.addWebSocketList(_type, _webSocketUrl, null, mapMessageEventHandler);
                        _webSocketHelper.wsConnect(_type);
                    }
                    break;
                case "toiletRoom":
                    if($("div[templateCode='TMP008']").length>0){
                        _webSocketHelper.addWebSocketList(_type, _webSocketUrl, null, toiletRoomMessageEventHandler);
                        _webSocketHelper.wsConnect(_type);
                    }
                    break;
            }
        };

        /**
         * Map 웹소켓 메세지 리스너
         * @param message
         */
        var mapMessageEventHandler = function(message) {
            var resultData;
            try{
                resultData = JSON.parse(message.data);
            }catch(e){
                console.warn("[mapMessageEventHandler] json parse error - " + message.data);
                return false;
            }

            var _mapMediator = _self.getGuard('map', resultData['areaId']);
            if(resultData['areaId']!=null && _mapMediator!=null){
                switch (resultData['actionType']) {
                    case "add":
                        _mapMediator.addMarker(resultData['messageType'], resultData);
                        break;
                    case "save":
                        _mapMediator.saveMarker(resultData['messageType'], resultData);
                        break;
                    case "remove":
                        _mapMediator.removeMarker(resultData['messageType'], resultData);
                        break;
                }
            }
        };

        /**
         * 화장실재실 웹소켓 메세지 리스너
         * @param message
         */
        var toiletRoomMessageEventHandler = function(message) {
            var resultData;
            try{
                resultData = JSON.parse(message.data);
            }catch(e){
                console.warn("[toiletRoomMessageEventHandler] json parse error - " + message.data);
                return false;
            }

            if(resultData['areaId']!=null && _toiletRoomList[resultData['areaId']]!=null && resultData['imageData']!=null){
                _toiletRoomList[resultData['areaId']].saveCanvasImage(resultData['imageData']);
            }
        };

        /**
         * set Area List
         */
        this.setAreaList = function(){
            $.each($(".watch_area div[areaId]"), function(){
                var areaId = $(this).attr("areaId");
                _areaList[areaId] = {
                    'element' : $(this)
                    ,'detect' : {}
                    ,'templateCode' : $(this).attr("templateCode")
                    ,'notification' : $.extend(true,{},criticalList)
                    ,'childDevice' : {}
                    ,'childAreaIds' : $(this).attr("childAreaIds")
                };

                $.each($(this).find("div[deviceId]"),function(){
                    _areaList[areaId]['childDevice'][$(this).attr("deviceId")] = {
                        'element' : $(this)
                        ,'notification' : $.extend(true,{},criticalList)
                    };
                });
            });
        };

        /**
         * set Guard List
         */
        this.setGuardList = function(){
            var initFlag = false;
            $.each($("div[templateCode='TMP005']"),function(){
                var _areaId = $(this).attr("areaId");
                _guardList[_areaId] = {};
                _guardList[_areaId][_MEDIATOR_TYPE[0]] = new VideoMediator(_rootPath);
                _guardList[_areaId][_MEDIATOR_TYPE[1]] = templateSetting['safeGuardMapView']=='online'?new MapMediator(_rootPath, _version):new CustomMapMediator(_rootPath);
                _guardList[_areaId]['deviceIds'] = $(this).find("div[deviceId]").map(function(){return $(this).attr("deviceId")}).get();

                var deviceList = [];
                $.each($(this).find("div[deviceId]"),function(){
                    deviceList.push({
                        'areaId' : _areaId
                        ,'deviceId' : $(this).data("deviceid")
                        ,'deviceCode' : $(this).data("devicecode")
                        ,'ipAddress' : $(this).data("ipaddress")
                        ,'port' : $(this).data("port")
                        ,'deviceUserId' : $(this).data("deviceuserid")
                        ,'devicePassword' : $(this).data("devicepassword")
                        ,'subUrl' : $(this).data("suburl")
                        ,'linkUrl' : $(this).data("linkurl")
                        ,'streamServerUrl' : $(this).data("streamserverurl")
                        ,'deviceName' : $(this).data("devicename")
                        ,'deviceStat' : $(this).data("devicestat")
                    });
                });

                // Video Mediator
                _guardList[_areaId][_MEDIATOR_TYPE[0]].setElement($(this).find("ul[ptzPlayers]"));
                _guardList[_areaId][_MEDIATOR_TYPE[0]].init(_areaId,{'openLinkFlag': false});
                _guardList[_areaId][_MEDIATOR_TYPE[0]].createPlayerList(deviceList);

                // Map Mediator
                if(_guardList[_areaId][_MEDIATOR_TYPE[1]] instanceof MapMediator){
                    _guardList[_areaId][_MEDIATOR_TYPE[1]].setMap($(this).find("div[name='map-canvas']"), $(this).attr("areaDesc"), deviceList);
                    _guardList[_areaId][_MEDIATOR_TYPE[1]].addImage();
                }else if(_guardList[_areaId][_MEDIATOR_TYPE[1]] instanceof CustomMapMediator){
                    _guardList[_areaId][_MEDIATOR_TYPE[1]].setElement($(this), $(this).find("div[name='map-canvas']"));
                    _guardList[_areaId][_MEDIATOR_TYPE[1]].setMessageConfig(_messageConfig);
                    _guardList[_areaId][_MEDIATOR_TYPE[1]].init(_areaId,{
                        'websocketSend':false
                        ,'fenceView':true
                        ,'openLinkFlag': false
                        ,'click':function(targetId,deviceCode){
                            if(deviceCode=='area'){ moveDashboard(_areaId,targetId); }
                        }
                    });
                }
                initFlag = true;
            });

            if(initFlag){
                console.log("[DashboardHelper] initialize Safe-Guard - "+templateSetting['safeGuardMapView']);
            }
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
         * set ToiletRoom list
         */
        this.setToiletRoomList = function(){
            var initFlag = false;
            $.each($("div[templateCode='TMP008']"),function(){
                var _areaId = $(this).attr("areaId");
                _toiletRoomList[_areaId] = {};
                _toiletRoomList[_areaId] = new ToiletRoomMediator(_rootPath);
                _toiletRoomList[_areaId].setElement($(this));
                _toiletRoomList[_areaId].init(_areaId);
                initFlag = true;
            });

            if(initFlag){
                console.log("[DashboardHelper] initialize Toilet Room");
            }
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
                        case "TMP005": // guard
                            break;
                        case "TMP008": // 화장실재실
                            if(data['eventLog']['areaId']!=null && _toiletRoomList[data['eventLog']['areaId']]!=null){
                                _toiletRoomList[data['eventLog']['areaId']].setAnimate(data['eventLog']);
                            }
                            break;
                    }
                    break;
                case "addNotification": // 알림이벤트 등록
                    if(Array.isArray(data['notification'])){
                        for(var index in data['notification']){
                            _self.appendEventHandler(messageType, data['notification'][index]);
                        }
                    }else{
                        if(data['areaId']!=null && _guardList[data['areaId']]!=null && data['status']!="C"){
                            _guardList[data['areaId']][_MEDIATOR_TYPE[0]].setAnimate("add",data['criticalLevel'],data);
                            _guardList[data['areaId']][_MEDIATOR_TYPE[1]].setAnimate("add",data['criticalLevel'],data);
                            if(_noneAddEvents.indexOf(data['eventId'])<0){
                                notificationGuardInfoUpdate(messageType, data['criticalLevel'], data);
                            }
                        }
                        if(_noneAddEvents.indexOf(data['eventId'])<0){
                            notificationUpdate(messageType, data);
                            notificationMarqueeUpdate(data['areaId'], data);
                        }
                    }
                    break;
                case "removeNotification": // 알림이벤트 해제
                    if(data['notification']['areaId']!=null && _guardList[data['notification']['areaId']]!=null){
                        _guardList[data['notification']['areaId']][_MEDIATOR_TYPE[0]].setAnimate("remove",data['notification']['criticalLevel'],data['notification']);
                        _guardList[data['notification']['areaId']][_MEDIATOR_TYPE[1]].setAnimate("remove",data['notification']['criticalLevel'],data['notification']);
                        notificationGuardInfoUpdate(messageType, data['notification']['criticalLevel'],data['notification']);
                    }
                    notificationUpdate(messageType, data['notification']);
                    notificationMarqueeUpdate(data['areaId']);
                    break;
                case "cancelDetection": // 감지 해제
                    if(data['notification']['areaId']!=null && _guardList[data['notification']['areaId']]!=null){
                        for(var index in data['cancel']){
                            _guardList[data['notification']['areaId']][_MEDIATOR_TYPE[0]].setAnimate("remove",data['cancel'][index]['criticalLevel'],data['notification']);
                            _guardList[data['notification']['areaId']][_MEDIATOR_TYPE[1]].setAnimate("remove",data['cancel'][index]['criticalLevel'],data['notification']);
                            notificationGuardInfoUpdate(messageType, data['cancel'][index]['criticalLevel'], data['notification']);
                        }
                    }
                    break;
                case "editDeviceStatus": // 장치 상태
                    _self.setDeviceStatusList(data['deviceStatusList']);
                    for(var index in _guardList){
                        _guardList[index][_MEDIATOR_TYPE[0]].setDeviceStatusList(data['deviceStatusList']);
                        _guardList[index][_MEDIATOR_TYPE[1]].setDeviceStatusList(data['deviceStatusList']);
                    }
                    break;
            }
        };

        /**
         * set ObjectViewFlag
         * @author psb
         */
        this.setObjectViewFlag = function(areaId, _this){
            if(_guardList[areaId]!=null){
                _guardList[areaId][_MEDIATOR_TYPE[1]].setObjectViewFlag($(_this).is(":checked"));
            }
        };

        /**
         * get blinker
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
                case "child" :
                    for(var index in _areaList){
                        var _area = _areaList[index];
                        if(_area['childAreaIds']!=null && _area['childAreaIds']!="" && _area['childAreaIds'].split(",").indexOf(areaId)>-1){
                            result = _areaList[index];
                        }
                    }
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
         * get guard obj
         */
        this.getGuard = function(type, areaId){
            var result = null;
            switch (type){
                case "all" :
                    if(_guardList[areaId]!=null){
                        result = _guardList[areaId];
                    }
                    break;
                case "full" :
                    result = _guardList;
                    break;
                default :
                    if(_guardList[areaId]!=null && _guardList[areaId][type]!=null){
                        result = _guardList[areaId][type];
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
         * 장치상태
         * @author psb
         */
        this.setDeviceStatusList = function(deviceStatusList){
            for(var index in deviceStatusList){
                var deviceStatus = deviceStatusList[index];

                for(var index in _areaList){
                    var _area = _areaList[index];
                    if(_area['childDevice'][deviceStatus['deviceId']]!=null){
                        if(deviceStatus['deviceStat']=='Y'){
                            _area['childDevice'][deviceStatus['deviceId']]['element'].removeClass('level-die');
                        }else{
                            _area['childDevice'][deviceStatus['deviceId']]['element'].addClass('level-die');
                        }
                    }
                }
            }
            updateDeviceStatus();
        };

        var updateDeviceStatus = function(){
            $.each($(".watch_area > div"),function(){
                if($(this).find(".device_box div.level-die").length>0){
                    $(this).find(".device_view").addClass("level-die");
                }else{
                    $(this).find(".device_view").removeClass("level-die");
                }
            });
        };

        /**
         * 구역별 진출입 상태
         */
        var blinkerRender = function(data){
            if(data==null){
                return false;
            }

            for(var index in data){
                var inout = data[index];
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
        };

        /**
         * Safe-Guard 왼쪽 상단 거수자감시 인원 표시
         */
        var notificationGuardInfoUpdate = function(messageType, criticalLevel, data){
            if(!_options['guardInfo']) {
                return false;
            }

            var areaComponent = _self.getArea("all", data['areaId']);

            if(areaComponent==null || data['deviceId']==null || data['fenceId']==null || data['objectId']==null){
                return false;
            }
            var detect = areaComponent['detect'];

            if(detect[data['fenceId']] == null){
                var element = areaComponent['element'];
                var detectTag = $("<div/>",{class:'copybox'}).append(
                    $("<p/>").text(data['eventName']+' - '+data['fenceName'])
                ).append(
                    $("<span/>",{name:'detectCnt'})
                ).append(
                    $("<em/>",{name:'detectEventDatetime'})
                );
                element.find("div[guardInfo]").append(detectTag);

                detect[data['fenceId']] = {
                    'element' : detectTag
                    ,'notification' : $.extend(true,{},criticalList)
                }
            }

            var fenceTarget = detect[data['fenceId']];
            switch (messageType) {
                case "addNotification": // 알림센터 이벤트 등록
                    if(data['objectId']!=null){
                        fenceTarget['notification'][criticalLevel].push(data['objectId']);
                    }
                    break;
                case "cancelDetection": // 감지 해제
                case "removeNotification": // 알림 해지
                    if(fenceTarget['notification'][criticalLevel].indexOf(data['objectId']) > -1){
                        fenceTarget['notification'][criticalLevel].splice(fenceTarget['notification'][criticalLevel].indexOf(data['objectId']),1);
                    }
                    break;
            }

            var detectCnt = 0;
            for(var index in fenceTarget['notification']){
                detectCnt += fenceTarget['notification'][index].length;
                if(fenceTarget['notification'][index].length > 0){
                    fenceTarget['element'].addClass("level-"+criticalCss[index]);
                }else{
                    fenceTarget['element'].removeClass("level-"+criticalCss[index]);
                }
            }

            if(detectCnt>0){
                fenceTarget['element'].find("span[name='detectCnt']").text(detectCnt);
                fenceTarget['element'].find("em[name='detectEventDatetime']").text(new Date(data['eventDatetime']).format("yyyy.MM.dd HH:mm:ss"));
            }else{
                fenceTarget['element'].remove();
                delete _areaList[data['areaId']]['detect'][data['fenceId']];
            }
        };

        /**
         * Notification marquee Update
         */
        var notificationMarqueeUpdate = function(areaId, data){
            if(!_options['marquee']) {
                return false;
            }

            function setMarquee(areaComponent, _data){
                var element = areaComponent['element'];
                var lastNoti = null;

                if(_data!=null){
                    lastNoti = _data;
                }else{
                    var notification = areaComponent['notification'];
                    for(var index in notification){
                        var noti = notification[index];
                        var notiLen = noti.length;
                        if(notiLen > 0){
                            var notiData = null;
                            var roop = true;
                            while(roop){
                                if(notiLen<0){
                                    roop = false;
                                }else{
                                    notiData = notificationHelper.getNotification("data",noti[--notiLen]);

                                    if(notiData!=null && (lastNoti==null || lastNoti['eventDatetime']<notiData['eventDatetime'])){
                                        lastNoti = notiData;
                                        roop = false;
                                    }
                                }
                            }
                        }
                    }
                }
                if(lastNoti!=null){
                    var marqueeText = lastNoti['areaName']+" "+lastNoti['deviceName']+" "+lastNoti['eventName']+" "+new Date(lastNoti['eventDatetime']).format("yyyy.MM.dd HH:mm:ss");
                    if(element.find("p[messageBox] span").length > 0){
                        element.find("p[messageBox] span").attr("notificationId",lastNoti['notificationId']).text(marqueeText);
                    }else{
                        element.find("p[messageBox]").append(
                            $("<span/>",{notificationId:lastNoti['notificationId']}).text(marqueeText)
                        );
                    }
                }
            }


            var areaComponent = _self.getArea("all", areaId);
            if(areaComponent!=null){
                setMarquee(areaComponent, data);
            }else{
                var component = _self.getArea("full");
                for(var key in component){
                    setMarquee(component[key]);
                }
            }
        };

        /**
         * Notification update
         */
        var notificationUpdate = function(messageType, data){
            var areaComponent = _self.getArea("all", data['areaId']);

            if(areaComponent==null){
                areaComponent = _self.getArea("child", data['areaId']);
                if(areaComponent==null){
                    console.warn("[DashboardHelper][notificationUpdate] do not need to work on '" + data['areaId'] + "' area - " + data['notificationId']);
                    return false;
                }
            }
            var element = areaComponent['element'];
            var notification = areaComponent['notification'];
            var childDevice = areaComponent['childDevice'];
            var templateCode = areaComponent['templateCode'];

            switch (messageType){
                case "addNotification" :
                    notification[data['criticalLevel']].push(data['notificationId']);
                    if(childDevice[data['deviceId']] != null){
                        childDevice[data['deviceId']]['notification'][data['criticalLevel']].push(data['notificationId']);
                    }
                    break;
                case "removeNotification" :
                    if(notification[data['criticalLevel']].indexOf(data['notificationId']) > -1){
                        notification[data['criticalLevel']].splice(notification[data['criticalLevel']].indexOf(data['notificationId']),1);
                    }

                    if(childDevice[data['deviceId']] != null){
                        if(childDevice[data['deviceId']]['notification'][data['criticalLevel']].indexOf(data['notificationId']) > -1){
                            childDevice[data['deviceId']]['notification'][data['criticalLevel']].splice(childDevice[data['deviceId']]['notification'][data['criticalLevel']].indexOf(data['notificationId']),1);
                        }
                    }
                    break;
            }

            for(var index in notification){
                if(notification[index].length > 0){
                    element.addClass("level-"+criticalCss[index]);
                }else{
                    element.removeClass("level-"+criticalCss[index]);
                }

                if(templateCode==_defaultTemplateCode){
                    element.find("div[criticalLevel='"+index+"'] p").text(notification[index].length>0?notification[index].length:"");
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

            if(eventDatetime>=startDatetime && eventDatetime<=endDatetime){
                var inCount = 0;
                var outCount = 0;
                for(var index in data['infos']){
                    var info = data['infos'][index];

                    if(info['key']=="inCount"){
                        inCount = info['value'];
                    }else if(info['key']=="outCount"){
                        outCount = info['value'];
                    }
                }

                if(inCount>0 || outCount>0){
                    var inTag = element.find("[in]");
                    var outTag = element.find("[out]");
                    inTag.text(Number(inCount) + Number(inTag.text()));
                    outTag.text(Number(outCount) + Number(outTag.text()));
                    element.find("[gap]").text(Number(element.find("[in]").text())-Number(element.find("[out]").text()));
                }else{
                    console.warn("[DashboardHelper][blinkerUpdate] in/out Count is empty - inCount : "+inCount+", outCount : "+outCount);
                }

                if(chartList[data['areaId']]!=null && outCount>0) {
                    var _eventDate = new Date();
                    _eventDate.setTime(data['eventDatetime']);
                    var _eventDateStr;
                    switch ($("div[dateSelType='"+data['areaId']+"'] button.on").attr("value")){
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
                            chartList[data['areaId']].data.series[0][i] = Number(chartList[data['areaId']].data.series[0][i]) + Number(outCount);
                            chartList[data['areaId']].update();
                        }catch(e){
                            console.error("[DashboardHelper][blinkerUpdate] series index error - "+e);
                        }
                    }
                }
            }else{
                console.warn("[DashboardHelper][blinkerUpdate] eventDatetime is not between startDatetime and endDatetime"
                    ,{"areaId":data['areaId'],"startDatetime":startDatetime.format("yyyy-MM-dd HH:mm:ss"),"endDatetime":endDatetime.format("yyyy-MM-dd HH:mm:ss"),"eventDatetime":eventDatetime.format("yyyy-MM-dd HH:mm:ss")});
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
                            deviceElement.find("p[evtValue]").text(Number(eventValue).toFixed(2));
                        }catch(e){
                            deviceElement.find("p[evtValue]").text(eventValue);
                            console.error("[DashboardHelper][detectorUpdate] parse error - "+ e.message);
                        }
                        updateFlag = true;
                    }
                }

                if(deviceElement.hasClass("on") && updateFlag){
                    if(chartList[data['areaId']]==null) {
                        console.error("[DashboardHelper][detectorUpdate] chartList is null - areaId : " + data['areaId']);
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
                            console.error("[DashboardHelper][detectorUpdate] series index error - "+e);
                        }
                    }
                }
            }
        };

        initialize(rootPath, version);
    }
);