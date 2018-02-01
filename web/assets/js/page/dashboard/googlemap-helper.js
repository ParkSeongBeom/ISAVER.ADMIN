/**
 * Google Map Helper
 * - 구글맵 제어
 *
 * @author psb
 * @type {Function}
 */
var GoogleMapHelper = (
    function(_rootPath){
        var rootPath;
        var MARKER_TYPE = [
            'device'
            , 'fence'
            , 'object'
        ];
        var defaultLat = {lat : 37.495460,lng : 127.030969};
        var map;
        var marker = {
            'device' : {},
            'fence' : {},
            'object' : {}
        };
        var targetClass = {
            'device' : ".device",
            'object' : ".tracking"
        };
        var content = {
            'device' : "<div class='device'><div class='icon-tof'></div><div class='icon-ptz'></div></div>",
            'object' : "<div class='tracking'></div>"
        };

        var _self = this;

        /**
         * initialize
         * @author psb
         * @param _canvas
         * @returns
         */
        var _initialize = function(_rootPath){
            rootPath = _rootPath;
        };

        /**
         * set canvas
         * @author psb
         * @param _canvas
         * @returns
         */
        this.setMap = function(_canvas, _lat){
            if(_canvas==null){
                console.error("[GoogleMapHelper][_initialize] canvas is null");
                return false;
            }

            if(_lat==null){
                _lat = defaultLat;
            }

            map = new google.maps.Map(_canvas, {
                center: new google.maps.LatLng(_lat['lat'], _lat['lng']),
                zoom: 25, // 지도 zoom단계
                mapTypeId: "satellite",
                zoomControl: true,
                mapTypeControl : false,
                streetViewControl : false,
                scaleControl : false,
                fullscreenControl : false
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
                console.error("[GoogleMapHelper][setMarker] parameter not enough");
                return false;
            }
            if(marker[_type]!=null && marker[_type][_id]!=null){
                console.warn("[GoogleMapHelper][setMarker] marker is exist - [" + _type + "][" + _id + "]");
                return false;
            }

            try{
                switch (_type){
                    case MARKER_TYPE[0] : // Device
                        marker[_type][_id] = new RichMarker({
                            position: new google.maps.LatLng(_lat[0]['lat'], _lat[0]['lng']),
                            title : _id,
                            map: map,
                            content : content[_type],
                            anchor: RichMarkerPosition.MIDDLE
                        });
                        marker[_type][_id]['objects'] = [];
                        break;
                    case MARKER_TYPE[2] : // Object
                        marker[_type][_id] = new RichMarker({
                            position: new google.maps.LatLng(_lat[0]['lat'], _lat[0]['lng']),
                            title : _id,
                            map: map,
                            content : content[_type],
                            anchor: RichMarkerPosition.MIDDLE
                        });
                        break;
                    case MARKER_TYPE[1] : // Fence
                        marker[_type][_id] = new google.maps.Polygon({
                            paths: validateLat(_lat),
                            strokeColor: '#FF0000',
                            strokeOpacity: 0.8,
                            strokeWeight: 2,
                            fillColor: '#FF0000',
                            fillOpacity: 0.35
                        });
                        marker[_type][_id].setMap(map);

                        //function action(_color, _cnt){
                        //    _color = _color == "#FF0000" ? "#000000" : "#FF0000";
                        //    marker[MARKER_TYPE[1]][_deviceId].strokeColor = _color;
                        //    marker[MARKER_TYPE[1]][_deviceId].fillColor = _color;
                        //    marker[MARKER_TYPE[1]][_deviceId].setVisible(false);
                        //    marker[MARKER_TYPE[1]][_deviceId].setVisible(true);
                        //    //if(){
                        //    //
                        //    //}
                        //    setTimeout(function(){
                        //        action(_color);
                        //    },1000);
                        //}
                        //action();
                        break;
                }
            }catch(e){
                console.error("[GoogleMapHelper][setMarker] error - " + e.message);
            }
        };

        /**
         * save marker
         * @author psb
         */
        this.saveMarker = function(_type, _id, _lat){
            if(_type==null || _id==null || _lat==null){
                console.error("[GoogleMapHelper][saveMarker] parameter not enough");
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
                        marker[_type][_id].animateTo(_lat, {easing: "swing", duration: 1000});
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
                console.error("[GoogleMapHelper][removeMarker] parameter not enough");
                return false;
            }

            switch (_type){
                case MARKER_TYPE[0] : // Device
                case MARKER_TYPE[1] : // Fence
                case MARKER_TYPE[2] : // Object
                    if(marker[_type][_id]!=null){
                        marker[_type][_id].setMap(null);
                        delete marker[_type][_id];
                        console.log("[GoogleMapHelper][removeMarker] complete - [" + _type + "][" + _id + "]");
                    }
                    break;
            }
        };

        /**
         * get marker
         * @author psb
         */
        this.setAnimate = function(_deviceId, _objectId, _action, _className){
            var deviceMarker = _self.getMarker("device", _deviceId);
            if(deviceMarker!=null && deviceMarker['objects'] instanceof Array){
                var markerDiv = $(deviceMarker.markerWrapper_).find(targetClass["device"]);
                switch (_action){
                    case "add" :
                        if(deviceMarker['objects'].length == 0 || deviceMarker['objects'].indexOf(_objectId)==-1){
                            deviceMarker['objects'].push(_objectId);
                        }
                        markerDiv.addClass(_className);
                        break;
                    case "remove" :
                        var index = deviceMarker['objects'].indexOf(_objectId);
                        if(index!=-1){
                            deviceMarker['objects'].splice(index,1);
                        }
                        if(deviceMarker['objects'].length == 0) {
                            markerDiv.removeClass(_className);
                        }
                        break;
                }
            }else{
                console.error("[GoogleMapHelper][setAnimate] not found device marker ior child object - " + _deviceId);
            }

            var objectMarker = _self.getMarker("object", _objectId);
            if(objectMarker!=null){
                var markerDiv = $(objectMarker.markerWrapper_).find(targetClass["object"]);
                switch (_action){
                    case "add" :
                        markerDiv.addClass(_className);
                        break;
                    case "remove" :
                        markerDiv.removeClass(_className);
                        break;
                }
            }else{
                console.error("[GoogleMapHelper][setAnimate] not found object marker - " + _objectId);
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

        _initialize(_rootPath);
    }
);