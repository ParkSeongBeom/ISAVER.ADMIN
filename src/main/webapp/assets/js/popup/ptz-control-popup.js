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
        var _fenceElement;
        var _setPresetList = [];
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
            var presetName = _element.find("#presetElement li[id='"+presetId+"'] select option:selected").val();
            if(presetName==null){
                console.error("[PtzControlPopup][updatePreset] preset name is null",presetId,actionType);
                return false;
            }

            webSocketHelper.sendMessage("ptz",{"messageType":"setPreset","deviceId":_device['deviceId'],"operation":actionType,"presetId":presetId,"presetName":presetName});

            switch (actionType){
                case "move" :
                    break;
                case "save" :
                case "remove" :
                    updateSetting(_element.find("#presetElement li[id='"+presetId+"']"),actionType,presetName);
                    _initFlag = false;
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
            _setPresetList = [];
            _element.find("#deviceName").text(_device['deviceName']);
            _element.fadeIn();

            _video = new VideoMediator(_rootPath);
            _video.setElement(_element);
            _video.createPlayer(_device);

            if(!webSocketHelper.isConnect("ptz")){
                webSocketHelper.wsConnect("ptz");
            }

            var fenceList = notificationHelper.getFenceList('areaId',_device['areaId']);
            _fenceElement = $("<select/>");
            for(var index in fenceList){
                var fence = fenceList[index];
                _fenceElement.append(
                    $("<option/>",{value:fence['fenceId']}).text(fence['fenceName']!=null?fence['fenceName']:fence['fenceId'])
                )
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

        var updateSetting = function(element, mode, presetName){
            // Reset
            _fenceElement.find("option").prop("disabled",false);
            _element.find("#presetElement li select option").prop("disabled",false);

            switch (mode){
                case "save" :
                    if(_setPresetList.indexOf(presetName) < 0){
                        _setPresetList.push(presetName);
                    }
                    element.addClass("setting");
                    break;
                case "remove" :
                    if(_setPresetList.indexOf(presetName) > 0){
                        _setPresetList.splice(_setPresetList.indexOf(presetName),1);
                    }
                    element.removeClass("setting");
                    
                    $.each(_element.find("#presetElement li select"),function(){
                        $(this).find("option[value='"+presetName+"']").prop("disabled",false);
                    });
                    _fenceElement.find("option[value='"+presetName+"']").prop("disabled",false);
                    break;
            }

            for(var index in _setPresetList){
                $.each(_element.find("#presetElement li select"),function(){
                    if($(this).val()!=_setPresetList[index]){
                        $(this).find("option[value='"+_setPresetList[index]+"']").prop("disabled",true);
                    }
                });
                _fenceElement.find("option[value='"+_setPresetList[index]+"']").prop("disabled",true);
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
            reset();
            _initFlag = false;
        };

        var reset = function(){
            _presetList = {};
            _element.find("#presetElement").empty();
        };

        /**
         * preset list render
         * @author psb
         */
        var presetListRender = function(dataList){
            if(_initFlag){
                return false;
            }
            reset();

            var presetElement = _element.find("#presetElement");
            for(var index in dataList){
                var data = dataList[index];
                var fenceElementClone = _fenceElement.clone();
                if(fenceElementClone.find("option[value='"+data['presetName']+"']").length==0){
                    fenceElementClone.append(
                        $("<option/>",{value:data['presetName']}).text(data['presetName'])
                    )
                }
                fenceElementClone.val(data['presetName']).prop("selected","selected");

                var element = $("<li/>",{id:data['presetId']}).append(
                    // 설정 저장 버튼
                    $("<button/>",{class:"cs_btn"}).on("click",function(){
                        _self.updatePreset($(this).parent().attr("id"),"save");
                    })
                ).append(
                    // 프리셋 펜스명
                    $("<div/>").append(fenceElementClone)
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

                if(data['setYn']=='Y'){
                    updateSetting(element,'save', data['presetName']);
                }

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