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
                    //request("GET",_deviceList[index]['streamServerUrl'] + "/api/getMediaList?streamServerUrl="+_deviceList[index]['streamServerUrl']+"&deviceId="+_deviceList[index]['deviceId']).done( function (response) {
                    //    var params = new URLSearchParams(response.url.split("?")[1]);
                    //    var deviceId = params.get("deviceId");
                    //    var streamServerUrl = params.get("streamServerUrl");
                    //
                    //    var responseBody =  JSON.parse(response.body);
                    //    var url = responseBody[0];
                    //    var videoTag = "video_" + deviceId;
                    //
                    //    _element.append(
                    //        $("<li/>",{class:'ptz', deviceId:deviceId}).append(
                    //            $("<video/>",{id:videoTag,style:"width: 350px;"})
                    //        )
                    //    );
                    //
                    //    // connect video element to webrtc stream
                    //    var webRtcServer = new WebRtcStreamer(videoTag, streamServerUrl);
                    //    webRtcServer.connect(url.video, url.audio, _options['webrtcConnect']);
                    //
                    //    // register webrtc streamer connection
                    //    _playerList[deviceId] = webRtcServer;
                    //});

                    var rtspSrc = "rtsp://"+_deviceList[index]['deviceUserId']+":"+_deviceList[index]['devicePassword']+"@"+_deviceList[index]['ipAddress']+(_deviceList[index]['port']!=null?":"+_deviceList[index]['port']:"")+_deviceList[index]['subUrl'];
                    var videoTag = "video_" + _deviceList[index]['deviceId'];

                    var ptzElement = $("<li/>",{class:'ptz', deviceId:_deviceList[index]['deviceId']}).append(
                        $("<video/>",{id:videoTag,style:"width: 350px;"})
                    );
                    _element.append(ptzElement);

                    // connect video element to webrtc stream
                    var webRtcServer = new WebRtcStreamer(videoTag, _deviceList[index]['streamServerUrl']);
                    webRtcServer.connect(rtspSrc, null, _options['webrtcConnect']);

                    // register webrtc streamer connection
                    _playerList[_deviceList[index]['deviceId']] = {
                        'element' : ptzElement
                        ,'server' : webRtcServer
                    }
                }
            }
        };

        ///**
        // * play
        // * @author psb
        // * @param _playerId
        // */
        //this.play = function(_playerId){
        //    if(_playerId==null || _playerList[_playerId]==null){
        //        console.error("[VideoMediator][play] _playerId is null or not in _playerList");
        //        return false;
        //    }
        //    _playerList[_playerId].play();
        //    console.log('[VideoMediator][play] complete - '+_playerId);
        //};
        //
        ///**
        // * stop
        // * @author psb
        // * @param _playerId
        // */
        //this.stop = function(_playerId){
        //    if(_playerId==null || _playerList[_playerId]==null){
        //        console.error("[VideoMediator][stop] _playerId is null or not in _playerList");
        //        return false;
        //    }
        //    _playerList[_playerId].stop();
        //};

        _initialize(rootPath);
    }
);