/**
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
        var _OBJECT_TYPE = ['unknown','unknown-LEV001','unknown-LEV002','unknown-LEV003','human','human-LEV001','human-LEV002','human-LEV003'];
        var _FENCE_TYPE = ['normal','ignore'];
        var _marker = {
            'fence' : {}
            ,'object' : {}
            ,'custom' : {}
        };
        // 환경설정에 따라 사람 <-> 오브젝트로 전환
        var _OBJECT_TYPE_CUSTOM = {
            'human' : 'human'
            ,'unknown' : 'unknown'
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
        };
        var _angleCss = ['deg10','deg15','deg20','deg25','deg30','deg35','deg40','deg45','deg50'];
        var _options = {
            'element' : {
                'draggable': true // 드래그 기능
                ,'mousewheel': true // zoom in/out 기능
                ,'saveLastPosition': true // 마지막에 머무른 값 쿠키 저장 기능
                ,'zoom' : {
                    'init' : 1
                    ,'min' : 0.3
                    ,'max' : 5.0
                }
                ,'skewXIncrementValue': 1 // X 기울기 클릭시 증가치
                ,'skewYIncrementValue': 1 // Y 기울기 클릭시 증가치
                ,'rotateIncrementValue': 1 // 회전 클릭시 증가치
                ,'guardInfo' : true
                ,'guardInfoCnt' : false
            }
            ,'fence' : {
                'text' : {
                    'text-anchor': "middle"
                    , 'fill': "white"
                    , 'font-size': "5px"
                }
                , 'animateFlag' : true // 이벤트 발생시 펜스 애니메이션 사용 여부
            }
            ,'object' : {
                'pointsHideFlag' : false // 트래킹 이동경로 숨김여부
                ,'pointShiftCnt' : 80 // 트래킹 잔상 갯수 null일경우 무제한
                , 'animateFlag' : true // 이벤트 발생시 오브젝트 애니메이션 사용 여부
            }
            ,'custom' : {
                'draggable': false // 드래그 기능
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
                , 'moveFenceHide': true // 이벤트 발생시 펜스로 이동 기능 (true:사용안함, false:사용)
                , 'moveFenceScale': 3.0 // 이벤트 발생시 펜스 Zoom Size
                , 'moveReturn': true // 펜스로 이동 후 해당 펜스의 메인장치로 복귀 기능
                , 'moveReturnTimeout':null // 펜스로 이동 후 해당 펜스의 메인장치로 복귀
                , 'moveReturnDelay': 3000 // 메인장치로 복귀 딜레이
                , 'lidarHideFlag': false // 라이다 반경표시 (true:사용안함, false:사용)
                , 'animateFlag' : false // 이벤트 발생시 장치 애니메이션 사용 여부
            }
        };
        var _targetClass = {
            'area' : "g-area"
            ,'object' : "g-tracking"
            ,'fence' : "g-fence"
            ,"DEV002" : "g-ico g-camera"
            ,"DEV006" : "g-ico g-led"
            ,"DEV007" : "g-ico g-speaker"
            ,"DEV008" : "g-ico g-wlight"
            ,"DEV013" : "g-ico g-m8"
            ,"DEV015" : "g-ico g-qguard"
            ,"DEV016" : "g-ico g-server"
            ,"DEV017" : "g-ico g-shock"
        };
        var _customDeviceCode = ['DEV002','DEV006','DEV007','DEV008','DEV013','DEV016','DEV017'];
        // true :사람만보기
        // false:전체보기
        var _objectViewFlag=false;

        // 비율 1m : 10px
        var _ratio=10;
        var _scale=_options['element']['zoom']['init'];
        var _originX = 5000;
        var _originY = 5000;
        var _translateX = 0;
        var _translateY = 0;
        var _rotate=0;
        var _skewX=0;
        var _skewY=0;
        var _element;
        var _copyBoxElement;
        var _mapCanvas;
        var _canvasSvg;
        var _fileUploadPath;
        var _messageConfig;
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

        this.setObjectTypeCustom = function(human, unknown){
            if(human!=null && human!=""){
                _OBJECT_TYPE_CUSTOM['human'] = human;
            }
            if(unknown!=null && unknown!=""){
                _OBJECT_TYPE_CUSTOM['unknown'] = unknown;
            }
        };

        /**
         * get custom area/device list
         * @author psb
         */
        this.init = function(areaId,options){
            _areaId = areaId;

            var objectViewFlag = $.cookie(_areaId+"objectViewFlag");
            if(objectViewFlag != null && objectViewFlag.length > 0){
                _objectViewFlag = objectViewFlag == "true";
                _element.find("input[name='humanCkb']").prop("checked",_objectViewFlag);
                if(_objectViewFlag){
                    _mapCanvas.addClass("onlyhuman");
                }
            }
            var pointsHideFlag = $.cookie(_areaId+"pointsHideFlag");
            if(pointsHideFlag != null && pointsHideFlag.length > 0){
                _options['object']['pointsHideFlag'] = pointsHideFlag == "true";
                _element.find("input[name='pointsCkb']").prop("checked",_options['object']['pointsHideFlag']);
            }

            var lidarHideFlag = $.cookie(_areaId+"lidarHideFlag");
            if(lidarHideFlag != null && lidarHideFlag.length > 0){
                _options['custom']['lidarHideFlag'] = lidarHideFlag == "true";
                _element.find("input[name='lidarCkb']").prop("checked",_options['custom']['lidarHideFlag']);
            }

            var moveFenceHideFlag = $.cookie(_areaId+"moveFenceHideFlag");
            if(moveFenceHideFlag != null && moveFenceHideFlag.length > 0){
                _options['custom']['moveFenceHide'] = moveFenceHideFlag == "true";
                _element.find("input[name='moveFenceCkb']").prop("checked",_options['custom']['moveFenceHide']);
            }

            for(var i in options){
                if(_options.hasOwnProperty(i)){
                    for(var index in options[i]){
                        _options[i][index] = options[i][index];
                    }
                }
            }

            if(_options['element']['saveLastPosition']){
                var top = $.cookie(_areaId+"MapCanvasTop");
                var left = $.cookie(_areaId+"MapCanvasLeft");
                if(top != null && top.length > 0 && left != null && left.length > 0){
                    _mapCanvas.css({
                        'top':top
                        ,'left':left
                    });
                }
                var originX = $.cookie(_areaId+"MapCanvasOriginX");
                if(!isNaN(originX)){ _originX = eval(originX); }
                var originY = $.cookie(_areaId+"MapCanvasOriginY");
                if(!isNaN(originY)){ _originY = eval(originY); }
                var translateX = $.cookie(_areaId+"MapCanvasTranslateX");
                if(!isNaN(translateX)){ _translateX = eval(translateX); }
                var translateY = $.cookie(_areaId+"MapCanvasTranslateY");
                if(!isNaN(translateY)){ _translateY = eval(translateY); }
                var scale = $.cookie(_areaId+"MapCanvasScale");
                if(!isNaN(scale)){ _scale = eval(scale); }
                setTransform2d();
            }
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
                    var newOrigX = imageX/_scale;
                    var newOrigY = imageY/_scale;
                    _originX = newOrigX;
                    _originY = newOrigY;
                    _translateX = _translateX + (imageX-prevOrigX)*(1-1/_scale);
                    _translateY = _translateY + (imageY-prevOrigY)*(1-1/_scale);

                    if(event.originalEvent.deltaY > 0){if(_scale > _options['element']['zoom']['min']){_scale-=0.1;}}
                    if(event.originalEvent.deltaY < 0){if(_scale < _options['element']['zoom']['max']){_scale+=0.1;}}
                    setTransform2d();
                    savePosition();
                });
            }

            _mapCanvas.css({
                left:(_mapCanvas.parent().width()-_mapCanvas.width())/2
                , top:(_mapCanvas.parent().height()-_mapCanvas.height())/2
            });
            setTransform2d();
        };

        var savePosition = function(){
            if(_options['element']['saveLastPosition']) {
                $.cookie(_areaId + "MapCanvasTop",_mapCanvas.css("top"));
                $.cookie(_areaId + "MapCanvasLeft",_mapCanvas.css("left"));
                $.cookie(_areaId + "MapCanvasOriginX",_originX.toFixed(10));
                $.cookie(_areaId + "MapCanvasOriginY",_originY.toFixed(10));
                $.cookie(_areaId + "MapCanvasTranslateX",_translateX.toFixed(1));
                $.cookie(_areaId + "MapCanvasTranslateY",_translateY.toFixed(1));
                $.cookie(_areaId + "MapCanvasScale", _scale.toFixed(1));
            }
        };

        var setTransform2d = function(scale){
            if(scale!=null){
                _scale = scale;
            }
            var orig = _originX.toFixed(10) + "px " + _originY.toFixed(10) + "px";
            var transform2d = "matrix(" + _scale.toFixed(1) + ",0,0," + _scale.toFixed(1) + "," + _translateX.toFixed(1) +"," + _translateY.toFixed(1) + ")";
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
                _mapCanvas.find(".on").removeClass("on");
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
         * set guard option
         * lidarHide : 라이다반경표시 on/off
         * objectView : 전체보기/사람만보기
         * pointsHide : 트래킹 잔상 보기/숨기기
         * moveFenceHideFlag : 이벤트 발생시 펜스로이동/이동안함
         * @author psb
         */
        this.setGuardOption = function(actionType, flag){
            switch (actionType){
                case "objectView" :
                    _objectViewFlag = flag;
                    $.cookie(_areaId+'objectViewFlag',flag);
                    if(_objectViewFlag){
                        _mapCanvas.addClass("onlyhuman");
                    }else{
                        _mapCanvas.removeClass("onlyhuman");
                    }
                    break;
                case "lidarHide" :
                    _options['custom']['lidarHideFlag'] = flag;
                    if(flag){
                        _mapCanvas.find(".g-m8").removeClass("lidar");
                    }else{
                        _mapCanvas.find(".g-m8").addClass("lidar");
                    }
                    $.cookie(_areaId+'lidarHideFlag',flag);
                    break;
                case "pointsHide" :
                    _options['object']['pointsHideFlag'] = flag;
                    $.cookie(_areaId+'pointsHideFlag',flag);
                    break;
                case "moveFenceHide" :
                    _options['custom']['moveFenceHide'] = flag;
                    $.cookie(_areaId+'moveFenceHideFlag',flag);
                    break;
            }
        };

        /**
         * set icon image
         * @author psb
         */
        var setDefsMarkerRef = function(templateSetting, iconFileList){
            try{
                for(var settingId in templateSetting){
                    if(settingId.indexOf("safeGuardMapIcon") > -1){
                        var objectType = settingId.split("safeGuardMapIcon-")[1];
                        for(var index in iconFileList){
                            let iconFile = iconFileList[index];
                            if(iconFile['fileId'] == templateSetting[settingId] && _defsMarkerRef[objectType]!=null){
                                _defsMarkerRef[objectType] = _fileUploadPath+iconFile['physicalFileName'];
                            }
                        }
                    }
                }
            }catch(e){
                console.error("[CustomMapMediator][setDefsMarkerRef] set error - "+e.message);
            }
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
                            let marker = _canvasSvg.marker(defs,_OBJECT_TYPE[i],10,18,6,6,"0");
                            _canvasSvg.circle(marker,10,11,8,{fill:"none"});
                            _canvasSvg.circle(marker,10,11,11,{fill:"none"});
                            _canvasSvg.circle(marker,10,11,16,{fill:"none"});
                            _canvasSvg.image(marker,null,null,null,null,_defsMarkerRef[_OBJECT_TYPE[i]]);
                        }
                    }
                });
                _mapCanvas.find("svg").addClass("g-fence g-line");
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

            if(callBackFlag && _options['custom']['changeConfig']!=null && typeof _options['custom']['changeConfig'] == "function"){
                _options['custom']['changeConfig']("fileId",physicalFileName);
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

            if(callBackFlag && _options['custom']['changeConfig']!=null && typeof _options['custom']['changeConfig'] == "function"){
                _options['custom']['changeConfig']("angleClass",angleClass);
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

            if(_options['custom']['change']!=null && typeof _options['custom']['change'] == "function"){
                _options['custom']['change'](targetData);
            }

            setTranslate(targetData, targetElement);
        };

        /**
         * 기준 설정
         * 장치코드 DEV013(M8)이고 메인여부가 Y일 경우 object, fence의 기준장치로 설정함
         * Custom-map-popup에서 m8장치 이동 및 사이즈 변경시 fence를 새로그림
         * @author psb
         */
        var setTranslate = function (targetData, targetElement){
            if(targetData['deviceCode']=='DEV013' && targetData['mainFlag']=='Y'){
                targetData['translate'] = {
                    'x' : parseInt(targetElement.css("left")) + (_mapCanvas.width()-targetData['x1']-targetData['x2'])/2
                    ,'y' : parseInt(targetElement.css("top")) + (_mapCanvas.height()-targetData['y1']-targetData['y2'])/2
                };

                if(targetData.hasOwnProperty("setFenceList")){
                    for(var index in _marker[_MARKER_TYPE[1]]){
                        for(var i in _marker[_MARKER_TYPE[1]][index]){
                            if(targetData['targetId']==_marker[_MARKER_TYPE[1]][index][i]['data']['deviceId']){
                                _self.saveFence(index, i);
                            }
                        }
                    }
                }else if(_options['custom']['fenceView']){
                    targetData['setFenceList'] = true;
                    _marker[_MARKER_TYPE[1]][targetData['targetId']] = {};
                    _marker[_MARKER_TYPE[2]][targetData['targetId']] = {};

                    targetElement.on('dblclick', function(evt){
                        setTransform2d(_options['element']['zoom']['init']);
                        _mapCanvas.animate({
                            'top': parseInt(_mapCanvas.css('top')) + _mapCanvas.parent().height()/2 - ($(this).offset().top + $(this)[0].getBoundingClientRect().height/2*(1-1/_scale) - _mapCanvas.parent().offset().top)
                            ,'left': parseInt(_mapCanvas.css('left')) + _mapCanvas.parent().width()/2 - ($(this).offset().left + $(this)[0].getBoundingClientRect().width/2*(1-1/_scale) - _mapCanvas.parent().offset().left)
                        },300);
                    });
                    _ajaxCall('fenceList',{deviceId:targetData['targetId']});
                }
            }
        };

        /**
         * save fence name
         * @author psb
         */
        this.saveFence = function(deviceId, fenceId, fenceName, fenceType, location){
            if(_marker[_MARKER_TYPE[1]][deviceId]!=null && _marker[_MARKER_TYPE[1]][deviceId][fenceId]!=null){
                _self.addMarker(
                    _MARKER_TYPE[1]
                    , {
                        'uuid':_marker[_MARKER_TYPE[1]][deviceId][fenceId]['data']['uuid']
                        ,'id' : fenceId
                        ,'deviceId':_marker[_MARKER_TYPE[1]][deviceId][fenceId]['data']['deviceId']
                        ,'fenceType':fenceType!=null?fenceType:_marker[_MARKER_TYPE[1]][deviceId][fenceId]['data']['fenceType']
                        ,'fenceName':fenceName!=null?fenceName:_marker[_MARKER_TYPE[1]][deviceId][fenceId]['data']['fenceName']
                        ,'location':location!=null?location:_marker[_MARKER_TYPE[1]][deviceId][fenceId]['data']['location']
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
                var targetElement = $("<div/>",{targetId:data['targetId'],deviceCode:data['deviceCode'],linkUrl:data['linkUrl'],class:_targetClass[data['deviceCode']]});
                targetElement.on("click",function(){
                    if(_options['custom']['click']!=null && typeof _options['custom']['click'] == "function"){
                        _options['custom']['click']($(this).attr("targetId"),$(this).attr("deviceCode"));
                    }else{
                        positionChangeEventHandler($(this).attr("targetId"));
                    }

                    var linkUrl = $(this).attr("linkUrl");
                    if(_options['custom']['openLinkFlag'] && linkUrl!=null && linkUrl!=''){
                        openLink(linkUrl);
                    }
                });
                setDeviceStatus(targetElement, data['deviceStat']);

                if(_options['custom']['resizable']){
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
                            canvasOffset = _mapCanvas.offset();
                            pointerY = (evt.pageY - canvasOffset.top) / _scale - parseInt($(evt.target).css('top'));
                            pointerX = (evt.pageX - canvasOffset.left) / _scale - parseInt($(evt.target).css('left'));
                        }
                        ,drag : function(evt, ui) {
                            ui.position.top = (evt.pageY - canvasOffset.top) / _scale - pointerY;
                            ui.position.left = (evt.pageX - canvasOffset.left) / _scale - pointerX;
                        }
                        ,stop: function(){
                            positionChangeEventHandler($(this).attr("targetId"),'update');
                        }
                    });
                }

                if(_options['custom']['nameView'] && data["targetName"]!=null && data["targetName"]!=''){
                    targetElement.append( $("<span/>").text(data["targetName"]) );
                }

                if(!_options['custom']['lidarHideFlag'] && data['deviceCode']=='DEV013'){
                    targetElement.addClass("lidar");
                }
                targetElement.append( $("<div/>") );

                _mapCanvas.find("#drawElement").append(targetElement);
                _marker[_MARKER_TYPE[4]][data['targetId']] = {
                    'data' : {
                        'targetId' : data['targetId']
                        ,'mainFlag' : data['mainFlag']
                        ,'deviceCode' : data['deviceCode']
                        ,'x1' : data['useYn']?data['x1']:targetElement.position()['left']
                        ,'x2' : data['useYn']?data['x2']:_mapCanvas.width()-targetElement.position()['left']-(targetElement.width()/2)
                        ,'y1' : data['useYn']?data['y1']:targetElement.position()['top']
                        ,'y2' : data['useYn']?data['y2']:_mapCanvas.height()-targetElement.position()['top']-(targetElement.height()/2)
                        ,'useYn' : data['useYn']
                    }
                    ,'element' : targetElement
                    ,'notification' : $.extend(true,{},criticalList)
                };

                if(data['useYn']=='N'){
                    _self.setDisplayTarget(data['targetId'],false);
                }
                positionChangeEventHandler(data['targetId'],'init');
            }else{
                positionChangeEventHandler(data['targetId']);
            }

            if(_options['custom']['websocketSend']){
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
                console.error("[CustomMapMediator][addMarker] target M8 device is null - deviceId : " + data['deviceId']);
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
                        let latMin=null,latMax=null,lngMin=null,lngMax=null;
                        let fenceName;
                        for(let index in data['location']){
                            let location = data['location'][index];
                            location['uuid'] = data['uuid'];
                            const lat = Number(_marker[_MARKER_TYPE[4]][data['deviceId']]['data']['translate']['x'])+(Number(location['lat'])*_ratio);
                            const lng = Number(_marker[_MARKER_TYPE[4]][data['deviceId']]['data']['translate']['y'])+(Number(location['lng'])*_ratio);
                            if(latMin==null || latMin > lat){ latMin = lat; }
                            if(latMax==null || latMax < lat){ latMax = lat; }
                            if(lngMin==null || lngMin > lng){ lngMin = lng; }
                            if(lngMax==null || lngMax < lng){ lngMax = lng; }
                            points.push([lat,lng]);
                        }

                        if(_marker[messageType][data['deviceId']][data['id']]!=null){
                            _marker[messageType][data['deviceId']][data['id']]['element'].attr("points",points.join(" ")).off('click');
                            _marker[messageType][data['deviceId']][data['id']]['data']['location'] = data['location'];
                            fenceName = data['fenceName']!=null?data['fenceName']:_marker[messageType][data['deviceId']][data['id']]['data']['fenceName'];
                            _marker[messageType][data['deviceId']][data['id']]['data']['fenceName'] = fenceName;
                            _marker[messageType][data['deviceId']][data['id']]['data']['fenceType'] = data['fenceType'];
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
                                ,'copyBoxElement' : copyBoxElement
                                ,'data' : {
                                    'location' : data['location']
                                    ,'uuid' : data['uuid']
                                    ,'deviceId' : data['deviceId']
                                    ,'fenceType' : data['fenceType']
                                    ,'fenceId' : data['id']
                                    ,'fenceName' : fenceName
                                }
                                ,'notification' : $.extend(true,{},criticalList)
                            };

                            if(_options['custom']['draggable']){
                                let pointerY, pointerX;
                                _marker[messageType][data['deviceId']][data['id']]['element'].draggable({
                                    cursor: "move"
                                    ,containment: "parent"
                                    ,start : function(evt, ui) {
                                        pointerY = evt.pageY;
                                        pointerX = evt.pageX;
                                    }
                                    ,drag : function(evt, ui) {
                                        var locations = $(this).attr("points").split(" ");
                                        var pointList = [];
                                        for(let index in locations){
                                            const loc = locations[index].split(",");
                                            const lat = Number(loc[0])+(Number(evt.pageX)-Number(pointerX))/_scale;
                                            const lng = Number(loc[1])+(Number(evt.pageY)-Number(pointerY))/_scale;
                                            pointList.push([lat,lng]);
                                        }
                                        _self.saveFence(data['deviceId'], data['id'], null, null, _self.convertFenceLocationOrigin(data['deviceId'],pointList));
                                        pointerY = evt.pageY;
                                        pointerX = evt.pageX;
                                    }
                                });
                            }

                            if(_options['custom']['changeFence']!=null && typeof _options['custom']['changeFence'] == "function"){
                                _options['custom']['changeFence']('add',_marker[messageType][data['deviceId']][data['id']]['data']);
                            }
                        }

                        if(data['fenceType']==_FENCE_TYPE[1]){
                            _marker[messageType][data['deviceId']][data['id']]['element'].addClass('g-ignore_fence');
                            if(_marker[messageType][data['deviceId']][data['id']]['textElement']!=null) {
                                _marker[messageType][data['deviceId']][data['id']]['textElement'].remove();
                                _marker[messageType][data['deviceId']][data['id']]['textElement'] = null;
                            }
                        } else {
                            _marker[messageType][data['deviceId']][data['id']]['element'].removeClass('g-ignore_fence');
                            if(_marker[messageType][data['deviceId']][data['id']]['textElement']==null){
                                const svgText = _canvasSvg.text((latMin+latMax)/2, (lngMin+lngMax)/2, fenceName, $.extend({"fenceId": data['id']}, _options[_MARKER_TYPE[1]]['text']));
                                _marker[messageType][data['deviceId']][data['id']]['textElement'] = $(svgText);
                            }else{
                                _marker[messageType][data['deviceId']][data['id']]['textElement'].attr({x:(latMin+latMax)/2,y:(lngMin+lngMax)/2}).text(fenceName);
                            }
                            _marker[messageType][data['deviceId']][data['id']]['element'].dblclick({deviceId:data['deviceId']}, function(evt){
                                setTransform2d(_options['custom']['moveFenceScale']);
                                _mapCanvas.animate({
                                    'top': parseInt(_mapCanvas.css('top')) + _mapCanvas.parent().height()/2 - ($(this).offset().top + $(this)[0].getBoundingClientRect().height/2*(1-1/_scale) - _mapCanvas.parent().offset().top)
                                    ,'left': parseInt(_mapCanvas.css('left')) + _mapCanvas.parent().width()/2 - ($(this).offset().left + $(this)[0].getBoundingClientRect().width/2*(1-1/_scale) - _mapCanvas.parent().offset().left)
                                },300);
                                moveReturn(evt.data.deviceId);
                            });
                        }
                        console.debug("[CustomMapMediator][addMarker] fence complete - [" + messageType + "][" + data['id'] + "]");
                        break;
                    case _MARKER_TYPE[2] : // Object
                        if(_marker[messageType][data['deviceId']]==null){
                            return false;
                        }

                        if(data['location'] instanceof Array){
                            data['location'] = data['location'][0];
                        }
                        const left = Number(_marker[_MARKER_TYPE[4]][data['deviceId']]['data']['translate']['x'])+(Number(data['location']['lat'])*_ratio);
                        const top = Number(_marker[_MARKER_TYPE[4]][data['deviceId']]['data']['translate']['y'])+(Number(data['location']['lng'])*_ratio);
                        let element;

                        if(_marker[messageType][data['deviceId']][data['id']]!=null){
                            let points = [];
                            if(_options['object']['pointsHideFlag']){
                                points = [left+","+top];
                                _marker[messageType][data['deviceId']][data['id']]['points'] = points;
                            }else{
                                points = _marker[messageType][data['deviceId']][data['id']]['points'];
                                points.push(left+","+top);
                                if(_options['object']['pointShiftCnt']!=null && points.length > _options['object']['pointShiftCnt']){
                                    points.shift();
                                }
                            }
                            element = _marker[messageType][data['deviceId']][data['id']]['element'];

                            if(element.hasClass("level-"+criticalCss['LEV003'])){
                                element.attr("marker-end","url(#"+_OBJECT_TYPE_CUSTOM[data['objectType']]+"-LEV003)");
                            }else if(element.hasClass("level-"+criticalCss['LEV002'])){
                                element.attr("marker-end","url(#"+_OBJECT_TYPE_CUSTOM[data['objectType']]+"-LEV002)");
                            }else if(element.hasClass("level-"+criticalCss['LEV001'])){
                                element.attr("marker-end","url(#"+_OBJECT_TYPE_CUSTOM[data['objectType']]+"-LEV001)");
                            }else{
                                element.attr("marker-end","url(#"+_OBJECT_TYPE_CUSTOM[data['objectType']]+")");
                            }
                            element.attr("points",points.join(" "));
                        }else{
                            const polyline = _canvasSvg.polyline([[left,top]],{'objectId':data['id'],'marker-end':"url(#"+_OBJECT_TYPE_CUSTOM[data['objectType']]+")"});
                            element = $(polyline);
                            element.addClass(_targetClass[messageType]);
                            _marker[messageType][data['deviceId']][data['id']] = {
                                'element' : element
                                ,'points' : [left+","+top]
                            };
                        }
                        if(_OBJECT_TYPE_CUSTOM[data['objectType']]=='unknown'){
                            element.addClass("object");
                        }else{
                            element.removeClass("object");
                        }
                        console.debug("[CustomMapMediator][addMarker] object complete - [" + messageType + "][" + data['id'] + "]");
                        break;
                }
            }catch(e){
                console.error("[CustomMapMediator][addMarker] error- [" + messageType + "][" + data['id'] + "] - " + e.message);
            }
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
                _self.addMarker('fence',{
                    "deviceId":deviceId
                    ,"uuid":_uuid
                    ,"id":_fenceId
                    ,"fenceType":_marker[_MARKER_TYPE[1]][deviceId][fenceId]['data']['fenceType']
                    ,"fenceName":fenceName==null?_fenceId:(index==0?fenceName:(fenceName+"_"+index))
                    ,"location":_self.convertFenceLocationOrigin(deviceId,cutPoints[index])
                });
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
                    _self.addMarker(messageType, data);
                    break;
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
                        if(_options['custom']['changeFence']!=null && typeof _options['custom']['changeFence'] == "function"){
                            _options['custom']['changeFence']('remove',_marker[messageType][data['deviceId']][data['id']]['data']);
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
                        _marker[messageType][data['deviceId']][data['id']]['element'].remove();
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
            if(_options['custom']['moveFenceHide']){
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

            if(_options[_MARKER_TYPE[4]]['animateFlag']){
                var customMarker = _self.getMarker(_MARKER_TYPE[4], data);
                if(customMarker!=null){
                    var customKey = data['notificationId'];
                    if(data['fenceId']!=null && data['objectId']!=null){
                        customKey = data['objectId']+data['fenceId'];
                    }
                    switch (actionType){
                        case "add" :
                            if(customMarker['notification'][criticalLevel].indexOf(customKey)<0){
                                customMarker['notification'][criticalLevel].push(customKey);
                            }
                            break;
                        case "remove" :
                            if(customMarker['notification'][criticalLevel].indexOf(customKey)>-1){
                                customMarker['notification'][criticalLevel].splice(customMarker['notification'][criticalLevel].indexOf(customKey),1);
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
                    console.warn("[CustomMapMediator][setAnimate] not found custom marker");
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
                            if(fenceMarker['notification'][criticalLevel].indexOf(data['objectId'])<0){
                                fenceMarker['notification'][criticalLevel].push(data['objectId']);
                            }
                            _self.moveFence('fenceMarker',fenceMarker);
                            break;
                        case "remove" :
                            if(fenceMarker['notification'][criticalLevel].indexOf(data['objectId'])>-1){
                                fenceMarker['notification'][criticalLevel].splice(fenceMarker['notification'][criticalLevel].indexOf(data['objectId']),1);
                            }
                            break;
                    }

                    let detectCnt = 0;
                    for(var index in fenceMarker['notification']){
                        detectCnt += fenceMarker['notification'][index].length;
                        if(fenceMarker['notification'][index].length > 0){
                            fenceMarker['element'].addClass("level-"+criticalCss[index]);
                            if(fenceMarker['copyBoxElement']!=null){fenceMarker['copyBoxElement'].addClass("level-"+criticalCss[index]);}
                        }else{
                            fenceMarker['element'].removeClass("level-"+criticalCss[index]);
                            if(fenceMarker['copyBoxElement']!=null){fenceMarker['copyBoxElement'].removeClass("level-"+criticalCss[index]);}
                        }
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
                    console.warn("[CustomMapMediator][setAnimate] not found fence marker or child object - fenceId : " + data['fenceId'] + ", objectId : " + data['objectId']);
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
                    }else{
                        customObjectType = _OBJECT_TYPE_CUSTOM['human'];
                    }

                    if(objectMarker['element'].hasClass("level-"+criticalCss['LEV003'])){
                        objectMarker['element'].attr("marker-end","url(#"+customObjectType+"-LEV003)");
                    }else if(objectMarker['element'].hasClass("level-"+criticalCss['LEV002'])){
                        objectMarker['element'].attr("marker-end","url(#"+customObjectType+"-LEV002)");
                    }else if(objectMarker['element'].hasClass("level-"+criticalCss['LEV001'])){
                        objectMarker['element'].attr("marker-end","url(#"+customObjectType+"-LEV001)");
                    }else{
                        objectMarker['element'].attr("marker-end","url(#"+customObjectType+")");
                    }
                }else{
                    console.warn("[CustomMapMediator][setAnimate] not found object marker - objectId : " + data['objectId']);
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
                        if(_marker[messageType][data['deviceId']][data['fenceId']]!=null){
                            return _marker[messageType][data['deviceId']][data['fenceId']];
                        }
                    }
                    break;
                case _MARKER_TYPE[2] : // Object
                    if(data['deviceId']!=null && data['objectId']!=null){
                        if(_marker[messageType][data['deviceId']][data['objectId']]!=null){
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
        var _ajaxCall = function(actionType, data){
            sendAjaxPostRequest(_urlConfig[actionType+'Url'],data,_successHandler,_failureHandler,actionType);
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
            if(_options['custom']['changeConfig']!=null && typeof _options['custom']['changeConfig'] == "function"){
                _options['custom']['changeConfig'](settingType,callBackValue);
            }
        };

        var moveReturn = function(deviceId){
            if(!_options['custom']['moveReturn']){
                return false;
            }

            if(_options['custom']['moveReturnTimeout']!=null){
                clearTimeout(_options['custom']['moveReturnTimeout']);
            }

            _options['custom']['moveReturnTimeout'] = setTimeout(function() {
                if(_marker[_MARKER_TYPE[4]][deviceId]!=null){
                    _marker[_MARKER_TYPE[4]][deviceId]['element'].trigger('dblclick');
                }
            }, _options['custom']['moveReturnDelay']);
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
                        setDefsMarkerRef(data['templateSetting'], data['iconFileList']);
                    }
                    _self.setBackgroundImage(data['area']['physicalFileName'],true);
                    _self.setAngleXClass(data['area']['angleClass'],true);
                    if(_options['custom']['childListLoad']!=null && typeof _options['custom']['childListLoad'] == "function"){
                        _options['custom']['childListLoad'](data['childList']);
                    }
                    var childList = data['childList'];
                    for(var index in childList){
                        _self.targetRender(childList[index]);
                    }
                    _self.setImageConfig('rotate',"directInput", data['area']['rotate']);
                    _self.setImageConfig('skewX',"directInput", data['area']['skewX']);
                    _self.setImageConfig('skewY',"directInput", data['area']['skewY']);

                    if(_options['custom']['onLoad']!=null && typeof _options['custom']['onLoad'] == "function"){
                        _options['custom']['onLoad']();
                    }
                    break;
                case 'fenceList':
                    var fenceList = data['fenceList'];
                    for(var index in fenceList){
                        var fence = fenceList[index];
                        fence['id'] = fence['fenceId'];
                        fence['fenceName'] = fence['fenceName']!=null?fence['fenceName']:fence['fenceId'];
                        fence['deviceId'] = data['paramBean']['deviceId'];
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