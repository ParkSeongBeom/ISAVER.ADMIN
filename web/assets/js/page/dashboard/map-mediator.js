/**
 * Map Mediator
 * - 맵 관련 이벤트 및 데이터를 처리한다.
 * - 구역과 1:1 매칭
 *
 * @author psb
 * @type {Function}
 */
var MapMediator = (
    function(_rootPath, _version){
        var rootPath;
        var MARKER_TYPE = ['device', 'fence', 'object'];
        var testLat = {lat : 37.495450, lng : 127.031012};
        var canvas;
        var map;
        var imageUrl = "/assets/library/googlemap/images/mapex_n.svg";
        var marker = {
            'device' : {},
            'fence' : {},
            'object' : {}
        };
        var options = {
            "device" : {
                'content' : "<div class='device'><div class='icon-tof'></div><div class='icon-ptz'></div></div>"
                ,"targetClass" : ".device"
            },
            "fence" : {
                "fillColor" : ["#f6b900", "#FF0000"]
                ,"strokeColor" : ["#f6b900", "#FF0000"]
            },
            "object" : {
                'content' : "<div class='tracking'></div>"
                ,"targetClass" : ".tracking"
            },
            "image" : {
                'content' : "<div class='mapimages'><div></div></div>"
            }
        };

        var _self = this;

        /**
         * initialize
         * @author psb
         * @param _canvas
         * @returns
         */
        var _initialize = function(_rootPath, _version){
            rootPath = _rootPath;
            imageUrl = rootPath + imageUrl + "?version="+_version;
        };

        /**
         * set canvas
         * @author psb
         * @param _canvas
         * @returns
         */
        this.setMap = function(_canvas, _lat, _deviceList){
            if(_canvas==null){
                console.error("[MapMediator][_initialize] canvas is null");
                return false;
            }
            canvas = _canvas;

            if(_lat==null || _lat==""){
                _lat = testLat;
            }else if(typeof _lat!="object"){
                _lat = eval("("+_lat+")");
            }

            map = new google.maps.Map(canvas.get(0), {
                center: new google.maps.LatLng(_lat['lat'], _lat['lng']),
                zoom: 22, // 지도 zoom단계
                /**
                 * roadmap : 기본 도로 지도 뷰를 표시합니다. 기본 지도 유형입니다.
                 * satellite : Google 어스 위성 이미지를 표시합니다.
                 * hybrid : 일반 뷰와 위성 뷰를 섞어서 표시합니다.
                 * terrain : 지형 정보를 기반으로 실제 지도를 표시합니다.
                 */
                mapTypeId: "roadmap",
                //draggable: false,
                //zoomControl: false,
                mapTypeControl : false,
                mapTypeControlOptions: {
                    position: google.maps.ControlPosition.LEFT_BOTTOM
                },
                streetViewControl : false,
                scaleControl : false,
                fullscreenControl : false
            });

            map.addListener('tilesloaded', function() {
                for(var index in _deviceList){
                    if(_deviceList[index]['deviceCode']=="DEV013"){
                        webSocketHelper.sendMessage("device",{"messageType":"getDevice","areaId":_deviceList[index]['areaId'],"deviceId":_deviceList[index]['deviceId'],"ipAddress":_deviceList[index]['ipAddress']});
                    }
                }
            });
        };

        this.getMap = function(){
            return map;
        };

        /**
         * add marker
         * @author psb
         */
        this.addMarker = function(_type, _id, _lat){
            if(_id==null || _lat==null){
                console.error("[MapMediator][addMarker] parameter not enough");
                return false;
            }
            if(marker[_type]!=null && marker[_type][_id]!=null){
                console.warn("[MapMediator][addMarker] marker is exist - [" + _type + "][" + _id + "]");
                return false;
            }

            try{
                switch (_type){
                    case MARKER_TYPE[0] : // Device
                        marker[_type][_id] = new RichMarker({
                            position: new google.maps.LatLng(_lat[0]['lat'], _lat[0]['lng']),
                            title : _id,
                            map: map,
                            content : options[_type]["content"],
                            anchor: RichMarkerPosition.MIDDLE
                        });
                        marker[_type][_id]['objects'] = [];
                        break;
                    case MARKER_TYPE[2] : // Object
                        marker[_type][_id] = new RichMarker({
                            position: new google.maps.LatLng(_lat[0]['lat'], _lat[0]['lng']),
                            title : _id,
                            map: map,
                            content : options[_type]["content"],
                            anchor: RichMarkerPosition.MIDDLE
                        });
                        break;
                    case MARKER_TYPE[1] : // Fence
                        _lat = validateLat(_lat);
                        marker[_type][_id] = new google.maps.Polygon({
                            paths: _lat,
                            strokeColor: options["fence"]["fillColor"][0],
                            strokeOpacity: 0.8,
                            strokeWeight: 2,
                            fillColor: options["fence"]["fillColor"][0],
                            fillOpacity: 0.35,
                            text:_id
                        });
                        marker[_type][_id]['objects'] = [];
                        marker[_type][_id].setMap(map);

                        var bounds = new google.maps.LatLngBounds();
                        for (var i=0; i< _lat.length; i++) {
                            bounds.extend(_lat[i]);
                        }
                        var myLatlng = bounds.getCenter();
                        var mapLabel = new MapLabel({
                            text: _id,
                            position: myLatlng,
                            map: map,
                            fontSize: 11
                        });
                        break;
                }
                console.log("[MapMediator][addMarker] complete - [" + _type + "][" + _id + "]");
            }catch(e){
                console.error("[MapMediator][addMarker] error- [" + _type + "][" + _id + "] - " + e.message);
            }
        };

        /**
         * save marker
         * @author psb
         */
        this.saveMarker = function(_type, _id, _lat){
            if(_type==null || _id==null || _lat==null){
                console.error("[MapMediator][saveMarker] parameter not enough");
                return false;
            }

            switch (_type){
                case MARKER_TYPE[2] : // Object
                    if(marker[_type][_id]!=null){
                        if(_lat instanceof Array){
                            _lat = _lat[0];
                        }
                        if(!(_lat instanceof google.maps.LatLng)){
                            _lat = new google.maps.LatLng(_lat['lat'], _lat['lng']);
                        }
                        marker[_type][_id].animateTo(_lat, {easing: "swing", duration: 1});
                    }else{
                        _self.addMarker(_type, _id, _lat);
                    }
                    break;
            }
        };

        /**
         * remove marker
         * @author psb
         */
        this.removeMarker = function(_type, _id){
            if(_type==null || _id==null){
                console.error("[MapMediator][removeMarker] parameter not enough");
                return false;
            }

            switch (_type){
                case MARKER_TYPE[0] : // Device
                case MARKER_TYPE[1] : // Fence
                case MARKER_TYPE[2] : // Object
                    if(marker[_type][_id]!=null){
                        marker[_type][_id].setMap(null);
                        delete marker[_type][_id];
                        console.log("[MapMediator][removeMarker] complete - [" + _type + "][" + _id + "]");
                    }
                    break;
            }
        };

        /**
         * get marker
         * @author psb
         */
        this.setAnimate = function(_deviceId, _fenceId, _objectId, _action, _className){
            var deviceMarker = _self.getMarker("device", _deviceId);
            if(deviceMarker!=null && deviceMarker['objects'] instanceof Array){
                switch (_action){
                    case "add" :
                        if(deviceMarker['objects'].length == 0 || deviceMarker['objects'].indexOf(_objectId)==-1){
                            deviceMarker['objects'].push(_objectId);
                        }
                        $(deviceMarker.markerWrapper_).find(options["device"]["targetClass"]).addClass(_className);
                        break;
                    case "remove" :
                        var index = deviceMarker['objects'].indexOf(_objectId);
                        if(index!=-1){
                            deviceMarker['objects'].splice(index,1);
                        }
                        if(deviceMarker['objects'].length == 0) {
                            $(deviceMarker.markerWrapper_).find(options["device"]["targetClass"]).removeClass(_className);
                        }
                        break;
                }
            }else{
                console.warn("[MapMediator][setAnimate] not found device marker or child object - " + _deviceId);
            }

            var fenceMarker = _self.getMarker("fence", _fenceId);
            if(fenceMarker!=null && fenceMarker['objects'] instanceof Array){
                switch (_action){
                    case "add" :
                        if(fenceMarker['objects'].length == 0 || fenceMarker['objects'].indexOf(_objectId)==-1){
                            fenceMarker['objects'].push(_objectId);
                        }
                        break;
                    case "remove" :
                        if(fenceMarker['objects'].indexOf(_objectId)!=-1){
                            fenceMarker['objects'].splice(index,1);
                        }
                        break;
                }

                marker[MARKER_TYPE[1]][_fenceId].strokeColor = fenceMarker['objects'].length==0?options["fence"]["strokeColor"][0]:options["fence"]["strokeColor"][1];
                marker[MARKER_TYPE[1]][_fenceId].fillColor = fenceMarker['objects'].length==0?options["fence"]["fillColor"][0]:options["fence"]["fillColor"][1];
                marker[MARKER_TYPE[1]][_fenceId].setVisible(false);
                marker[MARKER_TYPE[1]][_fenceId].setVisible(true);
            }else{
                console.warn("[MapMediator][setAnimate] not found fence marker or child object - " + _fenceId);
            }

            var objectMarker = _self.getMarker("object", _objectId);
            if(objectMarker!=null){
                switch (_action){
                    case "add" :
                        $(objectMarker.markerWrapper_).find(options["object"]["targetClass"]).addClass(_className);
                        break;
                    case "remove" :
                        $(objectMarker.markerWrapper_).find(options["object"]["targetClass"]).removeClass(_className);
                        break;
                }
            }else{
                console.warn("[MapMediator][setAnimate] not found object marker - " + _objectId);
            }
        };

        /**
         * get marker
         * @author psb
         */
        this.getMarker = function(_type, _id){
            switch (_type){
                case MARKER_TYPE[0] : // Device
                case MARKER_TYPE[1] : // Fence
                case MARKER_TYPE[2] : // Object
                    if(marker[_type][_id]!=null){
                        return marker[_type][_id];
                    }
                    break;
                case "all" : // Object
                    return marker;
            }
            return null;
        };

        var validateLat = function( jsonData ) {
            if(jsonData instanceof Array){
                for(var key in jsonData) {
                    for(var i in jsonData[key]) {
                        if( typeof jsonData[key][i] === 'object' || typeof jsonData[key][i] === 'array' ) {
                            jsonData[key][i] = typeCheck( jsonData[key][i] );
                        } else {
                            if( /^(0|[1-9][0-9].*)$/.test( jsonData[key][i] ) ) {
                                jsonData[key][i] = Number( jsonData[key][i] );
                            }
                        }
                    }
                }
            }else{
                for(var key in jsonData) {
                    if( typeof jsonData[key] === 'object' || typeof jsonData[key] === 'array' ) {
                        jsonData[key] = typeCheck( jsonData[key] );
                    } else {
                        if( /^(0|[1-9][0-9].*)$/.test( jsonData[key] ) ) {
                            jsonData[key] = Number( jsonData[key] );
                        }
                    }
                }
            }
            return jsonData;
        };

        var historicalOverlay = null;
        this.addImage = function(){
            historicalOverlay = new google.maps.GroundOverlay(
                imageUrl,
                {
                    north: 37.49586539601683,
                    east: 127.03165207272161,
                    south: 37.49505460178254,
                    west: 127.03028592727844
                });
            historicalOverlay.setMap(map);
            canvas.addClass("map_images");
        };

        this.removeImage = function(){
            if(historicalOverlay!=null){
                historicalOverlay.setMap(null);
            }
            canvas.removeClass("map_images");
        };

        _initialize(_rootPath, _version);
    }
);