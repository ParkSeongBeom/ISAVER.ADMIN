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
        var _playerList = {};
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
         * fenceList init
         * @author psb
         */
        this.getFenceDeviceList = function(areaId){
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
                    sendAjaxGetRequest(
                        _deviceList[index]['streamServerUrl'] + "/api/getMediaList"
                        ,null
                        ,function(data, dataType, actionType){
                            for(var index in data){
                                var responseBody = data[index];
                                if(responseBody['video'].indexOf(actionType['ipAddress'])>-1){
                                    var videoTag = "video_" + actionType['deviceId'];

                                    var ptzElement = $("<li/>",{class:'ptz', deviceId:actionType['deviceId']}).append(
                                        //$("<video/>",{id:videoTag,style:"width: 350px;"})
                                        $("<video/>",{id:videoTag})
                                    );
                                    _element.append(ptzElement);

                                    // connect video element to webrtc stream
                                    var webRtcServer = new WebRtcStreamer(videoTag, actionType['streamServerUrl']);
                                    webRtcServer.connect(responseBody['video'], responseBody['audio'], _options['webrtcConnect']);

                                    // register webrtc streamer connection
                                    _playerList[actionType['deviceId']] = {
                                        'element' : ptzElement
                                        ,'server' : webRtcServer
                                        ,'objects' : []
                                    };
                                    return true;
                                }
                            }
                        }
                        ,function(XMLHttpRequest, textStatus, errorThrown, actionType){
                            console.error(XMLHttpRequest, textStatus, errorThrown, actionType);
                        }
                        ,{streamServerUrl:_deviceList[index]['streamServerUrl'],deviceId:_deviceList[index]['deviceId'],ipAddress:_deviceList[index]['ipAddress']}
                    );
                }
            }
        };

        /**
         * animation
         * @author psb
         */
        this.setAnimate = function(actionType, className, data){
            if(data['deviceId']==null || data['fenceId']==null || data['objectId']==null){
                return false;
            }

            for(var index in _fenceDeviceList){
                var fenceDevice = _fenceDeviceList[index];
                if(fenceDevice['fenceId']==data['fenceId']){
                    var video = _playerList[fenceDevice['deviceId']];
                    if(video!=null && video['objects'] instanceof Array){
                        switch (actionType){
                            case "add" :
                                if(video['objects'].length == 0 || video['objects'].indexOf(data['objectId'])==-1){
                                    video['objects'].push(data['objectId']);
                                }
                                break;
                            case "remove" :
                                if(video['objects'].indexOf(data['objectId']) > -1){
                                    video['objects'].splice(video['objects'].indexOf(data['objectId']),1);
                                }
                                break;
                        }

                        if(video['objects'].length>0){
                            video['element'].addClass(className);
                        }else{
                            video['element'].removeClass(className);
                        }
                    }else{
                        console.warn("[VideoMediator][setAnimate] not found fence marker or child object - fenceId : " + data['fenceId'] + ", objectId : " + data['objectId']);
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