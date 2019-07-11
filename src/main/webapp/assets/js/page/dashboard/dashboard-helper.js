/**
 * Dashboard Helper
 *
 * @author psb
 * @type {Function}
 */
var DashboardHelper = (
    function(rootPath, version){
        const _MEDIATOR_TYPE = ['video','map','toiletRoom'];
        const _defaultTemplateCode = "TMP001";
        const _self = this;

        let _rootPath;
        let _version;
        let _webSocketHelper;
        let _messageConfig;
        let _fileUploadPath;
        let _templateSetting;
        let _urlConfig = {
            blinkerListUrl : "/eventLog/blinkerList.json"
        };
        let _options ={
            marquee : false
        };

        let _areaList = {};
        let _guardList = {};
        let _toiletRoomList = {};

        /**
         * initialize
         */
        var initialize = function(rootPath, version){
            _rootPath = rootPath;
            _version = version;

            for(let index in _urlConfig){
                _urlConfig[index] = _rootPath + _urlConfig[index];
            }
            updateDeviceStatus();
            console.log('[DashboardHelper] initialize complete');
        };

        /**
         * set config
         * @author psb
         */
        this.setConfig = function(messageConfig, fileUploadPath, templateSetting){
            _messageConfig = messageConfig;
            _fileUploadPath = fileUploadPath;
            _templateSetting = templateSetting;
        };

        /**
         * set websocket
         * @author psb
         */
        this.setWebsocket = function(webSocketHelper, param){
            _webSocketHelper = webSocketHelper;
            for(let index in param){
                switch (index) {
                    case "map":
                        if($("div[templateCode='TMP005']").length>0){
                            _webSocketHelper.addWebSocketList(index, param[index], null, mapMessageEventHandler);
                            _webSocketHelper.wsConnect(index);
                        }
                        break;
                    case "toiletRoom":
                        if($("div[templateCode='TMP008']").length>0){
                            _webSocketHelper.addWebSocketList(index, param[index], null, toiletRoomMessageEventHandler);
                            _webSocketHelper.wsConnect(index);
                        }
                        break;
                }
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

            switch (resultData['messageType']) {
                case "object":
                    var _mapMediator = _self.getGuard('map', resultData['areaId']);
                    if(resultData['areaId']!=null && _mapMediator!=null){
                        if(resultData['markerList']!=null && resultData['markerList'] instanceof Array){
                            for(var index in resultData['markerList']){
                                var marker = resultData['markerList'][index];
                                marker['areaId'] = resultData['areaId'];
                                marker['deviceId'] = resultData['deviceId'];
                                switch (marker['actionType']) {
                                    case "add":
                                        _mapMediator.addMarker(resultData['messageType'], marker);
                                        break;
                                    case "save":
                                        _mapMediator.saveMarker(resultData['messageType'], marker);
                                        break;
                                    case "remove":
                                        _mapMediator.removeMarker(resultData['messageType'], marker);
                                        break;
                                }
                            }
                        }
                    }else{
                        console.warn("[mapMessageEventHandler] areaId or mapMediator is null  - " + resultData['areaId'] + ","+_mapMediator);
                    }
                    break;
                case "moveFence":
                    for(var index in _guardList){
                        if(_guardList[index]['map']!=null){
                            _guardList[index]['map'].moveFence('fenceName',resultData);
                        }
                    }
                    break;
            }
        };

        /**
         * 화장실재실 웹소켓 메세지 리스너
         * @param message
         */
        var toiletRoomMessageEventHandler = function(message) {
            let resultData;
            try{
                resultData = JSON.parse(message.data);
            }catch(e){
                console.warn("[toiletRoomMessageEventHandler] json parse error - " + message.data);
                return false;
            }

            const toiletRoomMediator = _toiletRoomList[resultData['areaId']];
            if(resultData['areaId']!=null && toiletRoomMediator!=null){
                switch (resultData['messageType']) {
                    case "imageMode":
                        toiletRoomMediator.updateImageMode(resultData['imageMode'],false);
                        break;
                    case "imageStream":
                        toiletRoomMediator.saveCanvasImage(resultData['imageData']);
                        break;
                }
            }
        };

        /**
         * set Area Template List
         */
        this.initAreaTemplate = function(){
            let blinkerAreaIds = "";

            $.each($(".watch_area div[areaId]"), function(){
                const areaId = $(this).attr("areaId");
                const templateCode = $(this).attr("templateCode");
                _areaList[areaId] = {
                    'element' : $(this)
                    ,'templateCode' : templateCode
                    ,'notification' : $.extend(true,{},criticalList)
                    ,'childDevice' : {}
                    ,'childAreaIds' : $(this).attr("childAreaIds")
                };

                if(!_options['marquee']) {
                    $(this).find(".m_marqueebox").attr("style","display: none !important;");
                }

                $.each($(this).find("div[deviceId]"),function(){
                    _areaList[areaId]['childDevice'][$(this).attr("deviceId")] = {
                        'element' : $(this)
                        ,'notification' : $.extend(true,{},criticalList)
                    };
                });

                switch (templateCode){
                    case "TMP003" :
                        if(blinkerAreaIds!=""){ blinkerAreaIds += ",";}
                        blinkerAreaIds += areaId;
                        break;
                    case "TMP005" :
                        _guardList[areaId] = {};
                        _guardList[areaId][_MEDIATOR_TYPE[0]] = new VideoMediator(_rootPath);
                        _guardList[areaId][_MEDIATOR_TYPE[1]] = _templateSetting['safeGuardMapView']=='online'?new MapMediator(_rootPath, _version):new CustomMapMediator(_rootPath);
                        _guardList[areaId]['deviceIds'] = $(this).find("div[deviceId]").map(function(){return $(this).attr("deviceId")}).get();

                        let deviceList = [];
                        $.each($(this).find("div[deviceId]"),function(){
                            deviceList.push($(this).data());
                        });

                        // Video Mediator
                        _guardList[areaId][_MEDIATOR_TYPE[0]].setElement($(this).find("ul[ptzPlayers]"));
                        _guardList[areaId][_MEDIATOR_TYPE[0]].init(areaId,{'openLinkFlag': false});
                        _guardList[areaId][_MEDIATOR_TYPE[0]].createPlayerList(deviceList);

                        // Map Mediator
                        if(_guardList[areaId][_MEDIATOR_TYPE[1]] instanceof MapMediator){
                            _guardList[areaId][_MEDIATOR_TYPE[1]].setMap($(this).find("div[name='map-canvas']"), $(this).attr("areaDesc"), deviceList);
                            _guardList[areaId][_MEDIATOR_TYPE[1]].addImage();
                        }else if(_guardList[areaId][_MEDIATOR_TYPE[1]] instanceof CustomMapMediator){
                            _guardList[areaId][_MEDIATOR_TYPE[1]].setElement($(this), $(this).find("div[name='map-canvas']"), $(this).find("div[name='copyboxElement']"));
                            _guardList[areaId][_MEDIATOR_TYPE[1]].setMessageConfig(_messageConfig);
                            _guardList[areaId][_MEDIATOR_TYPE[1]].init(areaId,{
                                'element' : {
                                    'lastPositionUseFlag' : true
                                }, 'custom' : {
                                    'websocketSend':false
                                    ,'fenceView':true
                                    ,'openLinkFlag':false
                                    ,'click':function(targetId,deviceCode){
                                        if(deviceCode=='area'){ moveDashboard(areaId,targetId); }
                                    }
                                }
                            });
                        }
                        break;
                    case "TMP008" :
                        _toiletRoomList[areaId] = {};
                        _toiletRoomList[areaId] = new ToiletRoomMediator(_rootPath);
                        _toiletRoomList[areaId].setElement($(this));
                        _toiletRoomList[areaId].init(areaId);
                        break;
                }
            });

            if(blinkerAreaIds!=""){
                _self.getBlinker(blinkerAreaIds);
            }
        };

        /**
         * sendMessage websocket
         * @author psb
         */
        this.toiletRoomSendMessage = function(message){
            const toiletRoomMediator = _toiletRoomList[message['areaId']];
            if(message['areaId']!=null && toiletRoomMediator!=null){
                _webSocketHelper.sendMessage('toiletRoom',message);
                if(message['messageType']=='imageMode'){
                    toiletRoomMediator.updateImageMode(message['imageMode'],true);
                }
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
                        for(let index in data['notification']){
                            _self.appendEventHandler(messageType, data['notification'][index]);
                        }
                    }else{
                        if(data['areaId']!=null && _guardList[data['areaId']]!=null && data['status']!="C"){
                            _guardList[data['areaId']][_MEDIATOR_TYPE[0]].setAnimate("add",data['criticalLevel'],data);
                            _guardList[data['areaId']][_MEDIATOR_TYPE[1]].setAnimate("add",data['criticalLevel'],data);
                        }
                        notificationUpdate(messageType, data);
                        notificationMarqueeUpdate(data['areaId'], data);
                    }
                    break;
                case "removeNotification": // 알림이벤트 해제
                    if(data['notification']['areaId']!=null && _guardList[data['notification']['areaId']]!=null){
                        _guardList[data['notification']['areaId']][_MEDIATOR_TYPE[0]].setAnimate("remove",data['notification']['criticalLevel'],data['notification']);
                        _guardList[data['notification']['areaId']][_MEDIATOR_TYPE[1]].setAnimate("remove",data['notification']['criticalLevel'],data['notification']);
                    }
                    notificationUpdate(messageType, data['notification']);
                    notificationMarqueeUpdate(data['areaId']);
                    break;
                case "cancelDetection": // 감지 해제
                    if(data['notification']['areaId']!=null && _guardList[data['notification']['areaId']]!=null){
                        for(let index in data['cancel']){
                            _guardList[data['notification']['areaId']][_MEDIATOR_TYPE[0]].setAnimate("remove",data['cancel'][index]['criticalLevel'],data['notification']);
                            _guardList[data['notification']['areaId']][_MEDIATOR_TYPE[1]].setAnimate("remove",data['cancel'][index]['criticalLevel'],data['notification']);
                        }
                    }
                    break;
                case "editDeviceStatus": // 장치 상태
                    _self.setDeviceStatusList(data['deviceStatusList']);
                    for(let index in _guardList){
                        _guardList[index][_MEDIATOR_TYPE[0]].setDeviceStatusList(data['deviceStatusList']);
                        _guardList[index][_MEDIATOR_TYPE[1]].setDeviceStatusList(data['deviceStatusList']);
                    }
                    break;
            }
        };

        /**
         * set Noti Options
         * @author psb
         */
        this.setNotificationOption = function(areaId, _this){
            var notificationShowOnlyFlag = false;
            if(_this!=null){
                notificationShowOnlyFlag = $(_this).is(":checked");
                $.cookie(areaId+"NotificationShowOnlyFlag", notificationShowOnlyFlag);
            }else{
                notificationShowOnlyFlag = $.cookie(areaId+"NotificationShowOnlyFlag") == "true";
                $("input[name='notificationShowOnly']").prop("checked",notificationShowOnlyFlag);
            }
            notificationHelper.setOptions({'thisAreaShowOnlyFlag':notificationShowOnlyFlag});
        };

        /**
         * set Guard Options
         * @author psb
         */
        this.setGuardOption = function(actionType, areaId, _this){
            if(_guardList[areaId]!=null){
                _guardList[areaId][_MEDIATOR_TYPE[1]].setGuardOption(actionType, $(_this).is(":checked"));
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
            let result = null;
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
                    for(let index in _areaList){
                        const _area = _areaList[index];
                        if(_area['childAreaIds']!=null && _area['childAreaIds']!="" && _area['childAreaIds'].split(",").indexOf(areaId)>-1){
                            result = _area;
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
            let result = null;
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
            for(let index in deviceStatusList){
                const deviceStatus = deviceStatusList[index];

                for(let index in _areaList){
                    const _area = _areaList[index];
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

            for(let index in data){
                const inout = data[index];
                const inoutTag = _self.getArea("element", inout['areaId']);
                if(inoutTag!=null){
                    const inCount = inout['inCount']!=null?inout['inCount']:0;
                    const outCount = inout['outCount']!=null?inout['outCount']:0;
                    inoutTag.find("p[in]").text(inCount);
                    inoutTag.find("p[out]").text(outCount);
                    inoutTag.find("p[gap]").text(inCount-outCount);
                    inoutTag.attr("startDatetime",inout['startDatetime']);
                    inoutTag.attr("endDatetime",inout['endDatetime']);
                }
            }
            blinkerSumUpdate();
        };

        /**
         * Notification marquee Update
         */
        var notificationMarqueeUpdate = function(areaId, data){
            if(!_options['marquee']) {
                return false;
            }

            function setMarquee(areaComponent, _data){
                const element = areaComponent['element'];
                let lastNoti = null;

                if(_data!=null){
                    lastNoti = _data;
                }else{
                    const notification = areaComponent['notification'];
                    for(let index in notification){
                        const noti = notification[index];
                        let notiLen = noti.length;
                        if(notiLen > 0){
                            let notiData = null;
                            let roop = true;
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
                    const marqueeText = lastNoti['areaName']+" "+lastNoti['deviceName']+" "+lastNoti['eventName']+" "+new Date(lastNoti['eventDatetime']).format("yyyy.MM.dd HH:mm:ss");
                    if(element.find("p[messageBox] span").length > 0){
                        element.find("p[messageBox] span").attr("notificationId",lastNoti['notificationId']).text(marqueeText);
                    }else{
                        element.find("p[messageBox]").append(
                            $("<span/>",{notificationId:lastNoti['notificationId']}).text(marqueeText)
                        );
                    }
                }
            }


            const areaComponent = _self.getArea("all", areaId);
            if(areaComponent!=null){
                setMarquee(areaComponent, data);
            }else{
                const component = _self.getArea("full");
                for(let key in component){
                    setMarquee(component[key]);
                }
            }
        };

        /**
         * Notification update
         */
        var notificationUpdate = function(messageType, data){
            let areaComponent = _self.getArea("all", data['areaId']);

            if(areaComponent==null){
                areaComponent = _self.getArea("child", data['areaId']);
                if(areaComponent==null){
                    console.warn("[DashboardHelper][notificationUpdate] do not need to work on '" + data['areaId'] + "' area - " + data['notificationId']);
                    return false;
                }
            }
            const element = areaComponent['element'];
            const notification = areaComponent['notification'];
            const childDevice = areaComponent['childDevice'];
            const templateCode = areaComponent['templateCode'];

            switch (messageType){
                case "addNotification" :
                    if(notification[data['criticalLevel']].indexOf(data['notificationId'])<0){
                        notification[data['criticalLevel']].push(data['notificationId']);
                        if(childDevice[data['deviceId']] != null && childDevice[data['deviceId']]['notification'][data['criticalLevel']].indexOf(data['notificationId'])<0){
                            childDevice[data['deviceId']]['notification'][data['criticalLevel']].push(data['notificationId']);
                        }
                    }
                    break;
                case "removeNotification" :
                    if(notification[data['criticalLevel']].indexOf(data['notificationId'])>-1){
                        notification[data['criticalLevel']].splice(notification[data['criticalLevel']].indexOf(data['notificationId']),1);
                    }
                    if(childDevice[data['deviceId']] != null){
                        if(childDevice[data['deviceId']]['notification'][data['criticalLevel']].indexOf(data['notificationId']) > -1){
                            childDevice[data['deviceId']]['notification'][data['criticalLevel']].splice(childDevice[data['deviceId']]['notification'][data['criticalLevel']].indexOf(data['notificationId']),1);
                        }
                    }
                    break;
            }

            for(let index in notification){
                if(notification[index].length > 0){
                    element.addClass("level-"+criticalCss[index]);
                }else{
                    element.removeClass("level-"+criticalCss[index]);
                }

                if(templateCode==_defaultTemplateCode){
                    element.find("div[criticalLevel='"+index+"'] p").text(notification[index].length>0?notification[index].length:"");
                }
            }

            for(let i in childDevice){
                const childElement = childDevice[i]['element'];
                const childNotification = childDevice[i]['notification'];
                for(let index in childNotification){
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
            const element = _self.getArea("element", data['areaId']);
            const notification = _self.getArea("notification", data['areaId']);
            const childDevice = _self.getArea("childDevice", data['areaId']);

            const startDatetime = new Date(Number(element.attr("startDatetime")));
            const endDatetime = new Date(Number(element.attr("endDatetime")));
            const eventDatetime = new Date(data['eventDatetime']);

            if(eventDatetime>=startDatetime && eventDatetime<=endDatetime){
                let inCount = 0;
                let outCount = 0;
                for(let index in data['infos']){
                    const info = data['infos'][index];
                    if(info['key']=="inCount"){
                        inCount = info['value'];
                    }else if(info['key']=="outCount"){
                        outCount = info['value'];
                    }
                }

                if(inCount>0 || outCount>0){
                    const inTag = element.find("[in]");
                    const outTag = element.find("[out]");
                    inTag.text(Number(inCount) + Number(inTag.text()));
                    outTag.text(Number(outCount) + Number(outTag.text()));
                    element.find("[gap]").text(Number(element.find("[in]").text())-Number(element.find("[out]").text()));
                }else{
                    console.warn("[DashboardHelper][blinkerUpdate] in/out Count is empty - inCount : "+inCount+", outCount : "+outCount);
                }

                if(chartList[data['areaId']]!=null && outCount>0) {
                    let _eventDate = new Date();
                    _eventDate.setTime(data['eventDatetime']);
                    let _eventDateStr;
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

                    const _labels = chartList[data['areaId']].data.labels;
                    let seriesIndex = null;
                    for(let i=0; i<_labels.length; i++){
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

            blinkerSumUpdate();
        };

        var blinkerSumUpdate = function(){
            var sumValue = {};
            $.each($("div[templateCode='TMP003']"), function(){
                var sumAreaId = $(this).attr("sumAreaId");
                var inCount = Number($(this).find("p[in]").text());
                var outCount = Number($(this).find("p[out]").text());
                sumValue[sumAreaId] = {
                    'in' : sumValue[sumAreaId]==null?inCount:(sumValue[sumAreaId]['in']+inCount)
                    ,'out' : sumValue[sumAreaId]==null?outCount:(sumValue[sumAreaId]['out']+outCount)
                };
            });

            for(var index in sumValue){
                var sumTag = $("div[valueType][sumAreaId='"+index+"']");
                sumTag.find("p[in]").text(sumValue[index]['in']);
                sumTag.find("p[out]").text(sumValue[index]['out']);
                sumTag.find("p[gap]").text(sumValue[index]['in']-sumValue[index]['out']);
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

            const element = _self.getArea("element", data['areaId']);
            const notification = _self.getArea("notification", data['areaId']);
            const childDevice = _self.getArea("childDevice", data['areaId']);

            if(childDevice[data['deviceId']] != null){
                const deviceElement = childDevice[data['deviceId']]['element'];
                let updateFlag = false;
                let eventValue;
                for(let index in data['infos']){
                    const info = data['infos'][index];

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

                    let _eventDate = new Date();
                    _eventDate.setTime(data['eventDatetime']);
                    let _eventDateStr;
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

                    const _labels = chartList[data['areaId']].data.labels;
                    let seriesIndex = null;
                    for(let i=0; i<_labels.length; i++){
                        if(_labels[i]==_eventDateStr){
                            seriesIndex = i;
                            break;
                        }
                    }

                    if(seriesIndex!=null){
                        try{
                            if(chartList[data['areaId']].data.series[0][seriesIndex] < eventValue){
                                chartList[data['areaId']].data.series[0][seriesIndex] = eventValue;
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