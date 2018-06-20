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
        var _urlConfig = {
            listUrl : "/customMapLocation/list.json"
        };
        var _markerClass = {
            'area' : "g-area"
            ,'object' : "g-tracking"
            ,'fence' : "g-fence"
            ,"DEV013" : "g-m8"
            ,"DEV002" : "g-camera"
        };
        var _ratio={
            'standard' : {
                'width' : 800
                ,'height' : 450
            }
            ,'scale' : {
                'horizontal' : 1 // 가로
                ,'vertical' : 1 // 세로
            }
        };
        var _scale=1.0;
        var _element;
        var _messageConfig;
        var _callBackEventHandler = null;
        var _customList = {};
        var _objectList = {};

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
            _ratio['scale']['horizontal'] = toRound(_element.width()/_ratio['standard']['width'],2);
            _ratio['scale']['vertical'] = toRound(_element.height()/_ratio['standard']['height'],2);
            _element.empty();
        };

        /**
         * set target display
         * @author psb
         */
        this.setDisplayTarget = function(targetId, flag){
            if(_customList[targetId]==null){
                return false;
            }

            if(flag){
                _element.find(".on").removeClass("on");
                _customList[targetId]['data']['useYn'] = 'Y';
                _customList[targetId]['element'].addClass("on").show();
                return true;
            }else{
                _customList[targetId]['data']['useYn'] = 'N';
                _customList[targetId]['element'].hide();
                return false;
            }
        };

        /**
         * set image
         * @author psb
         */
        this.setBackgroundImage = function(filePath,physicalFileName){
            if(physicalFileName!=null && physicalFileName!=""){
                _element.css({"background-image":"url("+filePath+physicalFileName+")"});
                var limitLeft, limitTop;
                var pointerY, pointerX, canvasOffset, canvasHeight, canvasWidth;
                _element.draggable({
                    cursor: "move"
                    ,start : function(evt, ui) {
                        canvasOffset = _element.offset();
                        canvasHeight = _element.height();
                        canvasWidth = _element.width();
                        pointerY = evt.pageY - (canvasOffset.top / _scale) - parseInt($(evt.target).css('top'));
                        pointerX = evt.pageX - (canvasOffset.left / _scale) - parseInt($(evt.target).css('left'));
                    }
                    ,drag : function(evt, ui) {
                        // Fix for zoom
                        ui.position.top = Math.round(evt.pageY - (canvasOffset.top / _scale) - pointerY);
                        ui.position.left = Math.round(evt.pageX - (canvasOffset.left / _scale) - pointerX);

                        if(canvasWidth/2 < Math.abs(ui.position['left']) || canvasHeight/2 < Math.abs(ui.position['top'])){
                            ui.position.left = limitLeft;
                            ui.position.top = limitTop;
                        }else{
                            limitLeft = ui.position.left;
                            limitTop = ui.position.top;
                        }
                    }
                });
                var compteur = 10; // 10 = scale(1,1) and 5 = scale(0.5,0.5)
                _element.on("mousewheel",function(event) {
                    if(event.originalEvent.deltaY > 0){if(compteur > 5){compteur--;}}
                    if(event.originalEvent.deltaY < 0){if(compteur < 50){compteur++;}}
                    var scale = compteur/10;
                    _element.css({
                        'transform':'scale('+scale+')',
                        '-webkit-transform':'scale('+scale+')',
                        '-moz-transform':'scale('+scale+')',
                        '-o-transform':'scale('+scale+')',
                        '-ms-transform':'scale('+scale+')'
                    });
                    _scale = scale;
                });
            }else{
                if(_element.data('uiDraggable')){
                    _element.draggable('destroy');
                }
                _element.off('mousewheel').removeAttr("style").removeAttr("scale");
            }
        };

        /**
         * Map 설정 팝업에서 저장시 사용
         * @author psb
         */
        this.getCustomList = function(){
            return _customList;
        };

        /**
         * 수치값 변경시 이벤트 핸들러
         * - input 직접변경시
         * @author psb
         */
        this.setTargetData = function(targetId, data){
            if(_customList[targetId]==null){
                console.error("[CustomMapMediator][setTargetData] targetId is null or empty - "+targetId);
                return false;
            }

            var targetElement = _customList[targetId]['element'];
            var targetData = _customList[targetId]['data'];

            $.extend(targetData,data);
            targetElement.css("left",targetData['x1']);
            targetElement.css("width",_element.width()-targetData['x1']-targetData['x2']);
            targetElement.css("top",targetData['y1']);
            targetElement.css("height",_element.height()-targetData['y1']-targetData['y2']);
        };

        /**
         * 수치값 변경시 이벤트 핸들러
         * actionType
         *  - init : 초기 로딩 시
         *  - update : 마우스 드래그를 통한 위치 변경 or 축소 확대 시 이벤트 핸들러
         * @author psb
         */
        this.positionChangeEventHandler = function(targetId, actionType){
            if(_customList[targetId]==null){
                console.error("[CustomMapMediator][positionChangeEventHandler] targetId is null or empty - "+targetId);
                return false;
            }

            var targetElement = _customList[targetId]['element'];
            var targetData = _customList[targetId]['data'];

            switch (actionType){
                case 'init':
                    targetElement.css("left",targetData['x1']);
                    targetElement.css("width",_element.width()-targetData['x1']-targetData['x2']);
                    targetElement.css("top",targetData['y1']);
                    targetElement.css("height",_element.height()-targetData['y1']-targetData['y2']);
                    break;
                case 'update':
                    targetData['x1'] = toRound(targetElement.position()['left'] / _scale,2);
                    targetData['x2'] = toRound(_element.width() - (targetElement.position()['left'] / _scale) - targetElement.width(),2);
                    targetData['y1'] = toRound(targetElement.position()['top'] / _scale,2);
                    targetData['y2'] = toRound(_element.height() - (targetElement.position()['top'] / _scale) - targetElement.height(),2);
                    break;
            }

            if(_callBackEventHandler!=null){
                _callBackEventHandler('change', targetData);
            }
        };

        this.targetRender = function(data, controlFlag){
            if(_customList[data['targetId']]==null){
                var targetElement = $("<div/>",{targetId:data['targetId']}).addClass(_markerClass[data['deviceCode']]);
                if(controlFlag){
                    var pointerY, pointerX, canvasOffset;
                    targetElement
                        .on("click",function(){
                            _self.positionChangeEventHandler($(this).attr("targetId"));
                        })
                        .resizable({
                            containment: "parent"
                            ,aspectRatio:data['deviceCode']!="area"?true:false
                            ,resize: function(evt, ui){
                                var changeWidth = ui.size.width - ui.originalSize.width; // find change in width
                                var newWidth = ui.originalSize.width + changeWidth / _scale; // adjust new width by our zoomScale

                                var changeHeight = ui.size.height - ui.originalSize.height; // find change in height
                                var newHeight = ui.originalSize.height + changeHeight / _scale; // adjust new height by our zoomScale

                                ui.size.width = newWidth;
                                ui.size.height = newHeight;
                                _self.positionChangeEventHandler($(this).attr("targetId"),'update');
                            }
                        })
                        .draggable({
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
                                _self.positionChangeEventHandler($(this).attr("targetId"),'update');
                            }
                        });
                }else{
                    if(data["targetName"]!=null && data["targetName"]!=''){
                        targetElement.append(
                            $("<span/>").text(data["targetName"])
                        )
                    }
                }

                _element.append(targetElement);
                _customList[data['targetId']] = {
                    'data' : {
                        'targetId' : data['targetId']
                        ,'deviceCode' : data['deviceCode']
                        ,'x1' : data['useYn']?toRound(data['x1']*_ratio['scale']['horizontal'],2):targetElement.position()['left']
                        ,'x2' : data['useYn']?toRound(data['x2']*_ratio['scale']['horizontal'],2):_element.width()-targetElement.position()['left']-targetElement.width()
                        ,'y1' : data['useYn']?toRound(data['y1']*_ratio['scale']['vertical'],2):targetElement.position()['top']
                        ,'y2' : data['useYn']?toRound(data['y2']*_ratio['scale']['vertical'],2):_element.height()-targetElement.position()['top']-targetElement.height()
                        ,'useYn' : data['useYn']
                    }
                    ,'element' : targetElement
                };
                _self.positionChangeEventHandler(data['targetId'],'init');
            }else{
                _self.positionChangeEventHandler(data['targetId']);
            }
        };

        this.addMarker = function(_type, _id, _lat){
            //var ctx = document.getElementById('c').getContext('2d');
            //ctx.fillStyle = '#f00';
            //ctx.beginPath();
            //ctx.moveTo(0, 0);
            //ctx.lineTo(100, 50);
            //ctx.lineTo(50, 100);
            //ctx.lineTo(0, 90);
            //ctx.closePath();
            //ctx.fill();
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
        this.initCustomList = function(areaId,eventHandler){
            if(eventHandler!=null && typeof eventHandler == "function"){
                _callBackEventHandler = eventHandler;
            }
            _ajaxCall('list',{areaId:areaId});
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
                    if(_callBackEventHandler!=null){
                        _callBackEventHandler(actionType, data['childList']);
                    }else{
                        var childList = data['childList'];
                        for(var index in childList){
                            if(childList[index]['useYn']=='Y'){
                                _self.targetRender(childList[index], false);
                            }
                        }
                    }
                    break;
                default :
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

        _initialize(rootPath, version);
    }
);