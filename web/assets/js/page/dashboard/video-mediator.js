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
            fenceDeviceListUrl : "/fenceDevice/list.json"
        };
        var _options = {
            'useDeviceCode' : "DEV002"
            ,'webrtcConnect' : "rtptransport=tcp&timeout=60"
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
         * create
         * @author psb
         * @param _deviceList
         */
        this.createPlayer = function(_deviceList){
            for(var index in _deviceList){
                if(_deviceList[index]['deviceCode']==_options['useDeviceCode'] && _deviceList[index]['streamServerUrl']!=null && _deviceList[index]['streamServerUrl']!=''){
                    var ptzElement = $("<li/>",{class:'ptz', deviceId:_deviceList[index]['deviceId']}).append(
                        $("<span/>").text(_deviceList[index]['deviceName'])
                    ).append(
                        $("<div/>").append(
                            $("<video/>")
                        )
                    );
                    _element.append(ptzElement);
                    // register webrtc streamer connection
                    _videoList[_deviceList[index]['deviceId']] = {
                        'element' : ptzElement
                        ,'server' : null
                        ,'notification' : $.extend(true,{},criticalList)
                    };

                    sendAjaxGetRequest(
                        _deviceList[index]['streamServerUrl'] + "/api/getMediaList"
                        ,null
                        ,function(data, dataType, actionType){
                            for(var index in data){
                                var responseBody = data[index];
                                if(responseBody['video'].indexOf(actionType['ipAddress'])>-1){
                                    var videoTag = "video_" + actionType['deviceId'];
                                    _videoList[actionType['deviceId']]['element'].find("video").attr("id",videoTag);

                                    // connect video element to webrtc stream
                                    var webRtcServer = new WebRtcStreamer(videoTag, actionType['streamServerUrl']);
                                    webRtcServer.connect(responseBody['video'], responseBody['audio'], _options['webrtcConnect']);
                                    _videoList[actionType['deviceId']]['server'] = webRtcServer;
                                    return true;
                                }
                            }
                        }
                        ,function(XMLHttpRequest, textStatus, errorThrown, actionType){
                            console.error(XMLHttpRequest, textStatus, errorThrown, actionType);
                        }
                        ,{
                            streamServerUrl:_deviceList[index]['streamServerUrl']
                            ,deviceId:_deviceList[index]['deviceId']
                            ,ipAddress:_deviceList[index]['ipAddress']
                            ,deviceName:_deviceList[index]['deviceName']
                        }
                    );
                }
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