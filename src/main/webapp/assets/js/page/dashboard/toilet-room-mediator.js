/**
 * Toilet Room Mediator
 * - 화장실 재실 관련 이벤트 및 데이터를 처리한다.
 * - 구역과 1:1 매칭
 *
 * @author psb
 * @type {Function}
 */
var ToiletRoomMediator = (
    function(rootPath){
        var _areaId;
        var _element;
        var _canvas;
        var _rootPath;
        var _urlConfig = {
            'toiletRoomUrl' : "/eventLog/toiletRoom.json"
        };
        var _webSocketHelper;
        var _statusCss = {
            'empty' : ''
            ,'normal' : 'enter'
            ,'fall' : 'fall'
            ,'sign' : 'sign'
        };
        var _statusData = {
            'status' : null
            ,'eventDatetime' : null
        };
        var _self = this;

        /**
         * initialize
         * @author psb
         */
        var _initialize = function(rootPath){
            _rootPath = rootPath;
            for(var index in _urlConfig){
                _urlConfig[index] = _rootPath + _urlConfig[index];
            }
        };

        /**
         * fenceList init
         * @author psb
         */
        this.init = function(areaId,webSocketHelper){
            _areaId = areaId;
            _webSocketHelper = webSocketHelper;

            addRefreshTimeCallBack(refreshEventTime);
            _ajaxCall('toiletRoom',{areaId:_areaId});
        };

        /**
         * websocket sendMessage
         * @author psb
         */
        this.wsSendMessage = function(type){
            var message = {
                "messageType": type,
                "areaId": _areaId
            };

            switch (type){
                case "setImageMode" :
                    message['imageMode'] = _element.find("button[name='imageModeBtn']").hasClass("on")?'tof':'ir';
                    webSocketHelper.sendMessage('toiletRoom',message);
                    break;
                case "resetEvent" :
                    webSocketHelper.sendMessage('toiletRoom', message);
                    break;
            }
        };

        /**
         * set element
         * @author psb
         */
        this.setElement = function(element){
            if(element==null || element.length==0){
                console.error("[ToiletRoomMediator][setElement] _element is null or not found");
                return false;
            }
            _element = element;
            _canvas = _element.find("canvas[name='toiletRoom-canvas']");
        };

        this.updateImageMode = function(imageMode){
            switch (imageMode){
                case "tof" :
                    _element.find("button[name='imageModeBtn']").removeClass("on");
                    break;
                case "ir" :
                    _element.find("button[name='imageModeBtn']").addClass("on");
                    break;
            }
        };

        this.saveCanvasImage = function(imageData){
            if(!_element.find(".ir_btn").hasClass("on")){
                return false;
            }

            var canvas = _canvas.get(0);
            var context = canvas.getContext('2d');
            var image = new Image();
            image.onload = function () {
                var imgWidth = image.naturalWidth;
                var screenWidth  = canvas.width;
                var scaleX = 1;
                if (imgWidth > screenWidth)
                    scaleX = screenWidth/imgWidth;
                var imgHeight = image.naturalHeight;
                var screenHeight = canvas.height;
                var scaleY = 1;
                if (imgHeight > screenHeight)
                    scaleY = screenHeight/imgHeight;
                var scale = scaleY;
                if(scaleX < scaleY)
                    scale = scaleX;
                if(scale < 1){
                    imgHeight = imgHeight*scale;
                    imgWidth = imgWidth*scale;
                }
                canvas.height = imgHeight;
                canvas.width = imgWidth;
                context.drawImage(image, 0, 0, image.naturalWidth, image.naturalHeight, 0,0, imgWidth, imgHeight);
            };
            image.src = 'data:image/jpeg;base64,' + imageData;
        };

        var refreshEventTime = function(serverDatetime){
            var eventDatetime = _statusData['eventDatetime'];
            if(eventDatetime!=null){
                var gap;
                var negative = false;
                if(serverDatetime > eventDatetime){
                    gap = serverDatetime.getTime() - eventDatetime.getTime();
                }else{
                    gap = eventDatetime.getTime() - serverDatetime.getTime();
                    negative = true;
                }
                var hour = Math.floor(gap / (1000*60*60));
                if(hour>=0 && hour<10) {hour = "0" + hour;}
                var minute = Math.floor(gap / (1000*60))%60;
                if(minute>=0 && minute<10) {minute = "0" + minute;}
                var second = Math.floor(gap / (1000))%60;
                if(second>=0 && second<10) {second = "0" + second;}

                _element.find("#eventDatetime").text((negative?"-":"") + hour + ":" + minute + ":" + second);
            }else{
                _element.find("#eventDatetime").text("00:00:00");
            }
        };

        /**
         * animation
         * @author psb
         */
        this.setAnimate = function(data){
            var status = null;
            for(var index in data['infos']){
                var info = data['infos'][index];
                if(info['key']=="status"){
                    status = info['value'];
                }
            }
            modifyData(status, data['eventDatetime']);
        };

        var modifyData = function(status, eventDatetime){
            if(status==null){
                console.warn("[ToiletRoomMediator][modifyData] status is empty");
                return false;
            }else{
                _statusData['status'] = status;
            }

            switch (status){
                case "empty":
                    _statusData['eventDatetime'] = null;
                    break;
                case "normal":
                case "sign":
                case "fall":
                    if(_statusData['eventDatetime']==null && eventDatetime!=null){
                        _statusData['eventDatetime'] = new Date(eventDatetime);
                    }
                    break;
            }
            for(var key in _statusCss){
                _element.find("#statusIco").removeClass(_statusCss[key]);
            }
            if(_statusCss[status]!=null){
                _element.find("#statusIco").addClass(_statusCss[status]);
            }
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
                case 'toiletRoom':
                    modifyData(data['status'], data['eventDatetime']);
                    break;
            }
        };

        /**
         * failure handler
         * @author psb
         */
        var _failureHandler = function(XMLHttpRequest, textStatus, errorThrown, actionType){
            if(XMLHttpRequest['status']!="0"){
                console.error(XMLHttpRequest, textStatus, errorThrown, actionType);
            }
        };
        _initialize(rootPath);
    }
);