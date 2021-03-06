﻿/**
 * Map Mediator
 * - 맵 관련 이벤트 및 데이터를 처리한다. (오프라인 맵)
 * - 구역과 1:1 매칭
 *
 * @author psb
 * @type {Function}
 */
var CustomMapMediator = (
    function(rootPath){
        var _rootPath;
        var _areaId;
        var _urlConfig = {
            listUrl : "/customMapLocation/list.json"
            ,fenceListUrl : "/fence/list.json"
        };
        var _MARKER_TYPE = ['device','fence','object','camera','custom'];
        var _OBJECT_TYPE = [
            'unknown','unknown-LEV001','unknown-LEV002','unknown-LEV003'
            ,'human','human-LEV001','human-LEV002','human-LEV003'
            ,'vehicle','vehicle-LEV001','vehicle-LEV002','vehicle-LEV003'
        ];
        var _FENCE_TYPE = ['normal','ignore','section','camera'];
        var _marker = {
            'fence' : {}
            ,'object' : {}
            ,'custom' : {}
        };
        // 환경설정에 따라 사람 <-> 오브젝트로 전환
        var _OBJECT_TYPE_CUSTOM = {
            'human' : 'human'
            ,'unknown' : 'unknown'
            ,'vehicle' : 'vehicle'
            ,'heatmap' : 'heatmap'
        };
        var _defsMarkerRef = {
            'unknown' : '/assets/images/ico/sico_39.svg'
            ,'unknown-LEV001' : '/assets/images/ico/sico_39_cau.svg'
            ,'unknown-LEV002' : '/assets/images/ico/sico_39_war.svg'
            ,'unknown-LEV003' : '/assets/images/ico/sico_39_dan.svg'
            ,'human' : '/assets/images/ico/sico_81.svg'
            ,'human-LEV001' : '/assets/images/ico/sico_81_cau.svg'
            ,'human-LEV002' : '/assets/images/ico/sico_81_war.svg'
            ,'human-LEV003' : '/assets/images/ico/sico_81_dan.svg'
            ,'vehicle' : '/assets/images/ico/sico_141.svg'
            ,'vehicle-LEV001' : '/assets/images/ico/sico_141_cau.svg'
            ,'vehicle-LEV002' : '/assets/images/ico/sico_141_war.svg'
            ,'vehicle-LEV003' : '/assets/images/ico/sico_141_dan.svg'
        };
        var _angleCss = ['deg10','deg15','deg20','deg25','deg30','deg35','deg40','deg45','deg50'];
        let _mouseDownInterval = 0;
        var _options = {
            'element' : {
                'draggable': true // 드래그 기능
                ,'mousewheel': true // zoom in/out 기능
                ,'lastPositionUseFlag': false // 마지막에 머무른 값 사용여부
                ,'zoom' : {
                    'init' : 1
                    ,'min' : 0.01
                    ,'max' : 7.0
                    ,'def' : 0.02
                }
                ,'skewXIncrementValue': 1 // X 기울기 클릭시 증가치
                ,'skewYIncrementValue': 1 // Y 기울기 클릭시 증가치
                ,'rotateIncrementValue': 1 // 회전 클릭시 증가치
                ,'guardInfo' : true // 우측 펜스별 상세정보 사용여부
                ,'guardInfoCnt' : false // 우측 펜스별 상세정보에 인원수 카운팅 여부
            }
            ,'fence' : {
                'custom' :{
                    'text' : {
                        'text-anchor': "middle"
                        , 'fill': "rgb(255, 255, 255)"
                        , 'style': {
                            "font-size":"16px"
                        }
                    },
                    'polygon' : {
                        'fill': "rgb(246, 185, 0,0.2)"
                        , 'stroke': "rgb(246, 185, 0)"
                    },
                    'LEV001' : {
                        'fill': "rgb(210, 160, 30, 0.8)"
                        , 'stroke': "rgb(210,160,30)"
                    },
                    'LEV002' : {
                        'fill': "rgb(240, 100, 0, 0.8)"
                        , 'stroke': "rgb(240,100,0)"
                    },
                    'LEV003' : {
                        'fill': "rgba(195, 2, 2, 0.8)"
                        , 'stroke': "rgb(195,2,2)"
                    }
                }
                , 'cameraFenceUseFlag' : true // 카메라 전용 펜스 표출여부
                , 'animateFlag' : true // 이벤트 발생시 펜스 애니메이션 사용 여부
            }
            ,'object' : {
                'pointsHide' : false // 트래킹 이동경로 숨김여부
                ,'pointShiftCnt' : 80 // 트래킹 잔상 갯수 null일경우 무제한
                ,'speedFlag' : false // 트래킹 이동속도 표시여부
                ,'locationZFlag' : false // Z값 표시여부
                ,'speedFormat' : " km/h" // 트래킹 이동속도 포맷
                ,'locationZFormat' : " m" // Z값 표시 포맷
                ,'animateFlag' : true // 이벤트 발생시 오브젝트 애니메이션 사용 여부
                ,'humanOnly' : false // 사람만보기
            }
            ,'custom' : {
                'draggable': false // 드래그 기능
                , 'rotatable': false // 회전 조절 기능
                , 'resizable': false // 사이즈 조절 기능
                , 'nameView': true // 이름 표시 여부
                , 'websocketSend': false // getdevice 요청 여부
                , 'fenceView': false // fence 표시 여부
                , 'childListLoad': null // List load eventHandler
                , 'changeFence': null // fence change eventHandler
                , 'onLoad': null // List load eventHandler
                , 'change': null // drag or resize로 인한 수치값 변경시 eventHandler
                , 'changeConfig': null // 회전 / X축,Y축 기울기 eventHandler
                , 'click': null // click eventHandler
                , 'openLinkFlag': true // 클릭시 LinkUrl 사용 여부
                , 'moveFenceHide': true // 이벤트 발생시 펜스로 이동 숨김 기능
                , 'moveFenceScale': 3.0 // 이벤트 발생시 펜스 Zoom Size
                , 'moveReturn': true // 펜스로 이동 후 해당 펜스의 메인장치로 복귀 기능
                , 'moveReturnTimeout':null // 펜스로 이동 후 해당 펜스의 메인장치로 복귀
                , 'moveReturnDelay': 3000 // 메인장치로 복귀 딜레이
                , 'lidarHide': false // 라이다 반경표시 숨김 처리
                , 'ignoreHide': true // 무시영역 숨김 처리
                , 'trackingScale' : 'scale-20' // 트래킹 크기
                , 'animateFlag' : false // 이벤트 발생시 장치 애니메이션 사용 여부
                , 'childAnimateFlag' : false // 이벤트 발생시 장치 애니메이션 사용 여부(하위장치포함)
            }
        };
        var _viewOptions = {};
        var _targetClass = {
            'area' : "g-area"
            ,'object' : "g-tracking"
            ,'fence' : "g-fence"
            ,"DEV002" : "g-ico ico-camera"
            ,"DEV006" : "g-ico ico-led"
            ,"DEV007" : "g-ico ico-speaker"
            ,"DEV008" : "g-ico ico-wlight"
            ,"DEV013" : "g-ico ico-m8"
            ,"DEV015" : "g-ico ico-qguard"
            ,"DEV016" : "g-ico ico-server"
            ,"DEV017" : "g-ico ico-shock"
            ,"DEV019" : "g-ico ico-qguard"
            ,"DEV020" : "g-ico ico-m8"
            ,"DEV003" : "g-ico ico-server"
        };
        var _trackingScale = {
            'scale-20' : [
                {cx : 10,cy : 11,r : 8}
                ,{cx : 10,cy : 11,r : 11}
                ,{cx : 10,cy : 11,r : 16}
            ],
            'scale-30' : [
                {cx : 15,cy : 15,r : 15}
                ,{cx : 15,cy : 15,r : 20}
                ,{cx : 15,cy : 15,r : 25}
            ],
            'scale-40' : [
                {cx : 20,cy : 20,r : 20}
                ,{cx : 20,cy : 20,r : 25}
                ,{cx : 20,cy : 20,r : 30}
            ]
        };
        // 라이다 메인장치 코드
        var _mainDeviceCode = ['DEV013','DEV020'];
        // Map에 표출되는 장치코드
        var _customDeviceCode = ['DEV002','DEV006','DEV007','DEV008','DEV013','DEV016','DEV017','DEV020','DEV003'];

        // 비율 1m : 10px
        var _ratio=10;
        var _scale=_options['element']['zoom']['init'];
        var _canvasSize = {
            'width' : 5000
            ,'height' : 5000
        };
        let _mainDevices = [];
        let _top = null;
        let _left = null;
        let _originX = null;
        let _originY = null;
        let _translateX = 0;
        let _translateY = 0;
        let _rotate=0;
        let _skewX=0;
        let _skewY=0;
        let _element;
        let _copyBoxElement;
        let _mapCanvas;
        let _canvasSvg;
        let _fileUploadPath;
        let _messageConfig;
        let _initOptions;
        var _self = this;

        /**
         * initialize
         * @author psb
         * @param _canvas
         * @returns
         */
        var _initialize = function(rootPath){
            _rootPath = rootPath;
            for(var index in _urlConfig){
                _urlConfig[index] = _rootPath + _urlConfig[index];
            }

            for(var index in _defsMarkerRef){
                _defsMarkerRef[index] = _rootPath + _defsMarkerRef[index];
            }
        };

        /**
         * set message config
         * @author psb
         */
        this.setMessageConfig = function(messageConfig){
            _messageConfig = messageConfig;
        };

        this.getRatio = function(){
            return _ratio;
        };

        this.getImagePoint = function(width, height, cutX, cutY){
            if(width==null || height==null){
                console.error("width or height is null - width : "+width+", heigth : "+height);
                return false;
            }
            var marginWidth = (_canvasSize['width']-width)/2;
            var marginHeight = (_canvasSize['height']-height)/2;

            for(var index in _mainDevices){
                var targetData = _marker[_MARKER_TYPE[4]][_mainDevices[index]]['data'];
                console.log({
                    deviceId : _mainDevices[index]
                    ,sensor_x : (targetData['translate']['x']-marginWidth-(cutX?cutX:0))/10
                    ,sensor_y : (targetData['translate']['y']-marginHeight-(cutY?cutY:0))/10
                    ,org_sensor_x : (targetData['translate']['x']-marginWidth)/10
                    ,org_sensor_y : (targetData['translate']['y']-marginHeight)/10
                });
            }
        };

        /**
         * get custom area/device list
         * @author psb
         */
        this.init = function(areaId,options){
            _areaId = areaId;
            _initOptions = options;
            _ajaxCall('list',{areaId:_areaId,deviceCodes:_customDeviceCode.toString()});
        };

        /**
         * set element
         * @author psb
         */
        this.setElement = function(element, canvas, copyBox){
            _element = element;
            _copyBoxElement = copyBox;
            _mapCanvas = canvas;
            _mapCanvas.empty();
            _mapCanvas.append($("<div/>",{"id":"drawElement","class":"g-angle"}));
            if(_mapCanvas.data('uiDraggable')){
                _mapCanvas.draggable('destroy');
            }
            _mapCanvas.off('mousewheel').removeAttr("style").removeAttr("scale");

            if(_options['element']['draggable']){
                var pointerY, pointerX, canvasOffset;
                _mapCanvas.draggable({
                    cursor: "move"
                    ,start : function(evt, ui) {
                        canvasOffset = _mapCanvas.offset();
                        pointerY = evt.pageY - (canvasOffset.top / _scale) - parseInt($(evt.target).css('top'));
                        pointerX = evt.pageX - (canvasOffset.left / _scale) - parseInt($(evt.target).css('left'));
                    }
                    ,drag : function(evt, ui) {
                        // Fix for zoom
                        ui.position.top = evt.pageY - (canvasOffset.top / _scale) - pointerY;
                        ui.position.left = evt.pageX - (canvasOffset.left / _scale) - pointerX;
                    }
                    ,stop : function(){
                        savePosition();
                    }
                });
            }

            if(_options['element']['mousewheel']){
                _mapCanvas.on("mousewheel",function(event) {
                    var offsetLeft = $(this).offset().left;
                    var offsetTop = $(this).offset().top;
                    // current cursor position on image
                    var imageX = (event.pageX - offsetLeft).toFixed(2);
                    var imageY = (event.pageY - offsetTop).toFixed(2);
                    // previous cursor position on image
                    var prevOrigX = (_originX*_scale).toFixed(2);
                    var prevOrigY = (_originY*_scale).toFixed(2);
                    // set origin to current cursor position
                    _originX = imageX/_scale;
                    _originY = imageY/_scale;
                    _translateX = _translateX + (imageX-prevOrigX)*(1-1/_scale);
                    _translateY = _translateY + (imageY-prevOrigY)*(1-1/_scale);

                    if(event.originalEvent.deltaY > 0){_self.startZoomControl('zoomOut');}
                    if(event.originalEvent.deltaY < 0){_self.startZoomControl('zoomIn');}
                });
            }

            _element.find(".view_size").remove();
            _mapCanvas.after(
                $("<div/>",{class:"view_size on"}).append(
                    $("<div/>",{class:"view_plus"}).append(
                        $("<button/>",{'href':'#'}).mousedown(function(){
                            _self.startZoomControl('zoomIn', true);
                        }).on("mouseup mouseout",function(){
                            _self.stopZoomControl();
                        })
                    )
                ).append(
                    $("<div/>",{class:"view_minus"}).append(
                        $("<button/>",{'href':'#'}).mousedown(function(){
                            _self.startZoomControl('zoomOut', true);
                        }).on("mouseup mouseout",function(){
                            _self.stopZoomControl();
                        })
                    )
                )
            )
        };

        /**
         * zoom control
         * @author psb
         */
        this.startZoomControl = function(actionType, continueFlag){
            switch (actionType){
                case "zoomIn" :
                    if(_scale.toFixed(2) < _options['element']['zoom']['max'] && _scale+_options['element']['zoom']['def'] < _options['element']['zoom']['max']){_scale+=_options['element']['zoom']['def'];}
                    break;
                case "zoomOut" :
                    if(_scale.toFixed(2) > _options['element']['zoom']['min'] && _scale-_options['element']['zoom']['def'] > _options['element']['zoom']['min']){_scale-=_options['element']['zoom']['def'];}
                    break;
            }
            setTransform2d(null,true);

            if(continueFlag!=null && continueFlag){
                _mouseDownInterval = setInterval(function(){
                    _self.startZoomControl(actionType);
                }, 30);
            }
        };

        this.stopZoomControl = function(){
            clearInterval(_mouseDownInterval);
        };

        var loadPosition = function(){
            if(_viewOptions!=null && _viewOptions.hasOwnProperty('mapCanvas')) {
                _top = _viewOptions['mapCanvas']['top'];
                _left = _viewOptions['mapCanvas']['left'];
                _originX = eval(_viewOptions['mapCanvas']['originX']);
                _originY = eval(_viewOptions['mapCanvas']['originY']);
                _translateX = eval(_viewOptions['mapCanvas']['translateX']);
                _translateY = eval(_viewOptions['mapCanvas']['translateY']);
                _scale = eval(_viewOptions['mapCanvas']['scale']);
            }
        };

        var loadViewOption = function(viewOptions){
            if(viewOptions!="" && viewOptions!=null) {
                try{
                    _viewOptions = JSON.parse(viewOptions);
                    for(var index in _viewOptions){
                        if(_options[_MARKER_TYPE[2]].hasOwnProperty(index)){
                            _options[_MARKER_TYPE[2]][index] = _viewOptions[index];
                        }else if(_options[_MARKER_TYPE[4]].hasOwnProperty(index)){
                            _options[_MARKER_TYPE[4]][index] = _viewOptions[index];
                        }
                    }
                }catch(e){
                    console.error("[loadViewOption] viewOptions parse error.");
                }
            }
            for(var i in _initOptions){
                if(_options.hasOwnProperty(i)){
                    for(var index in _initOptions[i]){
                        _options[i][index] = _initOptions[i][index];
                    }
                }
            }

            _element.find("input[name='humanCkb']").prop("checked",_options[_MARKER_TYPE[2]]['humanOnly']);
            _element.find("input[name='pointsCkb']").prop("checked",_options[_MARKER_TYPE[2]]['pointsHide']);
            _element.find("input[name='lidarCkb']").prop("checked",_options[_MARKER_TYPE[4]]['lidarHide']);
            _element.find("input[name='ignoreCkb']").prop("checked",_options[_MARKER_TYPE[4]]['ignoreHide']);
            _element.find("div[name='trackingScale']").addClass(_options[_MARKER_TYPE[4]]['trackingScale']);
            _element.find("input[name='moveFenceCkb']").prop("checked",_options[_MARKER_TYPE[4]]['moveFenceHide']);
            if(_options[_MARKER_TYPE[2]]['humanOnly']){
                _mapCanvas.addClass("onlyhuman");
            }
            if(_options['element']['lastPositionUseFlag']){
                loadPosition();
            }
        };

        this.getViewOption = function(){
            return _viewOptions;
        };

        var savePosition = function(){
            _viewOptions['mapCanvas'] = {
                'top' : _mapCanvas.css("top")
                ,'left' : _mapCanvas.css("left")
                ,'originX' : _originX.toFixed(10)
                ,'originY' : _originY.toFixed(10)
                ,'translateX' : _translateX.toFixed(1)
                ,'translateY' : _translateY.toFixed(1)
                ,'scale' : _scale.toFixed(2)
            };
        };

        var setTransform2d = function(scale,saveFlag){
            if(scale!=null){
                _scale = scale;
            }
            var orig = _originX.toFixed(10) + "px " + _originY.toFixed(10) + "px";
            var transform2d = "matrix(" + _scale.toFixed(2) + ",0,0," + _scale.toFixed(2) + "," + _translateX.toFixed(1) +"," + _translateY.toFixed(1) + ")";
            _mapCanvas.css({
                'transform':transform2d
                ,'-webkit-transform':transform2d
                ,'-moz-transform':transform2d
                ,'-o-transform':transform2d
                ,'-ms-transform':transform2d
                ,'transform-origin':orig
                ,'-webkit-transform-origin':orig
                ,'-moz-transform-origin':orig
                ,'-o-transform-origin':orig
                ,'-ms-transform-origin':orig
            });

            if(saveFlag){
                savePosition();
            }
        };

        this.getMapCanvas = function(){
            return _mapCanvas;
        };

        this.getCanvasSvg = function(){
            return _canvasSvg;
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
                _marker[_MARKER_TYPE[4]][targetId]['data']['useYn'] = 'Y';
                _marker[_MARKER_TYPE[4]][targetId]['element'].show();
            }else{
                _marker[_MARKER_TYPE[4]][targetId]['data']['useYn'] = 'N';
                _marker[_MARKER_TYPE[4]][targetId]['element'].hide();
            }
        };

        /**
         * set target display
         * @author psb
         */
        this.setSelectTarget = function(targetId){
            if(_marker[_MARKER_TYPE[4]][targetId]==null){
                return false;
            }
            _mapCanvas.find(".on").removeClass("on");
            _marker[_MARKER_TYPE[4]][targetId]['element'].addClass("on");
        };

        /**
         * set guard option
         * lidarHide : 라이다반경표시 on/off
         * humanOnly : 전체보기/사람만보기
         * ignoreHide : 무시영역표시 on/off
         * trackingScale : 트래킹 아이콘 크기
         * pointsHide : 트래킹 잔상 보기/숨기기
         * moveFenceHide : 이벤트 발생시 펜스로이동/이동안함
         * @author psb
         */
        this.setGuardOption = function(actionType, flag){
            if(_options[_MARKER_TYPE[2]].hasOwnProperty(actionType)){
                _options[_MARKER_TYPE[2]][actionType] = flag;
            }else if(_options[_MARKER_TYPE[4]].hasOwnProperty(actionType)){
                _options[_MARKER_TYPE[4]][actionType] = flag;
            }
            _viewOptions[actionType] = flag;

            switch (actionType){
                case "humanOnly" :
                    if(_options[_MARKER_TYPE[2]]['humanOnly']){
                        _mapCanvas.addClass("onlyhuman");
                    }else{
                        _mapCanvas.removeClass("onlyhuman");
                    }
                    break;
                case "lidarHide" :
                    if(_options[_MARKER_TYPE[4]]['lidarHide']){
                        _mapCanvas.find(".ico-m8").removeClass("lidar");
                    }else{
                        _mapCanvas.find(".ico-m8").addClass("lidar");
                    }
                    break;
                case "ignoreHide" :
                    _self.setIgnoreHide();
                    break;
                case "trackingScale" :
                    _self.setTrackingScale(flag);
                    break;
            }
        };

        /**
         * set icon image
         * @author psb
         */
        var setDefsMarkerRef = function(){
            if(_mapCanvas.find("#drawElement").data('svgwrapper')){
                _mapCanvas.find("#drawElement").svg('destroy');
            }
            // canvas svg initnone
            if($.fn.svg!=null){
                _mapCanvas.find("#drawElement").svg({
                    onLoad:function(svg){
                        _canvasSvg = svg;
                        let defs = _canvasSvg.defs();
                        for(let i in _OBJECT_TYPE){
                            let marker = _canvasSvg.marker(defs,_areaId+_OBJECT_TYPE[i],10,18,6,6,"0");
                            if(_trackingScale[_options[_MARKER_TYPE[4]]['trackingScale']]!=null){
                                for(var k in _trackingScale[_options[_MARKER_TYPE[4]]['trackingScale']]){
                                    let config = _trackingScale[_options[_MARKER_TYPE[4]]['trackingScale']][k];
                                    _canvasSvg.circle(marker,config['cx'],config['cy'],config['r'],{fill:"none"});
                                }
                            }
                            _canvasSvg.image(marker,null,null,null,null,_defsMarkerRef[_OBJECT_TYPE[i]]);
                        }

                        _canvasSvg.circle(_canvasSvg.marker(defs,'heatmap',10,18,6,6,"0"),10,11,6,{fill:"rgb(255, 0, 0,0.02)",style:"animation:none"});
                    }
                });
                _mapCanvas.find("svg").addClass("g-fence g-line "+_options[_MARKER_TYPE[4]]['trackingScale']);
            }
        };

        /**
         * set background image
         * @author psb
         */
        this.setBackgroundImage = function(physicalFileName,callBackFlag){
            if(_mapCanvas.find(".map_bg").length==0){
                _mapCanvas.append($("<div/>",{class:'map_bg'}))
            }

            if(physicalFileName!=null && physicalFileName!=""){
                _mapCanvas.find(".map_bg").css({"background-image":"url("+_fileUploadPath+physicalFileName+")"});
            }else{
                _mapCanvas.find(".map_bg").css({"background-image":""});
            }

            if(callBackFlag && _options[_MARKER_TYPE[4]]['changeConfig']!=null && typeof _options[_MARKER_TYPE[4]]['changeConfig'] == "function"){
                _options[_MARKER_TYPE[4]]['changeConfig']("fileId",physicalFileName);
            }
        };

        /**
         * set background image
         * @author psb
         */
        this.setAngleXClass = function(angleClass,callBackFlag){
            for(var index in _angleCss){
                _mapCanvas.find("#drawElement").removeClass(_angleCss[index]);
            }

            if(angleClass!=null && angleClass!=""){
                _mapCanvas.find("#drawElement").addClass(angleClass);
            }

            if(callBackFlag && _options[_MARKER_TYPE[4]]['changeConfig']!=null && typeof _options[_MARKER_TYPE[4]]['changeConfig'] == "function"){
                _options[_MARKER_TYPE[4]]['changeConfig']("angleClass",angleClass);
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

            switch (type){
                case _MARKER_TYPE[1] :
                    for(var deviceId in _marker[type]){
                        for(var fenceId in _marker[type][deviceId]){
                            _self.computePolyPoints({deviceId:deviceId, id:fenceId});
                        }
                    }
                    break;
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
            let targetData = $.extend(true,_marker[_MARKER_TYPE[4]][targetId]['data'],data);

            targetElement.css("left",targetData['x1']);
            targetElement.css("width",_mapCanvas.width()-targetData['x1']-targetData['x2']);
            targetElement.css("top",targetData['y1']);
            targetElement.css("height",_mapCanvas.height()-targetData['y1']-targetData['y2']);

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
                    targetElement.outerWidth(_mapCanvas.width()-targetData['x1']-targetData['x2']);
                    targetElement.css("top",targetData['y1']);
                    targetElement.outerHeight(_mapCanvas.height()-targetData['y1']-targetData['y2']);
                    break;
                case 'update':
                    targetData['x1'] = parseInt(targetElement.css("left"));
                    targetData['x2'] = _mapCanvas.width() - targetData['x1'] - targetElement.width();
                    targetData['y1'] = parseInt(targetElement.css("top"));
                    targetData['y2'] = _mapCanvas.height() - targetData['y1'] - targetElement.height();
                    break;
            }

            if(_options[_MARKER_TYPE[4]]['change']!=null && typeof _options[_MARKER_TYPE[4]]['change'] == "function"){
                _options[_MARKER_TYPE[4]]['change'](targetData);
            }

            setTranslate(targetData, targetElement);
        };

        /**
         * 기준 설정
         * 장치코드 DEV013(M8) DEV020(벨로다인)이고 메인여부가 Y일 경우 object, fence의 기준장치로 설정함
         * Custom-map-popup에서 m8장치 이동 및 사이즈 변경시 fence를 새로그림
         * @author psb
         */
        var setTranslate = function (targetData, targetElement){
            if(_mainDeviceCode.indexOf(targetData['deviceCode'])>-1 && targetData['mainFlag']=='Y'){
                // 펜스 갱신전에 회전값에 따른 계산 우선 수행
                if(targetData.hasOwnProperty("setFenceList")){
                    if(_marker[_MARKER_TYPE[1]][targetData['targetId']]!=null){
                        for(var fenceId in _marker[_MARKER_TYPE[1]][targetData['targetId']]){
                            _self.computePolyPoints({deviceId:targetData['targetId'], id:fenceId});
                        }
                    }
                }

                targetData['translate'] = {
                    'x' : parseInt(targetElement.css("left")) + parseInt(_canvasSize['width']-targetData['x1']-targetData['x2'])/2
                    ,'y' : parseInt(targetElement.css("top")) + parseInt(_canvasSize['height']-targetData['y1']-targetData['y2'])/2
                };

                if(targetData.hasOwnProperty("setFenceList")){
                    if(_marker[_MARKER_TYPE[1]][targetData['targetId']]!=null){
                        for(var fenceId in _marker[_MARKER_TYPE[1]][targetData['targetId']]){
                            _self.saveFence({deviceId:targetData['targetId'], id:fenceId});
                        }
                    }
                }else if(_options[_MARKER_TYPE[4]]['fenceView']){
                    targetData['setFenceList'] = true;
                    _marker[_MARKER_TYPE[1]][targetData['targetId']] = {};
                    _marker[_MARKER_TYPE[2]][targetData['targetId']] = {};

                    targetElement.on('dblclick', function(evt){
                        setTransform2d(_options['element']['zoom']['init'],true);
                        _mapCanvas.animate({
                            'top': parseInt(_mapCanvas.css('top'))-($(this).offset().top-_mapCanvas.parent().offset().top)+(_mapCanvas.parent().height()-$(this)[0].getBoundingClientRect().height)/2
                            ,'left': parseInt(_mapCanvas.css('left'))-($(this).offset().left-_mapCanvas.parent().offset().left)+(_mapCanvas.parent().width()-$(this)[0].getBoundingClientRect().width)/2
                        },300,savePosition);
                    });
                    var fenceParam = {
                        deviceId:targetData['targetId']
                    };
                    if(!_options['fence']['cameraFenceUseFlag']){
                        fenceParam['ignoreCamera'] = 'Y';
                    }
                    _ajaxCall('fenceList',fenceParam);
                }
            }
        };

        /**
         * save fence
         * @author psb
         */
        this.saveFence = function(data){
            if(_marker[_MARKER_TYPE[1]][data['deviceId']]!=null && _marker[_MARKER_TYPE[1]][data['deviceId']][data['id']]!=null){
                let fenceDataCopy = $.extend(true,{},_marker[_MARKER_TYPE[1]][data['deviceId']][data['id']]['data']);
                _self.addMarker(
                    _MARKER_TYPE[1]
                    , $.extend(true,fenceDataCopy,data)
                );
            }
        };

        /**
         * 구역/장치 단건 Render
         * @author psb
         */
        this.targetRender = function(data){
            if(_marker[_MARKER_TYPE[4]][data['targetId']]==null){
                var targetElement = $("<div/>",{targetId:data['targetId'],class:_targetClass[data['deviceCode']]});
                targetElement.on("click",function(){
                    if(_options[_MARKER_TYPE[4]]['click']!=null && typeof _options[_MARKER_TYPE[4]]['click'] == "function"){
                        _options[_MARKER_TYPE[4]]['click'](_marker[_MARKER_TYPE[4]][data['targetId']]['data']);
                    }else{
                        positionChangeEventHandler(data['targetId']);
                    }

                    var linkUrl = data['linkUrl'];
                    if(_options[_MARKER_TYPE[4]]['openLinkFlag'] && linkUrl!=null && linkUrl!=''){
                        openLink(linkUrl);
                    }
                });
                setDeviceStatus(targetElement, data['deviceStat']);

                if(_options[_MARKER_TYPE[4]]['resizable']){
                    targetElement.resizable({
                        containment: "parent"
                        ,aspectRatio:data['deviceCode'] != "area"
                        ,resize: function(evt, ui){
                            var changeWidth = ui.size.width - ui.originalSize.width; // find change in width
                            var newWidth = ui.originalSize.width + changeWidth / _scale; // adjust new width by our zoomScale

                            var changeHeight = ui.size.height - ui.originalSize.height; // find change in height
                            var newHeight = ui.originalSize.height + changeHeight / _scale; // adjust new height by our zoomScale

                            ui.size.width = newWidth;
                            ui.size.height = newHeight;
                        }
                        ,stop: function(){
                            positionChangeEventHandler(data['targetId'],'update');
                        }
                    });
                }

                if(_options[_MARKER_TYPE[4]]['draggable']){
                    var pointerY, pointerX, canvasOffset;
                    targetElement.draggable({
                        cursor: "move"
                        ,containment: "parent"
                        ,start : function(evt, ui) {
                            canvasOffset = _mapCanvas.offset();
                            pointerY = (evt.pageY - canvasOffset.top) / _scale - parseInt($(evt.target).css('top'));
                            pointerX = (evt.pageX - canvasOffset.left) / _scale - parseInt($(evt.target).css('left'));
                        }
                        ,drag : function(evt, ui) {
                            ui.position.top = (evt.pageY - canvasOffset.top) / _scale - pointerY;
                            ui.position.left = (evt.pageX - canvasOffset.left) / _scale - pointerX;
                        }
                        ,stop: function(){
                            positionChangeEventHandler(data['targetId'],'update');
                        }
                    });
                }

                if(_options[_MARKER_TYPE[4]]['nameView'] && data["targetName"]!=null && data["targetName"]!=''){
                    targetElement.append( $("<span/>").text(data["targetName"]) );
                }

                if(!_options[_MARKER_TYPE[4]]['lidarHide'] && _mainDeviceCode.indexOf(data['deviceCode'])>-1){
                    targetElement.addClass("lidar");
                }
                targetElement.append( $("<div/>") );

                _mapCanvas.find("#drawElement").append(targetElement);
                _marker[_MARKER_TYPE[4]][data['targetId']] = {
                    'data' : {
                        'targetId' : data['targetId']
                        ,'mainFlag' : data['mainFlag']
                        ,'deviceCode' : data['deviceCode']
                        ,'targetName' : data["targetName"]
                        ,'x1' : data['useYn']?data['x1']:(_canvasSize['width']/2)-(targetElement.width()/2)
                        ,'x2' : data['useYn']?data['x2']:(_canvasSize['width']/2)-(targetElement.width()/2)
                        ,'y1' : data['useYn']?data['y1']:(_canvasSize['height']/2)-(targetElement.height()/2)
                        ,'y2' : data['useYn']?data['y2']:(_canvasSize['height']/2)-(targetElement.height()/2)
                        ,'useYn' : data['useYn']?data['useYn']:"N"
                        ,'childDeviceList' : data['childDeviceList']
                    }
                    ,'element' : targetElement
                    ,'notification' : $.extend(true,{},criticalList)
                };

                if(data['useYn']==null || data['useYn']=='N'){
                    targetElement.hide();
                }
                positionChangeEventHandler(data['targetId'],'init');
            }else{
                positionChangeEventHandler(data['targetId']);
            }

            if(_options[_MARKER_TYPE[4]]['websocketSend']){
                webSocketHelper.sendMessage("device",{"messageType":"getDevice","areaId":_areaId,"deviceId":data['targetId'],"ipAddress":''});
            }
        };

        this.convertFenceLocationOrigin = function(deviceId, location){
            var points = [];
            for(var index in location){
                var lat = (location[index][0]-Number(_marker[_MARKER_TYPE[4]][deviceId]['data']['translate']['x']))/_ratio;
                var lng = (location[index][1]-Number(_marker[_MARKER_TYPE[4]][deviceId]['data']['translate']['y']))/_ratio;
                points.push({lat:lat,lng:lng});
            }
            return points;
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
                console.debug("[CustomMapMediator][addMarker] target M8 device is null - deviceId : " + data['deviceId']);
                return false;
            }
            if(_marker[messageType]==null){
                console.error("[CustomMapMediator][addMarker] unknown message type - messageType : " + messageType);
                return false;
            }
            if(_canvasSvg==null){
                console.warn("[CustomMapMediator][addMarker] canvas svg is not init - messageType : " + messageType + ",id :" + data['id']);
                return false;
            }

            try{
                switch (messageType){
                    case _MARKER_TYPE[1] : // Fence
                        let points = [];
                        let fenceName;
                        for(let index in data['location']){
                            let location = data['location'][index];
                            location['uuid'] = data['uuid'];
                            const lat = Number(_marker[_MARKER_TYPE[4]][data['deviceId']]['data']['translate']['x'])+(Number(location['lat'])*_ratio);
                            const lng = Number(_marker[_MARKER_TYPE[4]][data['deviceId']]['data']['translate']['y'])+(Number(location['lng'])*_ratio);
                            points.push([lat,lng]);
                        }

                        if(_marker[messageType][data['deviceId']][data['id']]!=null){
                            _marker[messageType][data['deviceId']][data['id']]['element'].attr("points",points.join(" "));
                            fenceName = data['fenceName']!=null?data['fenceName']:_marker[messageType][data['deviceId']][data['id']]['data']['fenceName'];
                            $.extend(true,_marker[messageType][data['deviceId']][data['id']]['data'],data);
                            _marker[messageType][data['deviceId']][data['id']]['data']['location'] = data['location'];
                        }else{
                            fenceName = data['fenceName']?data['fenceName']:data['id'];
                            const svgPolygon = _canvasSvg.polygon(points, {fenceId:data['id']});
                            let copyBoxElement = null;
                            if(_options['element']['guardInfo'] && _copyBoxElement!=null) {
                                copyBoxElement = $("<div/>",{class:'copybox'}).append(
                                    $("<p/>",{name:'detectText'})
                                );

                                if(_options['element']['guardInfoCnt']){
                                    copyBoxElement.append(
                                        $("<span/>",{name:'detectCnt'}).text(0)
                                    );
                                }
                                copyBoxElement.append(
                                    $("<em/>",{name:'fenceName'}).text(data['fenceName'])
                                ).append(
                                    $("<p/>",{name:'detectEventDatetime'})
                                );
                                _copyBoxElement.append(copyBoxElement);
                            }

                            _marker[messageType][data['deviceId']][data['id']] = {
                                'element' : $(svgPolygon)
                                ,'textElement' : null
                                ,'circleElement' : null
                                ,'polylineElement' : null
                                ,'copyBoxElement' : copyBoxElement
                                ,'data' : {
                                    'location' : data['location']
                                    ,'uuid' : data['uuid']
                                    ,'deviceId' : data['deviceId']
                                    ,'fenceType' : data['fenceType']
                                    ,'fenceSubType' : data['fenceSubType']
                                    ,'config' : (data['config']?data['config']:null)
                                    ,'fenceId' : data['id']
                                    ,'fenceName' : fenceName
                                    ,'custom' : data['custom']?data['custom']:$.extend(true,{},_options['fence']['custom'])
                                    ,'transX' : null
                                    ,'transY' : null
                                }
                                ,'notification' : $.extend(true,{},criticalList)
                            };

                            if(_options[_MARKER_TYPE[4]]['draggable']){
                                let pointerY, pointerX;
                                _marker[messageType][data['deviceId']][data['id']]['element'].draggable({
                                    cursor: "move"
                                    ,containment: "parent"
                                    ,start : function(evt, ui) {
                                        pointerY = evt.pageY;
                                        pointerX = evt.pageX;
                                    }
                                    ,drag : function(evt, ui) {
                                        _self.computePolyPoints({deviceId:data['deviceId'], id:data['id']});
                                        var locations = $(this).attr("points").split(" ");
                                        var transX = (Number(evt.pageX)-Number(pointerX))/_scale;
                                        var transY = (Number(evt.pageY)-Number(pointerY))/_scale;
                                        var pointList = [];
                                        for(let index in locations){
                                            const loc = locations[index].split(",");
                                            const lat = Number(loc[0])+transX;
                                            const lng = Number(loc[1])+transY;
                                            pointList.push([lat,lng]);
                                        }
                                        _self.saveFence({deviceId:data['deviceId'], id:data['id'], location:_self.convertFenceLocationOrigin(data['deviceId'],pointList)});
                                        pointerY = evt.pageY;
                                        pointerX = evt.pageX;
                                    }
                                });
                            }

                            _marker[messageType][data['deviceId']][data['id']]['element'].dblclick({deviceId:data['deviceId']}, function(evt){
                                setTransform2d(_options[_MARKER_TYPE[4]]['moveFenceScale'],false);
                                _mapCanvas.animate({
                                    'top': parseInt(_mapCanvas.css('top'))-($(this).offset().top-_mapCanvas.parent().offset().top)+(_mapCanvas.parent().height()-$(this)[0].getBoundingClientRect().height)/2
                                    ,'left': parseInt(_mapCanvas.css('left'))-($(this).offset().left-_mapCanvas.parent().offset().left)+(_mapCanvas.parent().width()-$(this)[0].getBoundingClientRect().width)/2
                                },300);
                                moveReturn(evt.data.deviceId);
                            });

                            if(_options[_MARKER_TYPE[4]]['changeFence']!=null && typeof _options[_MARKER_TYPE[4]]['changeFence'] == "function"){
                                _options[_MARKER_TYPE[4]]['changeFence']('add',_marker[messageType][data['deviceId']][data['id']]['data']);
                            }
                        }

                        setTimeout(function(){
                            _marker[messageType][data['deviceId']][data['id']]['element'].show();
                            var elRect = _marker[messageType][data['deviceId']][data['id']]['element'][0].getBoundingClientRect();
                            var svgRect = _mapCanvas.find("svg")[0].getBoundingClientRect();
                            var transX = ((elRect.left - svgRect.left) + (elRect.right - svgRect.left))/2/_scale;
                            var transY = ((elRect.top - svgRect.top) + (elRect.bottom - svgRect.top))/2/_scale;
                            _marker[messageType][data['deviceId']][data['id']]['data']['transX'] = transX;
                            _marker[messageType][data['deviceId']][data['id']]['data']['transY'] = transY;

                            if(_marker[messageType][data['deviceId']][data['id']]['polylineElement']!=null){ _marker[messageType][data['deviceId']][data['id']]['polylineElement'].remove(); }
                            if(_marker[messageType][data['deviceId']][data['id']]['circleElement']!=null){ _marker[messageType][data['deviceId']][data['id']]['circleElement'].remove(); }
                            if(_marker[messageType][data['deviceId']][data['id']]['textElement']!=null){ _marker[messageType][data['deviceId']][data['id']]['textElement'].remove(); }

                            if(_options[_MARKER_TYPE[4]]['rotatable']){
                                this.Left = (elRect.left - svgRect.left)/_scale - transX;
                                this.Right = (elRect.right - svgRect.left)/_scale - transX;
                                this.Top = (elRect.top - svgRect.top)/_scale - transY;
                                this.Bottom = (elRect.bottom - svgRect.top)/_scale - transY;
                                var transf = 'translate('+transX + ',' + transY+')';
                                var svgPolyline = _canvasSvg.polyline(
                                    [[this.Left,this.Top],[this.Right,this.Top],[this.Right,this.Bottom],[this.Left,this.Bottom],[this.Left,this.Top]]
                                    ,{"fill":'none',"stroke": "#f6b900",'stroke-dasharray': '5,5','transform':transf}
                                );
                                var svgCircle = _canvasSvg.circle(
                                    this.Left, this.Top, 3
                                    ,{"fill":'#f6b900',"cursor": "alias",'transform':transf}
                                );
                                var A = Math.atan2(elRect.height / 2, elRect.width / 2);
                                $(svgPolyline).prependTo(_mapCanvas.find("svg"));
                                _marker[messageType][data['deviceId']][data['id']]['polylineElement'] = $(svgPolyline);
                                _marker[messageType][data['deviceId']][data['id']]['circleElement'] = $(svgCircle);
                                _marker[messageType][data['deviceId']][data['id']]['circleElement'].draggable({
                                    cursor: "alias"
                                    ,containment: "parent"
                                    ,drag : function(evt, ui) {
                                        var polygon = _marker[messageType][data['deviceId']][data['id']]['element'];
                                        var _transX = _marker[messageType][data['deviceId']][data['id']]['data']['transX'];
                                        var _transY = _marker[messageType][data['deviceId']][data['id']]['data']['transY'];
                                        var _svgRect = _mapCanvas.find("svg")[0].getBoundingClientRect();
                                        var rotate = (Math.atan2(_transY - Math.round(evt.clientY - _svgRect.top)/_scale, _transX - Math.round(evt.clientX - _svgRect.left)/_scale) - A) * (180 / Math.PI);
                                        var _transf = 'translate(' + _transX + ',' + _transY + ') rotate(' + rotate + ')';
                                        if(!polygon[0].hasAttribute("transform")){
                                            var locations = polygon.attr("points").split(" ");
                                            var pointList = [];
                                            for(let index in locations){
                                                const loc = locations[index].split(",");
                                                const lat = Number(loc[0])-Number(_transX);
                                                const lng = Number(loc[1])-Number(_transY);
                                                pointList.push([lat,lng]);
                                            }
                                            _marker[messageType][data['deviceId']][data['id']]['element'].attr("points",pointList.join(" "));
                                        }
                                        _marker[messageType][data['deviceId']][data['id']]['element'][0].setAttributeNS(null,'transform',_transf);
                                        this.setAttributeNS(null, 'transform', _transf);
                                        $(svgPolyline)[0].setAttributeNS(null, 'transform', _transf);
                                    }
                                });
                            }

                            _marker[messageType][data['deviceId']][data['id']]['element'].css({
                                fill:_marker[messageType][data['deviceId']][data['id']]['data']['custom']['polygon']['fill']
                                ,stroke:_marker[messageType][data['deviceId']][data['id']]['data']['custom']['polygon']['stroke']
                            });

                            if(data['fenceType']==_FENCE_TYPE[1]){
                                _marker[messageType][data['deviceId']][data['id']]['element'].addClass('g-ignore_fence');
                            } else {
                                _marker[messageType][data['deviceId']][data['id']]['element'].removeClass('g-ignore_fence');
                                let textConfig = $.extend(true,{},_options[_MARKER_TYPE[1]]['custom']['text']);
                                $.extend(true,textConfig,_marker[messageType][data['deviceId']][data['id']]['data']['custom']['text']);
                                let styleText = '';
                                for(let key in textConfig['style']){
                                    styleText += key + ':' + textConfig['style'][key] + ';';
                                }
                                textConfig['style'] = styleText;
                                const svgText = _canvasSvg.text(transX, transY, fenceName, textConfig);
                                _marker[messageType][data['deviceId']][data['id']]['textElement'] = $(svgText);
                                //_mapCanvas.find("svg").append(svgText);
                                $(svgText).prependTo(_mapCanvas.find("svg"));
                            }

                            if(data['fenceType']==_FENCE_TYPE[1] && _options[_MARKER_TYPE[4]]['ignoreHide']){
                                if(_marker[_MARKER_TYPE[1]][data['deviceId']][data['id']]['element']!=null){ _marker[_MARKER_TYPE[1]][data['deviceId']][data['id']]['element'].hide(); }
                                if(_marker[_MARKER_TYPE[1]][data['deviceId']][data['id']]['circleElement']!=null){ _marker[_MARKER_TYPE[1]][data['deviceId']][data['id']]['circleElement'].hide(); }
                                if(_marker[_MARKER_TYPE[1]][data['deviceId']][data['id']]['polylineElement']!=null){ _marker[_MARKER_TYPE[1]][data['deviceId']][data['id']]['polylineElement'].hide(); }
                            }
                        },10);
                        console.debug("[CustomMapMediator][addMarker] fence complete - [" + messageType + "][" + data['id'] + "]");
                        break;
                    case _MARKER_TYPE[2] : // Object
                        if(_marker[messageType][data['deviceId']]==null){
                            return false;
                        }

                        let element;
                        let lastSpeed = null;
                        let lastLocationZ = null;
                        let lastPoint = null;

                        if(_marker[messageType][data['deviceId']][data['id']]!=null){
                            let points = [];

                            for(var index in data['location']){
                                let left = Number(_marker[_MARKER_TYPE[4]][data['deviceId']]['data']['translate']['x'])+(Number(toRound(data['location'][index]['lat'],2))*_ratio);
                                let top = Number(_marker[_MARKER_TYPE[4]][data['deviceId']]['data']['translate']['y'])+(Number(toRound(data['location'][index]['lng'],2))*_ratio);

                                if(data['location'][index]['speed']!=null){
                                    lastSpeed = toRound(data['location'][index]['speed'],1);
                                }
                                if(data['location'][index]['z']!=null){
                                    lastLocationZ = toRound(data['location'][index]['z'],1);
                                }
                                lastPoint = {lat:left,lng:top};
                                if(_options[_MARKER_TYPE[2]]['pointsHide']){
                                    points.push(left+","+top);
                                    _marker[messageType][data['deviceId']][data['id']]['points'] = points;
                                    break;
                                }else{
                                    points = _marker[messageType][data['deviceId']][data['id']]['points'];
                                    points.push(left+","+top);
                                    if(_options[_MARKER_TYPE[2]]['pointShiftCnt']!=null && points.length > _options[_MARKER_TYPE[2]]['pointShiftCnt']){
                                        points.shift();
                                    }
                                }
                            }
                            element = _marker[messageType][data['deviceId']][data['id']]['element'];

                            if(element.hasClass("level-"+criticalCss['LEV003'])){
                                element.attr("marker-end","url(#"+_areaId+_OBJECT_TYPE_CUSTOM[data['objectType']]+"-LEV003)");
                            }else if(element.hasClass("level-"+criticalCss['LEV002'])){
                                element.attr("marker-end","url(#"+_areaId+_OBJECT_TYPE_CUSTOM[data['objectType']]+"-LEV002)");
                            }else if(element.hasClass("level-"+criticalCss['LEV001'])){
                                element.attr("marker-end","url(#"+_areaId+_OBJECT_TYPE_CUSTOM[data['objectType']]+"-LEV001)");
                            }else{
                                element.attr("marker-end","url(#"+_areaId+_OBJECT_TYPE_CUSTOM[data['objectType']]+")");
                            }
                            element.attr("points",points.join(" "));
                        }else{
                            let points = [];
                            let polylinePoints = [];
                            for(var index in data['location']){
                                let left = Number(_marker[_MARKER_TYPE[4]][data['deviceId']]['data']['translate']['x'])+(Number(toRound(data['location'][index]['lat'],2))*_ratio);
                                let top = Number(_marker[_MARKER_TYPE[4]][data['deviceId']]['data']['translate']['y'])+(Number(toRound(data['location'][index]['lng'],2))*_ratio);

                                points.push(left+","+top);
                                polylinePoints.push([left,top]);

                                if(data['location'][index]['speed']!=null){
                                    lastSpeed = toRound(data['location'][index]['speed'],1);
                                }
                                if(data['location'][index]['z']!=null){
                                    lastLocationZ = toRound(data['location'][index]['z'],1);
                                }
                                lastPoint = {lat:left,lng:top};
                                if(_options[_MARKER_TYPE[2]]['pointsHide']){
                                    break;
                                }else{
                                    if(_options[_MARKER_TYPE[2]]['pointShiftCnt']!=null && points.length > _options[_MARKER_TYPE[2]]['pointShiftCnt']){
                                        points.shift();
                                    }
                                }
                            }
                            const polyline = _canvasSvg.polyline(polylinePoints,{'objectId':data['id'],'marker-end':"url(#"+_areaId+_OBJECT_TYPE_CUSTOM[data['objectType']]+")"});
                            element = $(polyline);
                            element.addClass(_targetClass[messageType]);
                            _marker[messageType][data['deviceId']][data['id']] = {
                                'element' : element
                                ,'textElement' : null
                                ,'points' : points
                            };
                        }

                        if(_options[_MARKER_TYPE[2]]['speedFlag'] && lastSpeed!=null && lastPoint!=null){
                            if(_marker[messageType][data['deviceId']][data['id']]['textElement']!=null){ _marker[messageType][data['deviceId']][data['id']]['textElement'].remove(); }
                            const svgText = _canvasSvg.text(lastPoint['lat']+8, lastPoint['lng'], lastSpeed+_options[_MARKER_TYPE[2]]['speedFormat'], {
                                'text-anchor': "start"
                                , 'fill': "rgb(0,0,255)"
                                , 'style': "font-size:8px"
                            });
                            _marker[messageType][data['deviceId']][data['id']]['textElement'] = $(svgText);
                            if(_OBJECT_TYPE_CUSTOM[data['objectType']]!='human'){
                                $(svgText).addClass('object');
                            }
                            _mapCanvas.find("svg").append(svgText);
                            //$(svgText).prependTo(_mapCanvas.find("svg"));
                        }

                        if(_options[_MARKER_TYPE[2]]['locationZFlag'] && lastLocationZ!=null && lastPoint!=null){
                            if(_marker[messageType][data['deviceId']][data['id']]['locationZElement']!=null){ _marker[messageType][data['deviceId']][data['id']]['locationZElement'].remove(); }
                            const svgText = _canvasSvg.text(lastPoint['lat']+8, lastPoint['lng']-8, lastLocationZ+_options[_MARKER_TYPE[2]]['locationZFormat'], {
                                'text-anchor': "start"
                                , 'fill': "rgb(0,255,0)"
                                , 'style': "font-size:8px"
                            });
                            _marker[messageType][data['deviceId']][data['id']]['locationZElement'] = $(svgText);
                            if(_OBJECT_TYPE_CUSTOM[data['objectType']]!='human'){
                                $(svgText).addClass('object');
                            }
                            _mapCanvas.find("svg").append(svgText);
                        }

                        if(data['objectType']=='heatmap'){
                            element.attr({"marker-start":"url(#heatmap)","marker-mid":"url(#heatmap)","style":"stroke:none"});
                        }

                        if(_OBJECT_TYPE_CUSTOM[data['objectType']]=='unknown'){
                            element.removeClass("vehicle");
                            element.addClass("object");
                        }else if(_OBJECT_TYPE_CUSTOM[data['objectType']]=='vehicle'){
                            element.removeClass("object");
                            element.addClass("vehicle");
                        }else{
                            element.removeClass("object");
                            element.removeClass("vehicle");
                        }
                        console.debug("[CustomMapMediator][addMarker] object complete - [" + messageType + "][" + data['id'] + "]");
                        break;
                }
            }catch(e){
                console.error("[CustomMapMediator][addMarker] error- [" + messageType + "][" + data['id'] + "] - " + e.message);
            }
        };

        this.computePolyPoints = function(data){
            var polygon = _marker[_MARKER_TYPE[1]][data['deviceId']][data['id']]['element'][0];
            if(polygon.hasAttribute("transform")){
                var sCTM = polygon.getCTM();
                var pointsList = polygon.points;
                var n = pointsList.numberOfItems;
                var points = [];
                for(var m=0;m<n;m++){
                    var mySVGPoint = _mapCanvas.find("svg")[0].createSVGPoint();
                    mySVGPoint.x = pointsList.getItem(m).x;
                    mySVGPoint.y = pointsList.getItem(m).y;
                    var mySVGPointTrans = mySVGPoint.matrixTransform(sCTM);
                    points.push([mySVGPointTrans.x,mySVGPointTrans.y])
                }
                //---force removal of transform--
                data['location'] = _self.convertFenceLocationOrigin(data['deviceId'],points);
                polygon.setAttribute("transform","");
                polygon.removeAttribute("transform");
                _self.saveFence(data);
                return true;
            }
            return false;
        };

        /**
         * fence partition (펜스 자르기 기능)
         * deviceId(String), fenceId(String), partition(가로:w, 세로:h -> {'w':?,'h':?})
         * @author psb
         */
        this.fencePartition = function(deviceId, fenceId, partition){
            if(_marker[_MARKER_TYPE[1]][deviceId][fenceId]==null){
                console.log("fence null");
                return false;
            }
            _self.computePolyPoints({deviceId:deviceId, id:fenceId});

            let locations = _marker[_MARKER_TYPE[1]][deviceId][fenceId]['data']['location'];
            let fenceName = _marker[_MARKER_TYPE[1]][deviceId][fenceId]['data']['fenceName']!=fenceId?_marker[_MARKER_TYPE[1]][deviceId][fenceId]['data']['fenceName']:null;
            let points = [];
            let lngs = [];
            for(let index in locations){
                let location = locations[index];
                const lat = Number(_marker[_MARKER_TYPE[4]][deviceId]['data']['translate']['x'])+(Number(location['lat'])*_ratio);
                const lng = Number(_marker[_MARKER_TYPE[4]][deviceId]['data']['translate']['y'])+(Number(location['lng'])*_ratio);
                points.push([lat,lng]);
                lngs.push(lng);
            }

            if(points.length!=4){
                _alertMessage("partitionValidate");
                return false;
            }

            var topLng = lngs.slice();
            topLng = topLng.sort((a,b) => a-b).slice(0,2);
            var positionIndex = {
                lt : null
                ,rt : null
                ,rb : null
                ,lb : null
            };

            var pointIndex = [];
            // Top Position 체크 y축이 가장위에 있는 2점을 상단으로함
            if(lngs.indexOf(topLng[0])==lngs.indexOf(topLng[1])){
                var idx = -1;
                do {
                    idx = lngs.indexOf(topLng[0],idx+1);
                    if(idx != -1)
                        pointIndex.push(idx);
                } while (idx != -1);
            }else{
                pointIndex.push(lngs.indexOf(topLng[0]));
                pointIndex.push(lngs.indexOf(topLng[1]));
            }

            if(points[pointIndex[0]][0]>points[pointIndex[1]][0]){
                positionIndex['lt'] = pointIndex[1];
                positionIndex['rt'] = pointIndex[0];
            }else{
                positionIndex['lt'] = pointIndex[0];
                positionIndex['rt'] = pointIndex[1];
            }

            if(positionIndex['lt']>positionIndex['rt']){
                if(positionIndex['lt']-positionIndex['rt']==1){
                    positionIndex['lb'] = positionIndex['lt']+1>3?0:positionIndex['lt']+1;
                    positionIndex['rb'] = positionIndex['lb']+1>3?0:positionIndex['lb']+1;
                }else{
                    positionIndex['lb'] = positionIndex['lt']-1<0?3:positionIndex['lt']-1;
                    positionIndex['rb'] = positionIndex['lb']-1<0?3:positionIndex['lb']-1;
                }
            }else{
                if(positionIndex['rt']-positionIndex['lt']==1){
                    positionIndex['lb'] = positionIndex['lt']-1<0?3:positionIndex['lt']-1;
                    positionIndex['rb'] = positionIndex['lb']-1<0?3:positionIndex['lb']-1;
                }else{
                    positionIndex['lb'] = positionIndex['lt']+1>3?0:positionIndex['lt']+1;
                    positionIndex['rb'] = positionIndex['lb']+1>3?0:positionIndex['lb']+1;
                }
            }

            var cutPoints = [];
            var topLatCut = (points[positionIndex['rt']][0]-points[positionIndex['lt']][0])/partition['w'];
            var topLngCut = (points[positionIndex['rt']][1]-points[positionIndex['lt']][1])/partition['w'];
            var bottomLatCut = (points[positionIndex['rb']][0]-points[positionIndex['lb']][0])/partition['w'];
            var bottomLngCut = (points[positionIndex['rb']][1]-points[positionIndex['lb']][1])/partition['w'];

            for(var i=1; i<=partition['w']; i++){
                var lt = [points[positionIndex['lt']][0], points[positionIndex['lt']][1]];
                var rt = [points[positionIndex['rt']][0], points[positionIndex['rt']][1]];
                var lb = [points[positionIndex['lb']][0], points[positionIndex['lb']][1]];
                var rb = [points[positionIndex['rb']][0], points[positionIndex['rb']][1]];

                lt[0] += topLatCut*(i-1);
                lt[1] += topLngCut*(i-1);
                rt[0] -= topLatCut*(partition['w']-i);
                rt[1] -= topLngCut*(partition['w']-i);
                lb[0] += bottomLatCut*(i-1);
                lb[1] += bottomLngCut*(i-1);
                rb[0] -= bottomLatCut*(partition['w']-i);
                rb[1] -= bottomLngCut*(partition['w']-i);

                var leftLatCut = (lb[0]-lt[0])/partition['h'];
                var leftLngCut = (lb[1]-lt[1])/partition['h'];
                var rightLatCut = (rb[0]-rt[0])/partition['h'];
                var rightLngCut = (rb[1]-rt[1])/partition['h'];

                for(var k=1; k<=partition['h']; k++){
                    var loc = [];
                    loc.push([lt[0]+leftLatCut*(k-1),lt[1]+leftLngCut*(k-1)]);
                    loc.push([lb[0]-leftLatCut*(partition['h']-k),lb[1]-leftLngCut*(partition['h']-k)]);
                    loc.push([rb[0]-rightLatCut*(partition['h']-k),rb[1]-rightLngCut*(partition['h']-k)]);
                    loc.push([rt[0]+rightLatCut*(k-1),rt[1]+rightLngCut*(k-1)]);
                    cutPoints.push(loc);
                }
            }
            for(var index in cutPoints){
                var _uuid = null;
                var _fenceId = null;

                if(index==0){
                    _uuid = _marker[_MARKER_TYPE[1]][deviceId][fenceId]['data']['uuid'];
                    _fenceId = fenceId;
                }else{
                    _uuid = uuid32();
                    _fenceId = uuid38();
                }
                let fenceDataCopy = $.extend(true,{},_marker[_MARKER_TYPE[1]][deviceId][fenceId]['data']);
                _self.addMarker('fence',$.extend(true,fenceDataCopy,{
                    "deviceId":deviceId
                    ,"uuid":_uuid
                    ,"id":_fenceId
                    ,"fenceName":fenceName==null?_fenceId:(index==0?fenceName:(fenceName+"_"+index))
                    ,"location":_self.convertFenceLocationOrigin(deviceId,cutPoints[index])
                }));
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
                case _MARKER_TYPE[2] : // Object
                    _self.addMarker(messageType, data);
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
                    if(_marker[messageType][data['deviceId']]!=null && _marker[messageType][data['deviceId']][data['id']]!=null){
                        if(_marker[messageType][data['deviceId']][data['id']]['element']!=null) _marker[messageType][data['deviceId']][data['id']]['element'].remove();
                        if(_marker[messageType][data['deviceId']][data['id']]['textElement']!=null) _marker[messageType][data['deviceId']][data['id']]['textElement'].remove();
                        if(_marker[messageType][data['deviceId']][data['id']]['circleElement']!=null) _marker[messageType][data['deviceId']][data['id']]['circleElement'].remove();
                        if(_marker[messageType][data['deviceId']][data['id']]['polylineElement']!=null) _marker[messageType][data['deviceId']][data['id']]['polylineElement'].remove();
                        if(_options[_MARKER_TYPE[4]]['changeFence']!=null && typeof _options[_MARKER_TYPE[4]]['changeFence'] == "function"){
                            _options[_MARKER_TYPE[4]]['changeFence']('remove',_marker[messageType][data['deviceId']][data['id']]['data']);
                        }
                        delete _marker[messageType][data['deviceId']][data['id']];
                        console.debug("[CustomMapMediator][removeMarker] fence complete - [" + messageType + "][" + data['id'] + "]");
                    }
                    break;
                case _MARKER_TYPE[2] : // Object
                    if(_marker[messageType][data['deviceId']]!=null && _marker[messageType][data['deviceId']][data['id']]!=null){
                        for(var marker in _marker[_MARKER_TYPE[1]][data['deviceId']]){
                            var fenceMarker = _marker[_MARKER_TYPE[1]][data['deviceId']][marker];
                            for(var index in criticalList){
                                if(fenceMarker['notification'][index].indexOf(data['id'])>-1){
                                    _self.setAnimate("remove",index,{
                                        deviceId:data['deviceId']
                                        ,objectId:data['id']
                                        ,objectType:data['objectType']
                                        ,fenceId:marker
                                    });
                                }
                            }
                        }
                        if(_marker[messageType][data['deviceId']][data['id']]['element']!=null) _marker[messageType][data['deviceId']][data['id']]['element'].remove();
                        if(_marker[messageType][data['deviceId']][data['id']]['textElement']!=null) _marker[messageType][data['deviceId']][data['id']]['textElement'].remove();
                        if(_marker[messageType][data['deviceId']][data['id']]['locationZElement']!=null) _marker[messageType][data['deviceId']][data['id']]['locationZElement'].remove();
                        delete _marker[messageType][data['deviceId']][data['id']];
                        console.debug("[CustomMapMediator][removeMarker] object complete - [" + messageType + "][" + data['id'] + "]");
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

        this.moveFence = function(actionType, data){
            if(_options[_MARKER_TYPE[4]]['moveFenceHide']){
                return false;
            }

            var fenceMarker = null;
            switch (actionType) {
                case "fenceName":
                    var findFlag = false;
                    for(var index in _marker[_MARKER_TYPE[1]]){
                        for(var i in _marker[_MARKER_TYPE[1]][index]){
                            if(_marker[_MARKER_TYPE[1]][index][i]['data']['fenceName']==data['fenceName']){
                                fenceMarker = _marker[_MARKER_TYPE[1]][index][i];
                                findFlag = true;
                                break;
                            }
                        }
                        if(findFlag){
                            break;
                        }
                    }
                    break;
                case "fenceId":
                    fenceMarker = _self.getMarker(_MARKER_TYPE[1], data);
                    break;
                case "fenceMarker":
                    fenceMarker = data;
                    break;
            }

            if(fenceMarker!=null){
                fenceMarker['element'].trigger('dblclick');
            }
        };

        /**
         * animation
         * @author psb
         */
        this.setAnimate = function(actionType, criticalLevel, data){
            if(data['deviceId']==null){
                return false;
            }

            if(_options[_MARKER_TYPE[4]]['childAnimateFlag']){
                data['childDeviceId'] = data['deviceId'];
            }

            if(_options[_MARKER_TYPE[4]]['animateFlag'] || _options[_MARKER_TYPE[4]]['childAnimateFlag']){
                var customMarker = _self.getMarker(_MARKER_TYPE[4], data);
                if(customMarker!=null){
                    var customKey = data['notificationId'];
                    if(data['fenceId']!=null && data['objectId']!=null){
                        customKey = data['objectId']+data['fenceId'];
                    }
                    switch (actionType){
                        case "add" :
                            var customIndex = customMarker['notification'][criticalLevel].indexOf(customKey);
                            if(fenceIndex<0){
                                customMarker['notification'][criticalLevel].push(customKey);
                            }
                            break;
                        case "remove" :
                            var customIndex = customMarker['notification'][criticalLevel].indexOf(customKey);
                            if(customIndex>-1){
                                customMarker['notification'][criticalLevel].splice(customIndex,1);
                            }
                            break;
                    }

                    for(var index in customMarker['notification']){
                        if(customMarker['notification'][index].length > 0){
                            customMarker['element'].addClass("level-"+criticalCss[index]);
                        }else{
                            customMarker['element'].removeClass("level-"+criticalCss[index]);
                        }
                    }
                }else{
                    console.debug("[CustomMapMediator][setAnimate] not found custom marker");
                }
            }

            if(data['fenceId']==null || data['objectId']==null){
                return false;
            }

            if(_options[_MARKER_TYPE[1]]['animateFlag']){
                var fenceMarker = _self.getMarker(_MARKER_TYPE[1], data);
                if(fenceMarker!=null){
                    let detectText = null;
                    switch (actionType){
                        case "add" :
                            detectText = data['eventName'];
                            var fenceIndex = fenceMarker['notification'][criticalLevel].indexOf(data['objectId']);
                            if(fenceIndex<0){
                                fenceMarker['notification'][criticalLevel].push(data['objectId']);
                            }
                            if(data['moveFenceHide']!=true){
                                _self.moveFence('fenceMarker',fenceMarker);
                            }
                            break;
                        case "remove" :
                            var fenceIndex = fenceMarker['notification'][criticalLevel].indexOf(data['objectId']);
                            if(fenceIndex>-1){
                                fenceMarker['notification'][criticalLevel].splice(fenceIndex,1);
                            }
                            break;
                    }

                    let detectCnt = 0;
                    for(var index in fenceMarker['notification']){
                        detectCnt += fenceMarker['notification'][index].length;
                        if(fenceMarker['notification'][index].length > 0){
                            fenceMarker['element'].addClass("level-"+criticalCss[index]);
                            fenceMarker['element'].attr('style',
                                "fill:"+_marker[_MARKER_TYPE[1]][data['deviceId']][data['fenceId']]['data']['custom'][criticalLevel]['fill'] + " !important; " +
                                "stroke:"+_marker[_MARKER_TYPE[1]][data['deviceId']][data['fenceId']]['data']['custom'][criticalLevel]['stroke'] + " !important;"
                            );
                            if(fenceMarker['copyBoxElement']!=null){fenceMarker['copyBoxElement'].addClass("level-"+criticalCss[index]);}
                        }else{
                            fenceMarker['element'].removeClass("level-"+criticalCss[index]);
                            if(fenceMarker['copyBoxElement']!=null){fenceMarker['copyBoxElement'].removeClass("level-"+criticalCss[index]);}
                        }
                    }

                    if(detectCnt==0){
                        fenceMarker['element'].css({
                            fill:_marker[_MARKER_TYPE[1]][data['deviceId']][data['fenceId']]['data']['custom']['polygon']['fill']
                            ,stroke:_marker[_MARKER_TYPE[1]][data['deviceId']][data['fenceId']]['data']['custom']['polygon']['stroke']
                        });
                    }

                    if(fenceMarker['copyBoxElement']!=null){
                        if(detectCnt>0){
                            if(detectText!=null){
                                fenceMarker['copyBoxElement'].find("p[name='detectText']").text(detectText);
                            }
                            fenceMarker['copyBoxElement'].find("span[name='detectCnt']").text(detectCnt);
                            if(data['eventDatetime']!=null){
                                fenceMarker['copyBoxElement'].find("p[name='detectEventDatetime']").text(new Date(data['eventDatetime']).format("yyyy.MM.dd HH:mm:ss"));
                            }
                        }else{
                            fenceMarker['copyBoxElement'].find("p[name='detectText']").text("");
                            fenceMarker['copyBoxElement'].find("span[name='detectCnt']").text(detectCnt);
                            fenceMarker['copyBoxElement'].find("p[name='detectEventDatetime']").text("");
                        }
                    }
                }else{
                    console.debug("[CustomMapMediator][setAnimate] not found fence marker or child object - fenceId : " + data['fenceId'] + ", objectId : " + data['objectId']);
                }
            }

            if(_options[_MARKER_TYPE[2]]['animateFlag']){
                var objectMarker = _self.getMarker(_MARKER_TYPE[2], data);
                if(objectMarker!=null){
                    switch (actionType){
                        case "add" :
                            objectMarker['element'].addClass("level-"+criticalCss[criticalLevel]);
                            break;
                        case "remove" :
                            objectMarker['element'].removeClass("level-"+criticalCss[criticalLevel]);
                            break;
                    }

                    var customObjectType = null;
                    if(objectMarker['element'].hasClass("object")){
                        customObjectType = _OBJECT_TYPE_CUSTOM['unknown'];
                    }else if(objectMarker['element'].hasClass("vehicle")){
                        customObjectType = _OBJECT_TYPE_CUSTOM['vehicle'];
                    }else{
                        customObjectType = _OBJECT_TYPE_CUSTOM['human'];
                    }

                    if(objectMarker['element'].hasClass("level-"+criticalCss['LEV003'])){
                        objectMarker['element'].attr("marker-end","url(#"+_areaId+customObjectType+"-LEV003)");
                    }else if(objectMarker['element'].hasClass("level-"+criticalCss['LEV002'])){
                        objectMarker['element'].attr("marker-end","url(#"+_areaId+customObjectType+"-LEV002)");
                    }else if(objectMarker['element'].hasClass("level-"+criticalCss['LEV001'])){
                        objectMarker['element'].attr("marker-end","url(#"+_areaId+customObjectType+"-LEV001)");
                    }else{
                        objectMarker['element'].attr("marker-end","url(#"+_areaId+customObjectType+")");
                    }
                }else{
                    console.debug("[CustomMapMediator][setAnimate] not found object marker - objectId : " + data['objectId']);
                }
            }
        };

        /**
         * get marker
         * @author psb
         */
        this.getMarker = function(messageType, data){
            switch (messageType){
                case _MARKER_TYPE[1] : // Fence
                    if(data==null) {
                        return _marker[messageType];
                    }else if(data['deviceId']!=null && data['fenceId']!=null){
                        if(_marker[messageType][data['deviceId']]!=null && _marker[messageType][data['deviceId']][data['fenceId']]!=null){
                            return _marker[messageType][data['deviceId']][data['fenceId']];
                        }
                    }
                    break;
                case _MARKER_TYPE[2] : // Object
                    if(data['deviceId']!=null && data['objectId']!=null){
                        if(_marker[messageType][data['deviceId']]!=null && _marker[messageType][data['deviceId']][data['objectId']]!=null){
                            return _marker[messageType][data['deviceId']][data['objectId']];
                        }
                    }
                    break;
                case _MARKER_TYPE[4] : // custom
                    if(data==null) {
                        return _marker[messageType];
                    }else if(data['deviceId']!=null){
                        if(_marker[messageType][data['deviceId']]!=null){
                            return _marker[messageType][data['deviceId']];
                        }else if(data['childDeviceId']!=null){
                            for(var index in _marker[messageType]){
                                if(_marker[messageType][index]['data']['childDeviceList']!=null){
                                    for(var i in _marker[messageType][index]['data']['childDeviceList']){
                                        if(_marker[messageType][index]['data']['childDeviceList'][i]['deviceId']==data['childDeviceId']){
                                            return _marker[messageType][index];
                                        }
                                    }
                                }
                            }
                        }
                    }
                    break;
                case "all" :
                    return _marker;
                    break;
            }
            return null;
        };

        /**
         * ajax call
         * @author psb
         */
        var _ajaxCall = function(actionType,data,resolve,reject){
            sendAjaxPostRequest(_urlConfig[actionType+'Url'],data,_successHandler,_failureHandler,actionType,resolve,reject);
        };

        this.setTrackingScale = function(scaleValue){
            _mapCanvas.find("svg").attr("class","g-fence g-line "+scaleValue);

            if(_trackingScale[scaleValue]!=null){
                for(let i in _OBJECT_TYPE){
                    _mapCanvas.find("#"+_OBJECT_TYPE[i]+" circle:eq(0)").attr(_trackingScale[scaleValue][0]);
                    _mapCanvas.find("#"+_OBJECT_TYPE[i]+" circle:eq(1)").attr(_trackingScale[scaleValue][1]);
                    _mapCanvas.find("#"+_OBJECT_TYPE[i]+" circle:eq(2)").attr(_trackingScale[scaleValue][2]);
                }
            }else{
                console.warn("trackingScale is not found - "+scaleValue);
            }
        };

        this.setIgnoreHide = function(flag){
            if(flag!=null){
                _options[_MARKER_TYPE[4]]['ignoreHide'] = flag;
            }

            let markerList = _marker[_MARKER_TYPE[1]];
            for(let deviceId in markerList){
                let fenceList = markerList[deviceId];
                for(let fenceId in fenceList){
                    var fence = fenceList[fenceId];
                    if(fence['data']['fenceType']==_FENCE_TYPE[1]){
                        if(_options[_MARKER_TYPE[4]]['ignoreHide']){
                            if(fence['element']!=null){
                                fence['element'].hide();
                            }
                            if(fence['circleElement']!=null){
                                fence['circleElement'].hide();
                            }
                            if(fence['polylineElement']!=null){
                                fence['polylineElement'].hide();
                            }
                        }else{
                            if(fence['element']!=null){
                                fence['element'].show();
                            }
                            if(fence['circleElement']!=null){
                                fence['circleElement'].show();
                            }
                            if(fence['polylineElement']!=null){
                                fence['polylineElement'].show();
                            }
                        }
                    }
                }
            }
        };

        this.setImageConfig = function(settingType, type, deg){
            var callBackValue = null;
            switch (settingType){
                case "rotate" :
                    switch (type){
                        case "increase" :
                            _rotate += _options['element']['rotateIncrementValue'];
                            break;
                        case "decrease" :
                            _rotate -= _options['element']['rotateIncrementValue'];
                            break;
                        case "directInput" :
                            if(deg != null){ _rotate = eval(deg); }
                            break;
                        default :
                            return false;
                    }
                    callBackValue = _rotate;
                    break;
                case "skewX" :
                    switch (type){
                        case "increase" :
                            _skewX += _options['element']['skewXIncrementValue'];
                            break;
                        case "decrease" :
                            _skewX -= _options['element']['skewXIncrementValue'];
                            break;
                        case "directInput" :
                            if(deg != null){ _skewX = eval(deg); }
                            break;
                        default :
                            return false;
                    }
                    callBackValue = _skewX;
                    break;
                case "skewY" :
                    switch (type){
                        case "increase" :
                            _skewY += _options['element']['skewYIncrementValue'];
                            break;
                        case "decrease" :
                            _skewY -= _options['element']['skewYIncrementValue'];
                            break;
                        case "directInput" :
                            if(deg != null){ _skewY = eval(deg); }
                            break;
                        default :
                            return false;
                    }
                    callBackValue = _skewY;
                    break;
            }

            var rotateTransform = "rotate("+_rotate+"deg)";
            _mapCanvas.find(".map_bg").css({
                'transform':rotateTransform
                ,'-webkit-transform':rotateTransform
                ,'-moz-transform':rotateTransform
                ,'-o-transform':rotateTransform
                ,'-ms-transform':rotateTransform
            });

            var drawTransform = "rotateX("+_skewX+"deg) rotateY("+_skewY+"deg)";
            _mapCanvas.find("#drawElement").css({
                'transform':drawTransform
                ,'-webkit-transform':drawTransform
                ,'-moz-transform':drawTransform
                ,'-o-transform':drawTransform
                ,'-ms-transform':drawTransform
            });
            if(_options[_MARKER_TYPE[4]]['changeConfig']!=null && typeof _options[_MARKER_TYPE[4]]['changeConfig'] == "function"){
                _options[_MARKER_TYPE[4]]['changeConfig'](settingType,callBackValue);
            }
        };

        var moveReturn = function(deviceId){
            if(!_options[_MARKER_TYPE[4]]['moveReturn']){
                return false;
            }

            if(_options[_MARKER_TYPE[4]]['moveReturnTimeout']!=null){
                clearTimeout(_options[_MARKER_TYPE[4]]['moveReturnTimeout']);
            }

            _options[_MARKER_TYPE[4]]['moveReturnTimeout'] = setTimeout(function() {
                //if(_marker[_MARKER_TYPE[4]][deviceId]!=null){
                //    _marker[_MARKER_TYPE[4]][deviceId]['element'].trigger('dblclick');
                //}
                loadPosition();
                _mapCanvas.css({
                    left:_left
                    , top:_top
                });
                setTransform2d(null,false);
            }, _options[_MARKER_TYPE[4]]['moveReturnDelay']);
        };

        /**
         * success handler
         * @author psb
         */
        var _successHandler = function(data, dataType, actionType){
            switch(actionType){
                case 'list':
                    _fileUploadPath = data['fileUploadPath'];
                    if(data['templateSetting']!=null && data['iconFileList']!=null){
                        var templateSetting = data['templateSetting'];
                        var iconFileList = data['iconFileList'];
                        try{
                            for(var settingId in templateSetting){
                                if(templateSetting[settingId]!=null && templateSetting[settingId]!=""){
                                    switch (settingId){
                                        case "safeGuardObjectTypeHuman" :
                                            _OBJECT_TYPE_CUSTOM['human'] = templateSetting[settingId];
                                            break;
                                        case "safeGuardObjectTypeUnknown" :
                                            _OBJECT_TYPE_CUSTOM['unknown'] = templateSetting[settingId];
                                            break;
                                        case "safeGuardObjectTypeVehicle" :
                                            _OBJECT_TYPE_CUSTOM['vehicle'] = templateSetting[settingId];
                                            break;
                                        case "moveFenceScale" :
                                            _options[_MARKER_TYPE[4]]['moveFenceScale'] = Number(templateSetting[settingId]);
                                            break;
                                        case "moveReturnDelay" :
                                            _options[_MARKER_TYPE[4]]['moveReturnDelay'] = Number(templateSetting[settingId])*1000;
                                            break;
                                        case "safeGuardMapIcon-human" :
                                        case "safeGuardMapIcon-human-LEV001" :
                                        case "safeGuardMapIcon-human-LEV002" :
                                        case "safeGuardMapIcon-human-LEV003" :
                                        case "safeGuardMapIcon-unknown" :
                                        case "safeGuardMapIcon-unknown-LEV001" :
                                        case "safeGuardMapIcon-unknown-LEV002" :
                                        case "safeGuardMapIcon-unknown-LEV003" :
                                        case "safeGuardMapIcon-vehicle" :
                                        case "safeGuardMapIcon-vehicle-LEV001" :
                                        case "safeGuardMapIcon-vehicle-LEV002" :
                                        case "safeGuardMapIcon-vehicle-LEV003" :
                                            var objectType = settingId.split("safeGuardMapIcon-")[1];
                                            for(var index in iconFileList){
                                                let iconFile = iconFileList[index];
                                                if(iconFile['fileId'] == templateSetting[settingId] && _defsMarkerRef[objectType]!=null){
                                                    _defsMarkerRef[objectType] = _fileUploadPath+iconFile['physicalFileName'];
                                                }
                                            }
                                            break;
                                        case "safeGuardCanvasWidth" :
                                            _canvasSize['width'] = Number(templateSetting[settingId]);
                                            break;
                                        case "safeGuardCanvasHeight" :
                                            _canvasSize['height'] = Number(templateSetting[settingId]);
                                            break;
                                    }
                                }
                            }
                        }catch(e){
                            console.error("[CustomMapMediator] templateSetting set error - "+e.message);
                        }
                    }

                    loadViewOption(data['area']['viewOption']);
                    if(_originX==null){ _originX = _canvasSize['width']/2; }
                    if(_originY==null){ _originY = _canvasSize['height']/2; }
                    _mapCanvas.css({
                        left:_left?_left:(_mapCanvas.parent().width()-_canvasSize['width'])/2
                        , top:_top?_top:(_mapCanvas.parent().height()-_canvasSize['height'])/2
                        , width:_canvasSize['width']
                        , height:_canvasSize['height']
                    });
                    setTransform2d(null,true);
                    setDefsMarkerRef();
                    _self.setBackgroundImage(data['area']['physicalFileName'],true);
                    _self.setAngleXClass(data['area']['angleClass'],true);
                    if(_options[_MARKER_TYPE[4]]['childListLoad']!=null && typeof _options[_MARKER_TYPE[4]]['childListLoad'] == "function"){
                        _options[_MARKER_TYPE[4]]['childListLoad'](data['childList']);
                    }
                    var childList = data['childList'];
                    for(var index in childList){
                        _self.targetRender(childList[index]);
                        if(childList[index]['mainFlag']=='Y'){
                            _mainDevices.push(childList[index]['targetId']);
                        }
                    }
                    _self.setImageConfig('rotate',"directInput", data['area']['rotate']);
                    _self.setImageConfig('skewX',"directInput", data['area']['skewX']);
                    _self.setImageConfig('skewY',"directInput", data['area']['skewY']);

                    if(_options[_MARKER_TYPE[4]]['onLoad']!=null && typeof _options[_MARKER_TYPE[4]]['onLoad'] == "function"){
                        _options[_MARKER_TYPE[4]]['onLoad']();
                    }
                    break;
                case 'fenceList':
                    var fenceList = data['fenceList'];
                    for(var index in fenceList){
                        var fence = fenceList[index];
                        fence['id'] = fence['fenceId'];
                        fence['fenceName'] = fence['fenceName']!=null?fence['fenceName']:fence['fenceId'];
                        fence['deviceId'] = data['paramBean']['deviceId'];
                        let optionCopy = $.extend(true,{},_options[_MARKER_TYPE[1]]['custom']);
                        fence['custom'] = $.extend(true,optionCopy,JSON.parse(fence['customJson']));
                        if(fence['custom']['text']!=null && fence['custom']['text']['fill']!=null && isHex(fence['custom']['text']['fill'])){
                            fence['custom']['text']['fill'] = hexToRgb(fence['custom']['text']['fill']);
                        }

                        if(fence['custom']['polygon']!=null){
                            if(fence['custom']['polygon']['fill']!=null && isHex(fence['custom']['polygon']['fill'])){
                                fence['custom']['polygon']['fill'] = hexToRgb(fence['custom']['polygon']['fill'],0.2);
                            }
                            if(fence['custom']['polygon']['stroke']!=null && isHex(fence['custom']['polygon']['stroke'])){
                                fence['custom']['polygon']['stroke'] = hexToRgb(fence['custom']['polygon']['stroke']);
                            }
                        }
                        _self.addMarker(_MARKER_TYPE[1], fence);
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
        _initialize(rootPath);
    }
);