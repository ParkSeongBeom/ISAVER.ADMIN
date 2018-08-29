/**
 * Ptz Control Popup
 *
 * @author psb
 * @type {Function}
 */
var PtzControlPopup = (
    function(rootPath, ptzWebSocketUrl){
        var _rootPath;
        var _ptzWebSocketUrl;
        var _initFlag = false;
        var _mouseDownInterval = 0;
        var _presetList = {};
        var _video = null;
        var _device = null;
        var _element;
        var _GET_LIST_RETRY = {
            'cnt' : 10
            , 'delay' : 1000
        };
        var _operations = {
            'top' : '1'
            ,'bottom' : '2'
            ,'left' : '3'
            ,'right' : '4'
            ,'leftTop' : '5'
            ,'leftBottom' : '6'
            ,'rightTop' : '7'
            ,'rightBottom' : '8'
            ,'zoomIn' : 'zoomin'
            ,'zoomOut' : 'zoomout'
            ,'focusIn' : 'focusin'
            ,'focusOut' : 'focusout'
            ,'irisIn' : 'irisin'
            ,'irisOut' : 'irisout'
        };
        var _self = this;

        /**
         * initialize
         */
        var initialize = function(rootPath, ptzWebSocketUrl){
            _rootPath = rootPath;
            _ptzWebSocketUrl = ptzWebSocketUrl;
            webSocketHelper.addWebSocketList("ptz", _ptzWebSocketUrl, null, ptzMessageEventHandler);
            console.log('[PtzControlPopup] initialize complete');
        };

        /**
         * set target
         * @author psb
         */
        this.setElement = function(element){
            _element = element;
        };

        /**
         * ptz socket message handler
         * @author psb
         */
        var ptzMessageEventHandler = function(message){
            var resultData;
            try{
                resultData = JSON.parse(message.data);
            }catch(e){
                console.warn("[ptzMessageEventHandler] json parse error - " + message.data);
                return false;
            }

            switch (resultData['messageType']) {
                case "presetList":
                    if(resultData['deviceId']==_device['deviceId']){
                        presetListRender(resultData['presetList']);
                    }
                    break;
            }
        };

        /**
         * PTZ 제어
         * @author psb
         */
        this.operation = function(actionType, continueFlag){
            if(_operations[actionType]==null){
                console.error("[PtzControlPopup][operation] operation is not found",actionType);
                return false;
            }
            webSocketHelper.sendMessage("ptz",{"messageType":"ptzControl","deviceId":_device['deviceId'],"operation":_operations[actionType]});

            if(continueFlag!=null && continueFlag){
                _mouseDownInterval = setInterval(function(){
                    _self.operation(actionType);
                }, 500);
            }
        };

        this.stopOperation = function(){
            clearInterval(_mouseDownInterval);
        };

        /**
         * preset move/save/remove
         * @author psb
         */
        this.updatePreset = function(presetId, actionType){
            if(_presetList[presetId]==null){
                console.error("[PtzControlPopup][updatePreset] presetId is null or not found ptzList",presetId,actionType);
                return false;
            }
            webSocketHelper.sendMessage("ptz",{"messageType":"setPreset","deviceId":_device['deviceId'],"operation":actionType,"presetId":presetId,"presetName":_presetList[presetId]['presetName']});

            switch (actionType){
                case "move" :
                    break;
                case "save" :
                    _element.find("#presetElement li[id='"+presetId+"']").addClass("setting");
                    break;
                case "remove" :
                    _element.find("#presetElement li[id='"+presetId+"']").removeClass("setting");
                    break;
            }
        };

        /**
         * open popup
         * @author psb
         */
        this.openPopup = function(data){
            if(data['deviceId']==null || data['deviceId']==''){
                console.error("[PtzControlPopup][openPopup] deviceId is null");
                return false;
            }

            _device = data;
            _element.find("#deviceName").text(_device['deviceName']);
            _element.fadeIn();

            _video = new VideoMediator(_rootPath);
            _video.setElement(_element);
            _video.createPlayer(_device);

            if(!webSocketHelper.isConnect("ptz")){
                webSocketHelper.wsConnect("ptz");
            }
            getPresetList();
        };

        /**
         * get preset list
         * @author psb
         */
        var getPresetList = function(_count){
            if(webSocketHelper.isConnect("ptz")){
                webSocketHelper.sendMessage("ptz",{"messageType":"getPresetList","deviceId":_device['deviceId']});
            }else{
                if(_count == null){
                    _count = _GET_LIST_RETRY['cnt'];
                }
                if(_count > 0){
                    setTimeout(function(){
                        getPresetList(_count - 1);
                    },_GET_LIST_RETRY['delay']);
                }else{
                    console.error('[PtzControlPopup][getPresetList] failure - retry count over');
                }
            }
        };

        /**
         * close popup
         * @author psb
         */
        this.closePopup = function(){
            _element.fadeOut();
            webSocketHelper.wsDisConnect("ptz");
            _video.disconnect(_device['deviceId']);
            _presetList = {};
            _element.find("#presetElement").empty();
            _initFlag = false;
        };

        /**
         * preset list render
         * @author psb
         */
        var presetListRender = function(dataList){
            if(_initFlag){
                return false;
            }

            var fenceElement = $("<select/>");
            var fenceList = notificationHelper.getFenceList(_device['areaId']);
            for(var index in fenceList){
                var fence = fenceList[index];
                fenceElement.append(
                    $("<option/>",{value:fence['fenceId']}).text(fence['fenceName']!=null?fence['fenceName']:fence['fenceId'])
                )
            }

            var presetElement = _element.find("#presetElement");
            for(var index in dataList){
                var data = dataList[index];
                var fenceElementClone = fenceElement.clone();
                fenceElementClone.val(data['presetName']).prop("selected","selected");

                var element = $("<li/>",{id:data['presetId']}).append(
                    // 설정 저장 버튼
                    $("<button/>",{class:"cs_btn"}).on("click",function(){
                        _self.updatePreset($(this).parent().attr("id"),"save");
                    })
                ).append(
                    // 프리셋 펜스명
                    $("<div/>").append(
                        $("<input/>",{type:"text",readonly:"readonly"})
                    ).append(fenceElementClone)
                ).append(
                    // 프리셋 이동 버튼
                    $("<button/>",{class:"cp_btn"}).on("click",function(){
                        _self.updatePreset($(this).parent().attr("id"),"move");
                    })
                ).append(
                    // 설정 삭제 버튼
                    $("<button/>",{class:"cd_btn"}).on("click",function(){
                        _self.updatePreset($(this).parent().attr("id"),"remove");
                    })
                );

                element.on("click",function(){
                    presetElement.find("li").removeClass("on");
                    $(this).addClass("on");
                });
                _presetList[data['presetId']] = {
                    'data' : data
                    ,'element' : element
                };
                presetElement.append(element);
            }
            _initFlag = true;
        };

        initialize(rootPath, ptzWebSocketUrl);
    }
);