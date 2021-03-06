/**
 * Dashboard Helper
 *
 * @author psb
 * @type {Function}
 */
var DashboardHelper = (
    function(rootPath, version){
        const _MEDIATOR_TYPE = ['video','map','school'];
        const _defaultTemplateCode = "TMP001";
        const _self = this;

        let _rootPath;
        let _version;
        let _webSocketHelper;
        let _messageConfig;
        let _fileUploadPath;
        let _templateSetting;
        let _schoolPopup = {
            'initFlag' : false
            ,'areaId' : null
            ,'speedMeter' : {
                'fn' : null
                ,'uuid' : {
                    'vehicleSpeedAverage' : null
                    ,'vehicleSpeedMax' : null
                }
            }
            ,'multiBar' : {
                'fn' : null
                ,'uuid' : {
                    'crossing' : null
                    ,'vehicleTraffic' : null
                    ,'trespassers' : null
                    ,'speedingVehicleTraffic' : null
                }
            }
            ,'multiLine' : {
                'fn' : null
                ,'uuid' : {
                    'crossing' : null
                    ,'vehicleTraffic' : null
                    ,'trespassers' : null
                    ,'speedingVehicleTraffic' : null
                }
            }
        };
        let _urlConfig = {
            blinkerListUrl : "/eventLog/blinkerList.json"
            ,deviceListUrl : "/device/list.json"
            ,saveViewOptionUrl : "/area/saveViewOption.json"
        };
        let _options ={
            marquee : false
        };

        let _areaList = {};
        let _guardList = {};
        let _toiletRoomList = {};
        let _analysisList = {};


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

        var setSchoolPopup = function(){
            _schoolPopup['speedMeter']['fn'] = new SpeedMeter();
            _schoolPopup['speedMeter']['uuid']['vehicleSpeedMax'] = _schoolPopup['speedMeter']['fn'].setElement($('#schoolPopupMaxEl'));
            _schoolPopup['speedMeter']['uuid']['vehicleSpeedAverage'] = _schoolPopup['speedMeter']['fn'].setElement($('#schoolPopupAvgEl'));

            _schoolPopup['multiBar']['fn'] = new MultiBar();
            _schoolPopup['multiBar']['uuid']['crossing'] = _schoolPopup['multiBar']['fn'].setElement($("section[name='crossing']"));
            _schoolPopup['multiBar']['uuid']['vehicleTraffic'] = _schoolPopup['multiBar']['fn'].setElement($("section[name='vehicleTraffic']"));
            _schoolPopup['multiBar']['uuid']['trespassers'] = _schoolPopup['multiBar']['fn'].setElement($("section[name='trespassers']"));
            _schoolPopup['multiBar']['uuid']['speedingVehicleTraffic'] = _schoolPopup['multiBar']['fn'].setElement($("section[name='speedingVehicleTraffic']"));

            _schoolPopup['multiLine']['fn'] = new MultiLine();
            _schoolPopup['multiLine']['uuid']['crossing'] = _schoolPopup['multiLine']['fn'].setElement($("section[name='crossing']"));
            _schoolPopup['multiLine']['uuid']['vehicleTraffic'] = _schoolPopup['multiLine']['fn'].setElement($("section[name='vehicleTraffic']"));
            _schoolPopup['multiLine']['uuid']['trespassers'] = _schoolPopup['multiLine']['fn'].setElement($("section[name='trespassers']"));
            _schoolPopup['multiLine']['uuid']['speedingVehicleTraffic'] = _schoolPopup['multiLine']['fn'].setElement($("section[name='speedingVehicleTraffic']"));
            _schoolPopup['initFlag'] = true;
        };

        /**
         * set websocket
         * @author psb
         */
        this.setWebsocket = function(webSocketHelper, param){
            _webSocketHelper = webSocketHelper;
            for(let index in param){
                switch (param[index]) {
                    case "map":
                        if($("div[templateCode='TMP005'], div[templateCode='TMP012']").length>0){
                            _webSocketHelper.addWebSocketList(param[index], mapMessageEventHandler);
                        }

                        if($("div[templateCode='TMP012']").length>0){
                            $(".sub_title_area").after(
                                $("<h2/>").text(_messageConfig['schoolZoneTitle'])
                            );
                            modifyElementClass($("body"),'school-mode','add');
                        }
                        break;
                    case "toiletRoom":
                        if($("div[templateCode='TMP008']").length>0){
                            _webSocketHelper.addWebSocketList(param[index], toiletRoomMessageEventHandler);
                        }
                        break;
                    case "eventLog":
                        _webSocketHelper.addWebSocketList(param[index], eventHandler);
                        break;
                }
            }
        };

        /**
         * Event 웹소켓 메세지 리스너
         * @param message
         */
        var eventHandler = function(message) {
            var resultData;
            try{
                if(typeof message.data!='undefined'){
                    resultData = message.data;
                }else if(typeof message.body!='undefined'){
                    resultData = message.body;
                }
                resultData = JSON.parse(resultData);
            }catch(e){
                console.warn("[eventHandler] json parse error - " + message);
                return false;
            }

            switch (resultData['messageType']) {
                case "refreshBlinker": // 진출입 갱신
                    _self.getBlinker(resultData['areaId']);
                    break;
                case "addEvent" : // 일반 이벤트
                    addEvent(resultData);
                    break;
                case "editDeviceStatus": // 장치 상태
                    editDeviceStatus(resultData);
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
                if(typeof message.data!='undefined'){
                    resultData = message.data;
                }else if(typeof message.body!='undefined'){
                    resultData = message.body;
                }
                resultData = JSON.parse(resultData);
            }catch(e){
                console.warn("[mapMessageEventHandler] json parse error - " + message);
                return false;
            }

            switch (resultData['messageType']) {
                case "object":
                    var _mapMediator = _self.getGuard(_MEDIATOR_TYPE[1], resultData['areaId']);
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
                        console.debug("[mapMessageEventHandler] areaId or mapMediator is null  - " + resultData['areaId'] + ","+_mapMediator);
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
                if(message.hasOwnProperty("data")){
                    resultData = message.data;
                }else if(message.hasOwnProperty("body")){
                    resultData = message.body;
                }
                resultData = JSON.parse(resultData);
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

            $.each($(".watch_area div[areaId][templatecode]"), function(){
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

                        var deviceList = [];
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
                                },
                                'object' : {
                                    'speedFlag' : true
                                    ,'locationZFlag' : true
                                },
                                'fence' : {
                                    'cameraFenceUseFlag' : false
                                }
                                , 'custom' : {
                                    'fenceView':true
                                    ,'openLinkFlag':false
                                    ,'click':function(data){
                                        if(data['deviceCode']=='area'){
                                            moveDashboard(areaId,data['targetId']);
                                        }else if(data['deviceCode']=='DEV002'){
                                            cs.openCamera({"deviceId":data['targetId'],"deviceName":data['targetName']})
                                        }
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
                    case "TMP010" :
                        _guardList[areaId] = {};
                        _guardList[areaId][_MEDIATOR_TYPE[1]] = new CustomMapMediator(_rootPath);
                        _guardList[areaId][_MEDIATOR_TYPE[1]].setElement($(this), $(this).find("div[name='map-canvas']"), $(this).find("div[name='copyboxElement']"));
                        _guardList[areaId][_MEDIATOR_TYPE[1]].setMessageConfig(_messageConfig);
                        _guardList[areaId][_MEDIATOR_TYPE[1]].init(areaId,{
                            'element' : {
                                'lastPositionUseFlag' : true
                            }, 'custom' : {
                                'openLinkFlag':false
                                ,'childAnimateFlag':true
                                ,'click':function(data){
                                    if($("#controlDeviceId").val()!=data['targetId']){
                                        _ajaxCall('deviceList', {deviceId:data['targetId'], parentDeviceId:data['targetId'],farmFlag:'Y'});
                                    }else{
                                        openDetailPopup();
                                    }
                                }
                            }
                        });
                        break;
                    case "TMP011" :
                        _analysisList[areaId] = {};
                        _analysisList[areaId] = new AnalysisMediator(_rootPath);
                        _analysisList[areaId].setElement($(this));
                        _analysisList[areaId].init(areaId);
                        break;
                    case "TMP012" :
                        _guardList[areaId] = {};
                        _guardList[areaId][_MEDIATOR_TYPE[1]] = new CustomMapMediator(_rootPath);
                        _guardList[areaId]['deviceIds'] = $(this).find("div[deviceId]").map(function(){return $(this).attr("deviceId")}).get();

                        // Map Mediator
                        _guardList[areaId][_MEDIATOR_TYPE[1]].setElement($(this), $(this).find("div[name='map-canvas']"), $(this).find("div[name='copyboxElement']"));
                        _guardList[areaId][_MEDIATOR_TYPE[1]].setMessageConfig(_messageConfig);
                        _guardList[areaId][_MEDIATOR_TYPE[1]].init(areaId,{
                            'element' : {
                                'lastPositionUseFlag' : true
                            },
                            'object' : {
                                'speedFlag' : true
                                ,'locationZFlag' : true
                            }
                            , 'custom' : {
                                'fenceView':true
                                ,'openLinkFlag':false
                            }
                        });

                        // School Mediator
                        _guardList[areaId][_MEDIATOR_TYPE[2]] = new SchoolMediator(_rootPath);
                        _guardList[areaId][_MEDIATOR_TYPE[2]].setElement($(this));
                        _guardList[areaId][_MEDIATOR_TYPE[2]].init(areaId);
                        _guardList[areaId][_MEDIATOR_TYPE[2]].bindSchoolPopupHandler(schoolPopupHandler);
                        break;
                }
            });

            if(blinkerAreaIds!=""){
                _self.getBlinker(blinkerAreaIds);
            }
        };

        var schoolPopupHandler = function(areaId, type, info){
            if(_schoolPopup['areaId']!=null && _schoolPopup['areaId'] == areaId){
                switch (type){
                    case "crossing" : // 횡단보도
                    case "vehicleTraffic" : // 차량 통행량
                    case "trespassers" : // 무단 횡단자
                    case "speedingVehicleTraffic" : // 과속차량 통행량
                        $(".layer-sub section[name='"+type+"'] p[name='now']").text(info['data']['todayValue']);
                        $(".layer-sub section[name='"+type+"'] p[name='pre']").text(info['data']['preValue']);

                        if(_schoolPopup['multiBar']!=null && _schoolPopup['multiBar'].hasOwnProperty('fn')){
                            _schoolPopup['multiBar']['fn'].setValue(_schoolPopup['multiBar']['uuid'][type], info['chartData']);
                        }
                        if(_schoolPopup['multiLine']!=null && _schoolPopup['multiLine'].hasOwnProperty('fn')){
                            let data = [];
                            for(var fenceId in info['fenceList']){
                                let fenceData = {
                                    'id' : fenceId
                                    ,'name' : info['fenceList'][fenceId]
                                    ,'values' : []
                                };
                                for(var index in info['chartData']){
                                    fenceData['values'].push({
                                        'date' : index
                                        ,'cnt' : info['chartData'][index]['today'][fenceId]?info['chartData'][index]['today'][fenceId]:0
                                    })
                                }
                                data.push(fenceData);
                            }
                            _schoolPopup['multiLine']['fn'].setValue(_schoolPopup['multiLine']['uuid'][type], data);
                        }
                        break;
                    case "vehicleSpeedAverage" : // 차량 평균속도
                    case "vehicleSpeedMax" : // 차량 최고속도
                        if(_schoolPopup['speedMeter']!=null && _schoolPopup['speedMeter'].hasOwnProperty('fn')){
                            _schoolPopup['speedMeter']['fn'].setValue(_schoolPopup['speedMeter']['uuid'][type], info['data']['todayValue']);
                        }
                        break;
                }
            }
        };

        this.startZoomControl = function(areaId, actionType){
            if(areaId!=null && _guardList[areaId]!=null && _guardList[areaId][_MEDIATOR_TYPE[1]]!=null){
                _guardList[areaId][_MEDIATOR_TYPE[1]].startZoomControl(actionType, true);
            }
        };

        this.stopZoomControl = function(areaId){
            if(areaId!=null && _guardList[areaId]!=null && _guardList[areaId][_MEDIATOR_TYPE[1]]!=null){
                _guardList[areaId][_MEDIATOR_TYPE[1]].stopZoomControl();
            }
        };

        this.saveViewOption = function(areaId){
            if(areaId!=null && _guardList[areaId]!=null && _guardList[areaId][_MEDIATOR_TYPE[1]]!=null){
                _ajaxCall('saveViewOption',{
                    'areaId' : areaId
                    ,'viewOption' : JSON.stringify(_guardList[areaId][_MEDIATOR_TYPE[1]].getViewOption())
                });
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

        this.openSchoolPopup = function(areaId){
            if(!_schoolPopup['initFlag']){
                setSchoolPopup();
            }
            if(_guardList[areaId][_MEDIATOR_TYPE[2]]!=null){
                _schoolPopup['areaId'] = areaId;
                _guardList[areaId][_MEDIATOR_TYPE[2]].getPopupData();
            }
            $('.layer-sub').addClass('on');
        };

        this.closeSchoolPopup = function(){
            _schoolPopup['areaId'] = null;
            $('.layer-sub').removeClass('on');
        };

        /**
         * websocket callback append event handler
         */
        this.appendEventHandler = function(messageType, data){
            switch (messageType) {
                case "addNotification": // 알림이벤트 등록
                    if(Array.isArray(data['notification'])){
                        for(let index in data['notification']){
                            data['notification'][index]['moveFenceHide'] = true;
                            _self.appendEventHandler(messageType, data['notification'][index]);
                        }
                    }else{
                        if(data['areaId']!=null && _guardList[data['areaId']]!=null && data['status']!="C"){
                            if(_guardList[data['areaId']][_MEDIATOR_TYPE[0]]!=null){
                                _guardList[data['areaId']][_MEDIATOR_TYPE[0]].setAnimate("add",data['criticalLevel'],data);
                            }
                            if(_guardList[data['areaId']][_MEDIATOR_TYPE[1]]!=null){
                                _guardList[data['areaId']][_MEDIATOR_TYPE[1]].setAnimate("add",data['criticalLevel'],data);
                            }
                            if(_guardList[data['areaId']][_MEDIATOR_TYPE[2]]!=null){
                                _guardList[data['areaId']][_MEDIATOR_TYPE[2]].setAnimate(data);
                            }
                        }
                        notificationUpdate(messageType, data);
                        notificationMarqueeUpdate(data['areaId'], data);
                    }
                    break;
                case "removeNotification": // 알림이벤트 해제
                    if(data['notification']['areaId']!=null && _guardList[data['notification']['areaId']]!=null){
                        if(_guardList[data['notification']['areaId']][_MEDIATOR_TYPE[0]]!=null){
                            _guardList[data['notification']['areaId']][_MEDIATOR_TYPE[0]].setAnimate("remove",data['notification']['criticalLevel'],data['notification']);
                        }
                        if(_guardList[data['notification']['areaId']][_MEDIATOR_TYPE[1]]!=null){
                            _guardList[data['notification']['areaId']][_MEDIATOR_TYPE[1]].setAnimate("remove",data['notification']['criticalLevel'],data['notification']);
                        }
                    }
                    notificationUpdate(messageType, data['notification']);
                    notificationMarqueeUpdate(data['areaId']);
                    break;
                case "cancelDetection": // 감지 해제
                    if(data['notification']['areaId']!=null && _guardList[data['notification']['areaId']]!=null){
                        for(let index in data['cancel']){
                            if(_guardList[data['notification']['areaId']][_MEDIATOR_TYPE[0]]!=null){
                                _guardList[data['notification']['areaId']][_MEDIATOR_TYPE[0]].setAnimate("remove",data['cancel'][index]['criticalLevel'],data['notification']);
                            }
                            if(_guardList[data['notification']['areaId']][_MEDIATOR_TYPE[1]]!=null){
                                _guardList[data['notification']['areaId']][_MEDIATOR_TYPE[1]].setAnimate("remove",data['cancel'][index]['criticalLevel'],data['notification']);
                            }
                        }
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
                let value = null;
                switch (actionType){
                    case "trackingScale":
                        value = "scale-20";
                        if($(_this).hasClass("scale-20")){
                            $(_this).removeClass("scale-20 scale-30 scale-40");
                            $(_this).addClass("scale-30");
                            value = "scale-30";
                        }else if($(_this).hasClass("scale-30")){
                            $(_this).removeClass("scale-20 scale-30 scale-40");
                            $(_this).addClass("scale-40");
                            value = "scale-40";
                        }else if($(_this).hasClass("scale-40")){
                            $(_this).removeClass("scale-20 scale-30 scale-40");
                            $(_this).addClass("scale-20");
                        }
                        break;
                    default :
                        value = $(_this).is(":checked");
                }
                _guardList[areaId][_MEDIATOR_TYPE[1]].setGuardOption(actionType, value);
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
                case 'deviceList':
                    let parentDevice = data['device'];
                    if(parentDevice!=null){
                        $("#controlDeviceId").val(parentDevice['deviceId']);
                        $("#controlParentSerialNo").val(parentDevice['serialNo']);
                        $("#controlAreaId").val(parentDevice['areaId']);
                    }

                    let deviceList = data['devices'];
                    $("#controlDeviceList").empty();
                    for(var index in deviceList){
                        let device = deviceList[index];
                        let deviceElement = $("<div/>",{deviceId:device['deviceId'],serialNo:device['serialNo'],deviceCode:device['deviceCode'],class:device['deviceCodeCss']}).append(
                            $("<p/>").text(device['deviceName'])
                        );

                        let evtValue;
                        if(device['deviceCode']=='DEV006'){
                            evtValue = device['evtValue']==1?"ON":"OFF";
                        }else{
                            evtValue = (Number(device['evtValue'])?Number(device['evtValue']):0).toFixed(2)+' '+(device['format']?device['format']:"");
                        }
                        deviceElement.append(
                            $("<p/>",{name:'evtValue'}).text(evtValue)
                        );

                        if(device['deviceTypeCode']=='D00001'){
                            if(device['deviceCode']=='DEV006'){
                                deviceElement.append(
                                    $("<div/>",{style:'position:absolute; right:0; margin-right:-40px; width:auto;'}).append(
                                        $("<div/>",{class:'checkbox_set csl_style02'}).append(
                                            $("<input/>",{type:'checkbox',id:device['serialNo']+'Led',checked:device['evtValue']==1}).change({serialNo:device['serialNo']},function(evt){
                                                deviceControl('led',evt.data.serialNo,$(this).is(":checked")?1:0);
                                            })
                                        ).append(
                                            $("<label/>")
                                        )
                                    )
                                );
                            }else{
                                deviceElement.append(
                                    $("<div/>",{style:'position:absolute; right:0; margin-right:10px; width:auto;'}).append(
                                        $("<input/>",{type:'text',style:'width:100px;',id:device['serialNo']+'Temp'})
                                    ).append(
                                        $("<button/>",{class:'btn',style:'width:80px; border: solid 1px;'}).text("전송").click({serialNo:device['serialNo']},function(evt){
                                            deviceControl('temp',evt.data.serialNo,$("#"+evt.data.serialNo+'Temp').val());
                                        })
                                    )
                                );
                            }
                        }
                        $("#controlDeviceList").append(deviceElement);
                    }
                    openDetailPopup();
                    break;
                case 'saveViewOption':
                    console.log("option save complete.");
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
                    inoutTag.find("p[gap]").text(inCount-outCount+(inoutTag.find("p[gap]").attr("resetCal")!=null?Number(inoutTag.find("p[gap]").attr("resetCal")):0));
                    inoutTag.attr("startDatetime",inout['startDatetime']);
                    inoutTag.attr("endDatetime",inout['endDatetime']);
                }
            }
            blinkerSumUpdate();
        };

        var editDeviceStatus = function(data){
            for(let index in data['deviceStatusList']){
                const deviceStatus = data['deviceStatusList'][index];
                if(deviceStatus['deviceStat']=='Y'){
                    $("li[deviceId='"+deviceStatus['deviceId']+"']").removeClass('level-die');
                }else{
                    $("li[deviceId='"+deviceStatus['deviceId']+"']").addClass('level-die');
                }
            }

            _self.setDeviceStatusList(data['deviceStatusList']);
            for(let index in _guardList){
                if(_guardList[index][_MEDIATOR_TYPE[0]]!=null){
                    _guardList[index][_MEDIATOR_TYPE[0]].setDeviceStatusList(data['deviceStatusList']);
                }
                if(_guardList[index][_MEDIATOR_TYPE[1]]!=null){
                    _guardList[index][_MEDIATOR_TYPE[1]].setDeviceStatusList(data['deviceStatusList']);
                }
            }
        };

        var addEvent = function(data){
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
                case "TMP010": // smart-farm
                    farmUpdate(data['eventLog']);
                    break;
                case "TMP011": // 영상분석
                    if(data['eventLog']['areaId']!=null && _analysisList[data['eventLog']['areaId']]!=null){
                        _analysisList[data['eventLog']['areaId']].setAnimate(data['eventLog']);
                    }
                    break;
                case "TMP012": // school zone
                    break;
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
                    console.debug("[DashboardHelper][notificationUpdate] do not need to work on '" + data['areaId'] + "' area - " + data['notificationId']);
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
                    var notificationIndex = notification[data['criticalLevel']].indexOf(data['notificationId']);
                    if(notificationIndex>-1){
                        notification[data['criticalLevel']].splice(notificationIndex,1);
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
                        childElement.addClass("level-"+criticalCss[index]);
                    }else{
                        childElement.removeClass("level-"+criticalCss[index]);
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
                let inCount = Number(data['inCount'])?Number(data['inCount']):0;
                let outCount = Number(data['outCount'])?Number(data['outCount']):0;

                if(inCount>0 || outCount>0){
                    const inTag = element.find("[in]");
                    const outTag = element.find("[out]");
                    inTag.text(inCount + Number(inTag.text()));
                    outTag.text(outCount + Number(outTag.text()));
                    element.find("[gap]").text(Number(element.find("[in]").text())-Number(element.find("[out]").text())+(element.find("p[gap]").attr("resetCal")!=null?Number(element.find("p[gap]").attr("resetCal")):0));
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

        this.resetGap = function(parent,allFlag){
            if(allFlag){
                parent.find("p[gap], p[in], p[out]").text(0);
                parent.find("p[gap]").attr("resetCal",0);
            }else{
                parent.find("p[gap]").each(function(){
                    var resetCal = $(this).attr("resetCal")!=null?Number($(this).attr("resetCal")):0;
                    resetCal-=$(this).text();
                    $(this).attr("resetCal",resetCal).text(0);
                });
            }
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
                sumTag.find("p[gap]").text(sumValue[index]['in']-sumValue[index]['out']+(sumTag.find("p[gap]").attr("resetCal")!=null?Number(sumTag.find("p[gap]").attr("resetCal")):0));
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
            const childDevice = _self.getArea("childDevice", data['areaId']);

            if(childDevice[data['deviceId']] != null){
                const deviceElement = childDevice[data['deviceId']]['element'];
                let updateFlag = false;
                let eventValue = 0;
                if(data['value']!=null){
                    eventValue = Number(data['value'])?Number(data['value']):0;
                    try{
                        deviceElement.find("p[evtValue]").text(eventValue.toFixed(2));
                    }catch(e){
                        deviceElement.find("p[evtValue]").text(eventValue);
                        console.error("[DashboardHelper][detectorUpdate] parse error - "+ e.message);
                    }
                    updateFlag = true;
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

        /**
         * farm update
         */
        var farmUpdate = function(data){
            if($("#controlAreaId").val()!=data['areaId']){
                return false;
            }
            const deviceElement = $("#controlDeviceList div[deviceId='"+data['deviceId']+"']");
            if(data['value']!=null){
                let evtValue = Number(data['value'])?Number(data['value']):0;
                if(deviceElement.attr("deviceCode")=='DEV006'){
                    deviceElement.find("p[name='evtValue']").text(evtValue==1?"ON":"OFF");
                }else{
                    deviceElement.find("p[name='evtValue']").text(evtValue.toFixed(2)+" "+(data['format']!=null?data['format']:""));
                }
            }
        };

        initialize(rootPath, version);
    }
);