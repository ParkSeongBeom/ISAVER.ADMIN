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
        var _deviceCodeClass = {
            'area' : "area"
            ,"DEV013" : "m8"
            ,"DEV002" : "camera"
        };
        var _scale=1.0;
        var _element;
        var _messageConfig;
        var _callBackEventHandler = null;
        var _customList = {};

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
         * get device Class
         * @author psb
         */
        this.getDeviceClass = function(){
            return _deviceCodeClass;
        };

        /**
         * set element
         * @author psb
         */
        this.setElement = function(element){
            _element = element;
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
                var limitLeft,limitTop;
                _element.draggable({
                    cursor: "move"
                    ,drag: function(event, ui){
                        if(ui.helper.width()/2 < Math.abs(ui.position['left']) || ui.helper.height()/2 < Math.abs(ui.position['top'])){
                            ui.position['left'] = limitLeft;
                            ui.position['top'] = limitTop;
                        }else{
                            limitLeft = ui.position['left'];
                            limitTop = ui.position['top']
                        }
                    }
                });
                var compteur = 10; // 10 = scale(1,1) and 5 = scale(0.5,0.5)
                _element.on("mousewheel",function(event) {
                    if(event.originalEvent.deltaY > 0){if(compteur > 5){compteur--;}}
                    if(event.originalEvent.deltaY < 0){if(compteur < 50){compteur++;}}
                    var scale = compteur/10;
                    _element.css({
                        'transform':'scale('+scale+','+scale+')',
                        '-webkit-transform':'scale('+scale+','+scale+')',
                        '-moz-transform':'scale('+scale+','+scale+')',
                        '-o-transform':'scale('+scale+','+scale+')',
                        '-ms-transform':'scale('+scale+','+scale+')'
                    });
                    _scale = scale;
                });
            }else{
                _element.off('mousewheel').draggable('destroy').attr("style","").attr("scale","");;
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
            }else{
                _self.setDisplayTarget(targetData['targetId'],targetData['useYn']=='Y'?true:false);
            }
        };

        this.targetRender = function(data, controlFlag){
            var pointerX, pointerY;
            if(_customList[data['targetId']]==null){
                var targetElement = $("<div/>",{targetId:data['targetId']}).addClass(_deviceCodeClass[data['deviceCode']])
                    .on("click",function(){
                        _self.positionChangeEventHandler($(this).attr("targetId"));
                    });
                if(controlFlag){
                    targetElement
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
                                pointerY = (evt.pageY - _element.offset().top) / _scale - parseInt($(evt.target).css('top'));
                                pointerX = (evt.pageX - _element.offset().left) / _scale - parseInt($(evt.target).css('left'));
                            }
                            ,drag : function(evt, ui) {
                                var canvasTop = _element.offset().top;
                                var canvasLeft = _element.offset().left;
                                var canvasHeight = _element.height();
                                var canvasWidth = _element.width();

                                // Fix for zoom
                                ui.position.top = Math.round((evt.pageY - canvasTop) / _scale - pointerY);
                                ui.position.left = Math.round((evt.pageX - canvasLeft) / _scale - pointerX);

                                // Check if element is outside canvas
                                if (ui.position.left < 0) ui.position.left = 0;
                                if (ui.position.left + $(this).width() > canvasWidth) ui.position.left = canvasWidth - $(this).width();
                                if (ui.position.top < 0) ui.position.top = 0;
                                if (ui.position.top + $(this).height() > canvasHeight) ui.position.top = canvasHeight - $(this).height();

                                ui.offset.left = Math.round(ui.position.left + canvasLeft);
                                _self.positionChangeEventHandler($(this).attr("targetId"),'update');
                            }
                        });
                }

                _element.append(targetElement);
                _customList[data['targetId']] = {
                    'data' : {
                        'targetId' : data['targetId']
                        ,'deviceCode' : data['deviceCode']
                        ,'x1' : data['useYn']?data['x1']:targetElement.position()['left']
                        ,'x2' : data['useYn']?data['x2']:_element.width()-targetElement.position()['left']-targetElement.width()
                        ,'y1' : data['useYn']?data['y1']:targetElement.position()['top']
                        ,'y2' : data['useYn']?data['y2']:_element.height()-targetElement.position()['top']-targetElement.height()
                        ,'useYn' : data['useYn']
                    }
                    ,'element' : targetElement
                };
                _self.positionChangeEventHandler(data['targetId'],'init');
            }else{
                _self.positionChangeEventHandler(data['targetId']);
            }
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
                                targetRender(childList[index], false);
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