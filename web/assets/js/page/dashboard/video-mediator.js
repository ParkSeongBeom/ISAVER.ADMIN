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
        var _rootPath;
        var _element;
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
         * create
         * @author psb
         * @param _deviceList
         */
        this.createPlayer = function(_deviceList){
            for(var index in _deviceList){
                if(_deviceList[index]['deviceCode']==_options['useDeviceCode'] && _deviceList[index]['streamServerUrl']!=null && _deviceList[index]['streamServerUrl']!=''){
                    _ajaxCall(
                        {streamServerUrl:_deviceList[index]['streamServerUrl'],deviceId:_deviceList[index]['deviceId'],ipAddress:_deviceList[index]['ipAddress']}
                        ,_deviceList[index]['streamServerUrl'] + "/api/getMediaList"
                    );

                    //var rtspSrc = "rtsp://"+_deviceList[index]['deviceUserId']+":"+_deviceList[index]['devicePassword']+"@"+_deviceList[index]['ipAddress']+(_deviceList[index]['port']!=null?":"+_deviceList[index]['port']:"")+_deviceList[index]['subUrl'];
                    //var videoTag = "video_" + _deviceList[index]['deviceId'];
                    //
                    //var ptzElement = $("<li/>",{class:'ptz', deviceId:_deviceList[index]['deviceId']}).append(
                    //    $("<video/>",{id:videoTag,style:"width: 350px;"})
                    //);
                    //_element.append(ptzElement);
                    //
                    //// connect video element to webrtc stream
                    //var webRtcServer = new WebRtcStreamer(videoTag, _deviceList[index]['streamServerUrl']);
                    //webRtcServer.connect(rtspSrc, null, _options['webrtcConnect']);
                    //
                    //// register webrtc streamer connection
                    //_playerList[_deviceList[index]['deviceId']] = {
                    //    'element' : ptzElement
                    //    ,'server' : webRtcServer
                    //}
                }
            }
        };


        /**
         * ajax call
         * @author psb
         */
        var _ajaxCall = function(actionType, url, data){
            sendAjaxGetRequest(url,data,_successHandler,_failureHandler,actionType);
        };

        /**
         * success handler
         * @author psb
         */
        var _successHandler = function(data, dataType, actionType){
            for(var index in data){
                var responseBody = data[index];
                if(responseBody['video'].indexOf(actionType['ipAddress'])>-1){
                    var videoTag = "video_" + actionType['deviceId'];

                    var ptzElement = $("<li/>",{class:'ptz', deviceId:actionType['deviceId']}).append(
                        $("<video/>",{id:videoTag,style:"width: 350px;"})
                    );
                    _element.append(ptzElement);

                    // connect video element to webrtc stream
                    var webRtcServer = new WebRtcStreamer(videoTag, actionType['streamServerUrl']);
                    webRtcServer.connect(responseBody['video'], responseBody['audio'], _options['webrtcConnect']);

                    // register webrtc streamer connection
                    _playerList[actionType['deviceId']] = {
                        'element' : ptzElement
                        ,'server' : webRtcServer
                    };
                    return true;
                }
            }
        };

        /**
         * failure handler
         * @author psb
         */
        var _failureHandler = function(XMLHttpRequest, textStatus, errorThrown, actionType){
            console.error(XMLHttpRequest, textStatus, errorThrown, actionType);
        };

        _initialize(rootPath);
    }
);