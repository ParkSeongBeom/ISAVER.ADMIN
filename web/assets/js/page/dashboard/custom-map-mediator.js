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
        var MARKER_TYPE = ['device','fence','object','camera','custom'];
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
                    , 'font-size': "10px"
                }
            }
            ,'custom' : {
                'draggable': false // 드래그 기능
                , 'resizable': false // 사이즈 조절 기능
                , 'nameView': true // 이름 표시 여부
                , 'websocketSend': false // getdevice 요청 여부
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
        var _translate = null;
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
            if(_marker[MARKER_TYPE[4]][targetId]==null){
                return false;
            }

            if(flag){
                _element.find(".on").removeClass("on");
                _marker[MARKER_TYPE[4]][targetId]['data']['useYn'] = 'Y';
                _marker[MARKER_TYPE[4]][targetId]['element'].addClass("on").show();
                return true;
            }else{
                _marker[MARKER_TYPE[4]][targetId]['data']['useYn'] = 'N';
                _marker[MARKER_TYPE[4]][targetId]['element'].hide();
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
            if(MARKER_TYPE.indexOf(type) < 0){
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
            if(_marker[MARKER_TYPE[4]][targetId]==null){
                console.error("[CustomMapMediator][setTargetData] targetId is null or empty - "+targetId);
                return false;
            }

            var targetElement = _marker[MARKER_TYPE[4]][targetId]['element'];
            var targetData = _marker[MARKER_TYPE[4]][targetId]['data'];

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
        var positionChangeEventHandler = function(_id, _actionType){
            if(_marker[MARKER_TYPE[4]][_id]==null){
                console.error("[CustomMapMediator][positionChangeEventHandler] id is null or empty - "+_id);
                return false;
            }

            var targetElement = _marker[MARKER_TYPE[4]][_id]['element'];
            var targetData = _marker[MARKER_TYPE[4]][_id]['data'];

            switch (_actionType){
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
        var setTranslate = function (data, targetElement){
            if(data['deviceCode']=='DEV013'){
                _translate = {
                    'x' : parseInt(targetElement.css("left")) + targetElement.width()/2
                    ,'y' : parseInt(targetElement.css("top")) + targetElement.height()/2
                };
                for(var index in _marker[MARKER_TYPE[1]]){
                    _self.saveFence(index);
                }
            }
        };

        /**
         * save fence name
         * @author psb
         */
        this.saveFence = function(_id, _name){
            if(_marker[MARKER_TYPE[1]]!=null && _marker[MARKER_TYPE[1]][_id]!=null){
                _self.saveMarker(MARKER_TYPE[1], _id, _marker[MARKER_TYPE[1]][_id]['data']['lat'], {uuid:_marker[MARKER_TYPE[1]][_id]['data']['uuid'],'fenceName':_name!=null?_name:_marker[MARKER_TYPE[1]][_id]['data']['fenceName']});
            }
        };

        /**
         * 구역/장치 단건 Render
         * @author psb
         */
        this.targetRender = function(data){
            if(_marker[MARKER_TYPE[4]][data['targetId']]==null){
                var targetElement = $("<div/>",{targetId:data['targetId'],deviceCode:data['deviceCode']}).addClass(_targetClass[data['deviceCode']]);
                targetElement.on("click",function(){
                    if(_options['custom']['click']!=null && typeof _options['custom']['click'] == "function"){
                        _options['custom']['click']($(this).attr("targetId"),$(this).attr("deviceCode"));
                    }else{
                        positionChangeEventHandler($(this).attr("targetId"));
                    }
                });

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
                _marker[MARKER_TYPE[4]][data['targetId']] = {
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
        this.addMarker = function(_type, _id, _lat, _data){
            if(_id==null || _lat==null){
                console.error("[CustomMapMediator][addMarker] parameter not enough");
                return false;
            }
            if(_marker[_type]!=null && _marker[_type][_id]!=null){
                _self.saveMarker(_type, _id, _lat);
                return false;
            }

            try{
                switch (_type){
                    case MARKER_TYPE[1] : // Fence
                        var points = [];
                        for(var index in _lat){
                            points.push([toRound(Number(_translate['x'])+Number(_lat[index]['lat']),2),toRound(Number(_translate['y'])+Number(_lat[index]['lng']),2)]);
                        }

                        if(_fenceSvg==null){
                            console.error("[CustomMapMediator][addMarker] fence svg is not init - fenceId :" + _id);
                            return false;
                        }
                        _fenceSvg.polygon(points, {fenceId:_id});
                        _fenceSvg.text(points[0][0],points[0][1],_data['fenceName'], $.extend({"fenceId":_id}, _options[MARKER_TYPE[1]]['text']));

                        _marker[_type][_id] = {
                            'element' : _element.find("polygon[fenceId='"+_id+"']")
                            ,'textElement' : _element.find("text[fenceId='"+_id+"']")
                            ,'data' : {
                                'lat' : _lat
                                ,'uuid' : _data['uuid']
                                ,'fenceName' : _data['fenceName']
                            }
                            ,'objects' : []
                        };
                        break;
                    case MARKER_TYPE[2] : // Object
                        _marker[_type][_id] = $("<div/>",{objectId:_id}).addClass(_targetClass[_type]);
                        _element.append(_marker[_type][_id]);
                        _marker[_type][_id].css("left",toRound(Number(_translate['x'])+Number(_lat[0]['lat'])-(_marker[_type][_id].width()/2),2));
                        _marker[_type][_id].css("top",toRound(Number(_translate['y'])+Number(_lat[0]['lng'])-(_marker[_type][_id].height()/2),2));
                        break;
                }
                console.log("[CustomMapMediator][addMarker] complete - [" + _type + "][" + _id + "]");
            }catch(e){
                console.error("[CustomMapMediator][addMarker] error- [" + _type + "][" + _id + "] - " + e.message);
            }
        };

        /**
         * save marker
         * @author psb
         */
        this.saveMarker = function(_type, _id, _lat, _data){
            if(_type==null || _id==null || _lat==null){
                console.error("[CustomMapMediator][saveMarker] parameter not enough");
                return false;
            }

            switch (_type){
                case MARKER_TYPE[1] : // fence
                    if(_marker[_type][_id]!=null){
                        _self.removeMarker(_type, _id, _lat);
                    }
                    _self.addMarker(_type, _id, _lat, _data);
                    break;
                case MARKER_TYPE[2] : // Object
                    if(_marker[_type][_id]!=null){
                        if(_lat instanceof Array){
                            _lat = _lat[0];
                        }
                        _marker[_type][_id].css("left",toRound(Number(_translate['x'])+Number(_lat['lat'])-(_marker[_type][_id].width()/2),2));
                        _marker[_type][_id].css("top",toRound(Number(_translate['y'])+Number(_lat['lng'])-(_marker[_type][_id].height()/2),2));
                    }else{
                        _self.addMarker(_type, _id, _lat);
                    }
                    break;
            }
        };

        /**
         * remove marker
         * @author psb
         */
        this.removeMarker = function(_type, _id){
            if(_type==null || _id==null){
                console.error("[CustomMapMediator][removeMarker] parameter not enough");
                return false;
            }

            switch (_type){
                case MARKER_TYPE[1] : // Fence
                case MARKER_TYPE[2] : // Object
                    if(_marker[_type][_id]!=null){
                        if(_marker[_type][_id].hasOwnProperty('element')){
                            _marker[_type][_id]['element'].remove();
                        }else{
                            _marker[_type][_id].remove();
                        }
                        if(_marker[_type][_id].hasOwnProperty('textElement')){
                            _marker[_type][_id]['textElement'].remove();
                        }
                        delete _marker[_type][_id];
                        console.log("[CustomMapMediator][removeMarker] complete - [" + _type + "][" + _id + "]");
                    }
                    break;
            }
        };

        /**
         * animation
         * @author psb
         */
        this.setAnimate = function(_deviceId, _fenceId, _objectId, _action, _className){
            var fenceMarker = _self.getMarker(MARKER_TYPE[1], _fenceId);
            if(fenceMarker!=null && fenceMarker['objects'] instanceof Array){
                switch (_action){
                    case "add" :
                        if(fenceMarker['objects'].length == 0 || fenceMarker['objects'].indexOf(_objectId)==-1){
                            fenceMarker['objects'].push(_objectId);
                        }
                        break;
                    case "remove" :
                        if(fenceMarker['objects'].indexOf(_objectId) > -1){
                            fenceMarker['objects'].splice(fenceMarker['objects'].indexOf(_objectId),1);
                        }
                        break;
                }

                if(fenceMarker['objects'].length>0){
                    _marker[MARKER_TYPE[1]][_fenceId]['element'].addClass(_className);
                }else{
                    _marker[MARKER_TYPE[1]][_fenceId]['element'].removeClass(_className);
                }
            }else{
                console.warn("[CustomMapMediator][setAnimate] not found fence marker or child object - fenceId : " + _fenceId + ", objectId : " + _objectId);
            }

            var objectMarker = _self.getMarker(MARKER_TYPE[2], _objectId);
            if(objectMarker!=null){
                switch (_action){
                    case "add" :
                        objectMarker.addClass(_className);
                        break;
                    case "remove" :
                        objectMarker.removeClass(_className);
                        break;
                }
            }else{
                console.warn("[CustomMapMediator][setAnimate] not found object marker - objectId : " + _objectId);
            }
        };

        /**
         * get marker
         * @author psb
         */
        this.getMarker = function(_type, _id){
            switch (_type){
                case MARKER_TYPE[1] : // Fence
                case MARKER_TYPE[2] : // Object
                    if(_marker[_type][_id]!=null){
                        return _marker[_type][_id];
                    }
                    break;
                case "all" : // Object
                    return _marker;
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
                    }else{
                        var childList = data['childList'];
                        for(var index in childList){
                            if(childList[index]['useYn']=='Y'){
                                _self.targetRender(childList[index]);
                            }
                        }
                    }
                    _fileUploadPath = data['fileUploadPath'];
                    _self.setBackgroundImage(data['area']['physicalFileName']);

                    if(_options['custom']['fenceView']){
                        _ajaxCall('fenceList',{areaId:_areaId});
                    }
                    break;
                case 'fenceList':
                    if(_options['custom']['onLoad']!=null && typeof _options['custom']['onLoad'] == "function"){
                        _options['custom']['onLoad']('fenceList',data['fenceList']);
                    }else{
                        var fenceList = data['fenceList'];
                        for(var index in fenceList){
                            var fence = fenceList[index];
                            _self.saveMarker(MARKER_TYPE[1], fence['fenceId'], fence['locations'], {uuid:fence['uuid'],'fenceName':fence['fenceName']!=null?fence['fenceName']:fence['fenceId']});
                        }
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