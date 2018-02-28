/**
 * Video Helper
 * - RTSP Streaming
 *
 * @author psb
 * @type {Function}
 */
var VideoHelper = (
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
                console.error("[VideoHelper][_initialize] _element is null or not found");
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
                if(_deviceList[index]['deviceCode']==useDeviceCode && _deviceList[index]['linkUrl']!=null){
                    element.append(
                        $("<li/>",{class:'ptz'}).append(
                            $("<div/>",{id:_deviceList[index]['deviceId'],class:"vxgplayer",style:"border:0; margin:0;"})
                        )
                    );

                    vxgplayer(_deviceList[index]['deviceId'], {
                        url: '',
                        nmf_path: 'media_player.nmf',
                        nmf_src: rootPath+'/assets/library/vxg/pnacl/Release/media_player.nmf',
                        latency: 300000,
                        aspect_ratio_mode: 1,
                        autohide: 3,
                        controls: false,
                        connection_timeout: 5000,
                        connection_udp: 0,
                        custom_digital_zoom: false,
                        width : "100%",
                        height : "100%"
                    }).ready(function(){
                        playerList[_deviceList[index]['deviceId']] = vxgplayer(_deviceList[index]['deviceId']);
                        playerList[_deviceList[index]['deviceId']].src(_deviceList[index]['linkUrl']);
                        console.log('[VideoHelper][createPlayer] ready player - '+_deviceList[index]['deviceId']);
                        _self.play(_deviceList[index]['deviceId']);
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
                console.error("[VideoHelper][play] _playerId is null or not in playerList");
                return false;
            }
            playerList[_playerId].play();
            console.log('[VideoHelper][play] complete - '+_playerId);
        };

        /**
         * play
         * @author psb
         * @param _playerId
         */
        this.stop = function(_playerId){
            if(_playerId==null || playerList[_playerId]==null){
                console.error("[VideoHelper][stop] _playerId is null or not in playerList");
                return false;
            }
            playerList[_playerId].stop();
        };

        _initialize(_rootPath);
    }
);