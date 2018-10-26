/**
 * Video Mediator
 * - 비디오 관련 이벤트 및 데이터를 처리한다.
 * - 구역과 1:1 매칭
 *
 * @author psb
 * @type {Function}
 */
var VideoMediator = (
    function(rootPath){
        var _videoList = {};
        var _fenceDeviceList = null;
        var _rootPath;
        var _element;
        var _areaId;
        var _urlConfig = {
            'fenceDeviceListUrl' : "/fenceDevice/list.json"
        };
        var _options = {
            'useDeviceCode' : "DEV002"
            ,'webrtcConnect' : "rtptransport=tcp&timeout=60"
            ,'openLinkFlag' : true
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
         * set element
         * @author psb
         */
        this.setElement = function(element){
            if(element==null || element.length==0){
                console.error("[VideoMediator][_initialize] _element is null or not found");
                return false;
            }
            _element = element;
        };

        /**
         * get video list
         * @author psb
         */
        this.getVideoList = function(){
            return _videoList;
        };

        /**
         * fenceList init
         * @author psb
         */
        this.init = function(areaId){
            _areaId = areaId;
            _ajaxCall('fenceDeviceList',{areaId:_areaId});
        };

        /**
         * Create Player List (대시보드전용)
         * @author psb
         * @param deviceList
         */
        this.createPlayerList = function(deviceList){
            for(var index in deviceList){
                if(deviceList[index]['deviceCode']==_options['useDeviceCode'] && deviceList[index]['streamServerUrl']!=null && deviceList[index]['streamServerUrl']!=''){
                    var ptzElement = $("<li/>",{class:'ptz', deviceId:deviceList[index]['deviceId']}).append(
                        $("<span/>").text(deviceList[index]['deviceName'])
                    ).append(
                        $("<div/>",{id:"videoDiv"})
                    );

                    if(_options['openLinkFlag'] && deviceList[index]['linkUrl']!=null && deviceList[index]['linkUrl']!=''){
                        ptzElement.find("span").attr("onclick","javascript:openLink('"+deviceList[index]['linkUrl']+"');");
                    }
                    _element.append(ptzElement);

                    // register webrtc streamer connection
                    _videoList[deviceList[index]['deviceId']] = {
                        'element' : ptzElement
                        ,'server' : null
                        ,'responseBody' : null
                        ,'notification' : $.extend(true,{},criticalList)
                        ,'data' : deviceList[index]
                    };

                    setDeviceStatus(_videoList[deviceList[index]['deviceId']], deviceList[index]['deviceStat']);
                }
            }
        };

        /**
         * Create Player (구역장치관리 전용)
         * @author psb
         * @param data
         */
        this.createPlayer = function(data){
            if(data['deviceCode']==_options['useDeviceCode'] && data['streamServerUrl']!=null && data['streamServerUrl']!=''){
                _element.find(".onvif").attr("id","videoDiv");

                // register webrtc streamer connection
                _videoList[data['deviceId']] = {
                    'element' : _element
                    ,'server' : null
                    ,'responseBody' : null
                    ,'notification' : $.extend(true,{},criticalList)
                    ,'data' : data
                };
                setDeviceStatus(_videoList[data['deviceId']], data['deviceStat']);
            }
        };

        /**
         * 장치상태
         * @author psb
         */
        this.setDeviceStatusList = function(deviceStatusList){
            for(var index in deviceStatusList){
                var deviceStatus = deviceStatusList[index];
                if(_videoList[deviceStatus['deviceId']]!=null){
                    setDeviceStatus(_videoList[deviceStatus['deviceId']], deviceStatus['deviceStat']);
                }
            }
        };

        /**
         * 장치상태
         * @author psb
         */
        var setDeviceStatus = function(target, status){
            if(target==null){
                return false;
            }

            if(status=='Y'){
                target['element'].removeClass('level-die');
                _ajaxGetCall(target['data']);
            }else{
                target['element'].addClass('level-die');
                target['element'].find("video").remove();
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

            for(var index in _fenceDeviceList){
                var fenceDevice = _fenceDeviceList[index];
                if(fenceDevice['fenceId']==data['fenceId']){
                    var video = _videoList[fenceDevice['deviceId']];
                    if(video!=null){
                        switch (actionType){
                            case "add" :
                                video['notification'][criticalLevel].push(data['objectId']);
                                break;
                            case "remove" :
                                if(video['notification'][criticalLevel].indexOf(data['objectId']) > -1){
                                    video['notification'][criticalLevel].splice(video['notification'][criticalLevel].indexOf(data['objectId']),1);
                                }
                                break;
                        }

                        for(var index in video['notification']){
                            if(video['notification'][index].length > 0){
                                video['element'].addClass("level-"+criticalCss[index]);
                            }else{
                                video['element'].removeClass("level-"+criticalCss[index]);
                            }
                        }
                    }else{
                        console.warn("[VideoMediator][setAnimate] not found video device - deviceId : " + fenceDevice['deviceId'] + ", deviceId : " + data['fenceId']);
                    }
                }
            }
        };

        /**
         * ajax call
         * @author psb
         */
        var _ajaxGetCall = function(param){
            sendAjaxGetRequest(
                param['streamServerUrl'] + "/api/getMediaList"
                ,null
                ,function(data, dataType, actionType){
                    for(var index in data){
                        var responseBody = data[index];
                        if(responseBody['video'].indexOf(actionType['ipAddress'])>-1){
                            var videoTag = "video_" + actionType['deviceId'];
                            _videoList[actionType['deviceId']]['element'].find("video").remove();
                            _videoList[actionType['deviceId']]['element'].find("#videoDiv").append(
                                $("<video/>",{"id":videoTag})
                            );

                            // connect video element to webrtc stream
                            var webRtcServer = new WebRtcStreamer(videoTag, actionType['streamServerUrl']);
                            webRtcServer.connect(responseBody['video'], responseBody['audio'], _options['webrtcConnect']);
                            _videoList[actionType['deviceId']]['server'] = webRtcServer;
                            _videoList[actionType['deviceId']]['responseBody'] = responseBody;
                            return true;
                        }
                    }
                }
                ,function(XMLHttpRequest, textStatus, errorThrown, actionType){
                    console.error(XMLHttpRequest, textStatus, errorThrown, actionType);
                }
                ,param
            );
        };

        this.disconnect = function(deviceId){
            if(_videoList[deviceId]!=null && _videoList[deviceId]['server']!=null){
                _videoList[deviceId]['server'].disconnect();
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
                case 'fenceDeviceList':
                    _fenceDeviceList = data['fenceDeviceList'];
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