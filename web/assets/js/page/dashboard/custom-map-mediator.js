/**
 * Map Mediator
 * - 맵 관련 이벤트 및 데이터를 처리한다. (오프라인 맵)
 * - 구역과 1:1 매칭
 *
 * @author psb
 * @type {Function}
 */
var CustomMapMediator = (
    function(rootPath, version){
        var _rootPath;
        var _version;
        var _MARKER_TYPE = ['device','fence','object','camera','custom'];
        var _areaId;
        var _urlConfig = {
            listUrl : "/customMapLocation/list.json"
            ,fenceListUrl : "/fence/list.json"
        };
        var _marker = {
            'fence' : {}
            ,'object' : {}
            ,'custom' : {}
        };
        var _options = {
            'element' : {
                'draggable': true // 드래그 기능
                ,'mousewheel': true // zoom in/out 기능
                ,'zoom' : {  // 10 = scale(1,1) and 5 = scale(0.5,0.5)
                    'init' : 30
                    ,'min' : 5
                    ,'max' : 50
                }
            }
            ,'fence' : {
                'text' : {
                    'text-anchor': "middle"
                    , 'fill': "white"
                    , 'font-size': "5px"
                }
            }
            ,'custom' : {
                'draggable': false // 드래그 기능
                , 'resizable': false // 사이즈 조절 기능
                , 'nameView': true // 이름 표시 여부
                , 'websocketSend': false // getdevice 요청 여부
                , 'allView' : false // 사용유무 상관없이 전체보기
                , 'fenceView': false // fence 표시 여부
                , 'onLoad': null // List load eventHandler
                , 'change': null // drag or resize로 인한 수치값 변경시 eventHandler
                , 'click': null // click eventHandler
            }
        };
        var _targetClass = {
            'area' : "g-area"
            ,'object' : "g-tracking"
            ,'fence' : "g-fence"
            ,"DEV013" : "g-m8"
            ,"DEV002" : "g-camera"
        };
        var _scale=1.0;
        var _element;
        var _fenceSvg;
        var _fileUploadPath;
        var _messageConfig;
        var _self = this;

        /**
         * initialize
         * @author psb
         * @param _canvas
         * @returns
         */
        var _initialize = function(rootPath, version){
            _rootPath = rootPath;
            _version = version;
            for(var index in _urlConfig){
                _urlConfig[index] = _rootPath + _urlConfig[index];
            }
        };

        /**
         * set element
         * @author psb
         */
        this.setElement = function(element){
            _element = element;
            _element.addClass("map_images");
            _element.empty();
            if(_element.data('uiDraggable')){
                _element.draggable('destroy');
            }
            _element.off('mousewheel').removeAttr("style").removeAttr("scale");

            if(_options['element']['draggable']){
                var pointerY, pointerX, canvasOffset;
                _element.draggable({
                    cursor: "move"
                    ,start : function(evt, ui) {
                        canvasOffset = _element.offset();
                        pointerY = evt.pageY - (canvasOffset.top / _scale) - parseInt($(evt.target).css('top'));
                        pointerX = evt.pageX - (canvasOffset.left / _scale) - parseInt($(evt.target).css('left'));
                    }
                    ,drag : function(evt, ui) {
                        // Fix for zoom
                        ui.position.top = Math.round(evt.pageY - (canvasOffset.top / _scale) - pointerY);
                        ui.position.left = Math.round(evt.pageX - (canvasOffset.left / _scale) - pointerX);
                    }
                });
            }

            if(_options['element']['mousewheel']){
                var compteur = _options['element']['zoom']['init'];
                _element.on("mousewheel",function(event) {
                    if(event.originalEvent.deltaY > 0){if(compteur > _options['element']['zoom']['min']){compteur--;}}
                    if(event.originalEvent.deltaY < 0){if(compteur < _options['element']['zoom']['max']){compteur++;}}
                    var scale = compteur/10;
                    _element.css({
                        'transform':'scale('+scale+')'
                        ,'-webkit-transform':'scale('+scale+')'
                        ,'-moz-transform':'scale('+scale+')'
                        ,'-o-transform':'scale('+scale+')'
                        ,'-ms-transform':'scale('+scale+')'
                    });
                    _scale = scale;
                });
            }

            _element.css({
                left:(_element.parent().width()-_element.width())/2
                , top:(_element.parent().height()-_element.height())/2
                ,'transform':'scale('+_options['element']['zoom']['init']/10+')'
                ,'-webkit-transform':'scale('+_options['element']['zoom']['init']/10+')'
                ,'-moz-transform':'scale('+_options['element']['zoom']['init']/10+')'
                ,'-o-transform':'scale('+_options['element']['zoom']['init']/10+')'
                ,'-ms-transform':'scale('+_options['element']['zoom']['init']/10+')'
            });
            _scale = _options['element']['zoom']['init']/10;

            // fence svg init
            if($.fn.svg!=null){
                _element.svg({
                    onLoad:function(svg){
                        _fenceSvg = svg;
                    }
                });
                _element.find("svg").addClass("g-fence");
            }
        };

        /**
         * set target display
         * @author psb
         */
        this.setDisplayTarget = function(targetId, flag){
            if(_marker[_MARKER_TYPE[4]][targetId]==null){
                return false;
            }

            if(flag){
                _element.find(".on").removeClass("on");
                _marker[_MARKER_TYPE[4]][targetId]['data']['useYn'] = 'Y';
                _marker[_MARKER_TYPE[4]][targetId]['element'].addClass("on").show();
                return true;
            }else{
                _marker[_MARKER_TYPE[4]][targetId]['data']['useYn'] = 'N';
                _marker[_MARKER_TYPE[4]][targetId]['element'].hide();
                return false;
            }
        };

        /**
         * set image
         * @author psb
         */
        this.setBackgroundImage = function(physicalFileName){
            if(physicalFileName!=null && physicalFileName!=""){
                _element.css({"background-image":"url("+_fileUploadPath+physicalFileName+")"});
            }else{
                _element.css({"background-image":""});
            }
        };

        /**
         * Map 설정 팝업에서 저장시 사용
         * @author psb
         */
        this.getMarkerList = function(type){
            if(_MARKER_TYPE.indexOf(type) < 0){
                console.error("[CustomMapMediator][getMarkerList] unknown type - "+type);
                return false;
            }
            return _marker[type];
        };

        /**
         * 수치값 변경시 이벤트 핸들러
         * - input 직접변경시
         * @author psb
         */
        this.setTargetData = function(targetId, data){
            if(_marker[_MARKER_TYPE[4]][targetId]==null){
                console.error("[CustomMapMediator][setTargetData] targetId is null or empty - "+targetId);
                return false;
            }

            var targetElement = _marker[_MARKER_TYPE[4]][targetId]['element'];
            var targetData = _marker[_MARKER_TYPE[4]][targetId]['data'];

            $.extend(targetData,data);
            targetElement.css("left",targetData['x1']);
            targetElement.css("width",_element.width()-targetData['x1']-targetData['x2']);
            targetElement.css("top",targetData['y1']);
            targetElement.css("height",_element.height()-targetData['y1']-targetData['y2']);

            setTranslate(targetData, targetElement);
        };

        /**
         * 수치값 변경시 이벤트 핸들러
         * actionType
         *  - init : 초기 로딩 시
         *  - update : 마우스 드래그를 통한 위치 변경 or 축소 확대 시 이벤트 핸들러
         * @author psb
         */
        var positionChangeEventHandler = function(targetId, actionType){
            if(_marker[_MARKER_TYPE[4]][targetId]==null){
                console.error("[CustomMapMediator][positionChangeEventHandler] id is null or empty - "+targetId);
                return false;
            }

            var targetElement = _marker[_MARKER_TYPE[4]][targetId]['element'];
            var targetData = _marker[_MARKER_TYPE[4]][targetId]['data'];

            switch (actionType){
                case 'init':
                    targetElement.css("left",targetData['x1']);
                    targetElement.outerWidth(_element.width()-targetData['x1']-targetData['x2']);
                    targetElement.css("top",targetData['y1']);
                    targetElement.outerHeight(_element.height()-targetData['y1']-targetData['y2']);
                    break;
                case 'update':
                    targetData['x1'] = parseInt(targetElement.css("left"));
                    targetData['x2'] = toRound(_element.width() - targetData['x1'] - targetElement.width(),2);
                    targetData['y1'] = parseInt(targetElement.css("top"));
                    targetData['y2'] = toRound(_element.height() - targetData['y1'] - targetElement.height(),2);
                    break;
            }

            if(_options['custom']['change']!=null && typeof _options['custom']['change'] == "function"){
                _options['custom']['change'](targetData);
            }

            setTranslate(targetData, targetElement);
        };

        /**
         * 기준 설정
         * 장치코드 DEV013(M8) 일 경우 object, fence의 기준장치로 설정함
         * Custom-map-popup에서 m8장치 이동 및 사이즈 변경시 fence를 새로그림
         * @author psb
         */
        var setTranslate = function (targetData, targetElement){
            if(targetData['deviceCode']=='DEV013'){
                targetData['translate'] = {
                    'x' : parseInt(targetElement.css("left")) + targetElement.width()/2
                    ,'y' : parseInt(targetElement.css("top")) + targetElement.height()/2
                };

                if(targetData.hasOwnProperty("setFenceList")){
                    for(var index in _marker[_MARKER_TYPE[1]]){
                        _self.saveFence(index, targetData['targetId']);
                    }
                }else if(_options['custom']['fenceView']){
                    targetData['setFenceList'] = true;
                    _ajaxCall('fenceList',{deviceId:targetData['targetId']});
                }
            }
        };

        /**
         * save fence name
         * @author psb
         */
        this.saveFence = function(fenceId, deviceId, fenceName){
            if(_marker[_MARKER_TYPE[1]]!=null && _marker[_MARKER_TYPE[1]][fenceId]!=null){
                _self.saveMarker(
                    _MARKER_TYPE[1]
                    , {
                        'uuid':_marker[_MARKER_TYPE[1]][fenceId]['data']['uuid']
                        ,'id' : fenceId
                        ,'deviceId':deviceId
                        ,'location':_marker[_MARKER_TYPE[1]][fenceId]['data']['location']
                        ,'fenceName':fenceName!=null?fenceName:_marker[_MARKER_TYPE[1]][fenceId]['data']['fenceName']
                    }
                );
            }
        };

        /**
         * 구역/장치 단건 Render
         * @author psb
         */
        this.targetRender = function(data){
            if(_marker[_MARKER_TYPE[4]][data['targetId']]==null){
                var targetElement = $("<div/>",{targetId:data['targetId'],deviceCode:data['deviceCode'],class:_targetClass[data['deviceCode']]});
                targetElement.on("click",function(){
                    if(_options['custom']['click']!=null && typeof _options['custom']['click'] == "function"){
                        _options['custom']['click']($(this).attr("targetId"),$(this).attr("deviceCode"));
                    }else{
                        positionChangeEventHandler($(this).attr("targetId"));
                    }
                });
                setDeviceStatus(targetElement, data['deviceStat']);

                if(_options['custom']['resizable']){
                    targetElement.resizable({
                        containment: "parent"
                        ,aspectRatio:data['deviceCode']!="area"?true:false
                        ,resize: function(evt, ui){
                            var changeWidth = ui.size.width - ui.originalSize.width; // find change in width
                            var newWidth = ui.originalSize.width + changeWidth / _scale; // adjust new width by our zoomScale

                            var changeHeight = ui.size.height - ui.originalSize.height; // find change in height
                            var newHeight = ui.originalSize.height + changeHeight / _scale; // adjust new height by our zoomScale

                            ui.size.width = newWidth;
                            ui.size.height = newHeight;
                        }
                        ,stop: function(){
                            positionChangeEventHandler($(this).attr("targetId"),'update');
                        }
                    });
                }

                if(_options['custom']['draggable']){
                    var pointerY, pointerX, canvasOffset;
                    targetElement.draggable({
                        cursor: "move"
                        ,containment: "parent"
                        ,start : function(evt, ui) {
                            canvasOffset = _element.offset();
                            pointerY = (evt.pageY - canvasOffset.top) / _scale - parseInt($(evt.target).css('top'));
                            pointerX = (evt.pageX - canvasOffset.left) / _scale - parseInt($(evt.target).css('left'));
                        }
                        ,drag : function(evt, ui) {
                            ui.position.top = Math.round((evt.pageY - canvasOffset.top) / _scale - pointerY);
                            ui.position.left = Math.round((evt.pageX - canvasOffset.left) / _scale - pointerX);
                        }
                        ,stop: function(){
                            positionChangeEventHandler($(this).attr("targetId"),'update');
                        }
                    });
                }

                if(_options['custom']['nameView'] && data["targetName"]!=null && data["targetName"]!=''){
                    targetElement.append( $("<span/>").text(data["targetName"]) );
                }

                _element.append(targetElement);
                _marker[_MARKER_TYPE[4]][data['targetId']] = {
                    'data' : {
                        'targetId' : data['targetId']
                        ,'deviceCode' : data['deviceCode']
                        ,'x1' : data['useYn']?data['x1']:targetElement.position()['left']+(_element.width()/2)
                        ,'x2' : data['useYn']?data['x2']:_element.width()-targetElement.position()['left']-(_element.width()/2)-(targetElement.width()/2)
                        ,'y1' : data['useYn']?data['y1']:targetElement.position()['top']+(_element.height()/2)
                        ,'y2' : data['useYn']?data['y2']:_element.height()-targetElement.position()['top']-(_element.height()/2)-(targetElement.height()/2)
                        ,'useYn' : data['useYn']
                    }
                    ,'element' : targetElement
                };

                positionChangeEventHandler(data['targetId'],'init');
            }else{
                positionChangeEventHandler(data['targetId']);
            }

            if(_options['custom']['websocketSend']){
                webSocketHelper.sendMessage("device",{"messageType":"getDevice","areaId":_areaId,"deviceId":data['targetId'],"ipAddress":''});
            }
        };

        /**
         * Add Marker (object, fence)
         * @author psb
         */
        this.addMarker = function(messageType, data){
            if(data['id']==null || data['location']==null){
                console.error("[CustomMapMediator][addMarker] parameter not enough");
                return false;
            }
            if(data['deviceId']==null || _marker[_MARKER_TYPE[4]][data['deviceId']]==null){
                console.error("[CustomMapMediator][addMarker] target M8 device is null - deviceId : " + data['deviceId']);
                return false;
            }
            if(_marker[messageType]!=null && _marker[messageType][data['id']]!=null){
                _self.saveMarker(messageType, data);
                return false;
            }

            try{
                switch (messageType){
                    case _MARKER_TYPE[1] : // Fence
                        var points = [];
                        var latMin=null,latMax=null,lngMin=null,lngMax=null;
                        for(var index in data['location']){
                            var lat = toRound(Number(_marker[_MARKER_TYPE[4]][data['deviceId']]['data']['translate']['x'])+Number(data['location'][index]['lat']),2);
                            var lng = toRound(Number(_marker[_MARKER_TYPE[4]][data['deviceId']]['data']['translate']['y'])+Number(data['location'][index]['lng']),2);
                            if(latMin==null || latMin > lat){ latMin = lat; }
                            if(latMax==null || latMax < lat){ latMax = lat; }
                            if(lngMin==null || lngMin > lng){ lngMin = lng; }
                            if(lngMax==null || lngMax < lng){ lngMax = lng; }
                            points.push([lat,lng]);
                        }

                        if(_fenceSvg==null){
                            console.error("[CustomMapMediator][addMarker] fence svg is not init - fenceId :" + data['id']);
                            return false;
                        }
                        _fenceSvg.polygon(points, {fenceId:data['id']});
                        _fenceSvg.text(latMin+((latMax-latMin)/2),lngMin+((lngMax-lngMin)/2),data['fenceName']?data['fenceName']:data['id'], $.extend({"fenceId":data['id']}, _options[_MARKER_TYPE[1]]['text']));

                        _marker[messageType][data['id']] = {
                            'element' : _element.find("polygon[fenceId='"+data['id']+"']")
                            ,'textElement' : _element.find("text[fenceId='"+data['id']+"']")
                            ,'data' : {
                                'location' : data['location']
                                ,'uuid' : data['uuid']
                                ,'deviceId' : data['deviceId']
                                ,'fenceName' : data['fenceName']?data['fenceName']:data['id']
                            }
                            ,'notification' : $.extend(true,{},criticalList)
                        };
                        break;
                    case _MARKER_TYPE[2] : // Object
                        _marker[messageType][data['id']] = $("<div/>",{objectId:data['id']}).addClass(_targetClass[messageType]);
                        _element.append(_marker[messageType][data['id']]);
                        _marker[messageType][data['id']].css("left",toRound(Number(_marker[_MARKER_TYPE[4]][data['deviceId']]['data']['translate']['x'])+Number(data['location'][0]['lat'])-(_marker[messageType][data['id']].width()/2),2));
                        _marker[messageType][data['id']].css("top",toRound(Number(_marker[_MARKER_TYPE[4]][data['deviceId']]['data']['translate']['y'])+Number(data['location'][0]['lng'])-_marker[messageType][data['id']].height(),2));
                        break;
                }
                console.log("[CustomMapMediator][addMarker] complete - [" + messageType + "][" + data['id'] + "]");
            }catch(e){
                console.error("[CustomMapMediator][addMarker] error- [" + messageType + "][" + data['id'] + "] - " + e.message);
            }
        };

        /**
         * save marker
         * @author psb
         */
        this.saveMarker = function(messageType, data){
            if(messageType==null || data['id']==null || data['location']==null){
                console.error("[CustomMapMediator][saveMarker] parameter not enough");
                return false;
            }

            switch (messageType){
                case _MARKER_TYPE[1] : // fence
                    if(_marker[messageType][data['id']]!=null){
                        _self.removeMarker(messageType, data);
                    }
                    _self.addMarker(messageType, data);
                    break;
                case _MARKER_TYPE[2] : // Object
                    if(_marker[messageType][data['id']]!=null){
                        if(data['location'] instanceof Array){
                            data['location'] = data['location'][0];
                        }
                        _marker[messageType][data['id']].css("left",toRound(Number(_marker[_MARKER_TYPE[4]][data['deviceId']]['data']['translate']['x'])+Number(data['location']['lat'])-(_marker[messageType][data['id']].width()/2),2));
                        _marker[messageType][data['id']].css("top",toRound(Number(_marker[_MARKER_TYPE[4]][data['deviceId']]['data']['translate']['y'])+Number(data['location']['lng'])-_marker[messageType][data['id']].height(),2));
                    }else{
                        _self.addMarker(messageType, data);
                    }
                    break;
            }
        };

        /**
         * remove marker
         * @author psb
         */
        this.removeMarker = function(messageType, data){
            if(messageType==null || data['id']==null){
                console.error("[CustomMapMediator][removeMarker] parameter not enough");
                return false;
            }

            switch (messageType){
                case _MARKER_TYPE[1] : // Fence
                    if(_marker[messageType][data['id']]!=null){
                        _marker[messageType][data['id']]['element'].remove();
                        _marker[messageType][data['id']]['textElement'].remove();
                        delete _marker[messageType][data['id']];
                        console.log("[CustomMapMediator][removeMarker] complete - [" + messageType + "][" + data['id'] + "]");
                    }
                    break;
                case _MARKER_TYPE[2] : // Object
                    if(_marker[messageType][data['id']]!=null){
                        _marker[messageType][data['id']].remove();
                        delete _marker[messageType][data['id']];
                        console.log("[CustomMapMediator][removeMarker] complete - [" + messageType + "][" + data['id'] + "]");
                    }
                    break;
            }
        };

        /**
         * 장치상태
         * @author psb
         */
        this.setDeviceStatusList = function(deviceStatusList){
            for(var index in deviceStatusList){
                var deviceStatus = deviceStatusList[index];
                var customMarker = _marker[_MARKER_TYPE[4]][deviceStatus['deviceId']];
                if(customMarker!=null){
                    setDeviceStatus(customMarker['element'], deviceStatus['deviceStat']);
                }
            }
        };

        /**
         * 장치상태
         * @author psb
         */
        var setDeviceStatus = function(targetElement, status){
            if(status=='Y'){
                targetElement.removeClass('level-die');
            }else{
                targetElement.addClass('level-die');
            }
        };

        /**
         * animation
         * @author psb
         */
        this.setAnimate = function(actionType, criticalLevel, data){
            if(data['deviceId']==null || data['fenceId']==null || data['objectId']==null){
                return false;
            }

            var fenceMarker = _self.getMarker(_MARKER_TYPE[1], data['fenceId']);
            if(fenceMarker!=null){
                switch (actionType){
                    case "add" :
                        fenceMarker['notification'][criticalLevel].push(data['objectId']);
                        break;
                    case "remove" :
                        if(fenceMarker['notification'][criticalLevel].indexOf(data['objectId']) > -1){
                            fenceMarker['notification'][criticalLevel].splice(fenceMarker['notification'][criticalLevel].indexOf(data['objectId']),1);
                        }
                        break;
                }

                for(var index in fenceMarker['notification']){
                    if(fenceMarker['notification'][index].length > 0){
                        fenceMarker['element'].addClass("level-"+criticalCss[index]);
                    }else{
                        fenceMarker['element'].removeClass("level-"+criticalCss[index]);
                    }
                }
            }else{
                console.warn("[CustomMapMediator][setAnimate] not found fence marker or child object - fenceId : " + data['fenceId'] + ", objectId : " + data['objectId']);
            }

            var objectMarker = _self.getMarker(_MARKER_TYPE[2], data['objectId']);
            if(objectMarker!=null){
                switch (actionType){
                    case "add" :
                        objectMarker.addClass("level-"+criticalCss[criticalLevel]);
                        break;
                    case "remove" :
                        objectMarker.removeClass("level-"+criticalCss[criticalLevel]);
                        break;
                }
            }else{
                console.warn("[CustomMapMediator][setAnimate] not found object marker - objectId : " + data['objectId']);
            }
        };

        /**
         * get marker
         * @author psb
         */
        this.getMarker = function(messageType, id){
            switch (messageType){
                case _MARKER_TYPE[1] : // Fence
                case _MARKER_TYPE[2] : // Object
                    if(_marker[messageType][id]!=null){
                        return _marker[messageType][id];
                    }
                    break;
                case "all" : // Object
                    return _marker;
                    break;
            }
            return null;
        };

        /**
         * set message config
         * @author psb
         */
        this.setMessageConfig = function(messageConfig){
            _messageConfig = messageConfig;
        };

        /**
         * get custom area/device list
         * @author psb
         */
        this.init = function(areaId,options){
            _areaId = areaId;
            for(var index in options){
                if(_options['custom'].hasOwnProperty(index)){
                    _options['custom'][index] = options[index];
                }
            }
            _ajaxCall('list',{areaId:_areaId});
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
                case 'list':
                    if(_options['custom']['onLoad']!=null && typeof _options['custom']['onLoad'] == "function"){
                        _options['custom']['onLoad']('childList',data['childList']);
                    }

                    var childList = data['childList'];
                    for(var index in childList){
                        if(_options['custom']['allView'] || childList[index]['useYn']=='Y'){
                            _self.targetRender(childList[index]);
                        }
                    }
                    _fileUploadPath = data['fileUploadPath'];
                    _self.setBackgroundImage(data['area']['physicalFileName']);
                    break;
                case 'fenceList':
                    if(_options['custom']['onLoad']!=null && typeof _options['custom']['onLoad'] == "function"){
                        _options['custom']['onLoad']('fenceList',data['fenceList'],data['paramBean']);
                    }

                    var fenceList = data['fenceList'];
                    for(var index in fenceList){
                        var fence = fenceList[index];
                        fence['id'] = fence['fenceId'];
                        fence['fenceName'] = fence['fenceName']!=null?fence['fenceName']:fence['fenceId'];
                        fence['deviceId'] = data['paramBean']['deviceId'];
                        _self.saveMarker(_MARKER_TYPE[1], fence);
                    }
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

        var validateLat = function( jsonData ) {
            if(jsonData instanceof Array){
                for(var key in jsonData) {
                    for(var i in jsonData[key]) {
                        if( typeof jsonData[key][i] === 'object' || typeof jsonData[key][i] === 'array' ) {
                            jsonData[key][i] = typeCheck( jsonData[key][i] );
                        } else {
                            if( /^(0|[1-9][0-9].*)$/.test( jsonData[key][i] ) ) {
                                jsonData[key][i] = Number( jsonData[key][i] );
                            }
                        }
                    }
                }
            }else{
                for(var key in jsonData) {
                    if( typeof jsonData[key] === 'object' || typeof jsonData[key] === 'array' ) {
                        jsonData[key] = typeCheck( jsonData[key] );
                    } else {
                        if( /^(0|[1-9][0-9].*)$/.test( jsonData[key] ) ) {
                            jsonData[key] = Number( jsonData[key] );
                        }
                    }
                }
            }
            return jsonData;
        };

        _initialize(rootPath, version);
    }
);