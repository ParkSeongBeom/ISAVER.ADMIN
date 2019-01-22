/**
 * Video Mediator
 * - 비디오 관련 이벤트 및 데이터를 처리한다.
 * - 구역과 1:1 매칭
 *
 * @author psb
 * @type {Function}
 */
var VideoMediator = (
    function(_rootPath){
        var playerList = {};
        var rootPath;
        var element;
        var useDeviceCode = "DEV002";
        var _self = this;

        /**
         * initialize
         * @author psb
         */
        var _initialize = function(_rootPath){
            rootPath = _rootPath;
        };

        /**
         * set element
         * @author psb
         */
        this.setElement = function(_element){
            if(_element==null || _element.length==0){
                console.error("[VideoMediator][_initialize] _element is null or not found");
                return false;
            }

            element = _element;
        };

        /**
         * create
         * @author psb
         * @param _deviceList
         */
        this.createPlayer = function(_deviceList){
            for(var index in _deviceList){
                if(_deviceList[index]['deviceCode']==useDeviceCode && _deviceList[index]['ipAddress']!=null && _deviceList[index]['ipAddress']!=''){
                    var _src = "rtsp://"+_deviceList[index]['deviceUserId']+":"+_deviceList[index]['devicePassword']+"@"+_deviceList[index]['ipAddress']+(_deviceList[index]['port']!=null?":"+_deviceList[index]['port']:"")+_deviceList[index]['subUrl'];
                    element.append(
                        $("<li/>",{class:'ptz'}).append(
                            $("<div/>",{id:_deviceList[index]['deviceId'],class:"vxgplayer",style:"border:0; margin:0;"})
                        )
                    );

                    vxgplayer(_deviceList[index]['deviceId'], {
                        url: _src,
                        nmf_path: 'media_player.nmf',
                        nmf_src: rootPath+'/assets/library/vxg/pnacl/Release/media_player.nmf',
                        latency: 10000,
                        aspect_ratio_mode: 1,
                        autohide: 3,
                        controls: false,
                        connection_timeout: 5000,
                        connection_udp: 0,
                        custom_digital_zoom: false,
                        width : "100%",
                        height : "100%"
                    }).ready(function(){
                        playerList[this.id] = vxgplayer(this.id);
                        playerList[this.id].src(this.options['url']);
                        console.log('[VideoMediator][createPlayer] ready player - '+this.id);
                        _self.play(this.id);
                    });
                }
            }
        };

        /**
         * play
         * @author psb
         * @param _playerId
         */
        this.play = function(_playerId){
            if(_playerId==null || playerList[_playerId]==null){
                console.error("[VideoMediator][play] _playerId is null or not in playerList");
                return false;
            }
            playerList[_playerId].play();
            console.log('[VideoMediator][play] complete - '+_playerId);
        };

        /**
         * stop
         * @author psb
         * @param _playerId
         */
        this.stop = function(_playerId){
            if(_playerId==null || playerList[_playerId]==null){
                console.error("[VideoMediator][stop] _playerId is null or not in playerList");
                return false;
            }
            playerList[_playerId].stop();
        };

        _initialize(_rootPath);
    }
);